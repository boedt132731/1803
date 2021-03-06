#/bin/bash
yum -y install expect &> /dev/null
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
ls /root/.ssh/id_rsa.pub &> /dev/null
newstat=$?
if [ $newstat -eq 0 ];then
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

for i in ${aa[@]}
do
(expect << EOF
spawn ssh-copy-id 192.168.4.$i
expect "yes/no" { send "yes\r" }
expect "password" { send "1\r" }
expect eof
EOF
) &> /etc/null
done
echo "安全密钥部署成功！！！"
else
echo "安全密钥生成失败！！！"
fi
