#/bin/bash
echo "安装mongodb******************************"
file=`find / -type f -name mongodb-linux-x86_64-rhel70-3.6.3.tgz | sed -n '1p'`
echo "软件包位置：$file"
if [ "$file" != "" ];then
	tar -xf $file -C /opt
        mkdir /usr/local/mongodb/
	cp -r /opt/mongodb-linux-x86_64-rhel70-3.6.3/bin /usr/local/mongodb/
        cd /usr/local/mongodb
	mkdir -p etc log data/db
	host=`ifconfig eth0 | awk -n '/broadcast/{print $2}' | awk -F. '{print $4}'`
	echo "logpath=/usr/local/mongodb/log/mongodb.log
logappend=true			
dbpath=/usr/local/mongodb/data/db
fork=true			
bind_ip=192.168.4.$host
port=270$host		" > /usr/local/mongodb/etc/mongodb.conf
echo "export PATH=/usr/local/mongodb/bin:\$PATH" >> /etc/profile
. /etc/profile
echo $PATH
mongod -f /usr/local/mongodb/etc/mongodb.conf
ss -ntulp | grep 270$host
else
	echo "未找到安装软件包,请确保存在mongodb-linux-x86_64-rhel70-3.6.3.tgz软件包"
fi
