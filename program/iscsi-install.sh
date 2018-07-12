#/bin/bash
echo "请进行安装选择：
	1>安装服务器端
	2>安装客户端"
read -p "" c
case $c in
1) 
yum -y install targetcli
yum -y install expect
systemctl enable target
systemctl restart target
read -p "请输入后端存储磁盘如：/dev/vdb" bak
read -p "请输入iqn对象名如：iqn.2018-01.cn.tedu:server1" iqn1
read -p "请输入客户端iqn名如：iqn.2018-01.cn.tedu:client1" iqn2
expect << EOF
spawn targetcli
expect "/>" { send "backstores/block create blk ${bak}\r" }
expect "/>" { send "iscsi/ create ${iqn1}\r" }
expect "/>" { send "iscsi/${iqn1}/tpg1/acls create ${iqn2}\r" }
expect "/>" { send "iscsi/${iqn1}/tpg1/luns create /backstores/block/blk\r" }
expect "/>" { send "iscsi/${iqn1}/tpg1/potals create 0.0.0.0\r" }
expect "/>" { send "exit\r" }
expect eof
EOF
;;
2)
yum -y install iscsi-initiator-utils
systemctl restart iscsi
read -p"请输入访问控制acl iqn：" iqn3
sed -i '1c InitiatiorName='${iqn3}'' /etc/iscsi/initiatorname.iscsi
read -p "请输入iscsi地址：" ip
iscsiadm --mode discoverydb --type sendtargets --portal $ip --discover
;;
*)
echo "请输入1或2"
esac
