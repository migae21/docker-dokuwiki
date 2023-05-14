#!/bin/sh

set -e

chown -R nobody /var/www
chown -R nobody /var/dokuwiki-storage
chown -R nobody /var/lib/nginx

su -s /bin/sh nobody -c 'php82 /var/www/bin/indexer.php -c'

exec /usr/bin/supervisord -c /etc/supervisord.conf
