# Supafaust Core Options

This inventory follows the pinned `libretro.cpp` declarations. Supafaust's
`retro_load_game()` extracts the first token after each declaration's semicolon
as the fallback when Argon does not provide an exact option key.

## Complete inventory

| Option | Accepted values | First-value fallback | Argon policy |
|---|---|---|---|
| `supafaust_pixel_format` | <code>rgb565&#124;xrgb8888&#124;0rgb1555</code> | `rgb565` | Preserve upstream default |
| `supafaust_correct_aspect` | <code>enabled&#124;disabled&#124;force_ntsc&#124;force_pal</code> | `enabled` | Preserve upstream default |
| `supafaust_h_filter` | <code>phr256blend_auto512&#124;phr256blend_512&#124;512_blend&#124;512&#124;phr256blend</code> | `phr256blend_auto512` | Preserve upstream default |
| `supafaust_deinterlacer` | <code>bob_offset&#124;weave&#124;blend</code> | `bob_offset` | Preserve upstream default |
| `supafaust_slstart` | <code>0&#124;1&#124;2&#124;3&#124;4&#124;5&#124;6&#124;7&#124;8&#124;9&#124;10&#124;11&#124;12&#124;13&#124;14&#124;15&#124;16</code> | `0` | Preserve upstream default |
| `supafaust_slend` | <code>223&#124;222&#124;221&#124;220&#124;219&#124;218&#124;217&#124;216&#124;215&#124;214&#124;213&#124;212&#124;211&#124;210&#124;209&#124;208&#124;207</code> | `223` | Preserve upstream default |
| `supafaust_slstartp` | <code>0&#124;1&#124;2&#124;3&#124;4&#124;5&#124;6&#124;7&#124;8&#124;9&#124;10&#124;11&#124;12&#124;13&#124;14&#124;15&#124;16&#124;17&#124;18&#124;19&#124;20&#124;21&#124;22&#124;23&#124;24</code> | `0` | Preserve upstream default |
| `supafaust_slendp` | <code>238&#124;237&#124;236&#124;235&#124;234&#124;233&#124;232&#124;231&#124;230&#124;229&#124;228&#124;227&#124;226&#124;225&#124;224&#124;223&#124;222&#124;221&#124;220&#124;219&#124;218&#124;217&#124;216&#124;215&#124;214</code> | `238` | Preserve upstream default |
| `supafaust_region` | <code>auto&#124;ntsc&#124;pal&#124;ntsc_lie_auto&#124;pal_lie_auto&#124;ntsc_lie_pal&#124;pal_lie_ntsc</code> | `auto` | Preserve upstream default |
| `supafaust_frame_begin_vblank` | <code>enabled&#124;disabled</code> | `enabled` | Set `disabled` |
| `supafaust_run_ahead` | <code>disabled&#124;video&#124;video+audio</code> | `disabled` | Set `disabled` |
| `supafaust_multitap` | <code>disabled&#124;port1&#124;port2&#124;port1+port2</code> | `disabled` | Set `disabled` |
| `supafaust_cx4_clock_rate` | <code>100&#124;125&#124;150&#124;175&#124;200&#124;250&#124;300&#124;400&#124;500</code> | `100` | Set `100` |
| `supafaust_superfx_clock_rate` | <code>100&#124;125&#124;150&#124;175&#124;200&#124;250&#124;300&#124;400&#124;500&#124;95</code> | `100` | Set `100` |
| `supafaust_superfx_icache` | <code>disabled&#124;enabled</code> | `disabled` | Set `enabled` |
| `supafaust_audio_rate` | <code>disabled&#124;44100&#124;48000&#124;96000</code> | `disabled` | Set `disabled` |
| `supafaust_thread_affinity_emu` | <code>0x2&#124;0x0&#124;0x1&#124;0x3&#124;0x4&#124;0x5&#124;0x6&#124;0x7&#124;0x8&#124;0x9&#124;0xa&#124;0xb&#124;0xc&#124;0xd&#124;0xe&#124;0xf</code> | `0x2` | Set `0x1` |
| `supafaust_thread_affinity_ppu` | <code>0x1&#124;0x0&#124;0x2&#124;0x3&#124;0x4&#124;0x5&#124;0x6&#124;0x7&#124;0x8&#124;0x9&#124;0xa&#124;0xb&#124;0xc&#124;0xd&#124;0xe&#124;0xf</code> | `0x1` | Set `0x2` |
| `supafaust_renderer` | <code>mt&#124;st</code> | `mt` | Set `mt` |

## Upstream source literals

```text
supafaust_pixel_format: rgb565|xrgb8888|0rgb1555
supafaust_correct_aspect: enabled|disabled|force_ntsc|force_pal
supafaust_h_filter: phr256blend_auto512|phr256blend_512|512_blend|512|phr256blend
supafaust_deinterlacer: bob_offset|weave|blend
supafaust_slstart: 0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16
supafaust_slend: 223|222|221|220|219|218|217|216|215|214|213|212|211|210|209|208|207
supafaust_slstartp: 0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24
supafaust_slendp: 238|237|236|235|234|233|232|231|230|229|228|227|226|225|224|223|222|221|220|219|218|217|216|215|214
supafaust_region: auto|ntsc|pal|ntsc_lie_auto|pal_lie_auto|ntsc_lie_pal|pal_lie_ntsc
supafaust_frame_begin_vblank: enabled|disabled
supafaust_run_ahead: disabled|video|video+audio
supafaust_multitap: disabled|port1|port2|port1+port2
supafaust_cx4_clock_rate: 100|125|150|175|200|250|300|400|500
supafaust_superfx_clock_rate: 100|125|150|175|200|250|300|400|500|95
supafaust_superfx_icache: disabled|enabled
supafaust_audio_rate: disabled|44100|48000|96000
supafaust_thread_affinity_emu: 0x2|0x0|0x1|0x3|0x4|0x5|0x6|0x7|0x8|0x9|0xa|0xb|0xc|0xd|0xe|0xf
supafaust_thread_affinity_ppu: 0x1|0x0|0x2|0x3|0x4|0x5|0x6|0x7|0x8|0x9|0xa|0xb|0xc|0xd|0xe|0xf
supafaust_renderer: mt|st
```

## Selected launch policy

The SNES package selects `core = "mednafen_supafaust"` by default. The ten
`supafaust_*` entries provide the active core's namespaced policy; the existing
Snes9x entries remain available for alternate core selections through Argon's
existing string transport.

The renderer uses `mt` for A33 throughput. The emulation thread uses CPU0
(`0x1`) and the PPU render thread uses CPU1 (`0x2`). CPU1 contention with
existing audio and blit work is accepted, and this affinity split remains
provisional pending device performance comparison.

The package disables frame-begin-vblank, internal audio-rate conversion,
run-ahead, and multitap. It keeps CX4 and SuperFX clocks at `100` and enables
the SuperFX instruction cache. These values favor throughput and compatibility
without unsafe coprocessor overclocks.

The visual settings remain upstream defaults: `rgb565`, enabled aspect
correction, `phr256blend_auto512`, `bob_offset`, `auto` region, and the
upstream NTSC/PAL scanline endpoints. None of those six visual settings is
copied into `system.toml`.

## Renderer troubleshooting

For a title with renderer-specific problems, change the package value manually:

```toml
supafaust_renderer = "st"
```

`st` is an accepted upstream token. The build-time renderer patch removes the
wrapper's unconditional `mt` assignment while retaining the existing option
forwarding call.

## Existing transport proof

Argon already parses quoted string values in `[core_options]`, stores each
option for the session, and provides values through an exact-key
`GET_VARIABLE` lookup. Unknown names return false, so namespaced Supafaust
entries are harmless while Snes9x remains selected. No parser, runner, or
selector changes are required.
