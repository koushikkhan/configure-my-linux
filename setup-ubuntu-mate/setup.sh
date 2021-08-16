#!/usr/bin/bash

echo -e "\n########### AUTOMATED CONFIGURATION SCRIPT ###########\n"


## Add necessary GPG keys
echo -e "\nINFO: Setting up GPG keys ...\n"
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg \
 | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/vscodium.gpg && \
echo 'deb https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' \
 | sudo tee --append /etc/apt/sources.list.d/vscodium.list


## Install necessary programs, create necessary folders
echo -e "\nINFO: Running apt update and installing packages ...\n"
sudo apt update && \
sudo apt -y dist-upgrade && \
sudo apt -y install git tlp \
tlp-rdw redshift-gtk ufw gufw \
gimp vlc curl wget synaptic \
synapse ubuntu-restricted-extras \
codium papirus-icon-theme transmission-gtk \
gparted stacer gstreamer1.0-plugins-good \
gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly \
keepassxc p7zip-full p7zip-rar rar unrar guvcview


## Create directory for taking configuration backup
echo -e "\nINFO: Setting up backup directory ...\n"
mkdir $HOME/.copies


## Remove unnecessary dependencies
echo -e "\nINFO: Removing unnecessary package dependencies ...\n"
sudo apt -y autoremove


## Configure redshift
echo -e "\nINFO: Setting up redshift configurations ...\n"
touch $HOME/.config/redshift.conf && \
echo -e "[redshift]
; Set the day and night screen temperatures
temp-day=4000
temp-night=4000

; Enable/Disable a smooth transition between day and night
; 0 will cause a direct change from day to night screen temperature.
; 1 will gradually increase or decrease the screen temperature
transition=1

; Set the screen brightness. Default is 1.0
;brightness=0.9
; It is also possible to use different settings for day and night since version 1.8.
;brightness-day=0.7
;brightness-night=0.4
; Set the screen gamma (for all colors, or each color channel individually)
gamma=0.9

;gamma=0.8:0.7:0.8
; Set the location-provider: 'geoclue', 'gnome-clock', 'manual'
; type 'redshift -l list' to see possible values
; The location provider settings are in a different section.
location-provider=manual

; Set the adjustment-method: 'randr', 'vidmode'
; type 'redshift -m list' to see all possible values
; 'randr' is the preferred method, 'vidmode' is an older API
; but works in some cases when 'randr' does not.
; The adjustment method settings are in a different section.
adjustment-method=randr

; Configuration of the location-provider:
; type 'redshift -l PROVIDER:help' to see the settings
; e.g. 'redshift -l manual:help'
[manual]
lat=22.57
lon=88.36
; Configuration of the adjustment-method
; type 'redshift -m METHOD:help' to see the settings
; ex: 'redshift -m randr:help'
; In this example, randr is configured to adjust screen 1.
; Note that the numbering starts from 0, so this is actually the second screen.
[randr]
screen=0" > $HOME/.config/redshift.conf


## Install miniconda python for scientific computing
echo -e "\nINFO: Setting up miniconda python ...\n"
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
-O /tmp/miniconda.sh && \
bash /tmp/miniconda.sh -b -p $HOME/miniconda && \
cp $HOME/.bashrc $HOME/.copies/.bashrc.bak && \
echo -e "# miniconda configuration\nexport PATH=$HOME/miniconda/bin:$PATH" && \
>> $HOME/.bashrc


## Configure `auto-cpufreq`
echo -e "\nINFO: Setting up auto-cpufreq ...\n"
git clone https://github.com/AdnanHodzic/auto-cpufreq.git /tmp/autocpufreq/ && \
sudo bash /tmp/autocpufreq/auto-cpufreq-installer && \
sudo auto-cpufreq --install


## Configure necessary services
echo -e "\nINFO: Setting up necessary systemd services ...\n"
sudo systemctl enable --now fstrim.timer && \
sudo systemctl enable --now ufw.service
