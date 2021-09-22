#!/bin/bash

## Check for root user
if [[ $EUID -ne 0 ]]; then
	echo "This script must be executed as root"
	exit 1
fi

echo -e "\n\n"
echo "###### ############################ ######"
echo "###### Initial System Configuration ######"
echo "###### ############################ ######"
echo -e "\n\n"


## Define System Variables
RESOURCE_DIR="$PWD/../resources"
FONTS_DIR="$RESOURCE_DIR/fonts"
CURSOR_THEMES_DIR="$RESOURCE_DIR/cursor-themes"
BACKGROUNDS_DIR="$RESOURCE_DIR/backgrounds"
PYTHON_INSTALL_DIR="/home/$SUDO_USER/miniconda"
DEB_PKG_DIR="$RESOURCE_DIR/deb-pkgs"
THEMES_DIR="$RESOURCE_DIR/themes"
ICONS_DIR="$RESOURCE_DIR/icons"


## Turn off system beep sound on backspace and/or logout
echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf


## Copy redshift configuration file
cp $RESOURCE_DIR/conf-files/redshift.conf /home/$SUDO_USER/.config/


## Add 'non-free' and 'contrib' sources
apt-get install -y software-properties-common && \
add-apt-repository "contrib" && \
add-apt-repository "non-free"


## Update repositories
apt-get -y update
echo -e "\n\n"


## Install some required packages from repo
apt-get install -y git tlp tlp-rdw powertop \
fonts-roboto curl wget gparted stacer micro timeshift \
p7zip-full p7zip-rar rar unrar parole htop neofetch \
terminator gufw pavucontrol papirus-icon-theme plank \
redshift-gtk lightdm-gtk-greeter-settings arc-theme \
gdebi galculator grsync gnome-disk-utility synaptic gimp \
gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly \
gstreamer1.0-plugins-good transmission-gtk lsb-release \
build-essential bash-completion vim
echo -e "\n\n"


# Install additional packages offline
for file in $DEB_PKG_DIR/*.deb; do
	apt-get install $file
done
apt-get -f install


## Install additional fonts
cp -r $FONTS_DIR/* /usr/share/fonts/ && \
fc-cache -f -v
echo -e "\n\n"


## Install cursor themes
for file in $CURSOR_THEMES_DIR/*.tar.*; do 
	tar -xvf "$file" -C /usr/share/icons/
done
echo -e "\n\n"


# Install additional desktop background images
for file in $BACKGROUNDS_DIR/*; do 
	cp $file /usr/share/images/desktop-base/
done
echo -e "\n\n"


## Setup temporary download directory
if [ ! -d "$RESOURCE_DIR/tmp" ]; then
	mkdir -p $RESOURCE_DIR/tmp
fi
echo -e "\n\n"


## Install miniconda python
if [ ! -f "$RESOURCE_DIR/tmp/miniconda.sh" ]; then
	# echo -e "\nINFO: downloading miniconda installer script ...\n"
	wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
	-O $RESOURCE_DIR/tmp/miniconda.sh
fi

if [ ! -d "$PYTHON_INSTALL_DIR" ]; then
	# Unpack payload
	bash $RESOURCE_DIR/tmp/miniconda.sh -b -p $PYTHON_INSTALL_DIR && \
	cp "/home/$SUDO_USER/.bashrc" "/home/$SUDO_USER/.bashrc.backup" && \
	echo -e "\n# miniconda configuration\nexport PATH='$PYTHON_INSTALL_DIR/bin':$PATH" \
	>> /home/$SUDO_USER/.bashrc && \
	chown -R "$SUDO_USER:$SUDO_USER" $PYTHON_INSTALL_DIR && \
	chown "$SUDO_USER:$SUDO_USER" /home/$SUDO_USER/.bashrc.backup && \
	source /home/$SUDO_USER/.bashrc
else
	echo "looks like miniconda is already available"
fi
echo -e "\n\n"


## Install auto-cpufreq
status=$(systemctl is-active auto-cpufreq.service)
if [ $status == "inactive" ]; then
	# create the download directory if not exists
	if [ ! -d "$RESOURCE_DIR/tmp/auto-cpufreq" ]; then
		mkdir -p $RESOURCE_DIR/tmp/auto-cpufreq
	fi
	
	# clone git repository
	git clone https://github.com/AdnanHodzic/auto-cpufreq.git \
	$RESOURCE_DIR/tmp/auto-cpufreq

	# install
	bash "$RESOURCE_DIR/tmp/auto-cpufreq/auto-cpufreq-installer" && \
	auto-cpufreq --install
	echo "auto-cpufreq service status: $(systemctl is-active auto-cpufreq.service)"
else
	echo "auto-cpufreq service status: $(systemctl is-active auto-cpufreq.service)"
	echo "'auto-cpufreq.service' is already enabled, skipping installation ... \n"
fi
echo -e "\n\n"


## Enable services on boot
serviceToEnable=("fstrim.timer" "ufw.service")
for service in ${serviceToEnable[@]}; do
	checkStatus=$(systemctl is-active $service)
	if [ ! $checkStatus == "active" ]; then
		systemctl enable $service
		echo "---> $service is now enabled on boot"
	else
		echo "---> $service is already enabled and running"
	fi
done
echo -e "\n\n"


## Disable unnecessary systemd services
serviceToDisable=("bluetooth" "NetworkManager-wait-online" "networkd-dispatcher" "systemd-networkd" "ModemManager")
for service in ${serviceToDisable[@]}; do
	checkStatus=$(systemctl is-active ${service}.service)
	if [ ! $checkStatus == "inactive" ]; then
		systemctl disable ${service}.service
		echo "---> ${service}.service is now disabled on boot"
	else
		echo "---> ${service}.service is either already disabled or doesn't exist"
	fi
done
echo -e "\n\n"


## Perform upgrade
apt-get -y dist-upgrade


## Clean apt cache
apt-get -y clean
echo -e "\n\n"


## Remove redundant dependencies
apt-get -y autoremove
echo -e "\n\n"


## Remove resources/tmp directory
echo -e "Deleting $RESOURCE_DIR/tmp\n\n"
rm -rf $RESOURCE_DIR/tmp;


echo "# ------ Initial system configuration is now complete! ------ #"
echo -e "\n\n"


## References for other useful packages
# GitHub Desktop for linux: https://github.com/shiftkey/desktop/releases
