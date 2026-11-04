# Builds one system package. Each systems/<TAG>.system/Makefile sets CORE and includes this.
#
#   make             -> $(OUT)/Systems/<TAG>.system, the folder for SD:/Systems
#   make core        -> $(OUT)/cores/<profile>/$(CORE)_libretro.so for each profile
#   make system      -> $(OUT)/common/systems/<TAG>.system, metadata and bezels only

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
include $(ROOT)/cores/common.mk

TAG := $(basename $(notdir $(CURDIR)))
OUT ?= $(ROOT)/out
PROFILES ?= $(PROFILES_ALL)
override OUT := $(abspath $(OUT))

# CORE_BUILD=touch stubs the compile for layout tests.
CORE_BUILD ?=

ifeq ($(CORE_BUILD),touch)
build_core = mkdir -p '$(OUT)/cores/$(1)' && touch '$(OUT)/cores/$(1)/$(CORE)_libretro.so'
else
build_core = $(MAKE) -C '$(ROOT)/cores' $(CORE) PROFILE=$(1) OUT='$(OUT)'
endif

STAGE := $(OUT)/common/systems/$(TAG).system
PACKAGE := $(OUT)/Systems/$(TAG).system

.PHONY: all core system
all: core system
	rm -rf '$(PACKAGE)'
	mkdir -p '$(PACKAGE)'
	cp -Rp '$(STAGE)/.' '$(PACKAGE)/'
	$(foreach p,$(PROFILES),mkdir -p '$(PACKAGE)/cores/$(p)' && cp '$(OUT)/cores/$(p)/$(CORE)_libretro.so' '$(PACKAGE)/cores/$(p)/' &&) true

core:
	$(foreach p,$(PROFILES),$(call build_core,$(p)) &&) true

system:
	rm -rf '$(STAGE)'
	mkdir -p '$(STAGE)'
	cp system.toml '$(STAGE)/'
	if [ -d bezels ]; then cp -Rp bezels '$(STAGE)/'; fi
