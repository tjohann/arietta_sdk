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
	@echo Cheers

clean::
	rm -f *~
	for dir in $(MODULES); do (cd $$dir && $(MAKE) $@); done

distclean: clean
