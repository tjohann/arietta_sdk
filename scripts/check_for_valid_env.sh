#!/usr/bin/env bash
################################################################################
#
# Title       :    check_for_valid_env.sh
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
# Date/Beginn :    14.02.2017/05.07.2016
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
#   A simple tool to check if arm_env.sh and $ARIETTA_KERNEL* in sync
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
# ***                         Main Loop                                      ***
# ******************************************************************************

echo " "
echo "+----------------------------------------+"
echo "|  check if env variable and env script  |"
echo "|  are in sync                           |"
echo "+----------------------------------------+"
echo " "


TMP_STRING=`grep ARIETTA_KERNEL_VER ${ARIETTA_HOME}/arietta_env | awk -F '[=]' '{print $2}'`
if [ "$TMP_STRING" != "$ARIETTA_KERNEL_VER" ]; then
    echo " "
    echo "+---------------- ERROR -----------------+"
    echo "| The versions of ARIETTA_KERNEL_VER: ${ARIETTA_KERNEL_VER}"
    echo "| and arietta_env: ${TMP_STRING} are different!"
    echo "+----------------------------------------+"
    echo " "
    cleanup
    my_exit
fi

TMP_STRING=`grep ARIETTA_RT_KERNEL_VER ${ARIETTA_HOME}/arietta_env | awk -F '[=]' '{print $2}'`
if [ "$TMP_STRING" != "$ARIETTA_RT_KERNEL_VER" ]; then
    echo " "
    echo "+---------------- ERROR -----------------+"
    echo "| The versions of ARIETTA_RT_KERNEL_VER: ${ARIETTA_RT_KERNEL_VER}"
    echo "| and arietta_env: ${TMP_STRING} are different!"
    echo "+----------------------------------------+"
    echo " "
    cleanup
    my_exit
fi

TMP_STRING=`grep ARIETTA_RT_VER ${ARIETTA_HOME}/arietta_env | awk -F '[=]' '{print $2}'`
if [ "$TMP_STRING" != "$ARIETTA_RT_VER" ]; then
    echo " "
    echo "+---------------- ERROR -----------------+"
    echo "| The versions of ARIETTA_RT_VER: ${ARIETTA_RT_VER}"
    echo "| and arietta_env: ${TMP_STRING} are different!"
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
