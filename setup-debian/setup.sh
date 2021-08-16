#!/bin/bash

# clear screen
clear && sleep 3


## clean apt cache
echo -e "\nINFO: cleaning existing package cache ...\n"
sudo apt clean


## add non-free and contrib sources
echo -e "\nINFO: setting up additional package sources ...\n"
sudo apt-add-repository non-free && \
sudo apt-add-repository contrib


## remove applications (optional, uncomment if needed)
echo -e "\nINFO: removing unused applications / bloatwares ...\n"
sudo apt remove -y --purge \
gnome-games \ 
cheese \
evolution \
evolution-ews \
gnome-boxes \
gnome-calendar \
gnome-contacts \
gnome-dictionary \
gnome-documents \
gnome-getting-started-docs \
gnome-initial-setup \
gnome-maps \
gnome-online-miners \
gnome-photos \
gnome-software \
gnome-user-docs \
gnome-user-share \
gnome-video-effects \
gnome-weather \
simple-scan \
totem \
yelp \
rhythmbox* && \
sudo apt autoremove


## configure icons and themes
echo -e "\nINFO: installing additional themes and icons ...\n"
wget -qO- https://git.io/papirus-icon-theme-install | sh && \
sudo tar -xvf ./icons/Pop_Cyan.tar.gz -C /usr/share/icons && \
sudo tar -xvf ./icons/Pop_Cyan_Dark.tar.gz -C /usr/share/icons && \
sudo tar -xvf ./icons/macOSBigSur.tar.gz -C /usr/share/icons && \
sudo tar -xvf ./themes/Prof-Gnome-Dark-3.6.tar.xz -C /usr/share/themes && \
sudo tar -xvf ./themes/Prof-Gnome-Darker-3.6.tar.xz -C /usr/share/themes && \
sudo tar -xvf ./themes/Prof-Gnome-Light-3.6.tar.xz -C /usr/share/themes && \
sudo tar -xvf ./themes/Prof-Gnome-Light-DS-3.6.tar.xz -C /usr/share/themes


## install additional fonts
echo -e "\nINFO: installing additional fonts ...\n"
sudo cp -r ./fonts/* /usr/share/fonts/ && \
sudo fc-cache -f -v


## define path valriables
BKP_DIR="/home/$USER/.config-backup" # backup directory
DL_PKGS_DIR="/home/$USER/Downloads/downloaded-packages" # directory to store downloaded packages
MINICONDA_INSTALL_DIR="/home/$USER/miniconda" # miniconda installation directory
AUTOCPUFREQ_DIR="$DL_PKGS_DIR/auto-cpufreq/" # directory for cloning 'auto-cpufreq' from github


## create directory for taking configuration backup
if [ -d "$BKP_DIR" ]; then
    echo -e "\nINFO: $BKP_DIR already exists ...\n"
else
    echo -e "\nINFO: creating directory for backing up existing configuration files ...\n"
    mkdir $BKP_DIR && \
    sudo chown -R $USER:$USER $BKP_DIR
fi


## install additional packages
echo -e "\nINFO: configuring additional packages ...\n"
sudo apt update && \
sudo apt -y install git tlp powertop fonts-roboto \
tlp-rdw gimp gnome-tweak-tool vlc curl wget synaptic \
gparted stacer gstreamer1.0-plugins-good micro \
gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly \
dconf-editor timeshift p7zip-full p7zip-rar rar unrar


## create directory for downloading external packages
if [ -d "$DL_PKGS_DIR" ]; then
    echo -e "\nINFO: $DL_PKGS_DIR already exists ...\n"
else
    echo -e "\nINFO: creating directory for downloading additional applications ...\n"
    mkdir $DL_PKGS_DIR && \
    sudo chown -R $USER:$USER $DL_PKGS_DIR
fi


## setup miniconda python distribution
if [ -f "$DL_PKGS_DIR/miniconda.sh" ]; then
    echo -e "\nINFO: miniconda installation script available, avoiding download ...\n"
else
    echo -e "\nINFO: downloading miniconda installer script ...\n"
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    -O "$DL_PKGS_DIR/miniconda.sh"
fi

if [ -d "$MINICONDA_INSTALL_DIR" ]; then
    echo -e "\nINFO: $MINICONDA_INSTALL_DIR already exists, seems like 'miniconda' has already been installed ...\n" 
else
    echo -e "\nINFO: creating miniconda installation directory ...\n"
    bash "$DL_PKGS_DIR/miniconda.sh" -b -p $MINICONDA_INSTALL_DIR && \
    sudo chown -R $USER:$USER $MINICONDA_INSTALL_DIR && \
    cp /home/$USER/.bashrc "$BKP_DIR/.bashrc.bak" && \
    echo -e "\n\n# miniconda configuration\nexport PATH="$MINICONDA_INSTALL_DIR/bin":$PATH" \
    >> /home/$USER/.bashrc
fi


## setup latest GNU R
if [ -f "/etc/apt/sources.list.d/gnu-r.list" ]; then
    echo -e "\nINFO: seems like package sources have already been configured for GNU R ...\n"
else
    echo -e "\nINFO: setting up package sources for latest GNU R installation ...\n"
    sudo apt-key add ./cran40/jranke.asc && \
    sudo cp ./cran40/gnu-r.list /etc/apt/sources.list.d/ && \
    sudo apt update && \
    echo -e "\nINFO: installing latest GNU R ...\n" && \
    apt install -y -t bullseye-cran40 r-base-dev
fi


## setup auto-cpufreq
status=$(systemctl is-active auto-cpufreq.service)
if [ $status == "inactive" ]; then
    
    if [ -d "$AUTOCPUFREQ_DIR" ]; then
    echo -e "\nINFO: $AUTOCPUFREQ_DIR already exists, skipping 'git clone' ...\n"
    else
        git clone https://github.com/AdnanHodzic/auto-cpufreq.git $AUTOCPUFREQ_DIR
    fi
    sudo bash "$AUTOCPUFREQ_DIR/auto-cpufreq-installer" && \
    sudo auto-cpufreq --install

else
    echo "'auto-cpufreq.service' is already enabled, skipping installation ... \n"
fi


## turn off unnecessary services (optional, uncomment if needed)
# sudo systemctl disable bluetooth.service && \
# sudo systemctl mask bluetooth.service && \
# sudo systemctl disable NetworkManager-wait-online.service && \
# sudo systemctl mask NetworkManager-wait-online.service && \
# sudo systemctl disable plymouth-quit-wait.service && \
# sudo systemctl mask plymouth-quit-wait.service


## edit /etc/default/grub to change grub timeout, update grub by running 'sudo update-grub'