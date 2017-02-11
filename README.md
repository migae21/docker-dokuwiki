# docker-dokuwiki
A doker image providing dokwiki with focus of backup in the container 

This project based on the work of https://github.com/istepanov/docker-dokuwiki

with some improvements:
  * It will check the md5sum of the dokuwiki download.
  * It adds php7-openssl an his depencys to ssl-download plugins within the image (https://github.com/Simon-L/docker-dokuwiki)
  * It creates a volume "lib/plugins" for easy add|remove|backup plugins
  * It creates a volume "var/dokuwiki-backup" witch contains a week of daily Backups per cron
  
  
