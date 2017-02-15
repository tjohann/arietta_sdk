#!/usr/bin/env bash
################################################################################
#
# Title       :    make_sdcard.sh
#
# License:
#
# GPL
# (c) 2016-2017, thorsten.johannvorderbrueggen@t-online.de
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
################################################################################
#
# Date/Beginn :    15.02.2017/10.07.2016
#
# Version     :    V0.01
#
# Milestones  :    V0.01 (feb 2017) -> initial skeleton
#
# Requires    :    dialog, xterm
#
#
################################################################################
# Description
#
#   A simple tool for user interaction of sdcard generation
#
# Some features
#   - ...
#
################################################################################
#

# VERSION-NUMBER
VER='0.01'

# use dialog maybe later zenity
DIALOG=dialog

# if env is sourced
MISSING_ENV='false'

# pid of logterm ($TERM)
PID_LOGTERM=0

# which devnode?
DEVNODE='none'

# program name
PROGRAM_NAME=${0##*/}

# my usage method
my_usage()
{
    echo " "
    echo "+--------------------------------------------------------+"
    echo "| Usage: ${PROGRAM_NAME} "
    echo "|        [-v] -> print version info                      |"
    echo "|        [-h] -> this help                               |"
    echo "|                                                        |"
    echo "+--------------------------------------------------------+"
    echo " "
    exit
}

# my cleanup
cleanup() {
    rm $_temp 2>/dev/null
    rm $_log 2>/dev/null
}

# my exit method after an error
my_exit()
{
    echo "+-----------------------------------+"
    echo "|          Cheers $USER            |"
    echo "+-----------------------------------+"
    cleanup
    # http://tldp.org/LDP/abs/html/exitcodes.html
    exit 3
}

# normal leave
normal_exit()
{
    # kill log_term only if no error occured
    killall -u ${USER} -15 tail 2>$_log

    echo "+-----------------------------------+"
    echo "|          Cheers $USER            |"
    echo "+-----------------------------------+"
    cleanup
    exit
}

# print version info
print_version()
{
    echo "+------------------------------------------------------------+"
    echo "| You are using ${PROGRAM_NAME} with version ${VER} "
    echo "+------------------------------------------------------------+"
    cleanup
    exit
}

# --- Some values for internal use
_temp="/tmp/${PROGRAM_NAME}.$$"
_log="/tmp/${PROGRAM_NAME}.$$.log"


# check the args
while getopts 'hv' opts 2>$_log
do
    case $opts in
        h) my_usage ;;
        v) print_version ;;
        ?) my_usage ;;
    esac
done

# ******************************************************************************
# ***             Error handling for missing shell values                    ***
# ******************************************************************************

if [[ ! ${ARIETTA_HOME} ]]; then
    MISSING_ENV='true'
fi

if [[ ! ${ARIETTA_BIN_HOME} ]]; then
    MISSING_ENV='true'
fi

if [[ ! ${ARIETTA_SRC_HOME} ]]; then
    MISSING_ENV='true'
fi

# show a usage screen and exit
if [ "$MISSING_ENV" = 'true' ]; then
    cleanup
    echo " "
    echo "+--------------------------------------+"
    echo "|                                      |"
    echo "|  ERROR: missing env                  |"
    echo "|         have you sourced env-file?   |"
    echo "|                                      |"
    echo "|          Cheers $USER               |"
    echo "|                                      |"
    echo "+--------------------------------------+"
    echo " "
    exit
fi


# ******************************************************************************
# ***                      The functions for main_menu                       ***
# ******************************************************************************

# --- use xterm as something like a logterm
start_logterm()
{
    if [ -f /proc/${PID_LOGTERM}/exe ]; then
	echo "$TERM already running -> do nothing" >>$_log 2>&1
    else
	if [ -s $DISPLAY ]; then
	    $DIALOG --msgbox "To see logging output use tail on another tty:

\"tail -n 50 -f ${_log}\"" 10 60
	else
	    $TERM -e tail -f ${_log} &
	    if [ $? -ne 0 ] ; then
		$DIALOG --msgbox "ERROR: could not use $TERM for logging -> pls use xterm/mrxvt" 6 45
	    else
		PID_LOGTERM=$!
		echo "Using $TERM for logging" >>$_log 2>&1
	    fi
	fi
    fi

    echo "$!" >>$_log 2>&1
}

# --- show content of ${ARIETTA_HOME}/README.md (something like a help info)
show_sdk_readme()
{
    $DIALOG --textbox ${ARIETTA_HOME}/README.md 50 100
}

# --- enter a device node
enter_device_node()
{
    dialog --inputbox "Enter a valid device node (/dev/sdd or /dev/mmcblk0p): " 8 60 2>$_temp

    DEVNODE=`cat $_temp`
    dialog --title " Entered device node " --msgbox "Will use \"${DEVNODE}\" for all following actions" 5 60
}

# --- download the images
download_images()
{
    start_logterm

    $DIALOG --infobox "Download images" 6 45

    echo "${ARIETTA_HOME}/scripts/get_image_tarballs.sh" >>$_log 2>&1

    sleep 5
# TODO: ${ARIETTA_HOME}/scripts/get_image_tarballs.sh >>$_log 2>&1
    if [ $? -ne 0 ] ; then
	$DIALOG --msgbox "ERROR: could not download images ... pls check logterm output" 6 45
    else
	$DIALOG --msgbox "Finished download images" 6 45
    fi
}

# --- start partition_sdcard.sh
partition_sdcard()
{
    if [[ ! -b ${DEVNODE} ]]; then
	$DIALOG --msgbox "ERROR: ${DEVNODE} is not a block device!" 6 45
	return
    fi

    start_logterm

    $DIALOG --infobox "Start script to partition ${DEVNODE}" 6 45

    echo "${ARIETTA_HOME}/scripts/partition_sdcard.sh -d ${DEVNODE} " >>$_log 2>&1

    sleep 5
# TODO: ${ARIETTA_HOME}/scripts/partition_sdcard.sh -d ${DEVNODE} >>$_log 2>&1
    if [ $? -ne 0 ] ; then
	$DIALOG --msgbox "ERROR: could not partition ${DEVNODE} ... pls check logterm output" 6 45
    else
	$DIALOG --msgbox "Finished partition of ${DEVNODE}" 6 45
    fi
}

# --- write images to sd-card
write_images()
{
    start_logterm

    $DIALOG --infobox "Write images" 6 45

    echo "${ARIETTA_HOME}/scripts/untar_images_to_sdcard.sh" >>$_log 2>&1

    sleep 5
# TODO: ${ARIETTA_HOME}/scripts/untar_images_to_sdcard.sh >>$_log 2>&1
    if [ $? -ne 0 ] ; then
	$DIALOG --msgbox "ERROR: could not write images ... pls check logterm output" 6 45
    else
	$DIALOG --msgbox "Finished write of images to ${DEVNODE}" 6 45
    fi
}

# --- umount partitions
umount_partitions()
{
    start_logterm

    $DIALOG --infobox "Un-mount partions" 6 45

    echo "${ARIETTA_HOME}/scripts/mount_partitions.sh -u" >>$_log 2>&1

    sleep 5
# TODO:  ${ARIETTA_HOME}/scripts/mount_partitions.sh -u >>$_log 2>&1
    if [ $? -ne 0 ] ; then
	$DIALOG --msgbox "ERROR: could not un-mount partitions ... pls check logterm output" 6 45
    else
	$DIALOG --msgbox "Finished un-mount of partitions" 6 45
    fi
}

#
# --- main menu
#
menu()
{
    $DIALOG  --title " Main menu ${PROGRAM_NAME} - version $VER " \
	     --menu " Move using [UP] [DOWN] and [Enter] to select an entry" 20 60 20 \
	     1 "Enter device node (/dev/sdx)" \
	     2 "Download images" \
	     3 "Partition (and format) SD-Card ${DEVNODE}" \
	     4 "Write images to ${DEVNODE}" \
	     5 "Un-mount partions" \
	     6 "Start logging via ${TERM} console output" \
	     7 "Show ${ARIETTA_HOME}/README.md" \
             x "Exit" 2>$_temp

    local result=$?
    if [ $result != 0 ]; then normal_exit; fi

    local menuitem=`cat $_temp`
    echo "menu=$menuitem"
    case $menuitem in
	1) enter_device_node;;
	2) download_images;;
	3) partition_sdcard;;
	4) write_images;;
	5) umount_partitions;;
	6) start_logterm;;
	7) show_sdk_readme;;
        x) normal_exit;;
    esac
}


# ******************************************************************************
# ***                         Main Loop                                      ***
# ******************************************************************************

# sudo handling up-front
echo " "
echo "+------------------------------------------+"
echo "| Make a ready-to-use sdcard for your      |"
echo "| target device.                           |"
echo "| --> need sudo for some parts             |"
echo "+------------------------------------------+"
echo " "

sudo -v
# keep-alive
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if [ -s $DISPLAY ]; then
    $DIALOG --msgbox "To see logging output use tail on another tty:

\"tail -n 50 -f ${_log}\"" 10 60
fi

while true;
do
    menu
done

# should never reached
