#!/bin/bash


sudo apt update && sudo apt upgrade -y

sudo hostnamectl set-hostname  cli

sudo apt install -y xfce4 -y xfce4-goodies

sudo apt install -y xrdp chromium-browser filezilla

sudo adduser xrdp ssl-cert

echo xfce4-session > ~/.xsession


sudo sed -i '$d' /etc/netplan /50-cloud-init.yaml

sudo cat <<EOF >> /etc/netplan /50-cloud-init.yaml
        dhcp4-overrides:
            use-dns: false
            use-routes: false
        routes:
        - to: default
            via: 
        nameservers:
            addresses: [192.168.1.1]
    version: 2
EOF

sudo netplan apply




