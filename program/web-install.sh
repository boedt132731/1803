#/bin/bash
echo "###################################################"
echo ""
echo "web服务搭建：1 > httpd  2 > tomcat  3 > nginx"
echo ""
echo "###################################################"
read -p "请输入选择:" num
echo $num

case $num in 
1)
yum -y install httpd >> /dev/null
echo "http web服务器" > /var/www/html/index.html
systemctl restart httpd
systemctl enable httpd
stat=`systemctl status httpd | awk '/active/{print $2}'`
#echo $stat
if [ $stat == "active" ];then
   echo "httpd web服务器安装成功"
   else
   echo "http web服务器安装失败"
fi
;;
2)
read -p "请输入tomcat tar包目录/文件名" path2
tar -xf $path2 -C /usr/local/
mv /usr/local/apache-tomcat* /usr/local/tomcat
/usr/local/tomcat/bin/startup.sh
ss -ntulp | grep :8080
if [ $? -eq 0 ];then
  echo "tomcat安装成功"
else
  echo "tomcat安装失败"
fi
;;
3)
read -p "请输入nginx tar包目录/文件名" path3
tar -xf $path3 -C /opt
cd /opt/nginx-*
useradd -s /sbin/nologin nginx
yum -y install gcc make openssl-devel pcre-devel
./configure --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_ssl_module --with-http_stub_module --whth-stream_module
make && make install
killall -9 httpd
/usr/local/nginx/bin/nginx
ss -ntulp | grep nginx
echo "aaa$?"
;;
*)
echo "输入1-3以内数字"
esac

