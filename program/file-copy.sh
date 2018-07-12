#/bin/bash
if [ "$1" = "" ];then
   read -p "请输入搜索内容：" vax
else
   vax=$1
fi
case $vax in 
mysql)
file=`find / -name mysql-5.7.17-1.el7.x86_64.rpm-bundle.tar | sed -n '1p'`
;;
lnmp)
file=`find / -name lnmp_soft.tar.gz | sed -n '1p'`
;;
*)
file=`find / -name ${vax} | sed -n '1p'` &> /dev/null
if [ "$file" = "${vax}" ];then
  echo "传输文件:$file "
   break
else
   echo "未找到查询文件，以下为相似结果:"
   find / -name ${vax}
   exit
fi
esac
read -p "请输入传送地址:" dir
echo $dir
pscp.pssh -H "$dir" $file /opt/ 2> /dev/null
