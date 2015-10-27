#!/usr/bin/env bash
##
 # Copyright © 2015 by David Alger. All rights reserved
 # 
 # Licensed under the Open Software License 3.0 (OSL-3.0)
 # See included LICENSE file for full text of OSL-3.0
 # 
 # http://davidalger.com/contact/
 ##

########################################
# setup misc generic node configuration

set -e

# configure VM Ware tools to automatically rebuild missing VMX kernel modules upon boot
# see: https://github.com/mitchellh/vagrant/issues/4362#issuecomment-52589577
#
if [[ -f /etc/vmware-tools/locations ]]; then
    sed -i -re 's/^answer (AUTO_KMODS_ENABLED|AUTO_KMODS_ENABLED_ANSWER) no$/answer \1 yes/' /etc/vmware-tools/locations
fi

# import hosts file to maintain named refs for machine IPs
if [[ -f ./etc/hosts ]]; then
    cp ./etc/hosts /etc/hosts
fi

# import all available profile.d scripts to configure bash
if [[ -d ./etc/profile.d/ ]]; then
    cp ./etc/profile.d/*.sh /etc/profile.d/
fi

# set zone info to match host if possible
if [[ -f "$HOST_ZONEINFO" ]]; then
    if [[ -f /etc/localtime ]]; then
        mv /etc/localtime /etc/localtime.bak
    elif [[ -L /etc/localtime ]]; then
        rm /etc/localtime
    fi
    ln -s "$HOST_ZONEINFO" /etc/localtime
fi
