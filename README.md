# Argon

Argon is a frontend for handheld retro gaming devices. This repository holds
Argon's open parts: system packages, their libretro cores and build, and the
theme list.

Argon takes its name from the noble gas. Its full outer electron shell leaves it
with almost nothing to react with, so it stays stable by nature. Stability is the aim here too: a frontend that
runs games and stays out of the way.

The Argon themes take their colours from argon's emission spectrum. Excited
argon glows violet-blue and red, and Argon Dark and Argon Light pair those two
ends of the spectrum as foreground and accent.

## Features

- Nine systems: GB/GBC, GBA, NES, SNES, Mega Drive, Master System, Game Gear,
  PS1 and DS.
- Written from scratch in Zig.
- Intentionally simple and fast.
- Saves games on exit and resumes them seamlessly.
- Runs from a read-only image. Updates are atomic and roll back on failure.
- Add or override systems by dropping a folder into `Systems/` on the card.

## Supported devices

- Miyoo Mini Flip

## Installation

1. Download `argon-seed.zip` and `argon.zip` from the latest
   [release](../../releases/latest).
2. Extract `argon-seed.zip` into the root of a FAT32 SD card.
3. Copy `argon.zip` to the root of the card without extracting it.
4. Insert the card and power on the device.

> [!NOTE]
> Updating does not need `argon-seed.zip`. Copy the new `argon.zip` to the
> root of the card.

## Building

Install [Zig](https://ziglang.org/) 0.16 and GNU make, then:

```sh
git clone https://github.com/LJCOOL/argon.git
cd argon
make init        # check out the core sources
make             # build every system into out/Systems
make GBA         # build one system
make dist        # out/Systems and out/Roms, ready to copy to the SD card
```

Options:

- `PROFILES=<names>` builds for some device profiles only (default: all).
- `OUT=<dir>` writes somewhere other than `out/`.
- `make cores` builds only the cores, into `out/cores/<profile>/`.

Each `systems/<TAG>.system/Makefile` names its core and includes `system.mk`, so adding a
system takes only a `system.toml` and a two-line Makefile. The core
builds and their compiler flags live in `cores/Makefile`; device profiles live
in `cores/common.mk`.

## Themes

`themes.toml` lists the colour themes offered in Argon's settings:

```toml
[[theme]]
name = "Argon Dark"
background = "#12101A"
foreground = "#C5A8FF"
accent = "#E14B58"
```

A `themes.toml` in the root of the SD card adds themes in the same format. A
theme with the same name as a built-in one replaces it.

## Libretro extensions

Argon loads standard libretro cores. Its one extension is documented in
[docs/libretro-extensions.md](docs/libretro-extensions.md).

## Credits

- The authors of the libretro cores listed under [Licenses](#licenses).
- [libretro](https://www.libretro.com/) for the core API and libretro-common.
- [z2d](https://github.com/vancluever/z2d) for 2D drawing.
- [stb](https://github.com/nothings/stb) for image loading.
- [Exo 2](https://fonts.google.com/specimen/Exo+2), [Iosevka](https://github.com/be5invis/Iosevka)
  and [Roboto](https://fonts.google.com/specimen/Roboto) fonts.
- [Zig](https://ziglang.org/).

Thanks also to the [spruceOS](https://github.com/spruceUI/spruceOS) team,
[goweiwen](https://github.com/goweiwen), creator of
[Allium](https://github.com/goweiwen/Allium), and
[Shaun Inman](https://github.com/shauninman), creator of
[MinUI](https://github.com/shauninman/MinUI), for inspiration and for their
examples of high-quality handheld experiences.

## Licenses

This repository's own files (Makefiles, system and theme files, scripts and
docs) are under the [MIT license](LICENSE). Each core keeps its own license:

| Core | Systems | License | Source |
|------|---------|---------|--------|
| Gambatte | GB | GPL-2.0 | [libretro/gambatte-libretro](https://github.com/libretro/gambatte-libretro) |
| gpSP | GBA | GPL-2.0 | [libretro/gpsp](https://github.com/libretro/gpsp) |
| FCEUmm | NES | GPL-2.0 | [LJCOOL/libretro-fceumm](https://github.com/LJCOOL/libretro-fceumm) |
| Supafaust | SNES | GPL-2.0 | [LJCOOL/supafaust](https://github.com/LJCOOL/supafaust) |
| PicoDrive | MD, SMS, GG | PicoDrive license, **non-commercial** | [libretro/picodrive](https://github.com/libretro/picodrive) |
| PCSX ReARMed | PS1 | GPL-2.0 | [notaz/pcsx_rearmed](https://github.com/notaz/pcsx_rearmed) |
| DSperate | DS | GPL-3.0 | [LJCOOL/DSperate](https://github.com/LJCOOL/DSperate) |
| libretro-common | all | MIT | [libretro/libretro-common](https://github.com/libretro/libretro-common) |
