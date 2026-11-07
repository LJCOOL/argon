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

- Eight systems: GB/GBC, GBA, NES, SNES, Mega Drive, Master System, Game Gear
  and PS1.
- Written from scratch in Zig.
- Intentionally simple and fast.
- Three different game view styles with cover art support: game list, game list with covers and horizonal cover flow.
- Colour theme and font selection preferences.
- Saves games on exit and shutdown and resumes them seamlessly.
- Shutdown on lid close on supported devices.
- Auto shutdown after two minutes of inactivity.
- In-game save state list with previews and a special "restore" state that protects against accidental state loads and game resets.
- Alternate PlayStation button layout and glyph support.
- Built in LCD effect for supported systems.
- Overlay support, with overrides on the SD card.
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

## Overlays

Each system has at most one overlay per screen-size mode, found by filename:

```
<width>x<height>.fit.png        # Fit
<width>x<height>.integer.png    # Integer and Overscale
```

Width and height are the device's rendering size (Miyoo Mini Flip: `752x560`)
and must match exactly.

Argon's built-in overlays contain no logos or other copyrighted artwork.

Argon looks in two places, per file:

1. `Overlays/<TAG>/` in the root of the SD card. The tag matches
   case-insensitively.
2. `systems/<TAG>.system/overlays/` in the system package.

The in-game Overlay setting turns them on or off.

## Libretro extensions

Argon loads standard libretro cores. Its one extension is documented in
[docs/libretro-extensions.md](docs/libretro-extensions.md).

## Contributing

Bug reports are welcome as [GitHub issues](https://github.com/LJCOOL/argon/issues).
Pull requests that add systems or themes are welcome.

## AI disclosure

Argon has been developed with the assistance of AI tools.

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
| libretro-common | all | MIT | [libretro/libretro-common](https://github.com/libretro/libretro-common) |
