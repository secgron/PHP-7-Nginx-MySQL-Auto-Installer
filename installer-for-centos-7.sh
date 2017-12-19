#!/bin/bash
# PHP + NginX + MySQL Auto Installer
# Created by Teguh Aprianto
# https://bukancoder | https://teguh.co

IJO='\e[38;5;82m'
MAG='\e[35m'
RESET='\e[0m'

echo -e "$IJO                                                                                   $RESET"
echo -e "$IJO __________       __                    $MAG _________            .___             $RESET"
echo -e "$IJO \______   \__ __|  | _______    ____   $MAG \_   ___ \  ____   __| _/___________  $RESET"
echo -e "$IJO  |    |  _/  |  \  |/ /\__  \  /    \  $MAG /    \  \/ /  _ \ / __ |/ __ \_  __ \ $RESET"
echo -e "$IJO  |    |   \  |  /    <  / __ \|   |  \ $MAG \     \___(  <_> ) /_/ \  ___/|  | \/ $RESET"
echo -e "$IJO  |______  /____/|__|_ \(____  /___|  / $MAG  \______  /\____/\____ |\___  >__|    $RESET"
echo -e "$IJO        \/           \/     \/     \/   $MAG        \/            \/    \/         $RESET"
echo -e "$IJO ---------------------------------------------------------------------------       $RESET"
echo -e "$IJO |$MAG      PHP + NginX + MySQL Auto Installer on CentOS 7 by Bukan Coder      $IJO| $RESET"
echo -e "$IJO ---------------------------------------------------------------------------       $RESET"
echo -e "$IJO |$IJO                               Created by                                $IJO| $RESET"
echo -e "$IJO |$MAG                             Teguh Aprianto                              $IJO| $RESET"
echo -e "$IJO ---------------------------------------------------------------------------       $RESET"
echo ""

echo -e "$MAG--=[This script will install PHP + NginX + MySQL. Press any key to continue]=--$RESET"
read answer 

echo -e "$MAG--=[Adding the repositories for Epel, Remi & NginX]=--$IJO"
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
sed -i s'/enabled=1/enabled=0/' /etc/yum.repos.d/epel.repo	
sed -i s'/enabled=1/enabled=0/' /etc/yum.repos.d/remi.repo
sed -i s'/enabled=1/enabled=0/' /etc/yum.repos.d/nginx.repo
echo
echo

echo -e "$MAG--=[Installing MySQL]=--$IJO "
yum -y --enablerepo=remi install mysql-server 
echo
echo
echo -e "$MAG--=[Installing PHP 7]=--$IJO"
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
yum -y install php70w php70w-opcache php70w-fpm php70w-mysql
echo
echo
echo -e "$MAG--=[Installing NginX]=--$IJO"
yum -y --enablerepo=nginx install nginx
echo
echo
echo -e "$MAG--=[Creating NginX Default Configuration]=--$IJO"
rm -rf /etc/nginx/conf.d/default.conf
wget https://arc.bukancoder.co/Nginx-conf/default.txt -O /etc/nginx/conf.d/default.conf
echo
echo

echo -e "$MAG--=[Starting PHP, MySQL & Nginx Services]=--$IJO"
systemctl php-fpm start
systemctl mysqld start
systemctl nginx start
echo
echo
echo -e "$MAG--=[Set Services Auto Start after Reboot]=--$IJO"
chkconfig mysqld on
chkconfig php-fpm on
chkconfig nginx on
echo
echo
echo -e "$MAG--=[Creating PHP Info File]=--$IJO"
cd /usr/share/nginx/html/
cat > "info.php" <<EOF

<?php
phpinfo();
?>

EOF
echo
echo -e "$MAG--=[Done! PHP 7, Nginx & MySQL has been installed on your server with IP $IJO $(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/') $MAG]=--$IJO"
echo -e "$MAG--=[PHP Info available on $IJO http://$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')/info.php $MAG]=--$RESET"
