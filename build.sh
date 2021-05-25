#!/bin/bash
# Teamspeak 3 buildscript for openSUSE
# 
# Copyright (C) 2021 KaratekHD
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

REPO="home:KaratekHD:branches:home:sleep_walker/teamspeak3-client"
VERSION="3.5.6"

# Checking for OSC and installing if needed
echo "Checking dependencies..."
if ! command -v osc &> /dev/null
then
	echo "osc could not be found, installing..."
	sudo zypper install -y osc
fi
if ! command -v osc &> /dev/null
then
	echo "wget could not be found, installing..."
	sudo zypper install -y wget
fi
echo "Dependency test complete."

# We will work in /tmp/ts3_opensuse
mkdir -p /tmp/ts3_opensuse
cd /tmp/ts3_opensuse
# Buildroot must be owned by root
sudo mkdir -p buildroot

# Download Repo
rm -rf $REPO
osc checkout $REPO

cd $REPO

# Download Teamspeak executable
if test -f "TeamSpeak3-Client-linux_amd64-$VERSION.run"; then
	echo "Teamspeak binary already downloaded."
else
	echo "Downloading Teamspeak binary..."
	wget https://files.teamspeak-services.com/releases/client/$VERSION/TeamSpeak3-Client-linux_amd64-$VERSION.run
fi

# Build
osc build --root=/tmp/ts3_opensuse/buildroot

# Copy RPM to home dir
cp /tmp/ts3_opensuse/buildroot/home/abuild/rpmbuild/RPMS/x86_64/teamspeak3-client-$VERSION-0.x86_64.rpm ~
