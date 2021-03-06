#!/usr/bin/env bash

readonly profile="${1:-1}"
readonly rootdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#
# install python dependencies
#
pip install requests

#
# install bin to /usr/local/bin
#
cp ${rootdir}/bin/* /usr/local/bin

#
# install /etc/default
#
cp ${rootdir}/etc/default/* /etc/default

#
# install network interfaces
#
cp ${rootdir}/etc/network/interfaces.d/eth0.${profile} /etc/network/interfaces.d/eth0

#
# append /etc/hosts
#
cat ${rootdir}/etc/hosts.append.${profile} | tee -a /etc/hosts

#
# disable predictable network names
#
ln -s /dev/null /etc/systemd/network/99-default.link

#
# install dhcpd configs
#
cp ${rootdir}/etc/dhcpd.mesh.${profile} /etc
cp ${rootdir}/etc/dhcpd.cam.${profile}.* /etc
cp ${rootdir}/etc/dhcpd.conf.${profile} /etc/dhcpd.conf

#
# install cams config
#
cp ${rootdir}/etc/cams.json /etc

#
# install init.d scripts
#
cp ${rootdir}/etc/init.d/* /etc/init.d

#
# update rc.d
#
update-rc.d isc-dhcp-server defaults
update-rc.d camviewers defaults
update-rc.d power-button defaults
update-rc.d touch-waypoint defaults

#
# install cron jobs
#
cp ${rootdir}/etc/cron.d/* /etc/cron.d

#
# curl download dependencies
#
curl -o /usr/local/bin/wait-for-it.sh "https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh"
chmod +x /usr/local/bin/wait-for-it.sh
