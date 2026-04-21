# POD Docker Configuration

This repository contains the Dockerfile, **podman-compose.yml**, and supporting documentation for building and running the POD (Proof of Delivery) application container.

## Files

- **Dockerfile** – Multi-stage Dockerfile for building the POD PHP application image with PHP 8.3-FPM, Alpine Linux, and optimized production setup.
- **podman-compose.yml** – Defines services for a multi‑container setup using Podman (compatible with Docker Compose).
- **step.md** – Step‑by‑step guide for initial configuration and deployment.
- **README.md** – This file.

## Recent Changes

- Added multi-stage Dockerfile for PHP 8.3-FPM with Alpine, including builder and production stages for optimized image size and security.

## Quick Start

```bash
# Clone the repo (if not already)
git clone https://github.com/harys-rifai/POD-Dockerfile.git
cd POD-Dockerfile

# Build the image
podman build -t pod-image .

# Bring up services (Podman Compose compatible)
podman-compose up -d
```

## Usage

- **Running the container**: After building, start the container with `podman run -it --rm pod-image`.
- **Customizing**: Edit `Dockerfile` or `podman-compose.yml` to adjust base images, environment variables, or mounted volumes.

## Contributing

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/your-feature`).
3. Commit your changes and push to your fork.
4. Open a Pull Request against `main`.

## License

This project is licensed under the MIT License.
