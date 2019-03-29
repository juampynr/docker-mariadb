CREATE DATABASE myproject;

USE myproject;
SOURCE /tmp/dumps/myproject.sql;

GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;
FLUSH PRIVILEGES;
