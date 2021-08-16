# Automated Configuration Script

This script is created to help you configure your laptop after installing a debian based system preferably Ubuntu or Ubuntu derivatives.

It performs the following operations:

+ performing `apt-update` and `dist-upgrade` to ensure that your packages are upto date.

+ creating `$HOME/.copies` directory to contain backup copies of original configuration files like `.bashrc`.

+ performing `autoremove` to remove unnecessary package depedencies.

+ generating configuration file for *redshift* application which controls display temperature for DE's like MATE, XFCE, LXDE, LXQT etc.

+ installing and configuring *miniconda* python distribution for scientific computing.

+ installing and configuring *auto-cpufreq* application to control cpu usage based on needs. You can find more on this [here](https://github.com/AdnanHodzic/auto-cpufreq).

+ enabling necessary systemd services like *ufw*, *fstrim.timer* etc.


Permission is granted to distribute this. If you are interested to extend this script, then you are welcome. 