#/bin/bash
#read -p "请输入mysql tar包目录/文件名（msyql-5.7.17）" path1
filepath=`find / -name mysql-5.7.17-1.el7.x86_64.rpm-bundle.tar | sed -n '1p'`
if [ "$filepath" != "" ]; then
	tar -xf $filepath -C /opt/
else
	echo "压缩包不存在"
   	exit
fi	

        cd /opt/
	rm -rf mysql-community-server-minimal-5.7.17-1.el7.x86_64.rpm
	yum -y install perl-JSON
	rpm -Uvh mysql-community-*
	systemctl enable mysqld
	systemctl restart mysqld
	ss -ntulp | grep mysqld 
	result=`echo $?`
	if [ $result -eq 0 ];then
	echo "mysql安装成功"
        rm -rf mysql-community*
	else
	echo "mysql未安装成功"
        rm -rf mysql-community*
	exit
	fi
	pswd=`grep password /var/log/mysqld.log | awk '/temporary/{print $NF}'`
	echo $pswd
	yum -y install expect
expect<<EOF
spawn mysql -uroot -p
expect "Enter" { send "${pswd}\r" }
expect "mysql>" { send "set global validate_password_policy=0;\r" }
expect "mysql>" { send "set global validate_password_length=6;\r" }
expect "mysql>" { send "alter user user() identified by \"123456\";\r" }
expect "mysql>" { send "exit;\r" }
expect eof
EOF
	policy=`sed -n '/validate_password_policy=0/p' /etc/my.cnf`
	length=`sed -n '/validate_password_length=6/p' /etc/my.cnf`
	if [ "$policy" = "" ];then
		sed -i '/\[mysqld\]/a validate_password_policy=0' /etc/my.cnf
	fi
	if [ "$length" = "" ];then
		sed -i '/\[mysqld\]/a validate_password_length=6' /etc/my.cnf
	fi
