#!/bin/bash

# clear screen
clear && sleep 3


## clean apt cache
sudo apt clean


## add non-free and contrib sources
sudo apt-add-repository non-free && \
sudo apt-add-repository contrib


## remove applications (optional, uncomment if needed)
# sudo apt remove -y --purge gnome-games gnome-contacts gnome-maps \
# gnome-weather


## configure icons and themes
sudo tar -xvf ./icons/macOSBigSur.tar.gz -C /usr/share/icons && \
sudo tar -xvf ./icons/Pop_Cyan.tar.gz -C /usr/share/icons && \
sudo tar -xvf ./icons/Pop_Cyan_Dark.tar.gz -C /usr/share/icons && \
sudo tar -xvf ./themes/Prof-Gnome-Dark-3.6.tar.xz -C /usr/share/themes && \
sudo tar -xvf ./themes/Prof-Gnome-Darker-3.6.tar.xz -C /usr/share/themes && \
sudo tar -xvf ./themes/Prof-Gnome-Light-3.6.tar.xz -C /usr/share/themes && \
sudo tar -xvf ./themes/Prof-Gnome-Light-DS-3.6.tar.xz -C /usr/share/themes


## install additional fonts
sudo cp -r ./fonts/* /usr/share/fonts/ && \
sudo fc-cache -f -v


## define path valriables
BKP_DIR="/home/koushik/.config-backup" # backup directory
DL_PKGS_DIR="/home/koushik/Downloads/downloaded-packages" # directory to store downloaded packages
MINICONDA_INSTALL_DIR="/home/koushik/miniconda" # miniconda installation directory
AUTOCPUFREQ_DIR="$DL_PKGS_DIR/auto-cpufreq/" # directory for cloning 'auto-cpufreq' from github


## create directory for taking configuration backup
if [ -d "$BKP_DIR" ]; then
    echo -e "\nINFO: $BKP_DIR already exists ...\n"
else
    mkdir $BKP_DIR && \
    sudo chown -R koushik:koushik $BKP_DIR
fi


## install additional packages
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
    mkdir $DL_PKGS_DIR && \
    sudo chown -R koushik:koushik $DL_PKGS_DIR
fi


## setup miniconda python distribution
if [ -f "$DL_PKGS_DIR/miniconda.sh" ]; then
    echo -e "\nINFO: miniconda installation script available, avoiding download ...\n"
else
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    -O "$DL_PKGS_DIR/miniconda.sh"
fi

if [ -d "$MINICONDA_INSTALL_DIR" ]; then
    echo -e "\nINFO: $MINICONDA_INSTALL_DIR already exists, seems like 'miniconda' has already been configured ...\n" 
else
    bash "$DL_PKGS_DIR/miniconda.sh" -b -p $MINICONDA_INSTALL_DIR && \
    sudo chown -R koushik:koushik $MINICONDA_INSTALL_DIR && \
    cp /home/koushik/.bashrc "$BKP_DIR/.bashrc.bak" && \
    echo -e "# miniconda configuration\nexport PATH="$MINICONDA_INSTALL_DIR/bin":$PATH" \
    >> /home/koushik/.bashrc
fi


## setup latest GNU R
sudo apt-key add ./cran40/jranke.asc && \
sudo cp ./cran40/gnu-r.list /etc/apt/sources.list.d/ && \
sudo apt update && \
apt install -y -t bullseye-cran40 r-base-dev


## setup auto-cpufreq
if [ -d "$AUTOCPUFREQ_DIR" ]; then
    echo -e "\nINFO: $AUTOCPUFREQ_DIR already exists, seems like 'auto-cpufreq' has already been configured ...\n"
else
    git clone https://github.com/AdnanHodzic/auto-cpufreq.git $AUTOCPUFREQ_DIR && \
    sudo bash "$AUTOCPUFREQ_DIR/auto-cpufreq-installer" && \
    sudo auto-cpufreq --install
fi


## turn off unnecessary services (optional, uncomment if needed)
# sudo systemctl disable bluetooth.service && \
# sudo systemctl mask bluetooth.service && \
# sudo systemctl disable NetworkManager-wait-online.service && \
# sudo systemctl mask NetworkManager-wait-online.service && \
# sudo systemctl disable plymouth-quit-wait.service && \
# sudo systemctl mask plymouth-quit-wait.service


## edit /etc/default/grub to change grub timeout, update grub by running 'sudo update-grub' 