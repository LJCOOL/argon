#!/bin/sh
# Checks the dist layout with core builds stubbed out.
set -eu

root=$(cd "$(dirname "$0")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
profiles=$(sed -n 's/^PROFILES_ALL := //p' "$root/cores/common.mk")

make -C "$root" dist OUT="$tmp" CORE_BUILD=touch >/dev/null

fail() { echo "FAIL: $*"; exit 1; }

[ "$(echo $profiles | wc -w | tr -d ' ')" -ge 2 ] || fail "expected every device profile, got: $profiles"
for profile in $profiles; do
    [ -f "$tmp/Systems/GBA.system/cores/$profile/gpsp_libretro.so" ] || fail "GBA core missing: $profile"
    for tag in MD SMS GG; do
        [ -f "$tmp/Systems/$tag.system/cores/$profile/picodrive_libretro.so" ] || fail "$tag picodrive missing: $profile"
    done
    for tag in GB GBC; do
        [ -f "$tmp/Systems/$tag.system/cores/$profile/gambatte_libretro.so" ] || fail "$tag gambatte missing: $profile"
    done
    [ -f "$tmp/Systems/SNES.system/cores/$profile/mednafen_supafaust_libretro.so" ] || fail "SNES core missing: $profile"
done
[ -f "$tmp/Systems/GBA.system/system.toml" ] || fail "GBA system.toml missing"
[ -f "$tmp/Systems/GBA.system/overlays/752x560.fit.png" ] || fail "GBA overlay missing"
[ -d "$tmp/Roms/GBC" ] || fail "Roms/GBC missing"
[ -f "$tmp/common/systems/GBA.system/system.toml" ] || fail "staged GBA system.toml missing"
[ -z "$(find "$tmp/common" -name '*.so')" ] || fail "staged systems contain cores"
[ -f "$tmp/common/systems/GBA.system/overlays/752x560.fit.png" ] || fail "staged GBA overlay missing"
[ -z "$(find "$tmp" -name bezels)" ] || fail "bezels folder shipped"
[ "$(ls "$tmp/Systems" | wc -l | tr -d ' ')" = 9 ] || fail "expected 9 systems"

echo "layout: ok"
