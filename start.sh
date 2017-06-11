# Uses Some Steps from https://wiki.teamfortress.com/wiki/Linux_dedicated_server 
# Created by @rselwyn on Github

echo "Starting TF2 Dedicated Server Setup"

# Create Directory
mkdir ./hlserver && cd hlserver

# Install Dependencies

sudo apt-get -y install lib32z1
sudo apt-get -y install lib32ncurses5
sudo apt-get -y install lib32gcc1
sudo apt-get -y install lib32stdc++6

# Download SteamCMD
wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
tar zxf steamcmd_linux.tar.gz

echo "Creating SteamCMD Update Script"
touch tf2_ds.txt

echo "login anonymous 
force_install_dir ./tf2 
app_update 232250 
quit" >> tf2_ds.txt

echo "Creating and Installing TF2.  This might take a while."

touch update.sh

echo "#!/bin/sh
./steamcmd.sh +runscript tf2_ds.txt" >> update.sh

chmod +x update.sh

./update.sh

echo "Finished Installing"

echo "Creating Server File(s)"

cd ~/hlserver/tf2/tf/cfg

wget https://raw.githubusercontent.com/rselwyn/tf2-dedicated-server/master/server.cfg

echo "Changing some server settings and installing some libraries."

sudo dpkg --add-architecture i386
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install steamcmd

sudo apt-get -y install libtinfo5:i386 libncurses5:i386 libcurl3-gnutls:i386

mkdir .steam/sdk32
cp hlserver/linux64/steamclient.so .steam/sdk32/

echo "Creating Server Start Script"

cd ~/hlserver

touch tf.sh

echo "#!/bin/sh
tf2/srcds_run -console -game tf -nohltv +sv_pure 1 +map ctf_2fort +maxplayers 24" >> tf.sh

echo "alias tf2server='bash ~/hlserver/tf.sh'" >> ~/.bash_profile