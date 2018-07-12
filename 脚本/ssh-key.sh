#/bin/bash
yum -y install expect
##expect默认最后一行不执行
expect << EOF
spawn ssh-keygen
expect "(/root/.ssh/id_rsa)" { send "\r" }
expect "Enter" { send "\r" }
expect "Enter" { send "\r" }
expect eof
EOF
ls /root/.ssh/
echo "安全密钥对生成完成"；
echo "在192.168.4.50-57主机部署密钥登陆,请确认已经安装ssh服务"

for i in 1 2 3
do
expect << EOF
spawn ssh-copy-id 192.168.4.$i
expect "yes/no" { send "yes\r" }
expect "password" { send "1\r" }
expect eof
EOF
done
