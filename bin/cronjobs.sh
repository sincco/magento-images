#!/bin/bash

(crontab -l; echo "*/1 * * * * /usr/local/bin/php /var/www/html/bin/magento cron:run >> /var/www/html/var/log/magento.cron.log") | crontab -
(crontab -l; echo "*/1 * * * * /usr/local/bin/php /var/www/html/update/cron.php >> /var/www/html/var/log/update.cron.log") | crontab -
(crontab -l; echo "*/1 * * * * /usr/local/bin/php /var/www/html/bin/magento setup:cron:run >> /var/www/html/var/log/setup.cron.log") | crontab -