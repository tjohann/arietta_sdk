#!/usr/bin/env bash
################################################################################
#
# Title       :    check_for_valid_env.sh
#
# License:
#
# GPL
# (c) 2016, thorsten.johannvorderbrueggen@t-online.de
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
# Date/Beginn :    05.10.2016/05.07.2016
#
# Version     :    V0.01
#
# Milestones  :    V0.01 (okt 2016) -> take over from a20_sdk
#
# Requires    :
#
#
################################################################################
# Description
#
#   A simple tool to check if arm_env.sh and $ARMEL_KERNEL* in sync
#
# Some features
#   - ...
#
# Notes
#   - ...
#
################################################################################

# VERSION-NUMBER
VER='0.01'

# if env is sourced
MISSING_ENV='false'

# program name
PROGRAM_NAME=${0##*/}

# my usage method
my_usage()
{
    echo " "
    echo "+------------------------------------------+"
    echo "| Usage: ${PROGRAM_NAME} "
    echo "|        [-v] -> print version info        |"
    echo "|        [-h] -> this help                 |"
    echo "|                                          |"
    echo "+------------------------------------------+"
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
    echo "+------------------------------------------+"
    echo "|          Cheers $USER                   |"
    echo "+------------------------------------------+"
    cleanup
    exit 2
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

if [[ ! ${ARMEL_HOME} ]]; then
    MISSING_ENV='true'
fi

if [[ ! ${ARMEL_BIN_HOME} ]]; then
    MISSING_ENV='true'
fi

if [[ ! ${ARMEL_SRC_HOME} ]]; then
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
# ***                         Main Loop                                      ***
# ******************************************************************************

echo " "
echo "+----------------------------------------+"
echo "|  check if env variable and env script  |"
echo "|  are in sync                           |"
echo "+----------------------------------------+"
echo " "


TMP_STRING=`grep ARMEL_KERNEL_VER ${ARMEL_HOME}/armel_env | awk -F '[=]' '{print $2}'`
if [ "$TMP_STRING" != "$ARMEL_KERNEL_VER" ]; then
    echo " "
    echo "+---------------- ERROR -----------------+"
    echo "| The versions of ARMEL_KERNEL_VER: ${ARMEL_KERNEL_VER}"
    echo "| and armel_env: ${TMP_STRING} are different!"
    echo "+----------------------------------------+"
    echo " "
    cleanup
    my_exit
fi

TMP_STRING=`grep ARMEL_RT_KERNEL_VER ${ARMEL_HOME}/armel_env | awk -F '[=]' '{print $2}'`
if [ "$TMP_STRING" != "$ARMEL_RT_KERNEL_VER" ]; then
    echo " "
    echo "+---------------- ERROR -----------------+"
    echo "| The versions of ARMEL_RT_KERNEL_VER: ${ARMEL_RT_KERNEL_VER}"
    echo "| and armel_env: ${TMP_STRING} are different!"
    echo "+----------------------------------------+"
    echo " "
    cleanup
    my_exit
fi

TMP_STRING=`grep ARMEL_RT_VER ${ARMEL_HOME}/armel_env | awk -F '[=]' '{print $2}'`
if [ "$TMP_STRING" != "$ARMEL_RT_VER" ]; then
    echo " "
    echo "+---------------- ERROR -----------------+"
    echo "| The versions of ARMEL_RT_VER: ${ARMEL_RT_VER}"
    echo "| and armel_env: ${TMP_STRING} are different!"
    echo "+----------------------------------------+"
    echo " "
    cleanup
    my_exit
fi

echo " "
echo "+----------------------------------------+"
echo "| env variable and env script are in sync|"
echo "+----------------------------------------+"
echo " "

cleanup
echo " "
echo "+----------------------------------------+"
echo "|            Cheers $USER "
echo "+----------------------------------------+"
echo " "
