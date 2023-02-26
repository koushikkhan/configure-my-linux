# Configure Fedora For the First Time #

# 1. configure dnf
conf_dnf: /etc/dnf/dnf.conf
	echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
	echo "fastestmirror=true" | sudo tee -a /etc/dnf/dnf.conf
	echo "deltarpm=true" | sudo tee -a /etc/dnf/dnf.conf

# 2. update repository
update:
	sudo dnf update -y

# 3. install required packages (add more if required)
install:
	sudo dnf install -y curl wget git micro htop


# --------------------------------------------------------------------------- #

count_pkg:
	dnf list installed | wc -l
