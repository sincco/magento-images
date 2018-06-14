#!/bin/bash
#
COLOR='\033[0;35m'
NC='\033[0m'
file="/var/www/html/bin/magento"
if [ -f "$file" ]
then
	chown root:www-data /var/www/html -Rf
	echo -e "${COLOR}Magento ya está instalado."
	echo -e "${COLOR}Ahora puedes accesar desde $MAGENTO_BASE_URL $MAGENTO_BACKEND_FRONTNAME${NC}"
else
	echo -e "${COLOR}Obteniendo Magento2...${NC}"
	cd /var/www/html
	composer create-project --repository-url=https://repo.magento.com/ magento/$MAGENTO_VERSION .
	composer config secure-http false
	composer config minimum-stability alpha
	composer install
	echo -e "${COLOR}Instalando Magento2...${NC}"
	php bin/magento setup:install --admin-firstname=admin --admin-lastname=admin --admin-email=$MAGENTO_ADMIN_EMAIL --admin-user=$MAGENTO_ADMIN_USER --admin-password=$MAGENTO_ADMIN_PASSWORD --db-host=$MAGENTO_DB_HOST --db-name=$MAGENTO_DB_NAME --db-user=$MAGENTO_DB_USERNAME --db-password=$MAGENTO_DB_PASSWORD --currency=$MAGENTO_CURRENCY --timezone=$MAGENTO_TIMEZONE --language=$MAGENTO_LANGUAGE --base-url=$MAGENTO_BASE_URL --backend-frontname=$MAGENTO_BACKEND_FRONTNAME
	composer require sincco/language-es_mx
	composer require magepal/magento2-gmailsmtpapp

	cp /root/.composer/auth.json ./auth.json
	chown root:www-data /var/www/html -Rf
	php bin/magento module:enable MagePal_GmailSmtpApp
	echo -e "${COLOR}Configuraciones básicas...${NC}"
	php bin/magento setup:store-config:set --use-rewrites=1 --language=$MAGENTO_LANGUAGE
	if [ "$MAGENTO_B2B" == "yes" ]
	then
		echo -e "${COLOR}Activando B2B...${NC}"
		composer require magento/extension-b2b
	fi
	php bin/magento setup:upgrade
	php bin/magento setup:di:compile
	php bin/magento setup:static-content:deploy
	find . -type d -exec chmod 770 {} \; &&  find . -type f -exec chmod 660 {} \; &&  chmod u+x bin/magento
	if [ "$MAGENTO_SAMPLE_DATA" == "yes" ]
	then
		echo -e "${COLOR}Cargando productos de ejemplo...${NC}"
		php bin/magento sampledata:deploy
		php bin/magento setup:upgrade
	fi
	if [ "$MAGENTO_DEPLOY_MODE" == "developers" ]
	then
		echo -e "${COLOR}Configurando Grunt...${NC}"
		cp package.json.sample package.json
		cp Gruntfile.js.sample Gruntfile.js
		npm install
		npm update
	fi
	echo -e "${COLOR}Estableciendo modo de trabajo...${NC}"
	php bin/magento deploy:mode:set $MAGENTO_DEPLOY_MODE
	echo -e "${COLOR}Ahora puedes accesar desde $MAGENTO_BASE_URL $MAGENTO_BACKEND_FRONTNAME${NC}"
fi
