#!/bin/sh
## Usermin

## Dependencies Check
sudo bash /etc/piadvanced/dependencies/dep-whiptail.sh

## Variables
source /etc/piadvanced/install/firewall.conf
source /etc/piadvanced/install/variables.conf
source /etc/piadvanced/install/userchange.conf

{ if 
(whiptail --title "Usermin" --yes-button "Skip" --no-button "Proceed" --yesno "Do you want to install Usermin?" 10 80) 
then
echo "User Declined Usermin"
else
sudo apt-get install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl
sudo wget http://prdownloads.sourceforge.net/webadmin/usermin_1.701_all.deb
sudo dpkg --install usermin_1.701_all.deb
sudo echo "userminfirewall=yes" | sudo tee --append /etc/piadvanced/install/firewall.conf
fi }
