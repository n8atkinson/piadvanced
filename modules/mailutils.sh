#!/bin/sh
## Mail
NAMEOFAPP="mailutils"
WHATITDOES="Mailutils is a swiss army knife of electronic mail handling."

## Current User
CURRENTUSER="$(whoami)"

## Dependencies Check
sudo bash /etc/piadvanced/dependencies/dep-whiptail.sh

## Variables
source /etc/piadvanced/install/firewall.conf
source /etc/piadvanced/install/variables.conf
source /etc/piadvanced/install/userchange.conf

{ if 
(whiptail --title "$NAMEOFAPP" --yes-button "Skip" --no-button "Proceed" --yesno "Do you want to setup $NAMEOFAPP? $WHATITDOES" 10 80) 
then
echo "$CURRENTUSER Declined $NAMEOFAPP" | sudo tee --append /etc/piadvanced/install/installationlog.txt
echo ""$NAMEOFAPP"install=no" | sudo tee --append /etc/piadvanced/install/variables.conf
else
echo "$CURRENTUSER Accepted $NAMEOFAPP" | sudo tee --append /etc/piadvanced/install/installationlog.txt
echo ""$NAMEOFAPP"install=yes" | sudo tee --append /etc/piadvanced/install/variables.conf

## Below here is the magic.
MAIL_ROOT=$(whiptail --inputbox "What email address do you want to use?" 10 80 "user@gmail.com" 3>&1 1>&2 2>&3)
MAIL_MAILHUB=$(whiptail --inputbox "What email server and port?" 10 80 "smtp.gmail.com:587" 3>&1 1>&2 2>&3)
MAIL_HOSTNAME=$(whiptail --inputbox "Hostname" 10 80 "$NEW_HOSTNAME" 3>&1 1>&2 2>&3)
MAIL_AUTHUSER=$(whiptail --inputbox "Username" 10 80 "$MAIL_ROOT" 3>&1 1>&2 2>&3)
MAIL_AUTHPASS=$(whiptail --inputbox "Password" 10 80 "" 3>&1 1>&2 2>&3)
MAIL_STARTTLS=$(whiptail --inputbox "Use STARTTLS? YES or NO" 10 80 "YES" 3>&1 1>&2 2>&3)
sudo apt-get -y install ssmtp
sudo apt-get -y install mailutils
sudo apt-get -y install mpack
sudo sed -i "s/root=postmaster/root=$MAIL_ROOT/" /etc/ssmtp/ssmtp.conf
sudo echo "mailhub=$MAIL_MAILHUB" | sudo tee --append /etc/ssmtp/ssmtp.conf
sudo sed -i "s/hostname=$OLD_HOSTNAME/hostname=$NEW_HOSTNAME/" /etc/ssmtp/ssmtp.conf
sudo sed -i "s/hostname=$NEW_HOSTNAME/hostname=$MAIL_HOSTNAME/" /etc/ssmtp/ssmtp.conf
sudo echo "AuthUser$MAIL_AUTHUSER" | sudo tee --append /etc/ssmtp/ssmtp.conf
sudo echo "AuthPass=$MAIL_AUTHPASS" | sudo tee --append /etc/ssmtp/ssmtp.conf
sudo echo "useSTARTTLS=$MAIL_STARTTLS" | sudo tee --append /etc/ssmtp/ssmtp.conf
sudo echo "root:$MAIL_ROOT:$MAIL_MAILHUB" | sudo tee --append /etc/ssmtp/revaliases
sudo echo "$CURRENTUSER:$MAIL_ROOT:$MAIL_MAILHUB" | sudo tee --append /etc/ssmtp/revaliases
sudo echo "$MAIL_MAILHUB" | sudo tee --append ~/.forward

## End of install
fi }

## Unset Temporary Variables
unset NAMEOFAPP
unset CURRENTUSER
unset WHATITDOES

## Module Comments
