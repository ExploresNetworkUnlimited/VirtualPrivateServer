#
#!/bin/bash
#Script Service Restart (OpenSSH, OpenVPN, Dropbear, Webmin & Squid)
#
service dropbear restart
service webmin restart
service squid3 restart
service openvpn restart
service ssh restart
echo ""
