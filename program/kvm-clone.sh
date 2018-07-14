#/bin/bash
echo -e "\e[33;36m==============================================================================\e[0m"
echo -e "\e[33;31m                           自动创建虚拟机                                     \e[0m"
echo "如下为创建虚拟机条件："
echo "1>可用的/var/lib/libvirt/images/{rh7_template.img,.rhel7.xm}文件存在"
echo "2>可用的yum源http://192.168.4.254/rhel7存在"
echo -e "\e[33;33m - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\e[0m"
yum -y install expect &> /dev/null
read -p "请输入创建虚拟机编号(1-99)：" num
IMG_DIR=/var/lib/libvirt/images
BASEVM=rh7_template
NEWVM=pc${num}
if [ -e $IMG_DIR/${NEWVM}.img ]; then
echo -e "\e[33;31m                        ERROR:${NEWVM}已存在                                \e[0m"
echo -e "\e[33;36m==============================================================================\e[0m"
   exit 68
fi
echo -en "Creating Virtual Machine disk image......\t"
qemu-img create -f qcow2 -b $IMG_DIR/.${BASEVM}.img $IMG_DIR/${NEWVM}.img &> /dev/null
echo -e "\e[32;1m[OK]\e[0m"
cat /var/lib/libvirt/images/.rhel7.xml > /tmp/myvm.xml
sed -i "/<name>${BASEVM}/s/${BASEVM}/${NEWVM}/" /tmp/myvm.xml
sed -i "/${BASEVM}\.img/s/${BASEVM}/${NEWVM}/" /tmp/myvm.xml
echo -en "Defining new virtual machine......       \t"
virsh define /tmp/myvm.xml &> /dev/null
echo -e "\e[32;1m[OK]\e[0m"
sleep 2
virsh start pc$num > /dev/null
stat1=$?
if [ $stat1 -ne 0 ];then
   echo -e "\e[33;31m虚拟机pc$num启动失败!!!!!\e[0m"
   virsh destroy pc$num &> /dev/null
   virsh undefine pc$num &> /dev/null
   exit
fi
echo -en "设置IP地址中......                       \t"
(
expect << EOF 
spawn virsh console $NEWVM
sleep 30
expect "localhost" { send "root\r" }
expect "密码" { send "123456\r" }
sleep 10
expect "#" { send "ifconfig eth0 192.168.4.${num}/24\r" }
expect "#" { send "/29"} 
expect eof
EOF
) > /dev/null
ping -c 3 192.168.4.${num} &> /dev/null
stat2=$?
if [ $stat2 -ne 0 ];then
   echo -e "\e[32;31m[IP ADDR:192.168.4.${num}设置失败]\e[0m"
   exit
fi
echo -e "\e[32;1m[IP ADDR:192.168.4.${num}设置完成]\e[0m"
echo -en "部署密钥中......                         \t"
ls /root/.ssh/id_rsa.pub &> /dev/null
stat=$?
if [ $stat -ne 0 ];then
(expect << EOF
spawn ssh-keygen
expect "(/root/.ssh/id_rsa)" { send "\r" }
expect "Enter" { send "\r" }
expect "Enter" { send "\r" }
expect eof
EOF
) > /dev/null
fi
(expect << EOF
spawn ssh-copy-id 192.168.4.$num 
expect "yes/no" { send "yes\r"} 
expect "password:" { send "123456\r"}
expect eof
EOF
) > /dev/null

echo -e "\e[32;1m[密钥部署完成]\e[0m"
echo -en "虚拟机初始化配置中......                 \t"
(
expect << EOF
spawn ssh -X root@192.168.4.$num
expect "#" { send "nmcli connection modify eth0 ipv4.method manual ipv4.addresses 192.168.4.$num/24 connection.autoconnect yes
nmcli connection up eth0\r" }
expect "#" { send "hostname pc${num}.tedu.cn\r" }
expect "#" { send "echo pc${num}.tedu.cn > /etc/hostname\r" }
expect "#" {send "echo 1 | passwd --stdin root\r" }
expect "#" {send "echo \"\[rhel7]
name=rhel7
baseurl=http://192.168.4.254/rhel7
enabled=1
gpgcheck=0\" > /etc/yum.repos.d/rhel7.repo\r" }
expect "#" {send "yum repolist\r" }
expect eof
EOF
) > /dev/null
scp /root/桌面/github/program/* 192.168.4.${num}:/usr/local/sbin/ &> /dev/null
echo -e "\e[32;1m[主机名、初始密码、yum源配置完成]\e[0m"
echo -e "\e[33;31m                          虚拟机${NEWVM}创建完成                              \e[0m"
echo -e "\e[33;36m==============================================================================\e[0m"
