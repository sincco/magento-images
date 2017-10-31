# Imágenes Docker para Magento 2

Estas imagenes convierten el largo [proceso de instalación](http://devdocs.magento.com/guides/v1.0/install-gde/bk-install-guide.html) de Magento 2 en imágenes simples de levantar.

**Atención: esta imagen está etiquetada para desarrollo (proximamente para producción) para una implementación inmediata

## Levantar contenedores

El módo más simple es utiizar docker-compose con una configuración .yml con la siguiente estructura:

~~~
web:
    image: sinccocom/magento-images:<m2apachedev/m2apachepro>
    ports:
        - 80:80
    volumes:
        - ./src:/var/www/html
        - ./log/nginx:/var/log/nginx
        - ./log/php:/var/log/php-fpm
        - ./build:/build/
        - ./log/magento/:/var/www/html/var/log/
    environment:
        - MAGENTO_USER=magento2
        - MAGENTO_VERSION=project-community-edition=2.2
        - MAGENTO_DEPLOY_MODE=developer
        - MAGENTO_BASE_URL=http://magento2.net/
        - MAGENTO_BACKEND_FRONTNAME=admindev
        - MAGENTO_TIMEZONE=America/Mexico_City
        - MAGENTO_CURRENCY=MXN
        - MAGENTO_LANGUAGE=es_MX
        - MAGENTO_DB_HOST=mysql
        - MAGENTO_DB_USERNAME=root
        - MAGENTO_DB_PASSWORD=mysql
        - MAGENTO_DB_NAME=magento2
        - MAGENTO_ADMIN_USER=admindev
        - MAGENTO_ADMIN_PASSWORD=4dm1nd3v#
        - MAGENTO_ADMIN_EMAIL=magento2@magento2.net
        - MAGENTO_SAMPLE_DATA=no
    links:
        - mysql
    container_name: <magento2-web>
    restart: always
mysql:
    image: mysql:5.7
    volumes:
        - ./db:/var/lib/mysql
        - ./build:/build/
        - ./sql:/docker-entrypoint-initdb.d/
        - ./log/mysql:/var/log/mysql/
    ports:
      - 3306:3306
    environment:
        - MYSQL_ROOT_PASSWORD=mysql
        - MYSQL_DATABASE=magento2
    container_name: <magento2-db>
    restart: always

~~~

e iniciar los contenedores:

~~~
$ docker-compose up -d
~~~

## Uso

Cualquier interacción se hace dentro del contenedor web del stack:
~~~
$ docker exec -it <magento2-web> /bin/bash
~~~
y utilizar el usuario magento2 para ejecutar cualquier comando.
~~~
su magento2
~~~

### Iniciar nueva instancia
~~~
~/m2install.sh
~~~
