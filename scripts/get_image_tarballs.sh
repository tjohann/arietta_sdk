#!/usr/bin/env bash
################################################################################
#
# Title       :    get_image_tarballs.sh
#
# License:
#
# GPL
# (c) 2015-2017, thorsten.johannvorderbrueggen@t-online.de
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
# Date/Beginn :    15.02.2017/24.08.2015
#
# Version     :    V0.01
#
# Milestones  :    V0.01 (feb 2017) -> first functional version
#
# Requires    :
#
#
################################################################################
# Description
#
#   A simple tool to download the image tarballs
#
# Some features
#   - ...
#
# Notes
#   - Images reside on sourceforge with the following structure
#     "root on sf"
#     -> .
#         "device specific kernel images":
#         -> arietta_kernel.tgz
#         -> arietta_rootfs.tgz
#         -> arietta_home.tgz
#         -> toolchain*.tgz
#         -> host_*.tgz
#         -> checksum.sha256
#
################################################################################
#

# VERSION-NUMBER
VER='0.01'

# if env is sourced
MISSING_ENV='false'

# to download
DOWNLOAD_IMAGE='none'

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
    echo "+--------------------------------------------------------+"
    echo " "
    exit
}

# my cleanup
cleanup() {
    rm $_temp 2>/dev/null
    rm $_log 2>/dev/null
}

# my exit method
my_exit()
{
    echo "+-----------------------------------+"
    echo "|          Cheers $USER            |"
    echo "+-----------------------------------+"
    cleanup
    # http://tldp.org/LDP/abs/html/exitcodes.html
    exit 3
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

if [[ ! ${ARIETTE_HOME} ]]; then
    MISSING_ENV='true'
fi

if [[ ! ${ARIETTE_BIN_HOME} ]]; then
    MISSING_ENV='true'
fi

if [[ ! ${ARIETTE_SRC_HOME} ]]; then
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
    exit 3
fi


# ******************************************************************************
# ***                      The functions for main_menu                       ***
# ******************************************************************************

# --- download a tarballs from sf
get_tarball()
{
    echo "INFO: try to download ${DOWNLOAD_IMAGE}"

    local download_file=`echo ${DOWNLOAD_IMAGE} | awk -F '[/]' '{print $(NF-0)}'`
    if [ -f ${download_file} ]; then
	echo "${DOWNLOAD_IMAGE} already exist -> do nothing"
    else
	wget $DOWNLOAD_IMAGE
	if [ $? -ne 0 ] ; then
	    echo "ERROR -> could not download ${DOWNLOAD_IMAGE}" >&2
	    my_exit
	fi
    fi

    DOWNLOAD_IMAGE='none'
}


# ******************************************************************************
# ***                         Main Loop                                      ***
# ******************************************************************************

echo " "
echo "+----------------------------------------------+"
echo "|  dowload latest image tarballs               |"
echo "+----------------------------------------------+"
echo " "

if [ -d ${ARIETTE_BIN_HOME}/images ]; then
    cd ${ARIETTE_BIN_HOME}/images
else
    mkdir -p ${ARIETTE_BIN_HOME}/images
    if [ $? -ne 0 ] ; then
	echo "ERROR -> mkdir -p ${ARIETTE_BIN_HOME}/images" >&2
	my_exit
    fi
    cd ${ARIETTE_BIN_HOME}/images
fi

DOWNLOAD_IMAGE="http://sourceforge.net/projects/arietta-sdk/files/arietta_kernel.tgz"
get_tarball

DOWNLOAD_IMAGE="http://sourceforge.net/projects/arietta-sdk/files/arietta_rootfs.tgz"
get_tarball

DOWNLOAD_IMAGE="http://sourceforge.net/projects/arietta-sdk/files/arietta_home.tgz"
get_tarball


cleanup
echo " "
echo "+----------------------------------------+"
echo "|            Cheers $USER"
echo "+----------------------------------------+"
echo " "
