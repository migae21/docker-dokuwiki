FROM alpine:3.7
LABEL maintainer mig@aon.at

ENV DOKUWIKI_VERSION 2018-04-22
ENV MD5_CHECKSUM cec26670452f0122807d4f812432df4d
ENV TIMEZONE Europe/Vienna

RUN apk --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.7/main/ add \
libressl2.6-libssl tzdata && \
apk --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.7/community/ add \
php7 php7-fpm php7-gd php7-session php7-zlib php7-openssl php7-xml php7-json php7-iconv nginx supervisor curl tar

RUN mkdir -p /run/nginx && \
mkdir -p /var/www /var/dokuwiki-storage/data && \
mkdir -p /var/www /var/dokuwiki-backup && \
cd /var/www && \
curl -O -L "https://download.dokuwiki.org/src/dokuwiki/dokuwiki-$DOKUWIKI_VERSION.tgz" && \
echo "$MD5_CHECKSUM  dokuwiki-$DOKUWIKI_VERSION.tgz" > dokuwiki-$DOKUWIKI_VERSION.tgz.md5 && \
md5sum -c dokuwiki-$DOKUWIKI_VERSION.tgz.md5 && \
tar -xzf "dokuwiki-$DOKUWIKI_VERSION.tgz" --strip 1 && \
rm "dokuwiki-$DOKUWIKI_VERSION.tgz" && \
mv /var/www/data/pages /var/dokuwiki-storage/data/pages && \
ln -s /var/dokuwiki-storage/data/pages /var/www/data/pages && \
mv /var/www/data/meta /var/dokuwiki-storage/data/meta && \
ln -s /var/dokuwiki-storage/data/meta /var/www/data/meta && \
mv /var/www/data/media /var/dokuwiki-storage/data/media && \
ln -s /var/dokuwiki-storage/data/media /var/www/data/media && \
mv /var/www/data/media_attic /var/dokuwiki-storage/data/media_attic && \
ln -s /var/dokuwiki-storage/data/media_attic /var/www/data/media_attic && \
mv /var/www/data/media_meta /var/dokuwiki-storage/data/media_meta && \
ln -s /var/dokuwiki-storage/data/media_meta /var/www/data/media_meta && \
mv /var/www/data/attic /var/dokuwiki-storage/data/attic && \
ln -s /var/dokuwiki-storage/data/attic /var/www/data/attic && \
mv /var/www/conf /var/dokuwiki-storage/conf && \
ln -s /var/dokuwiki-storage/conf /var/www/conf && \
mv /var/www/lib/tpl /var/dokuwiki-storage/tpl && \
ln -s /var/dokuwiki-storage/tpl /var/www/lib/tpl

ADD nginx.conf /etc/nginx/nginx.conf
ADD supervisord.conf /etc/supervisord.conf
ADD start.sh /start.sh
ADD backup /etc/periodic/daily/backup
ADD backup-plugins /etc/periodic/daily/backup-plugins
ADD uploads.ini /etc/php7/conf.d/uploads.ini

RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php7/php-fpm.ini && \
sed -i -e "s|;daemonize\s*=\s*yes|daemonize = no|g" /etc/php7/php-fpm.conf && \
sed -i -e "s|listen\s*=\s*127\.0\.0\.1:9000|listen = /var/run/php-fpm7.sock|g" /etc/php7/php-fpm.d/www.conf && \
sed -i -e "s|;listen\.owner\s*=\s*|listen.owner = |g" /etc/php7/php-fpm.d/www.conf && \
sed -i -e "s|;listen\.group\s*=\s*|listen.group = |g" /etc/php7/php-fpm.d/www.conf && \
sed -i -e "s|;listen\.mode\s*=\s*|listen.mode = |g" /etc/php7/php-fpm.d/www.conf && \
cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
chown nobody:nobody /var/tmp/nginx && \
chmod +x /start.sh && \
chmod +x /etc/periodic/daily/backup && \
chmod +x /etc/periodic/daily/backup-plugins

EXPOSE 80
VOLUME /var/dokuwiki-storage  /var/www/lib/plugins  /var/dokuwiki-backup

CMD /start.sh
