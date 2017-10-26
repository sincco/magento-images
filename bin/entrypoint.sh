#!/bin/bash

### php.ini
[ ! -z "${PHP_MEMORY_LIMIT}" ] && sed -i "s/PHP_MEMORY_LIMIT/${PHP_MEMORY_LIMIT}/" /usr/local/etc/php/php.ini
[ ! -z "${PHP_MAXEXECUTION_TIME}" ] && sed -i "s/PHP_MAXEXECUTION_TIME/${PHP_MAXEXECUTION_TIME}/" /usr/local/etc/php/php.ini
[ ! -z "${PHP_UPLOAD_MAX_FILESIZE}" ] && sed -i "s/PHP_UPLOAD_MAX_FILESIZE/${PHP_UPLOAD_MAX_FILESIZE}/" /usr/local/etc/php/php.ini
[ ! -z "${PHP_POST_MAX_SIZE}" ] && sed -i "s/PHP_POST_MAX_SIZE/${PHP_POST_MAX_SIZE}/" /usr/local/etc/php/php.ini
[ ! -z "${PHP_MAX_IMPUT_VARS}" ] && sed -i "s/PHP_MAX_IMPUT_VARS/${PHP_MAX_IMPUT_VARS}/" /usr/local/etc/php/php.ini
[ ! -z "${PHP_DISPLAY_ERRORS}" ] && sed -i "s/PHP_DISPLAY_ERRORS/${PHP_DISPLAY_ERRORS}/" /usr/local/etc/php/php.ini
### www.conf
[ ! -z "${WEBSERVER_USER}" ] && sed -i "s/WEBSERVER_USER/${WEBSERVER_USER}/" /usr/local/etc/php-fpm.d/www.conf
[ ! -z "${MAGENTO_DEPLOY_MODE}" ] && sed -i "s/MAGENTO_DEPLOY_MODE/${MAGENTO_DEPLOY_MODE}/" /usr/local/etc/php-fpm.d/www.conf
### default.conf
[ ! -z "${SERVER_NAME}" ] && sed -i "s/SERVER_NAME/${SERVER_NAME}/" /etc/nginx/conf.d/default.conf 
[ ! -z "${MAGENTO_DEPLOY_MODE}" ] && sed -i "s/MAGENTO_DEPLOY_MODE/${MAGENTO_DEPLOY_MODE}/" /etc/nginx/conf.d/default.conf 
### m2install.sh
[ ! -z "${MAGENTO_VERSION}" ] && sed -i "s/MAGENTO_VERSION/${MAGENTO_VERSION}/" /home/magento2/m2install.sh
### magento.repo
[ ! -z "${MAGENTO_REPO_PUBLIC_KEY}" ] && sed -i "s/MAGENTO_REPO_PUBLIC_KEY/${MAGENTO_REPO_PUBLIC_KEY}/" /home/magento2/.composer/auth.json
[ ! -z "${MAGENTO_REPO_PRIVATE_KEY}" ] && sed -i "s/MAGENTO_REPO_PRIVATE_KEY/${MAGENTO_REPO_PRIVATE_KEY}/" /home/magento2/.composer/auth.json
### supervisord
[ ! -z "${MAGENTO_USER}" ] && sed -i "s/MAGENTO_USER/${MAGENTO_USER}/" /etc/supervisord.conf

export PATH=$PATH:/var/www/html/bin
chown -R $MAGENTO_USER:$WEBSERVER_USER /var/www/html -Rf
chown -R $MAGENTO_USER:root /home/$MAGENTO_USER -Rf

supervisord -n -c /etc/supervisord.conf


