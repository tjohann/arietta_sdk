# +------------------- setup the arietta dev environment ----------------------+
# |                              arietta_env                                   |
# +----------------------------------------------------------------------------+

# set MY_HOST_ARCH
export MY_HOST_ARCH=$(uname -m)

# set supported kernel version
export ARIETTA_KERNEL_VER=4.9.11
export ARIETTA_RT_KERNEL_VER=4.9.11
export ARIETTA_RT_VER=rt9

# home of the git repo
export ARIETTA_HOME=/var/lib/arietta_sdk
# home of the bin's
export ARIETTA_BIN_HOME=/opt/arietta_sdk
# home of src examples
export ARIETTA_SRC_HOME=$HOME/src/arietta_sdk

# extend PATH for out arietta stuff
export PATH=$PATH:${ARIETTA_BIN_HOME}/toolchain/bin:${ARIETTA_BIN_HOME}/host/usr/bin

# set mount points for the sdcard
export ARIETTA_SDCARD_KERNEL=/mnt/arietta/arietta_kernel
export ARIETTA_SDCARD_ROOTFS=/mnt/arietta/arietta_rootfs
export ARIETTA_SDCARD_HOME=/mnt/arietta/arietta_home

echo "Setup env for host \"${MY_HOST_ARCH}\" with root dir \"${ARIETTA_HOME}\" and bin root dir \"${ARIETTA_BIN_HOME}\""

#EOF
