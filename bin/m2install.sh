#!/bin/bash
COLOR='\033[0;35m'
NC='\033[0m'
file="/var/www/html/bin/magento"
if [ -f "$file" ]
then
	chown root:www-data /var/www/html -Rf
	echo -e "${COLOR}Magento ya está instalado."
	echo -e "${COLOR}Ahora puedes accesar desde $MAGENTO_BASE_URL $MAGENTO_BACKEND_FRONTNAME${NC}"
else
	echo -e "${COLOR}Obteniendo Magento2..."
	cd /var/www/html
	composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=2.1.9 .
	composer config secure-http false
	composer config minimum-stability alpha
	composer install
	echo -e "${COLOR}Instalando Magento2..."
	php bin/magento setup:install --admin-firstname=admin --admin-lastname=admin --admin-email=$MAGENTO_ADMIN_EMAIL --admin-user=$MAGENTO_ADMIN_USER --admin-password=$MAGENTO_ADMIN_PASSWORD --db-host=$MAGENTO_DB_HOST --db-name=$MAGENTO_DB_NAME --db-user=$MAGENTO_DB_USERNAME --db-password=$MAGENTO_DB_PASSWORD --currency=$MAGENTO_CURRENCY --timezone=$MAGENTO_TIMEZONE --language=$MAGENTO_LANGUAGE --base-url=$MAGENTO_BASE_URL --backend-frontname=$MAGENTO_BACKEND_FRONTNAME
	echo -e "${COLOR}Instalando ObwHub..."
	composer require obw/hub
	composer require obw/backendtheme
	cp /root/.composer/auth.json ./auth.json
	chown root:www-data /var/www/html -Rf
	echo -e "${COLOR}Activando ObwHub..."
	php bin/magento module:enable Obw_Humboldt
	php bin/magento setup:upgrade
	find . -type d -exec chmod 770 {} \; &&  find . -type f -exec chmod 660 {} \; &&  chmod u+x bin/magento
	chown root:www-data /var/www/html -Rf
	chown www-data:www-data /var/www/html/var -Rf
	chmod 774 /var/www/html/var -Rf
	#Soporte para ejecutar composer desde php
	cp /root/composer_update* ./
	chown root composer_update.sh
	chmod u=rwx,go=xr composer_update.sh
	chown root composer_update
	chmod u=rwx,go=xr,+s composer_update
	echo -e "${COLOR}Ahora puedes accesar desde $MAGENTO_BASE_URL $MAGENTO_BACKEND_FRONTNAME${NC}"
fi
