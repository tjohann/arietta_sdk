# +--------------------- setup the armel dev environment ----------------------+
# |                                armel_env                                   |
# +----------------------------------------------------------------------------+

# set MY_HOST_ARCH
export MY_HOST_ARCH=$(uname -m)

# set supported kernel version
export ARMEL_KERNEL_VER=4.4.31
export ARMEL_RT_KERNEL_VER=4.4.21
export ARMEL_RT_VER=rt30

# home of the git repo
export ARMEL_HOME=/var/lib/arietta_sdk
# home of the bin's
export ARMEL_BIN_HOME=/opt/arietta_sdk
# home of src examples
export ARMEL_SRC_HOME=$HOME/src/arietta_sdk

# extend PATH for out arietta stuff
export PATH=$PATH:${ARMEL_BIN_HOME}/toolchain/bin:${ARMEL_BIN_HOME}/host/usr/bin

# set mount points for the sdcard -> bananapi-(M1/PRO)
export ARIETTA_SDCARD_KERNEL=/mnt/arietta/arietta_kernel
export ARIETTA_SDCARD_ROOTFS=/mnt/arietta/arietta_rootfs
export ARIETTA_SDCARD_HOME=/mnt/arietta/arietta_home

echo "Setup env for host \"${MY_HOST_ARCH}\" with root dir \"${ARMEL_HOME}\" and bin root dir \"${ARMEL_BIN_HOME}\""

#EOF
