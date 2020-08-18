#!/bin/bash -x
#Setup hostname and fqdn resolved to private ip
yum -y update
yum -y install mysql-server mysql
service mysqld start

mysql -uroot <<MYSQL_SCRIPT
CREATE DATABASE wikidatabase;
CREATE USER 'wiki'@'%' IDENTIFIED BY 'admin123';
GRANT ALL ON wikidatabase.* TO wiki@'%' IDENTIFIED BY 'admin123';
MYSQL_SCRIPT
EOF

chkconfig mysqld on
