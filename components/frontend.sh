#!/bin/bash
echo -e "\e[36m installing Nginx \e[0m"
yum install nginx -y
echo -e "\e[36m Downloading Nginx content \e[0m"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zp"
echo -e "\e[36m Cleanup old nginx content and Extract new download archive file and load confiuration file \e[0m"
cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
echo -e "\e[36m starting Nginx \e[0m"
systemctl enable nginx
systemctl restart nginx


