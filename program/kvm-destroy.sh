#/bin/bash
read -p "请输入需要删除虚拟主机名称" vpc
virsh destroy $vpc
virsh undefine $vpc
rm -rf /var/lib/libvirt/images/${vpc}.img
echo "虚拟机${vpc}删除完成"

