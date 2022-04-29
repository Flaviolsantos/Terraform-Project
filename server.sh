#!/bin/bash


sudo apt update && sudo apt upgrade -y

sudo hostnamectl set-hostname  srv

sudo apt install iptables && sudp apt install netfilter persistent

sudo iptables -A POSTROUTING -o eth0 -j MASQUERADE && sudo netfilter-persistent save

sudo apt install nginx

sudo systemctl start nginx  

sudo rm -rf /var/www/html/index.html 

sudo cat >> /var/www/html/index.html 

bem vindo ao servidor nginx 









