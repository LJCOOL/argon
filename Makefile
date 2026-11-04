# Builds Argon's system packages.
#
#   make              every system into $(OUT)/Systems
#   make GBA          one system
#   make cores        every core
#   make dist         $(OUT)/Systems and $(OUT)/Roms, ready to copy to the SD card
#   make init         check out the core sources
#
# PROFILES=<names> picks device profiles (default: all). OUT=<dir> defaults to out/.

include cores/common.mk

OUT ?= $(CURDIR)/out
PROFILES ?= $(PROFILES_ALL)
override OUT := $(abspath $(OUT))
export OUT PROFILES CORE_BUILD

SYSTEMS := $(patsubst systems/%.system,%,$(wildcard systems/*.system))

.PHONY: all dist cores init clean $(SYSTEMS)
all: $(SYSTEMS)

$(SYSTEMS):
	$(MAKE) -C systems/$@.system

cores:
	$(foreach p,$(PROFILES),$(MAKE) -C cores all PROFILE=$(p) &&) true

init:
	$(MAKE) -C cores init

dist: all
	mkdir -p $(foreach s,$(SYSTEMS),'$(OUT)/Roms/$(s)')

clean:
	rm -rf '$(OUT)'
