#!/bin/bash

sudo yum install httpd -y
sudo systemctl start httpd
sudo echo "This is a web app" >> /var/www/html/index.html