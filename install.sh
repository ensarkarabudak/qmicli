#!/bin/sh

YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[1;34m'
SET='\033[0m'

echo "${YELLOW}What is your carrier APN?${SET}"
read carrierapn 

while [ 1 ]
do
	echo "${YELLOW}Does your carrier need username and password? [Y/n]${SET}"
	read usernpass
	
	case $usernpass in
		[Yy]* )  while [ 1 ] 
        do 
        
        echo "${YELLOW}Enter username${SET}"
        read username

        echo "${YELLOW}Enter password${SET}"
        read password
        break 
        done

        break;;
		
		[Nn]* )  break;;
		*)  echo "${RED}Wrong Selection, Select among Y or n${SET}";;
	esac
done


sudo apt update -y && sudo apt install libqmi-utils udhcpc -y

sudo qmicli -d /dev/cdc-wdm0 --dms-get-operating-mode

sudo qmicli -d /dev/cdc-wdm0 --dms-set-operating-mode='online'

sudo ip link set wwan0 down

echo 'Y' | sudo tee /sys/class/net/wwan0/qmi/raw_ip

echo 'Y' | sudo tee /sys/class/net/wwan0/qmi/raw_ip

sudo qmicli -d /dev/cdc-wdm0 --wda-get-data-format

if [  -z $username ]
then
sudo qmicli -p -d /dev/cdc-wdm0 --device-open-net='net-raw-ip|net-no-qos-header' --wds-start-network="apn='$carrierapn ',ip-type=4" --client-no-release-cid
else
   sudo qmicli -p -d /dev/cdc-wdm0 --device-open-net='net-raw-ip|net-no-qos-header' --wds-start-network="apn='$carrierapn ',username='$username',password='$password',ip-type=4" --client-no-release-cid
fi

sudo udhcpc -q -f -i wwan0

echo "Enjoy your Internet connection."

echo "You may check by pinging ping -I wwan0 -c 5 8.8.8.8"

