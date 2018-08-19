#!/usr/bin/env bash

#:: Adeptio dev team
#:: Copyright // 2018-08-20
#:: Version: v1.0.0.2
#:: Tested on Ubuntu 16.04 LTS Server Xenial only!

echo "== adeptio v1.0.0.2 =="
echo
echo "Good day. This is automated cold masternode setup for adeptio coin. Auto installer was tested on specific environment. Don't try to install masternode with undocumented operating system!"
echo
echo "This setup can be launched only once"
echo "Do you agree? y/n"
read agree
            if [ "$agree" != "y" ]; then
               echo "Sorry, we cannot continue" && exit 1
            fi
OS_version=$(cat /etc/lsb-release | grep -c xenial)
            if [ "$OS_version" -ne "1" ]; then
                    echo ""
                    echo "Looks like your OS version is not Ubuntu 16.04 Xenial" && exit 1
            fi
sudo apt-get install dnsutils -y
echo ""
wanip=$(/usr/bin/dig +short myip.opendns.com @resolver1.opendns.com)
echo "Your external IP is $wanip y/n?"
read wan
            if [ "$wan" != "y" ]; then
               echo "Sorry, we don't know your external IP" && exit 1
            fi
# Check if bitcoin repo exists //
repo=$(cat /etc/apt/sources.list | grep -c bitcoin)
            if [ "$repo" -ne "0" ]; then
                    echo ""
                    echo "Looks like you are trying to setup second time? You need a fresh installation!" && exit 1
            fi
sudo bash -c 'cat << EOF >> /etc/apt/sources.list
deb http://ppa.launchpad.net/bitcoin/bitcoin/ubuntu xenial main
EOF'
# Install dep. //
sudo apt-get update
sudo apt-get install libboost-system1.58-dev libboost-system1.58.0 -y
sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev  bsdmainutils software-properties-common libminiupnpc-dev libcrypto++-dev libboost-all-dev libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libboost-filesystem-dev libboost-thread-dev libssl-dev libdb++-dev libssl-dev ufw git software-properties-common unzip libzmq3-dev ufw wget -y
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y --allow-unauthenticated

# Download adeptio sources //
cd ~
rm -fr adeptio*.zip
wget https://github.com/adeptio-project/adeptio/releases/download/v1.0.0.2/adeptiod-v1.0.0.2.zip

# Manage coin daemon and configuration //
unzip -o adeptio*.zip
echo ""
sudo cp -fr adeptio-cli adeptiod /usr/bin/
mkdir -p ~/.adeptio/
touch ~/.adeptio/adeptio.conf
cat << EOF > ~/.adeptio/adeptio.conf
rpcuser=adeptiouser
rpcpassword=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')
rpcallow=127.0.0.1
server=1
listen=1
daemon=1
staking=1
addnode=202.182.106.136
addnode=23.225.207.13
addnode=78.61.18.211
addnode=[2001:470:71:35f:f816:3eff:fec9:3a7]
EOF

# Start adeptio daemon, wait for wallet creation and get an addr where to send 10 000 ADE //
/usr/bin/adeptiod --daemon &&
echo "" ; echo "Please wait for few minutes..."
sleep 120 &
PID=$!
i=1
sp="/-\|"
echo -n ' '
while [ -d /proc/$PID ]
do
  printf "\b${sp:i++%${#sp}:1}"
done
echo ""
/usr/bin/adeptio-cli stop &&
echo ""
echo "Shutting down daemon, reconfiguring adeptio.conf, we want to know your cold wallet masternodeprivkey (example: 7UwDGWAKNCAvyy9MFEnrf4JBBL2aVaDm2QzXqCQzAugULf7PUFD), please input now:"
read masternodeprivkey
privkey=$(echo $masternodeprivkey)
checkpriv_key=$(echo $masternodeprivkeyi | wc -c)
if [ "$checkpriv_key" -ne "52" ];
then
	echo "Looks like your $privkey is not correct, it should cointain 52 symbols, please paste it one more time"
	read masternodeprivkey
fi
privkey=$(echo $masternodeprivkey)
checkpriv_key=$(echo $masternodeprivkey | wc -c)

if [ "$checkpriv_key" -ne "52" ];
then
	"Something wrong with masternodeprivkey, cannot continue" && exit 1
fi
echo ""
echo "Give some time to shutdown the wallet..."
echo ""
sleep 60 &
PID=$!
i=1
sp="/-\|"
echo -n ' '
while [ -d /proc/$PID ]
do
  printf "\b${sp:i++%${#sp}:1}"
done
cat << EOF > ~/.adeptio/adeptio.conf
rpcuser=adeptiouser
rpcpassword=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')
rpcallow=127.0.0.1
server=1
listen=1
daemon=1
staking=1
maxconnections=125
masternode=1
masternodeaddr=$wanip:9077
externalip=$wanip
masternodeprivkey=$privkey
addnode=202.182.106.136
addnode=23.225.207.13
addnode=78.61.18.211
addnode=[2001:470:71:35f:f816:3eff:fec9:3a7]
EOF

# Firewall //
echo "Update firewall rules"
sudo /usr/sbin/ufw limit ssh/tcp comment 'Rate limit for openssh serer' 
sudo /usr/sbin/ufw allow 9077/tcp
sudo /usr/sbin/ufw --force enable
echo ""

# Start daemon after reboot //
echo "Update crontab"
crontab -l | { cat; echo "@reboot /usr/bin/adeptiod --daemon"; } | crontab -
echo "Crontab update done"

# Final start
echo ""
echo "Masternode config done, starting daemon again"
echo ""
/usr/bin/adeptiod --daemon
echo ""
echo "Setup almost completed. You have to wait 15 confirmations right now"
echo ""
echo "Setup summary:"
echo "Masternode privkey: $privkey"
echo "Your external IP: $wanip"
echo ""
echo "Setup completed. Please start a masternode from Cold Wallet"
