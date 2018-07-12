#/bin/bash
expect << EOF
spawn ssh -X root@192.168.4.50 
expect "#" { send "ifconfig eth0 192.168.4.51/24\r"}
expect eof
EOF
