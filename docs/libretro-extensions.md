# Libretro extensions

Argon runs standard libretro cores. A core needs nothing beyond the libretro
API to work in Argon. Argon adds one optional environment command.

## `ARGON_ENVIRONMENT_DS_NATIVE_FRAME`

| | |
|---|---|
| Command | `0x20000001` |
| Data | `struct ArgonDsNativeFrame *` |
| Returns | `true` if Argon consumed the frame |

```c
#define ARGON_ENVIRONMENT_DS_NATIVE_FRAME 0x20000001

struct ArgonDsNativeFrame {
    uint32_t version;         /* 1 */
    const uint32_t *top;      /* top screen, 256x192 */
    const uint32_t *bottom;   /* bottom screen, 256x192 */
};
```

A DS core calls this from `retro_run` instead of composing both screens into
one image. Argon then lays the screens out itself (side by side, stacked,
picture-in-picture or a single screen) without an extra copy.

- Each screen is 256×192 pixels in XRGB8888, packed with no row padding.
- The call is synchronous. Argon reads the pixels before it returns, and the
  pointers are only borrowed for the duration of the call.
- Argon returns `false` when the data is null, the version is not 1, or the
  current display mode does not use native frames.
- **When the call returns `false`, the core must present the frame through the
  normal `retro_video_refresh_t` callback.** Frontends other than Argon return
  `false` for unknown commands, so a core using this extension still works
  everywhere.
