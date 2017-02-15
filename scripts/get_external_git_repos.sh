#!/usr/bin/env bash
################################################################################
#
# Title       :    get_external_git_repos.sh
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
# Date/Beginn :    15.02.2017/15.08.2015
#
# Version     :    V0.01
#
# Milestones  :    V0.01 (feb 2017) -> first functional version
#
# Requires    :    ...
#
#
################################################################################
# Description
#
#   A simple tool to get externel git repos like can-utils ...
#
# Some features
#   - clone repo with all 3 possible network protocols
#
# Notes
#   - ...
#
# Improvement/missing feature
#   - add a file with all possible repos instead of hardcoded values
#   - clone repos not only to ${ARIETTA_BIN_HOME}/external ... clone to the current
#     working dir
#
################################################################################
#

# VERSION-NUMBER
VER='0.01'

# if env is sourced
MISSING_ENV='false'

# REPOs
# rt-tests -> http://git.kernel.org/pub/scm/linux/kernel/git/clrkwllms/rt-tests.git
# can-utils -> https://github.com/linux-can/can-utils.git
# lcd1602 -> http://github.com/tjohann/lcd160x_driver.git
# mydriver -> http://github.com/tjohann/mydriver.git
# baalued -> http://github.com/tjohann/baalued.git
# libbaalue -> http://github.com/tjohann/libbaalue.git
# tt-env -> http://github.com/tjohann/time_triggert_env.git
# can-lin-env -> https://github.com/tjohann/can_lin_env.git

REPO='none'

# PROTOCOL
# git -> git
# http -> http
# https -> https
PROTOCOL='none'

# REPO_NAME
# {$PROTOCOL$get_repo_name()}
REPO_NAME='none'

# program name
PROGRAM_NAME=${0##*/}

# my usage method
my_usage()
{
    echo " "
    echo "+--------------------------------------------------------+"
    echo "| Usage: ${PROGRAM_NAME} "
    echo "|        [-r REPO] -> name of the sdk                    |"
    echo "|        [-p PROTOCOL] -> git/http/https                 |"
    echo "|        [-v] -> print version info                      |"
    echo "|        [-h] -> this help                               |"
    echo "|                                                        |"
    echo "| Example:                                               |"
    echo "| get_external_git_repos.sh -r lcd1602 -p http           |"
    echo "|                                                        |"
    echo "| Valid repo names:                                      |"
    echo "| REPO: rt-tests -> rt-test tools                        |"
    echo "| REPO: can-utils -> common can-utils                    |"
    echo "| REPO: lcd1602 -> my simple lcd driver                  |"
    echo "| REPO: mydriver -> my simple driver example             |"
    echo "| REPO: libbaalue -> my base libary                      |"
    echo "| REPO: baalued -> control daemon of a baalue node       |"
    echo "| REPO: tt-env -> my realtime playground                 |"
    echo "| REPO: can-lin-env -> my can/lin playground             |"
    echo "|                                                        |"
    echo "| Valid network protocols:                               |"
    echo "| PROTOCOL: none or empty -> use the simple git          |"
    echo "| PROTOCOL: git                                          |"
    echo "| PROTOCOL: http                                         |"
    echo "| PROTOCOL: https                                        |"
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
while getopts 'hvr:p:' opts 2>$_log
do
    case $opts in
        h) my_usage ;;
	v) print_version ;;
	r) REPO=$OPTARG ;;
	p) PROTOCOL=$OPTARG ;;
        ?) my_usage ;;
    esac
done


# ******************************************************************************
# ***                 error handling for missing env                         ***
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
# ***                     the functions for main_menu                        ***
# ******************************************************************************

# --- set repo names
set_repo_names()
{
    rt_tests="://git.kernel.org/pub/scm/linux/kernel/git/clrkwllms/rt-tests.git"
    can_utils="://github.com/linux-can/can-utils.git"
    lcd1602="://github.com/tjohann/lcd160x_driver.git"
    mydriver="://github.com/tjohann/mydriver.git"
    baalued="://github.com/tjohann/baalued.git"
    libbaalue="://github.com/tjohann/libbaalue.git"
    tt_env="://github.com/tjohann/time_triggert_env.git"
    can_lin_env="://github.com/tjohann/can_lin_env.git"

    # array with all available repos
    repo_names_array[0]=${rt_tests}
    repo_names_array[1]=${can_utils}
    repo_names_array[2]=${lcd1602}
    repo_names_array[3]=${mydriver}
    repo_names_array[4]=${baalued}
    repo_names_array[5]=${libbaalue}
    repo_names_array[6]=${tt_env}
    repo_names_array[7]=${can_lin_env}
}

# --- get repo name
get_repo_name()
{
    case "$REPO" in
	'rt-tests')
	    REPO_NAME="${PROTOCOL}${rt_tests}"
	    ;;
	'can-utils')
	    REPO_NAME="${PROTOCOL}${can_utils}"
	    ;;
	'lcd1602')
	    REPO_NAME="${PROTOCOL}${lcd1602}"
	    ;;
	'mydriver')
	    REPO_NAME="${PROTOCOL}${mydriver}"
	    ;;
	'baalued')
	    REPO_NAME="${PROTOCOL}${baalued}"
	    ;;
	'libbaalue')
	    REPO_NAME="${PROTOCOL}${libbaalue}"
	    ;;
	'tt-env')
	    REPO_NAME="${PROTOCOL}${tt_env}"
	    ;;
	'can-lin-env')
	    REPO_NAME="${PROTOCOL}${can_lin_env}"
	    ;;
	*)
	    echo "ERROR -> ${REPO} is no valid repo ... pls check" >&2
	    my_usage
    esac
}

# --- get repo name
check_protocol()
{
    PROTOCOL_VALID='false'

    if [ $PROTOCOL = 'git' -o $PROTOCOL = 'GIT' ]; then
	PROTOCOL='git'
	PROTOCOL_VALID='true'
    fi

    if [ $PROTOCOL = 'http' -o $PROTOCOL = 'HTTP' ]; then
	PROTOCOL='http'
	PROTOCOL_VALID='true'
    fi

    if [ $PROTOCOL = 'https' -o $PROTOCOL = 'HTTPS' ]; then
	PROTOCOL='https'
	PROTOCOL_VALID='true'
    fi

    if [ $PROTOCOL_VALID = 'false' ]; then
	echo "ERROR -> ${PROTOCOL} is no valid network protocol ... pls check" >&2
	my_usage
    fi
}

# --- clone the repo
clone_repo()
{
    echo "start to clone repo $REPO_NAME"
    git clone $REPO_NAME
    if [ $? -ne 0 ] ; then
	echo "ERROR: could not clone ${REPO_NAME}" >&2
	# try the next and do not exit
    fi
}

# --- clone all repos
clone_all_repos()
{
    for item in ${repo_names_array[*]}
    do
	REPO_NAME="${PROTOCOL}${item}"
	clone_repo
    done
}


# ******************************************************************************
# ***                         Main Loop                                      ***
# ******************************************************************************

echo " "
echo "+--------------------------------------------------------+"
echo "|                 get external git repos                 |"
echo "+--------------------------------------------------------+"
echo " "

if [ -d $ARIETTA_BIN_HOME/external ]; then
    cd $ARIETTA_BIN_HOME/external
else
    echo "${ARIETTA_BIN_HOME}/external not available -> try to create it"
    mkdir -p $ARIETTA_BIN_HOME/external
    if [ $? -ne 0 ] ; then
	echo "ERROR: could not create ${ARIETTA_BIN_HOME}/external -> did you a make init_sdk?" >&2
	my_exit
    fi
    cd $ARIETTA_BIN_HOME/external
fi
set_repo_names

if [ $PROTOCOL = 'none' ]; then
    echo "PROTOCOL == none -> using git"
    PROTOCOL='git'
else
    check_protocol
fi

if [ $REPO = 'none' ]; then
    echo "REPO == none -> clone all repos"
    REPO_NAME='all'
    clone_all_repos
else
    echo "will clone ${REPO}"
    get_repo_name
    clone_repo
fi

cleanup
echo " "
echo "+------------------------------------------+"
echo "|             Cheers $USER                  "
echo "+------------------------------------------+"
echo " "
