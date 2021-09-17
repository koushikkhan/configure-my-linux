#!/bin/bash

## Check for root user
if [[ $EUID -ne 0 ]]; then
	echo "This script must be executed as root"
	exit 1
fi


## Check current status of battery conservation mode
currentStatus=$(cat /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode)
if [ $currentStatus == 1 ]; then
	echo "battery conservation is currently enabled"
	echo -e "Would you like to disable now? Give 'yes' or 'no' as response\n"

	read userInput

	if [ $userInput == 'yes' ]; then
		echo 0 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
		echo -e "\n battery conservation mode disabled successfully"
	else
		exit 0
	fi;
else
	echo "battery conservation is currently disabled"
	echo -e "Would you like to enable now? Give 'yes' or 'no' as response\n"

	read userInput

	if [ $userInput == 'yes' ]; then
		echo 1 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
		echo -e "\n battery conservation mode enabled successfully"
	else
		exit 0
	fi;
fi;


## Reference
# Tutorial Link: https://tildehacker.com/lenovo-ideapad-battery-conservation-mode-gnu-linux
