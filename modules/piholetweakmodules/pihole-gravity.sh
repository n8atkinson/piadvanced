#!/bin/sh
## pihole gravity
NAMEOFAPP="piholegravity"

## Dependencies Check
sudo bash /etc/piadvanced/dependencies/dep-whiptail.sh

## Variables
source /etc/piadvanced/install/firewall.conf
source /etc/piadvanced/install/variables.conf
source /etc/piadvanced/install/userchange.conf

{ if 
(whiptail --title "$NAMEOFAPP" --yes-button "Skip" --no-button "Proceed" --yesno "Do you want a script to update gravity every 6 hours?" 8 78) 
then
echo "User Declined $NAMEOFAPP"
else
(crontab -l ; echo "0 */6 * * * sudo bash /etc/piadvanced/piholetweaks/piholegravity.sh") | crontab -
fi }

unset NAMEOFAPP
