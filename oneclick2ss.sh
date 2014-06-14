#!/bin/bash
# Script function : One click to install shadowscoks.
# Script version : 20140614
# Author : null
# Made : 2014.06.14
# Support : Only CentOS 6.0+

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
LANG=C

export PATH
export LANG

if [ $1 = "uninstall" ] >> installss.log 2>&1 ;
then
echo "Uninstall all node and shadowsocks"
rm -rf ./node* ./shadowsocks* >> installss.log 2>&1
sed -i '/ssserver/d' /etc/rc.d/rc.local >> installss.log 2>&1
sed -i '/oneclickss/d' /etc/crontab >> installss.log 2>&1
kill -9 $(ps -ef | grep ssserver | awk '{print $2}' | head -n 1) >> installss.log 2>&1
service crond restart >> installss.log 2>&1
rm -rf ./installss.log
echo "Uninstall success"
exit 0
fi

if [ $1 = "restart" ] >> /dev/null 2>&1 ;
then
echo "restart all node and shadowsocks"
kill -9 $(ps -ef | grep ssserver | awk '{print $2}' | head -n 1) >> /dev/null 2>&1
source /etc/rc.d/rc.local >> /dev/null 2>&1
echo "Restart success"
exit 0
fi

SERVERPORT=$1
LOCALPORT=$2
PASSWORD=$3

echo "Stop iptables service"
service iptables stop >> installss.log 2>&1

if [ $# -ne 3 ];
then
echo "You do not enter your setting like => sh oneclick2ss.sh serverport localport password"
SERVERPORT=8980
LOCALPORT=1030
PASSWORD="shadowsocks"
echo "Your setting is default"
fi

yum -y install wget unzip >> installss.log 2>&1
echo "Install environment success"

wget http://nodejs.org/dist/v0.10.28/node-v0.10.28-linux-x86.tar.gz >> installss.log 2>&1
wget -O shadowsocks-nodejs.zip https://github.com/clowwindy/shadowsocks-nodejs/archive/master.zip >> installss.log 2>&1
echo "Download nodejs and shadowsocks success"

tar -zxvf node-v0.10.28-linux-x86.tar.gz >> installss.log 2>&1
unzip shadowsocks-nodejs.zip >> installss.log 2>&1
echo "Tar and unzip success"

rm -rf shadowsocks-nodejs.zip node-v0.10.28-linux-x86.tar.gz >> installss.log 2>&1
echo "Remove all the tar success"

mv node-v0.10.28-linux-x86 nodejs >> installss.log 2>&1
mv shadowsocks-nodejs-master shadowsocks >> installss.log 2>&1
echo "Rename to nodejs and shadowsocks success"

CONFIGPATH=$(pwd)/shadowsocks/config.json
echo "Your config path is $CONFIGPATH"

SERVERIP=$(ifconfig | grep "inet addr" | awk '{print $2}'| cut -d ':' -f 2 | grep -v 127.0.0 | head -n 1)

sed "s/127\.0\.0\.1/$SERVERIP/g" -i $CONFIGPATH
echo "Your server ip is $SERVERIP"

sed "s/8388/$SERVERPORT/g" -i $CONFIGPATH
echo "Your server port is $SERVERPORT"

sed "s/1080/$LOCALPORT/g" -i $CONFIGPATH
echo "Your proxy port is $LOCALPORT"

sed "s/barfoo\!/$PASSWORD/g" -i $CONFIGPATH
echo "Your encryption method AES-256-CFB password is $PASSWORD"

echo "$(pwd)/nodejs/bin/node $(pwd)/shadowsocks/bin/ssserver > /dev/null 2>&1 &" >> /etc/rc.d/rc.local
source /etc/rc.d/rc.local >> installss.log 2>&1
echo "Add to powerboot success"

echo "0  1  *  *  * root sh $(pwd)/oneclick2ss.sh restart" >> /etc/crontab
service crond restart >> installss.log 2>&1
echo "Add to auto reboot success"

echo "End success"
