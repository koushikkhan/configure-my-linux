#!/bin/bash

## Check for root user
if [[ $EUID -ne 0 ]]; then
	echo "This script must be executed as root"
	exit 1;
fi


## Check current status of battery conservation mode
currentStatus=$(cat /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode)
if [ $currentStatus == 1 ]; then
	echo "battery conservation mode is currently enabled"
	echo -e "Would you like to disable it now? Give 'yes' or 'no' as response\n"

	read userInput

	if [ $userInput == 'yes' ]; then
		echo 0 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
		echo -e "\n battery conservation mode disabled successfully"
	else
		exit;
	fi;
else
	echo "battery conservation mode is currently disabled"
	echo -e "Would you like to enable it now? Give 'yes' or 'no' as response\n"

	read userInput

	if [ $userInput == 'yes' ]; then
		echo 1 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
		echo -e "\n battery conservation mode enabled successfully"
	else
		exit;
	fi;
fi;


## Reference
# Tutorial Link: https://tildehacker.com/lenovo-ideapad-battery-conservation-mode-gnu-linux
