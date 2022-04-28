#!/bin/bash

echo "[TASK 0] Change root password"
sudo chpasswd <<<"root:root"

echo "[TASK 1] Update"
yum update -y

echo "[TASK 2] Install utilites"
yum install vim mc wget -y

echo "============= [TASK 3] Install nginx ============="
yum install epel-release -y
yum install nginx -y
systemctl start nginx
systemctl enable nginx
nginx -v


echo "============= [TASK 4] Install php-fpm ============="
rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum install yum-utils;
yum-config-manager --enable remi-php71;
yum install php-mysqlnd php-fpm php-mbstring php-cli -y
systemctl start php-fpm;
systemctl enable php-fpm;
php --version

echo "============= [TASK 5] Install mysql ============="

wget http://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm

yum localinstall mysql57-community-release-el7-11.noarch.rpm

yum repolist enabled | grep “mysql.-community.”

#  4. Установите mysql.
yum install mysql-community-server

systemctl start mysqld

systemctl enable mysqld
systemctl daemon-reload

echo "============= [TASK 6] Install node ============="

curl -fsSL https://rpm.nodesource.com/setup_16.x | sudo bash -
yum install -y nodejs
echo "Node version:"
node -v
echo "npm version"
npm -v
# install pm2 manager
npm i -g pm2