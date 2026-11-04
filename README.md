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

- Ten systems: GB/GBC, GBA, NES, SNES, Mega Drive, Master System, Game Gear,
  PS1, N64 and DS.
- Written from scratch in Zig.
- Intentionally simple and fast.
- Saves games on exit and resumes them seamlessly.
- Runs from a read-only image. Updates are atomic and roll back on failure.
- Add or override systems by dropping a folder into `Systems/` on the card.

## Supported devices

- Miyoo Mini Flip

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

## Libretro extensions

Argon loads standard libretro cores. Its one extension is documented in
[docs/libretro-extensions.md](docs/libretro-extensions.md).

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
| ParaLLEl N64 | N64 | GPL-2.0 | [LJCOOL/parallel-n64](https://github.com/LJCOOL/parallel-n64) |
| DSperate | DS | GPL-3.0 | [LJCOOL/DSperate](https://github.com/LJCOOL/DSperate) |
| libretro-common | all | MIT | [libretro/libretro-common](https://github.com/libretro/libretro-common) |
