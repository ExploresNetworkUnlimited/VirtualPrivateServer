#!/bin/bash
#
#Original Script Copyright www.fornesia.com
#By DOCT | Explore Network Unlimited
#

############################
# Initialization var
############################
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

############################
# Go to root
############################
cd

############################
# Disable IPv6
############################
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

############################
# Install Wget & Curl
############################
apt-get update; apt-get -y install wget curl;

############################
# Set Time To GMT+8
############################
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

############################
# Set Locale
############################
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

############################
# Set Repo
############################
wget -O /etc/apt/sources.list "https://raw.githubusercontent.com/ForNesiaFreak/FNS_Debian7/fornesia.com/null/sources.list.debian7"
wget "http://www.dotdeb.org/dotdeb.gpg"
wget "http://www.webmin.com/jcameron-key.asc"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg
cat jcameron-key.asc | apt-key add -;rm jcameron-key.asc

############################
# Update
############################
apt-get update

############################
# Install Nginx
############################
apt-get -y install nginx

############################
# Install Essential Package
############################
apt-get -y install bmon iftop htop nmap axel nano iptables traceroute sysv-rc-conf dnsutils bc nethogs openvpn vnstat less screen psmisc apt-file whois ptunnel ngrep mtr git zsh mrtg snmp snmpd snmp-mibs-downloader unzip unrar rsyslog debsums rkhunter
apt-get -y install build-essential

############################
# Disable Exim
############################
service exim4 stop
sysv-rc-conf exim4 off

############################
# Update Files
############################
apt-file update

cd

############################
# Install Webserver
############################
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/rizal180499/Auto-Installer-VPS/master/conf/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>DOCT | Explore Network Unlimited</pre>" > /home/vps/public_html/index.html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/nifira123/debian7_32bit/master/vps.conf"
service nginx restart

cd

############################
# Install OpenVPN
############################
wget -O /etc/openvpn/openvpn.tar "https://raw.github.com/arieonline/autoscript/master/conf/openvpn-debian.tar"
cd /etc/openvpn/
tar xf openvpn.tar
wget -O /etc/openvpn/1194.conf "https://raw.githubusercontent.com/rizal180499/Auto-Installer-VPS/master/conf/1194.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
iptables -t nat -I POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
iptables-save > /etc/iptables_yg_baru_dibikin.conf
wget -O /etc/network/if-up.d/iptables "https://raw.githubusercontent.com/nifira123/debian7_32bit/master/iptables"
chmod +x /etc/network/if-up.d/iptables
service openvpn restart

############################
# Configure OpenVPN
############################
cd /etc/openvpn/
wget -O /etc/openvpn/client.ovpn "https://raw.githubusercontent.com/nifira123/debian7_32bit/master/client-1194.conf"
sed -i $MYIP2 /etc/openvpn/client.ovpn;
cp client.ovpn /home/vps/public_html/

cd

############################
# Configure Port SSH
############################
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 80' /etc/ssh/sshd_config
service ssh restart

############################
# Install Dropbear
############################
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 443 -p 143"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
service ssh restart
service dropbear restart

cd

############################
# Install Squid3
############################
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/nifira123/debian7_32bit/master/squid3.conf"
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

cd

############################
# Install Webmin
############################
wget -O webmin-current.deb "http://www.webmin.com/download/deb/webmin-current.deb"
dpkg -i --force-all webmin-current.deb;
apt-get -y -f install;
rm webmin-current.deb
service webmin restart

############################
# Command Script
############################
cd /usr/bin
wget -O Menu "https://raw.github.com/ExploresNetworkUnlimited/VirtualPrivateServer/master/Menu.sh"
wget -O Trial "https://raw.github.com/ExploresNetworkUnlimited/VirtualPrivateServer/master/01.sh"
wget -O Register "https://raw.github.com/ExploresNetworkUnlimited/VirtualPrivateServer/master/02.sh"
wget -O Customer "https://raw.github.com/ExploresNetworkUnlimited/VirtualPrivateServer/master/03.sh"
wget -O Active "https://raw.github.com/ExploresNetworkUnlimited/VirtualPrivateServer/master/04.sh"
wget -O Banned "https://raw.github.com/ExploresNetworkUnlimited/VirtualPrivateServer/master/05.sh"
wget -O Delete "https://raw.github.com/ExploresNetworkUnlimited/VirtualPrivateServer/master/06.sh"
wget -O Speedtest "https://raw.github.com/ExploresNetworkUnlimited/VirtualPrivateServer/master/07.sh"
wget -O System "https://raw.githubusercontent.com/ExploresNetworkUnlimited/VirtualPrivateServer/master/08.sh"
wget -O Restart "https://raw.github.com/ExploresNetworkUnlimited/VirtualPrivateServer/master/09.sh"

chmod +x /usr/bin/Menu
chmod +x /usr/bin/01
chmod +x /usr/bin/02
chmod +x /usr/bin/03
chmod +x /usr/bin/04
chmod +x /usr/bin/05
chmod +x /usr/bin/06
chmod +x /usr/bin/07
chmod +x /usr/bin/08
chmod +x /usr/bin/09

cd

############################
# Finishing
############################
chown -R www-data:www-data /home/vps/public_html
service nginx start
service openvpn restart
service cron restart
service ssh restart
service dropbear restart
service squid3 restart
service webmin restart
rm -rf ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

cd

rm -f Debian7x86.sh

echo "Please Reboot VPS"
