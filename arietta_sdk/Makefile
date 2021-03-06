#
# my simple makefile act as something like a user interface
#

ifeq "${ARIETTA_HOME}" ""
    $(error error: please source arietta_env first!)
endif

ifeq "${ARIETTA_BIN_HOME}" ""
    $(error error: please source arietta_env first!)
endif

ifeq "${ARIETTA_SRC_HOME}" ""
    $(error error: please source arietta_env first!)
endif

MODULES = $(shell ls -d */ | cut -f1 -d'/' | grep -v toolchain | grep -v host)

all::
	@echo "+-----------------------------------------------------------+"
	@echo "|                                                           |"
	@echo "|                  Nothing to build                         |"
	@echo "|                                                           |"
	@echo "+-----------------------------------------------------------+"
	@echo "| make init_sdk           -> init all needed part           |"
	@echo "| make get_external_repos -> get git repos like u-boot      |"
	@echo "| make get_toolchain      -> install toolchain              |"
	@echo "| make get_latest_kernel  -> download latest kernel version |"
	@echo "| make get_image_tarballs -> download image tarballs        |"
	@echo "| make get_all            -> get all of the above           |"
	@echo "| make clean              -> clean all dir/subdirs          |"
	@echo "| make distclean          -> complete cleanup/delete        |"
	@echo "| ...                                                       |"
	@echo "+-----------------------------------------------------------+"

clean::
	rm -f *~ .*~
	for dir in $(MODULES); do (cd $$dir && $(MAKE) $@); done

distclean: clean clean_toolchain clean_external clean_kernel clean_images clean_user_home

clean_toolchain::
	($(ARIETTA_HOME)/scripts/clean_sdk.sh -t)

clean_external::
	($(ARIETTA_HOME)/scripts/clean_sdk.sh -e)

clean_kernel::
	($(ARIETTA_HOME)/scripts/clean_sdk.sh -k)

clean_images::
	($(ARIETTA_HOME)/scripts/clean_sdk.sh -i)

clean_user_home::
	($(ARIETTA_HOME)/scripts/clean_sdk.sh -u)

clean_opt: clean_toolchain clean_external clean_kernel clean_images


#
# run all get actions in sequence
#
get_all: get_toolchain get_image_tarballs get_external_repos get_latest_kernel
	@echo "+----------------------------------------------------------+"
	@echo "|                                                          |"
	@echo "|               All 'get' actions complete                 |"
	@echo "|                                                          |"
	@echo "+----------------------------------------------------------+"

get_external_repos::
	@echo "+----------------------------------------------------------+"
	@echo "|                                                          |"
	@echo "|               Clone useful external repos                |"
	@echo "|                                                          |"
	@echo "+----------------------------------------------------------+"
	($(ARIETTA_HOME)/scripts/get_external_git_repos.sh -p "git")

get_latest_kernel::
	@echo "+----------------------------------------------------------+"
	@echo "|                                                          |"
	@echo "|        Download latest supported kernel versions         |"
	@echo "|                                                          |"
	@echo "+----------------------------------------------------------+"
	($(ARIETTA_HOME)/scripts/get_latest_linux_kernel.sh -a)

get_toolchain::
	@echo "+----------------------------------------------------------+"
	@echo "|                                                          |"
	@echo "|        Download latest supported toolchain version       |"
	@echo "|                                                          |"
	@echo "+----------------------------------------------------------+"
	($(ARIETTA_HOME)/scripts/get_toolchain.sh)

get_image_tarballs::
	@echo "+----------------------------------------------------------+"
	@echo "|                                                          |"
	@echo "|        Download latest supported image tarballs          |"
	@echo "|                                                          |"
	@echo "+----------------------------------------------------------+"
	($(ARIETTA_HOME)/scripts/get_image_tarballs.sh)
