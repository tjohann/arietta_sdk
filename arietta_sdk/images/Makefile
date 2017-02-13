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

all::
	@echo "+----------------------------------------------------------+"
	@echo "|                                                          |"
	@echo "|                  Nothing to build                        |"
	@echo "|                                                          |"
	@echo "+----------------------------------------------------------+"
	@echo "| make get_image_tarballs -> download image tarballs       |"
	@echo "| make clean -> clean all dir/subdirs                      |"
	@echo "| make distclean -> rm also downloaded/build parts         |"
	@echo "+----------------------------------------------------------+"

clean::
	rm -f *~ *.o .*~

distclean::
	rm -f *~ *.o .*~
	($(ARIETTA_HOME)/scripts/clean_sdk.sh -i)

#
# download image tarballs
#
get_image_tarballs::
	@echo "+----------------------------------------------------------+"
	@echo "|                                                          |"
	@echo "|        Download latest supported image tarballs          |"
	@echo "|                                                          |"
	@echo "+----------------------------------------------------------+"
	($(ARIETTA_HOME)/scripts/get_image_tarballs.sh)
