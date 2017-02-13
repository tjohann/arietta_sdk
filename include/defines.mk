################################################################################
#
# Title       :    defines.mk
#
# (c) 2015-2017, thorsten.johannvorderbrueggen@t-online.de
#
################################################################################
#
# Description:
#   Common defines for all code used within this sdk.
#
# Usage:
#   - source arietta_env
#   - add this to the makefile
#   SNIP
#   include ${ARIETTA_HOME}/include/defines.mk
#   SNIP
#
################################################################################
#

# ---- host ----
CC = gcc
AR = ar
LD = ld

CFLAGS = -I${ARIETTA_SRC_HOME}/include -g -Wall -Wextra -std=gnu11
LDLIBS = -L${ARIETTA_SRC_HOME}/lib -lpthread -lrt

# ---- target ----
ifeq (${MY_HOST_ARCH},x86_64)
	CC_TARGET = arm-arietta-linux-gnueabi-gcc
	AR_TARGET = arm-arietta-linux-gnueabi-ar
	LD_TARGET = arm-arietta-linux-gnueabi-ld
else
	CC_TARGET = gcc
	AR_TARGET = ar
	LD_TARGET = ld
endif

LDLIBS_TARGET = -L${ARIETTA_SRC_HOME}/lib_target -lpthread -lrt

