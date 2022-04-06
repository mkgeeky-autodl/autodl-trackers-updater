#!/bin/bash
# mkgeeky -> https://github.com/mkgeeky/autodl-trackers-updater

## CONFIG - START EDITING
INSTALLEDPATH=/home/$USER/.irssi/scripts/AutodlIrssi/trackers
INSTALLEDPATH1=/home/$USER/.irssi/scripts/AutodlIrssi/
WORKINGDIR=/home/$USER/tmp
LOG=/home/$USER/mkgeeky-autodl-trackers.log
## CONFIG - STOP EDITING !

LINUX=tar.gz
URL=https://github.com/mkgeeky/autodl-trackers/releases
DOWNLOADURL=https://github.com/mkgeeky/autodl-trackers
die() { echo "$*" 1>&2 ; exit 1; }
log() { echo "[`date +"%Y-%m-%d %T"`]: $*" >> $LOG; }
NEW_VERSION=$(curl -s $URL | grep -Po ".*\/tags\/v([0-9\.]+)" | awk -F'/' '{print $7}' | tr -d 'v' | sort -V | tail -1)
echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Changing to Working dir"
log "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Changing to Working dir"
cd $WORKINGDIR
if [ $? -ne 0 ]; then
  mkdir $WORKINGDIR
  cd $WORKINGDIR
fi
echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Downloading v$NEW_VERSION"
log "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Downloading v$NEW_VERSION"
wget -N $DOWNLOADURL/archive/refs/tags/v$NEW_VERSION$LINUX
echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Extracting"
log "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Extracting"
tar -xf *.$LINUX
echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Change directory"
log "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Change directory"
cd autodl-trackers-*
echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Remove old trackers/"
log "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Remove old trackers/"
rm -rf $INSTALLEDPATH1/trackers
echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Copy new files into $INSTALLEDPATH"
log "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Copy new files into $INSTALLEDPATH"
cp -R trackers/ $INSTALLEDPATH1
echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Changing ownership"
log "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Changing ownership"
chown -R $USER:$USER $INSTALLEDPATH/*
echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Cleaning up"
log "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Cleaning up"
echo "$NEW_VERSION" > $INSTALLEDPATH/VERSION.md
cd ..
rm -rf $WORKINGDIR
echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Restarting irssi"
log "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Restarting irssi"
pkill -fu "$(whoami)" 'irssi' && screen -dmS autodl irssi
