# Simple Command Line Option Parsing for Lua 5.1, 5.2, 5.3 & 5.4
# Copyright (C) 2014-2018, 2021-2022 Gary V. Vaughan

LDOC	= ldoc
LUA	= lua
MKDIR	= mkdir -p
SED	= sed
SPECL	= specl

VERSION	= git

luadir	= lib/optparse
SOURCES =				\
	$(luadir)/init.lua		\
	$(luadir)/version.lua		\
	$(NOTHING_ELSE)

.PHONY: all check clean

all: $(luadir)/version.lua


$(luadir)/version.lua: .FORCE
	@echo "return 'Parse Command-Line Options / $(VERSION)'" > '$@T';	\
	if cmp -s '$@' '$@T'; then						\
	    rm -f '$@T';							\
	else									\
	    echo "echo return 'Parse Command-Line Options / $(VERSION)' > $@";	\
	    mv '$@T' '$@';							\
	fi

doc: build-aux/config.ld $(SOURCES)
	$(LDOC) -c build-aux/config.ld .

build-aux/config.ld: build-aux/config.ld.in
	$(SED) -e "s,@PACKAGE_VERSION@,$(VERSION)," '$<' > '$@'


CHECK_ENV = LUA=$(LUA)

check: $(SOURCES)
	LUA=$(LUA) $(SPECL) --unicode $(SPECL_OPTS) spec/*_spec.yaml

clean:
	rm -f $(luadir)/version.lua
	rm -rf doc/
	rm -f build-aux/config.ld

.FORCE:
