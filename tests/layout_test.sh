#!/bin/sh
# Checks the dist layout with core builds stubbed out.
set -eu

root=$(cd "$(dirname "$0")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
profile=armv7-neon-gnueabihf-glibc217

make -C "$root" dist OUT="$tmp" PROFILES="$profile" CORE_BUILD=touch >/dev/null

fail() { echo "FAIL: $*"; exit 1; }

[ -f "$tmp/Systems/GBA.system/cores/$profile/gpsp_libretro.so" ] || fail "GBA core missing"
[ -f "$tmp/Systems/GBA.system/system.toml" ] || fail "GBA system.toml missing"
[ -d "$tmp/Systems/GBA.system/bezels" ] || fail "GBA bezels missing"
for tag in MD SMS GG; do
    [ -f "$tmp/Systems/$tag.system/cores/$profile/picodrive_libretro.so" ] || fail "$tag picodrive missing"
done
[ -f "$tmp/Systems/SNES.system/cores/$profile/mednafen_supafaust_libretro.so" ] || fail "SNES core missing"
[ -d "$tmp/Roms/DS" ] || fail "Roms/DS missing"
[ -f "$tmp/common/systems/GBA.system/system.toml" ] || fail "staged GBA system.toml missing"
[ -z "$(find "$tmp/common" -name '*.so')" ] || fail "staged systems contain cores"
[ "$(ls "$tmp/Systems" | wc -l | tr -d ' ')" = 10 ] || fail "expected 10 systems"

echo "layout: ok"
