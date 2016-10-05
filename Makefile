#
# my simple makefile act as something like a user interface
#

ifeq "${ARMEL_HOME}" ""
    $(error error: please source armhf_env first!)
endif

ifeq "${ARMEL_BIN_HOME}" ""
    $(error error: please source armhf_env first!)
endif

ifeq "${ARMEL_SRC_HOME}" ""
    $(error error: please source armhf_env first!)
endif

MODULES = arietta
MODULES += include man pics configs scripts
MODULES += arietta_sdk arietta_sdk_src

all::
	@echo "+-----------------------------------------------------------+"
	@echo "|                                                           |"
	@echo "|                  Nothing to build                         |"
	@echo "|                                                           |"
	@echo "+-----------------------------------------------------------+"
	@echo "| Example:                                                  |"
	@echo "| make init_sdk           -> init all needed part           |"
	@echo "| make get_external_repos -> get git repos like u-boot      |"
	@echo "| make get_toolchain      -> install toolchain              |"
	@echo "| make get_latest_kernel  -> download latest kernel version |"
	@echo "| make get_image_tarballs -> download image tarballs        |"
	@echo "| make get_all            -> get all of the above           |"
	@echo "| make clean              -> clean all dir/subdirs          |"
	@echo "| make distclean          -> complete cleanup/delete        |"
	@echo "| make mrproper           -> do mrproper cleanup            |"
	@echo "| make man                -> show arietta_sdk manpage       |"
	@echo "| ...                                                       |"
	@echo "| make make_sdcard        -> small tool to make a read to   |"
	@echo "|                            use SD-Card                    |"
	@echo "| make install            -> install some scripts to        |"
	@echo "|                            $(HOME)/bin              |"
	@echo "| make uninstall          -> remove scripts from            |"
	@echo "|                            $(HOME)/bin              |"
	@echo "+-----------------------------------------------------------+"

clean::
	rm -f *~ .*~
	for dir in $(MODULES); do (cd $$dir && $(MAKE) $@); done

distclean: clean clean_toolchain clean_external clean_kernel clean_images clean_user_home

clean_toolchain::
	($(ARMEL_HOME)/scripts/clean_sdk.sh -t)

clean_external::
	($(ARMEL_HOME)/scripts/clean_sdk.sh -e)

clean_kernel::
	($(ARMEL_HOME)/scripts/clean_sdk.sh -k)

clean_images::
	($(ARMEL_HOME)/scripts/clean_sdk.sh -i)

clean_user_home::
	($(ARMEL_HOME)/scripts/clean_sdk.sh -u)

clean_opt: clean_toolchain clean_external clean_kernel clean_images

mrproper: clean
	($(ARMEL_HOME)/scripts/clean_sdk.sh -m)

install::
	(install $(ARMEL_HOME)/scripts/make_sdcard.sh $(HOME)/bin/arietta_sdk_make_sdcard.sh)
	(install $(ARMEL_HOME)/scripts/handle_kernel.sh $(HOME)/bin/arietta_sdk_handle_kernel.sh)

uninstall::
	(rm -rf $(HOME)/bin/arietta_sdk_make_sdcard.sh)
	(rm -rf $(HOME)/bin/arietta_sdk_handle_kernel.sh)

init_sdk: distclean
	@echo "+----------------------------------------------------------+"
	@echo "|                                                          |"
	@echo "|              Init SDK -> you may need sudo               |"
	@echo "|                                                          |"
	@echo "+----------------------------------------------------------+"
	($(ARMEL_HOME)/scripts/init_sdk.sh -a)

init_user_home: clean_user_home
	@echo "+----------------------------------------------------------+"
	@echo "|                                                          |"
	@echo "|              Init $USER specific SDK parts               |"
	@echo "|                                                          |"
	@echo "+----------------------------------------------------------+"
	($(ARMEL_HOME)/scripts/init_sdk.sh -u)

init_opt: clean_opt
	@echo "+----------------------------------------------------------+"
	@echo "|                                                          |"
	@echo "|              Init SDK (/opt) -> you may need sudo        |"
	@echo "|                                                          |"
	@echo "+----------------------------------------------------------+"
	($(ARMEL_HOME)/scripts/init_sdk.sh -o)

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
	($(ARMEL_HOME)/scripts/get_external_git_repos.sh -p "git")

get_latest_kernel::
	@echo "+----------------------------------------------------------+"
	@echo "|                                                          |"
	@echo "|        Download latest supported kernel versions         |"
	@echo "|                                                          |"
	@echo "+----------------------------------------------------------+"
	($(ARMEL_HOME)/scripts/get_latest_linux_kernel.sh -a)

get_toolchain::
	@echo "+----------------------------------------------------------+"
	@echo "|                                                          |"
	@echo "|        Download latest supported toolchain version       |"
	@echo "|                                                          |"
	@echo "+----------------------------------------------------------+"
	($(ARMEL_HOME)/scripts/get_toolchain.sh)

get_image_tarballs::
	@echo "+----------------------------------------------------------+"
	@echo "|                                                          |"
	@echo "|        Download latest supported image tarballs          |"
	@echo "|                                                          |"
	@echo "+----------------------------------------------------------+"
	($(ARMEL_HOME)/scripts/get_image_tarballs.sh)


man::
	(cd man && $(MAKE) $@)

#
# create ready to use sdcards
#
make_sdcard::
	@echo "+----------------------------------------------------------+"
	@echo "|                                                          |"
	@echo "|              Start tool to make a SD-Card                |"
	@echo "|                                                          |"
	@echo "+----------------------------------------------------------+"
	($(ARMEL_HOME)/scripts/make_sdcard.sh)