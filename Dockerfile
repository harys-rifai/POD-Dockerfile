# syntax = docker/dockerfile:1.4

# ------------------------------------------------------------
# Multi‑stage Dockerfile for PHP 8.3‑FPM with Alpine
# ------------------------------------------------------------
# Builder stage – install build tools, PHP extensions and composer,
# then compile the application.
FROM php:8.3-fpm-alpine AS builder

# Install system build dependencies and required libraries
RUN apk add --no-cache \
    git \
    unzip \
    libzip-dev \
    oniguruma-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    bash \
    shadow && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install pdo pdo_mysql zip gd bcmath opcache && \
    pecl install redis && docker-php-ext-enable redis

# Install Composer from the official image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copy application source code
COPY . .

# Install PHP dependencies without dev requirements for a lean image
RUN composer install --no-dev --optimize-autoloader --prefer-dist

# ------------------------------------------------------------
# Production stage – runtime image with only needed extensions
# ------------------------------------------------------------
FROM php:8.3-fpm-alpine AS production

# Install only runtime extensions (no build‑time packages)
RUN apk add --no-cache \
    libzip libpng freetype libjpeg-turbo curl && \
    docker-php-ext-install pdo pdo_mysql zip gd bcmath opcache && \
    pecl install redis && docker-php-ext-enable redis

# Create a non‑root user matching www‑data (uid 82) for better security
# Note: Alpine's php-fpm image already has www-data (uid 82), 
# but we ensure it's configured correctly for our needs.
RUN addgroup -g 82 -S www-data-group || true && \
    sed -i "s/www-data:x:82:82/www-data:x:1000:1000/" /etc/passwd || true

WORKDIR /var/www/html

# Copy only the compiled application from the builder stage
COPY --from=builder /var/www/html /var/www/html

# Adjust permissions for the non‑root user
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Set production environment variables
ENV APP_ENV=production \
    APP_DEBUG=0

# Expose the PHP‑FPM port (will be used by a reverse proxy such as Nginx)
EXPOSE 9000

# Healthcheck to ensure php‑fpm is responsive
# Using cgi-fcgi for a more accurate FPM health check if available, 
# but curl/wget to a health endpoint is also common.
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s \
    CMD curl -f http://localhost:9000/status || exit 1

# Switch to the non‑root user for runtime
USER www-data

# Default command runs php‑fpm in the foreground
CMD ["php-fpm"]
