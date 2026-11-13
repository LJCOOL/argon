# Device profiles. Values mirror argon-core's build/device_profiles.zig.

PROFILES_ALL := armv7-neon-gnueabihf-glibc217 aarch64-gnu-glibc217

CORE_TARGET_armv7-neon-gnueabihf-glibc217 := arm-linux-gnueabihf.2.17.0
SIMD_CFLAGS_armv7-neon-gnueabihf-glibc217 := -mfpu=neon-vfpv4 -mfloat-abi=hard -marm
CPU_CFLAG_armv7-neon-gnueabihf-glibc217 := -mcpu=cortex_a7

CORE_TARGET_aarch64-gnu-glibc217 := aarch64-linux-gnu.2.17.0
SIMD_CFLAGS_aarch64-gnu-glibc217 :=
CPU_CFLAG_aarch64-gnu-glibc217 := -mcpu=cortex_a53
