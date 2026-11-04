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

SYSTEMS := $(patsubst Systems/%.system,%,$(wildcard Systems/*.system))

.PHONY: all dist cores init clean $(SYSTEMS)
all: $(SYSTEMS)

$(SYSTEMS):
	$(MAKE) -C Systems/$@.system

cores:
	$(foreach p,$(PROFILES),$(MAKE) -C cores all PROFILE=$(p) &&) true

init:
	$(MAKE) -C cores init

dist: all
	mkdir -p '$(OUT)/Roms'
	cp -Rp Roms/. '$(OUT)/Roms/'
	find '$(OUT)/Roms' -name .keep -delete

clean:
	rm -rf '$(OUT)'
