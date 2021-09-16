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
echo -e "\n"


## Define System Variables
RESOURCE_DIR="$PWD/../resources"
ICONS_DIR="$RESOURCE_DIR/icons"
FONTS_DIR="$RESOURCE_DIR/fonts"
THEMES_DIR="$RESOURCE_DIR/themes"
CURSOR_THEMES_DIR="$RESOURCE_DIR/cursor-themes"
PYTHON_INSTALL_DIR="/home/$SUDO_USER/miniconda"


## Update repositories
apt-get -y update


## Remove bloatwares
apt-get remove -y --purge \
gnome-contacts \
gnome-weather \
geary \
totem


## Install some required packages from repo
apt-get install -y git tlp tlp-rdw powertop \
fonts-roboto gnome-tweaks curl wget gparted \
stacer micro timeshift p7zip-full p7zip-rar \
rar unrar ubuntu-restricted-extras parole \
htop neofetch terminator


## Install packages from external sources
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash


## Install preferred fonts
cp -r $FONTS_DIR/* /usr/share/fonts/ && \
fc-cache -f -v


## Install cursor icons
for file in $CURSOR_THEMES_DIR/*.tar.*; do 
	tar -xvf "$file" -C /usr/share/icons/
done


## Setup temporary download directory
if [ ! -d "$RESOURCE_DIR/tmp" ]; then
	mkdir -p $RESOURCE_DIR/tmp
fi


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
	chown -R "${SUDO_USER}:${SUDO_USER}" $PYTHON_INSTALL_DIR && \
	chown "${SUDO_USER}:${SUDO_USER}" /home/$SUDO_USER/.bashrc.backup && \
	source /home/$SUDO_USER/.bashrc
else
	echo "looks like miniconda is already available"
fi


## Install auto-cpufreq
status=$(systemctl is-active auto-cpufreq.service)
if [ $status == "inactive" ]; then
    
	# create the download directory if not exists
    if [ ! -d "$RESOURCE_DIR/tmp/auto-cpufreq" ]; then
		mkdir -p $RESOURCE_DIR/tmp/auto-cpufreq
	fi
    
	# clone git repository
	git clone https://github.com/AdnanHodzic/auto-cpufreq.git $RESOURCE_DIR/tmp/auto-cpufreq

	# install
    bash "$RESOURCE_DIR/tmp/auto-cpufreq/auto-cpufreq-installer" && \
    auto-cpufreq --install
	echo "auto-cpufreq service status: $(systemctl is-active auto-cpufreq.service)"

else
	echo "auto-cpufreq service status: $(systemctl is-active auto-cpufreq.service)"
    echo "'auto-cpufreq.service' is already enabled, skipping installation ... \n"
fi


## Disable unnecessary systemd services
serviceList=("bluetooth" "NetworkManager-wait-online" "plymouth-quit-wait" "networkd-dispatcher" "systemd-networkd" "ModemManager")
for service in ${serviceList[@]}; do
	checkStatus=$(systemctl is-active ${service}.service)
	if [ ! $checkStatus == "inactive" ]; then
		systemctl disable ${service}.service;
		echo "${service}.service is now disabled on boot"
	else
		echo "${service}.service is either already disabled or doesn't exist"
	fi
done


## Clean apt cache
apt-get -y clean


## Remove redundant dependencies
apt-get -y autoremove


## Remove resources/tmp directory
rm -rf $RESOURCE_DIR/tmp


echo -e "\n"
echo "# ------ Initial system configuration is now complete! ------ #"
echo -e "\n\n"
