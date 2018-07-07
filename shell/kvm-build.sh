#!/bin/bash
#**************************************************

#搭建初始环境
#设置IP\更改密码\设置主机名\搭建yum仓库

#**************************************************

#输入当前eth0 IP 地址
ipaddress=ifconfig eth0 | sed -n '2p' | awk '{print $2}' 
#配置永久IP地址
nmcli connection modify eth0 ipv4.method manual ipv4.addresses $ipaddress/24 connection.autoconnect yes 
#获取PC主机位地址
hostip=ifconfig eth0 | sed -n '2p' | awk '{print $2}'| awk -F. '{print $4}' 
#设置主机名
hostname pc${hostip}.tedu.cn
echo pc${hostip}.tedu.cn > /etc/hostname
#搭建yum源
echo "[rhel7]
name=rhel7
baseurl=http://192.168.4.254/rhel7
enabled=1
gpgcheck=0
" > /etc/yum.repos.d/rhel7.repo
yum repolist
#修改密码
echo 1 | passwd --stdin root

