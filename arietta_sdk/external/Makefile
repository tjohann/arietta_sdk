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

MODULES = $(shell ls -d */ | cut -f1 -d'/')

all::
	@echo "+----------------------------------------------------------+"
	@echo "|                                                          |"
	@echo "|                  Nothing to build                        |"
	@echo "|                                                          |"
	@echo "+----------------------------------------------------------+"
	@echo "| Example:                                                 |"
	@echo "| make get_external_repos -> get ALL git repos like u-boot |"
	@echo "| make get_rt-tests       -> clone rt test suite           |"
	@echo "| make get_can-utils      -> clone can-utils               |"
	@echo "| make get_lcd1602        -> clone my lcd kernel driver    |"
	@echo "| make get_mydriver       -> clone my learning kernel      |"
	@echo "|                            driver                        |"
	@echo "| make get_libbaalue      -> clone my common librar        |"
	@echo "| make get_baalued        -> clone my admin daemon         |"
	@echo "| make get_tt-env         -> clone time-triggert           |"
	@echo "|                            environment playground        |"
	@echo "| make get_can-lin-env    -> clone can/lin bus             |"
	@echo "|                            environment playground        |"
	@echo "| make clean              -> clean all dir/subdirs         |"
	@echo "| make distclean          -> complete cleanup/delete       |"
	@echo "+----------------------------------------------------------+"

clean::
	rm -f *~ *.o .*~
	for dir in $(MODULES); do (cd $$dir/ && $(MAKE) $@); done

distclean::
	rm -f *~ *.o .*~
	($(ARIETTA_HOME)/scripts/clean_sdk.sh -e)

update_all::
	rm -f *~ *.o
	for dir in $(MODULES_GIT); do (cd $$dir && git pull); done

get_external_repos::
	($(ARIETTA_HOME)/scripts/get_external_git_repos.sh -p "git")

get_rt-tests::
	($(ARIETTA_HOME)/scripts/get_external_git_repos.sh -r "rt-tests" -p "http")

get_can-utils::
	($(ARIETTA_HOME)/scripts/get_external_git_repos.sh -r "can-utils" -p "http")

get_lcd1602::
	($(ARIETTA_HOME)/scripts/get_external_git_repos.sh -r "lcd1602" -p "https")

get_mydriver::
	($(ARIETTA_HOME)/scripts/get_external_git_repos.sh -r "mydriver" -p "https")

get_libbaalue::
	($(ARIETTA_HOME)/scripts/get_external_git_repos.sh -r "libbaalue" -p "https")

get_baalued::
	($(ARIETTA_HOME)/scripts/get_external_git_repos.sh -r "baalued" -p "https")

get_tt-env::
	($(ARIETTA_HOME)/scripts/get_external_git_repos.sh -r "tt-env" -p "https")

get_can-lin-env::
	($(ARIETTA_HOME)/scripts/get_external_git_repos.sh -r "can-lin-env" -p "https")
