# only for cleaning :-)

ifeq "${ARMEL_HOME}" ""
    $(error error: please source armel_env first!)
endif

ifeq "${ARMEL_BIN_HOME}" ""
    $(error error: please source armel_env first!)
endif

ifeq "${ARMEL_SRC_HOME}" ""
    $(error error: please source armel_env first!)
endif

.PHONY: all
all:
	@echo Cheers

.PHONY: clean
clean:
	rm -f *~
	rm -f *.h

distclean: clean
