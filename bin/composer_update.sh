#!/bin/sh
composer update
bin/magento module:enable --all
bin/magento setup:upgrade
chown www-data:www-data /var/www/html/var -Rf
chmod 774 /var/www/html/var -Rf