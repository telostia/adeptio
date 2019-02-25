#!/usr/bin/env bash

#:: Adeptio dev team. Thanks to community member Skakyn34 for backbone
#:: Copyright // 2018-02-25
#:: Version: v1.0
#:: Tested on Ubuntu 18.04 LTS Server Bionic & Ubuntu 16.04 LTS Server Xenial!

cat << "ADE"
           _____  ______   __  __ _   _                      _                               _       _       
     /\   |  __ \|  ____| |  \/  | \ | |                    (_)                             | |     | |      
    /  \  | |  | | |__    | \  / |  \| | __   _____ _ __ ___ _  ___  _ __    _   _ _ __   __| | __ _| |_ ___ 
   / /\ \ | |  | |  __|   | |\/| | . ` | \ \ / / _ \ '__/ __| |/ _ \| '_ \  | | | | '_ \ / _` |/ _` | __/ _ \
  / ____ \| |__| | |____  | |  | | |\  |  \ V /  __/ |  \__ \ | (_) | | | | | |_| | |_) | (_| | (_| | ||  __/
 /_/    \_\_____/|______| |_|  |_|_| \_|   \_/ \___|_|  |___/_|\___/|_| |_|  \__,_| .__/ \__,_|\__,_|\__\___|
                                                                                  | |                        
                                                                                  |_|                        
ADE

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo $(date)
echo ""
echo "©Copyright 2017-2019 Adeptio Developer Team"
echo -e "${GREEN}== adeptio latest version v2.1.0.0 ==${NC}"
echo
echo "Good day. This is automated masternode wallet version updater. Auto updater was tested on specific environment. Don't try to update with undocumented operating system!"
echo ""
echo "Updater content:"
echo "adeptio core v2.1.0.0 + latest storADE platform code"
echo
echo "We want to begin the update process"
echo "Do you agree?"
echo -e "${GREEN}y${NC}/${RED}n"${NC}?
read agree
            if [ "$agree" != "y" ]; then
               echo "Sorry, we cannot continue" && exit 1
            fi
OS_version=$(cat /etc/lsb-release | grep -c bionic)
OS_version2=$(cat /etc/lsb-release | grep -c xenial)
            if [ "$OS_version" -ne "1" ]; then
                    echo ""
			echo -e "${RED}Looks like your OS version is not Ubuntu 18.04 Bionic //${GREEN} Maybe Ubuntu 16.04 Xenial? - Checking...${NC}"

                        if [ "$OS_version2" -eq "1" ]; then
                                echo ""
                        else
                                echo ""
                                echo -e "${RED}Looks like your OS version is not Ubuntu 16.04 Xenial or Ubuntu 18.04 Bionic${NC}" && exit 1
                        fi
            fi
if [ "$OS_version" -eq "1" ]; then
	cd ~
	rm -fr adeptio-cli adeptiod adeptio-tx adeptio*.zip
	cd /usr/bin/
	sudo rm -fr adeptio-cli adeptiod
	echo -e "${GREEN}1/5 Old Adeptio wallet is deleted${NC}"
	sudo systemctl stop adeptiocore.service
	sudo systemctl stop storADEupdater.timer
	sudo systemctl stop storADEupdater.service
	sudo systemctl stop storADEserver.service
	echo -e "${GREEN}2/5 Adeptio services is stopped${NC}" &&
	cd ~
	wget https://github.com/adeptio-project/adeptio/releases/download/v2.1.0.0/adeptiod-v2.1.0.0-linux64.zip
	echo -e "${GREEN}3/5 New Adeptio wallet is now downloaded${NC}"
	unzip -o adeptio*.zip
	sudo cp -fr adeptio-cli adeptiod /usr/bin/
	echo -e "${GREEN}4/5 Adeptio wallet is updated${NC}"
	rm -fr adeptio-cli adeptiod adeptio-tx adeptio*.zip
	sudo systemctl stop adeptiocore.service && sleep 30
	sudo systemctl start storADEserver.service
	sudo systemctl start storADEupdater.service
	sudo systemctl start storADEupdater.timer
	echo -e "${GREEN}5/5 Adeptio services is is started${NC}"
        else
	cd ~
        rm -fr adeptio-cli adeptiod adeptio-tx adeptio*.zip
        cd /usr/bin/
        sudo rm -fr adeptio-cli adeptiod
        echo -e "${GREEN}1/5 Old Adeptio wallet is deleted${NC}"
        sudo systemctl stop adeptiocore.service
        sudo systemctl stop storADEupdater.timer
        sudo systemctl stop storADEupdater.service
        sudo systemctl stop storADEserver.service
        echo -e "${GREEN}2/5 Adeptio services is stopped${NC}" &&
        cd ~
        wget https://github.com/adeptio-project/adeptio/releases/download/v2.1.0.0/adeptiod-v2.1.0.0-linux64-legacy.zip
        echo -e "${GREEN}3/5 New Adeptio wallet is now downloaded${NC}"
        unzip -o adeptio*.zip
        sudo cp -fr adeptio-cli adeptiod /usr/bin/
        echo -e "${GREEN}4/5 Adeptio wallet is updated${NC}"
        rm -fr adeptio-cli adeptiod adeptio-tx adeptio*.zip
        sudo systemctl stop adeptiocore.service && sleep 30
        sudo systemctl start storADEserver.service
        sudo systemctl start storADEupdater.service
        sudo systemctl start storADEupdater.timer
        echo -e "${GREEN}5/5 Adeptio services is is started${NC}"
        fi