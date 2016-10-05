#
# my simple makefile act as something like a user interface
#

ifeq "${ARMEL_HOME}" ""
    $(error error: please source armel_env first!)
endif

ifeq "${ARMEL_BIN_HOME}" ""
    $(error error: please source armel_env first!)
endif

ifeq "${ARMEL_SRC_HOME}" ""
    $(error error: please source armel_env first!)
endif

all::
	@echo Cheers

clean::
	rm -f *~
	rm -f *.ps

man::
	groff -man ./arietta_sdk.7 > ./arietta_sdk.ps
	groff -man -Tascii ./arietta_sdk.7 | less

distclean: clean
