#/bin/bash
if [ "$1" != "" ];then
vpc=$1
else
read -p "请输入需要删除虚拟主机名称" vpc
fi
virsh destroy $vpc
virsh undefine $vpc
rm -rf /var/lib/libvirt/images/${vpc}.img
ls /var/lib/libvirt/images/${vpc}.img &> /dev/null
s_img=$?
ls /etc/libvirt/qemu/${vpc}.xml &> /dev/null
s_xml=$?
if [ $s_img -ne 0 -a $s_xml -ne 0 ];then
echo "虚拟机${vpc}删除完成"
else 
echo "虚拟机${vpc}删除失败"
fi
