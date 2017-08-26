#
#!/bin/bash
#Script cipta akaun percubaan SSH/VPN
#Sunan | Explore Network Unlimited
#

IP=`dig +short myip.opendns.com @resolver1.opendns.com`

User=`</dev/urandom tr -dc X-Z0-9 | head -c5`
Day="1"
Pass=`</dev/urandom tr -dc A-C0-9 | head -c5`

useradd -e `date -d "$Day days" +"%Y-%m-%d"` -s /bin/false -M $User
echo -e "$Pass\n$Pass\n"|passwd $User &> /dev/null
echo ""
echo "==============================================="
echo "Trial | Cipta Akaun Percubaan (1 Hari)"
echo "==============================================="
echo -e "IP Address: $IP"
echo -e "Port OpenSSH: 22"
echo -e "Port Dropbear: 443"
echo -e "Squid: 8080"
echo -e "Config OpenVPN: http://$IP/client.ovpn"
echo -e "Username: $User"
echo -e "Password: $Pass"
echo "==============================================="
echo "Sunan | Explore Network Unlimited"
echo "==============================================="
echo ""
