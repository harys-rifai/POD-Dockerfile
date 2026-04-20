#powershell

cd C:\laravel-app

#Rebuild image | podman-compose.yml
podman-compose build
#start
podman-compose up -d

#stop
podman-compose down

#remove postgres
podman-compose down -v

#build
podman build -t "nextwave"

#Check IP Podman
podman inspect my-postgres | findstr "IPAddress"
podman inspect my-redis | findstr "IPAddress"
podman inspect nextwave | findstr "IPAddress"

#ssh container
podman exec -it nextwave bash

#Check container
podman ps

#logs
podman logs laravel

#logs --follow
podman logs -f laravel

#remove container
podman rm -f laravel

#remove image
podman rmi laravel

#remove network
podman network rm nextwave-net

#remove all container
podman rm -f $(podman ps -aq)

#remove all image
podman rmi -f $(podman images -aq)

#remove all volume
podman volume rm -f $(podman volume ls -q)

#remove all volume
podman system prune -a

#Clean all (Stop/Remove all containers, images, networks, volumes)
podman system prune -a -f

#ssh container
podman exec -it laravel bash

##composer
composer install
php artisan migrate
php artisan db:seed --class=CreateUsersSeeder

#list image
podman images

#list container
podman ps -a

#download file
curl "https://raw.githubusercontent.com/git-guides/git-flow/master/flow_chart.png" --output flow_chart.png

#copy file
podman cp flow_chart.png laravel:/var/www/html/nextwave/flow_chart.png

#download file
curl -o C:\laravel-app\flow_chart.png "https://raw.githubusercontent.com/git-guides/git-flow/master/flow_chart.png"

#copy file
podman cp flow_chart.png laravel:/var/www/html/nextwave/flow_chart.png

#backup
podman exec -it postgres pg*dumpall -U postgres > C:\laravel-app\backup\postgres\db-$(date +"%Y%m%d*%H%M%S").sql

#restore

#Start by running a plain vanilla Postgres container (no volume this time):
podman run -d --name reset-postgres -e POSTGRES_PASSWORD=Password09 postgres:18

#Drop all databases:
podman exec reset-postgres dropdb -U postgres --all

#Run migrations:
podman exec -it reset-postgres psql -U postgres -c "CREATE DATABASE nextwave_db;"
podman exec -it reset-postgres psql -U postgres -d nextwave_db -c "GRANT ALL PRIVILEGES ON DATABASE nextwave_db TO postgres;"

#Stop and remove reset container:
podman stop reset-postgres
podman rm reset-postgres

#start with new database name
podman-compose up -d --remove-orphans

#restart postgres container
podman-compose down -v
podman-compose up -d

#reset database
podman-compose down -v

#copy file from host to container
podman cp index.html container_name:/path/to/destination/

#copy file from container to host
podman cp container_name:/path/to/source/file .

#copy all file in container to host
podman cp laravel:/var/www/html/nextwave .

#recreate database postgres
podman-compose down -v
podman-compose up -d

#.env
DB_CONNECTION=pgsql
DB_HOST=10.10.0.6
DB_PORT=5432
DB_DATABASE=nextwave_db
DB_USERNAME=postgres
DB_PASSWORD=Password09

REDIS_HOST=10.10.0.7
REDIS_PORT=6379

#edit file in container
podman exec -it nextwave nano /var/www/html/nextwave/.env

#clear cache laravel
podman exec -it laravel php artisan optimize:clear
php artisan config:clear
php artisan cache:clear
