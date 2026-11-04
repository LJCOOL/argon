# Argon

Argon is a frontend for handheld retro gaming devices. This repository holds
the open parts of Argon: the system packages, the libretro cores they run, the
build that compiles them, the theme list and the ROM folder layout.

**Downloads:** every Argon release is published on this repository's
[Releases](../../releases) page.

## SD card layout

```
SD:/
├── Roms/<TAG>/         your games, one folder per system (GBA, SNES, …)
└── Systems/<TAG>.system/   optional systems you built or downloaded
```

Releases ship the standard systems built in. A folder in `SD:/Systems` adds a
new system, or **replaces** the built-in system with the same name. Names
match without case, so `Systems/gba.system` replaces the built-in `GBA`.
Remove the folder to go back to the built-in one.

A system folder looks like this:

```
GBA.system/
├── system.toml
├── bezels/…
└── cores/<profile>/<core>_libretro.so
```

`<profile>` names the device family the core was built for, for example
`armv7-neon-gnueabihf-glibc217`. A folder can carry cores for several
profiles; Argon loads the one for its device. If the folder has no core for the
device, the system shows as unavailable instead of falling back.

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

Each `<TAG>.system/Makefile` names its core and includes `system.mk`, so a new
system is a folder with a `system.toml` and a two-line Makefile. The core
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
| Snes9x 2005 | — | Snes9x license, **non-commercial** | [libretro/snes9x2005](https://github.com/libretro/snes9x2005) |
| Supafaust | SNES | GPL-2.0 | [LJCOOL/supafaust](https://github.com/LJCOOL/supafaust) |
| PicoDrive | MD, SMS, GG | PicoDrive license, **non-commercial** | [libretro/picodrive](https://github.com/libretro/picodrive) |
| PCSX ReARMed | PS1 | GPL-2.0 | [notaz/pcsx_rearmed](https://github.com/notaz/pcsx_rearmed) |
| ParaLLEl N64 | N64 | GPL-2.0 | [LJCOOL/parallel-n64](https://github.com/LJCOOL/parallel-n64) |
| DSperate | DS | GPL-3.0 | [LJCOOL/DSperate](https://github.com/LJCOOL/DSperate) |
| libretro-common | all | MIT | [libretro/libretro-common](https://github.com/libretro/libretro-common) |

**Argon is free and must stay free.** PicoDrive and Snes9x 2005 forbid
commercial use, so Argon, its releases and these cores must not be sold or
bundled with anything that is sold.
