#!/usr/bin/env bash
################################################################################
#
# Title       :    init_sdk.sh
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
# Date/Beginn :    13.02.2017/25.01.2016
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
#   A simple tool to init the sdk
#
# Some features
#   - ...
#
# Notes
#   - ...
#
################################################################################
#

# VERSION-NUMBER
VER='0.01'

# if env is sourced
MISSING_ENV='false'

# init only user home dir
INIT_USER_HOME='false'
INIT_OPT='false'

# program name
PROGRAM_NAME=${0##*/}

# my usage method
my_usage()
{
    echo " "
    echo "+--------------------------------------------------------+"
    echo "| Usage: ${PROGRAM_NAME} "
    echo "|        [-u] -> init only $HOME/src/arietta_sdk (srcdir)|"
    echo "|        [-o] -> init only /opt/arietta_sdk (workdir)    |"
    echo "|        [-a] -> init both                               |"
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
while getopts 'hvuoa' opts 2>$_log
do
    case $opts in
        u) INIT_USER_HOME='true' ;;
        o) INIT_OPT='true' ;;
	a) INIT_OPT='true'
	   INIT_USER_HOME='true'
	   ;;
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

add_documentations_links_opt()
{
    # arietta related docs
    if [ -d ${ARIETTA_BIN_HOME}/Documentation/arietta ]; then
	cd ${ARIETTA_BIN_HOME}/Documentation/arietta
	rsync -avz --delete ${ARIETTA_HOME}/arietta/Documentation/. .
	if [ $? -ne 0 ] ; then
	    echo "ERROR -> could not rsync ${ARIETTA_HOME}/arietta/Documentation/." >&2
	    my_exit
	fi
    else
	echo "ERROR: no dir ${ARIETTA_BIN_HOME}/Documentation/arietta" >&2
    fi
}

add_documentations_links_home()
{
    # arietta related docs
    if [ -d ${ARIETTA_SRC_HOME}/Documentation/arietta ]; then
	cd ${ARIETTA_SRC_HOME}/Documentation/arietta
	rsync -avz --delete ${ARIETTA_HOME}/arietta/Documentation/. .
	if [ $? -ne 0 ] ; then
	    echo "ERROR -> could not rsync ${ARIETTA_HOME}/arietta/Documentation/." >&2
	    my_exit
	fi
    else
	echo "ERROR: no dir ${ARIETTA_SRC_HOME}/Documentation/arietta" >&2
    fi
}


# ******************************************************************************
# ***                         Main Loop                                      ***
# ******************************************************************************

# sudo handling up-front
echo " "
echo "+------------------------------------------+"
echo "| init the sdk                             |"
echo "| --> need sudo for some parts             |"
echo "+------------------------------------------+"
echo " "

sudo -v
# keep-alive
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if [ "$INIT_OPT" = 'true' ]; then
    if [ -d $ARIETTA_BIN_HOME ]; then
	echo "$ARIETTA_BIN_HOME already available"
    else
	echo "Create $ARIETTA_BIN_HOME -> need sudo rights! "
	sudo mkdir -p $ARIETTA_BIN_HOME
	if [ $? -ne 0 ] ; then
	    echo "ERROR -> could not mkdir -p $ARIETTA_BIN_HOME" >&2
	    my_exit
	fi
	sudo chown $USER:users $ARIETTA_BIN_HOME
	if [ $? -ne 0 ] ; then
	    echo "ERROR -> could not chown $USER:users $ARIETTA_BIN_HOME" >&2
	    my_exit
	fi
	sudo chmod 775 $ARIETTA_BIN_HOME
	if [ $? -ne 0 ] ; then
	    echo "ERROR -> could not chmod 775 $ARIETTA_BIN_HOME" >&2
	    my_exit
	fi
    fi

    echo "Rsync content of ${ARIETTA_HOME}/arietta_sdk/ to $ARIETTA_BIN_HOME"
    cd $ARIETTA_BIN_HOME
    rsync -avz --delete ${ARIETTA_HOME}/arietta_sdk/. .
    if [ $? -ne 0 ] ; then
	echo "ERROR -> could not rsync ${ARIETTA_HOME}/arietta_sdk/." >&2
	my_exit
    fi

    add_documentations_links_opt

    echo "need sudo rights to chown ${USER}:users ${ARIETTA_BIN_HOME}"
    sudo chown $USER:users $ARIETTA_BIN_HOME
    if [ $? -ne 0 ] ; then
	echo "ERROR -> could not chown $USER:users $ARIETTA_BIN_HOME" >&2
	my_exit
    fi
fi

if [ "$INIT_USER_HOME" = 'true' ]; then
    if [ -d $ARIETTA_SRC_HOME ]; then
	echo "$ARIETTA_SRC_HOME already available"
    else
	echo "Create $ARIETTA_SRC_HOME"
	mkdir -p $ARIETTA_SRC_HOME
	if [ $? -ne 0 ] ; then
	    echo "ERROR -> could not mkdir -p $ARIETTA_SRC_HOME" >&2
	    my_exit
	fi
    fi

    cd $ARIETTA_SRC_HOME
    echo "Rsync content of ${ARIETTA_HOME}/arietta_sdk_src/ to $ARIETTA_SRC_HOME"
    rsync -avz --delete ${ARIETTA_HOME}/arietta_sdk_src/. .
    if [ $? -ne 0 ] ; then
	echo "ERROR -> could not rsync ${ARIETTA_HOME}/arietta_sdk_src/." >&2
	my_exit
    fi

    if [ -d $ARIETTA_BIN_HOME/kernel ]; then
	ln -s $ARIETTA_BIN_HOME/kernel $ARIETTA_SRC_HOME/kernel
	ln -s $ARIETTA_BIN_HOME/images $ARIETTA_SRC_HOME/images
	ln -s $ARIETTA_BIN_HOME/external $ARIETTA_SRC_HOME/external
	ln -s $ARIETTA_HOME/man $ARIETTA_SRC_HOME/man
    fi

    add_documentations_links_home
fi

cleanup
echo " "
echo "+----------------------------------------+"
echo "|            Cheers $USER"
echo "+----------------------------------------+"
echo " "
