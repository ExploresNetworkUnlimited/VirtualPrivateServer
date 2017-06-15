#
#!/bin/bash
#Script Trial Account SSH & VPN
#
IP=`dig +short myip.opendns.com @resolver1.opendns.com`

User=trial`</dev/urandom tr -dc X-Z0-9 | head -c4`
Day="1"
Pass=`</dev/urandom tr -dc a-f0-9 | head -c9`

useradd -e `date -d "$Day days" +"%Y-%m-%d"` -s /bin/false -M $User
echo -e "$Pass\n$Pass\n"|passwd $User &> /dev/null
echo ""
echo "==============================================="
echo "Trial | Cipta Akaun Percubaan (1 Hari)"
echo "==============================================="
echo -e "IP Address: $IP" 
echo -e "Port OpenSSH: 22,80"
echo -e "Port Dropbear: 443, 143"
echo -e "Squid: 80, 8080"
echo -e "Config OpenVPN: http://$IP:81/client.ovpn"
echo -e "Username: $User"
echo -e "Password: $Pass"
echo "==============================================="
echo "DOCTYPE | Explore Network Unlimited"
echo "==============================================="
echo ""
