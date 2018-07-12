#/bin/bash
<<<<<<< HEAD
yum -y install expect &> /dev/null
##expect默认最后一行不执行
ls /root/.ssh/id_rsa.pub &> /dev/null
stat=$?
if [ $stat -ne 0 ];then
(expect << EOF
=======
yum -y install expect
##expect默认最后一行不执行
expect << EOF
>>>>>>> 13887e175bf14c29b906de8e673cf93f48c08478
spawn ssh-keygen
expect "(/root/.ssh/id_rsa)" { send "\r" }
expect "Enter" { send "\r" }
expect "Enter" { send "\r" }
expect eof
EOF
<<<<<<< HEAD
) > /dev/null
fi
ls /root/.ssh/id_rsa.pub &> /dev/null
newstat=$?
if [ $stat -eq 0 ];then
echo "安全密钥对生成完成！！！"；
read -p "请输入需要部署密钥主机IP地址主机位置(如:2 3 用空格隔开):" a

for x in {0..100}
do
ai=`echo "$a" | awk '{print $x}'`
if [ "$ai" != "" ];then
aa[i]=$ai
else
break
fi
done
#echo ${aa[@]}

for i in ${aa[@]}
=======
ls /root/.ssh/
echo "安全密钥对生成完成"；
echo "在192.168.4.50-57主机部署密钥登陆,请确认已经安装ssh服务"

for i in 1 2 3
>>>>>>> 13887e175bf14c29b906de8e673cf93f48c08478
do
expect << EOF
spawn ssh-copy-id 192.168.4.$i
expect "yes/no" { send "yes\r" }
expect "password" { send "1\r" }
expect eof
EOF
done
<<<<<<< HEAD
else
echo "安全密钥生成失败！！！"
fi
=======
>>>>>>> 13887e175bf14c29b906de8e673cf93f48c08478
