#/bin/bash
cd /root/桌面/github
git add . -A
daytime=`date +%F`
git commit -m "$daytime" 
git push -u origin master
