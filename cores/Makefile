# Cross-compiles libretro cores with zig cc.
#
#   make -C cores <core> PROFILE=<profile> OUT=<dir>
#
# writes <OUT>/cores/<PROFILE>/<core>_libretro.so.

include common.mk

HERE := $(abspath .)
PROFILE ?= $(firstword $(PROFILES_ALL))
OUT ?= $(abspath ../out)

ifeq ($(CORE_TARGET_$(PROFILE)),)
$(error unknown PROFILE '$(PROFILE)'; known: $(PROFILES_ALL))
endif

TARGET := $(CORE_TARGET_$(PROFILE))
SIMD := $(SIMD_CFLAGS_$(PROFILE))
CPU := $(CPU_CFLAG_$(PROFILE))
DEST := $(OUT)/cores/$(PROFILE)
STAMPS := $(OUT)/.build

CC_WRAPPER := $(HERE)/zig-cc-wrapper.sh
CXX_WRAPPER := $(HERE)/zig-cxx-wrapper.sh

TUNED := -ffast-math -fsingle-precision-constant -fomit-frame-pointer -Ofast -DNDEBUG -fno-stack-protector -fno-ident -falign-functions=1 -falign-jumps=1 -falign-loops=1 -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-unroll-loops -fmerge-all-constants -fno-math-errno

CORES := gambatte gpsp fceumm mednafen_supafaust picodrive pcsx_rearmed

# name | source dir | makefile | CFLAGS | extra make args | CC wrapper | CXX wrapper | env
# <core>_ARGS_<profile>, when set, replaces <core>_ARGS for that profile.
gambatte_DIR := gambatte
gambatte_MK := Makefile.libretro
gambatte_CFLAGS := $(SIMD)
gambatte_CC := $(CXX_WRAPPER)
gambatte_CXX := $(CXX_WRAPPER)

gpsp_DIR := gpsp
gpsp_MK := Makefile
gpsp_CFLAGS :=
gpsp_ARGS := arch=arm CPU_ARCH=arm HAVE_DYNAREC=1
gpsp_ARGS_aarch64-gnu-glibc217 := CPU_ARCH=arm64 HAVE_DYNAREC=1
gpsp_CC := $(CC_WRAPPER)
gpsp_CXX := $(CC_WRAPPER)

fceumm_DIR := fceumm
fceumm_MK := Makefile.libretro
fceumm_CFLAGS := $(SIMD)
fceumm_CC := $(CC_WRAPPER)
fceumm_CXX := $(CC_WRAPPER)

mednafen_supafaust_DIR := beetle_supafaust
mednafen_supafaust_MK := Makefile
mednafen_supafaust_CFLAGS := $(SIMD) $(CPU) $(TUNED)
mednafen_supafaust_CC := $(CXX_WRAPPER)
mednafen_supafaust_CXX := $(CXX_WRAPPER)

picodrive_DIR := picodrive
picodrive_MK := Makefile.libretro
picodrive_CFLAGS := $(SIMD) $(CPU) $(TUNED)
picodrive_ARGS_aarch64-gnu-glibc217 := ARCH=aarch64 use_cyclone=0 use_fame=1 use_drz80=0 use_cz80=1 asm_render=0 asm_memory=0 asm_ym2612=0 asm_misc=0 asm_cdmemory=0 asm_32xdraw=0 asm_32xmemory=0 asm_mix=0 use_svpdrc=0
picodrive_ARGS := ARCH=arm use_cyclone=0 use_fame=1 use_drz80=0 use_cz80=1 asm_render=0 asm_memory=0 asm_ym2612=0 asm_misc=0 asm_cdmemory=0 asm_32xdraw=0 asm_32xmemory=0 asm_mix=0 use_svpdrc=0
picodrive_CC := $(CC_WRAPPER)
picodrive_CXX := $(CC_WRAPPER)

pcsx_rearmed_DIR := pcsx_rearmed
pcsx_rearmed_MK := Makefile.libretro
pcsx_rearmed_CFLAGS := $(SIMD) $(CPU) -ffast-math -fsingle-precision-constant -fomit-frame-pointer
pcsx_rearmed_ARGS_aarch64-gnu-glibc217 := DYNAREC=ari64 BUILTIN_GPU=neon HAVE_NEON_ASM=0 HAVE_CHD=1 HAVE_PHYSICAL_CDROM=0 USE_ASYNC_CDROM=0 USE_LIBRETRO_VFS=1 HAVE_NEON=1 CPU_ARCH=arm64 ARCH=arm64 OPTIMIZE="-Ofast -DNDEBUG=1"
pcsx_rearmed_ARGS := DYNAREC=ari64 BUILTIN_GPU=neon HAVE_NEON_ASM=1 HAVE_CHD=1 HAVE_PHYSICAL_CDROM=0 USE_ASYNC_CDROM=0 USE_LIBRETRO_VFS=1 HAVE_NEON=1 CPU_ARCH=arm ARCH=arm OPTIMIZE="-Ofast -DNDEBUG=1"
pcsx_rearmed_CC := $(CC_WRAPPER)
pcsx_rearmed_CXX := $(CC_WRAPPER)

core_args_for = $(if $($(1)_ARGS_$(2)),$($(1)_ARGS_$(2)),$($(1)_ARGS))
core_args = $(call core_args_for,$(1),$(PROFILE))
# Cleans with each profile's own arguments and target, so no profile's objects survive a switch.
core_clean = $(foreach p,$(PROFILES_ALL),make -C '$(HERE)/$($(1)_DIR)' -f '$($(1)_MK)' platform=unix$(if $(call core_args_for,$(1),$(p)), $(call core_args_for,$(1),$(p))) CC="$($(1)_CC) -target $(CORE_TARGET_$(p))" CXX="$($(1)_CXX) -target $(CORE_TARGET_$(p))" clean &&) true

.PHONY: all init $(CORES)
all: $(CORES)

# Checks out the core sources and their direct dependencies. A fully
# recursive checkout is not needed and fails on pcsx_rearmed's gnulib.
init:
	git -C '$(HERE)/..' submodule update --init
	for dir in $(sort $(foreach core,$(CORES),$(firstword $(subst /, ,$($(core)_DIR))))) libretro-common; do git -C '$(HERE)/'$$dir submodule update --init; done

# Source trees build in place, so a tree last built for another profile is cleaned first.
define core_rule
$(1):
	@mkdir -p '$(DEST)' '$(STAMPS)'
	@if [ -f '$(STAMPS)/$(1).profile' ] && [ "$$$$(cat '$(STAMPS)/$(1).profile')" != '$(PROFILE)' ]; then $(call core_clean,$(1)); fi
	$($(1)_ENV) CFLAGS='$(strip $($(1)_CFLAGS))' make -C '$(HERE)/$($(1)_DIR)' -f '$($(1)_MK)' platform=unix$(if $(call core_args,$(1)), $(call core_args,$(1))) CC="$($(1)_CC) -target $(TARGET)" CXX="$($(1)_CXX) -target $(TARGET)" AS="$(CC_WRAPPER) -target $(TARGET)" -j4
	@echo '$(PROFILE)' > '$(STAMPS)/$(1).profile'
	cp '$(HERE)/$($(1)_DIR)/$(1)_libretro.so' '$(DEST)/$(1)_libretro.so'
endef

$(foreach core,$(CORES),$(eval $(call core_rule,$(core))))
