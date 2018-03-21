# docker-fsyncms: Containerized palemoon sync server

This is [FSyncMS](https://github.com/MoonchildProductions/FSyncMS) on top of [php:apache](https://github.com/docker-library/php)

# Building locally
`docker build -t fsyncms .`

# Usage
## with local sqlite database
the database and settings file will be created in the volume mounted at /var/www/html

`docker run -p 80 -v fsyncms:/var/www/html fsyncms`

## with external mariadb database
`docker network create fsyncms`

`docker run -d --name fsyncms-db --net fsyncms -v fsyncms-db:/var/lib/mysql -e MYSQL_DATABASE=fsyncms -e MYSQL_USER=fsyncms -e MYSQL_PASSWORD=snakeoil -e MYSQL_RANDOM_ROOT_PASSWORD=yes mariadb`

`docker run -d --name fsyncms -p 80 --net fsyncms -v fsyncms-conf:/var/www/html -e DBTYPE=mysql -e DBHOST=fsyncms-db -e DBNAME=fsyncms -e DBUSER=fsyncms -e DBPASS=snakeoil fsyncms`

on subsequent starts, the environment variables are not needed. the values are stored in /var/www/html/settings.php:

`docker run -d --name fsyncms -p 80 --net fsyncms -v fsyncms-conf:/var/www/html fsyncms`

## disabling registration
If you expose your fsyncms server to the internet, consider disabling registration after creating your account.
Start the container with ENABLE_REGISTER=false or edit settings.php in your fsyncms-conf volume. Verify settings.php afterwards or look for `ENABLE_REGISTER changed to false` in the container logs.

`docker run -d --name fsyncms -p 80 --net fsyncms -v fsyncms-conf:/var/www/html -e ENABLE_REGISTER=false fsyncms`

# Environment variables
**DBTYPE**=[**sqlite**|mysql]

**DBHOST**=**db**

**DBNAME**=**fsyncms**

**DBUSER**=**fsyncms**

**DBPASS**=**snakeoil** this is set for easier testing. change it.

**ENABLE_REGISTER**=[**true**|false]

# TODO
* limit access to settings.php
* add examples on using nginx-proxy for ssl
