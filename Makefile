LDOC	= ldoc
LUA	= lua
MKDIR	= mkdir -p
SED	= sed
SPECL	= specl


all: doc


doc: doc/config.ld optparse.lua
	$(LDOC) -c doc/config.ld .

doc/config.ld: doc/config.ld.in
	version=`$(LUA) -e 'io.stdout:write(require"optparse"._VERSION)'`; \
	$(SED) -e "s,@PACKAGE_VERSION@,$$version," '$<' > '$@'


CHECK_ENV = LUA=$(LUA)

check:
	LUA=$(LUA) $(SPECL) --unicode $(SPECL_OPTS) specs/*_spec.yaml
