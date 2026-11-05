# Patched cores

Cores that need local changes build from forks. Each fork's `argon` branch is
upstream plus our patches as ordinary commits, and the submodule pins that branch.
Builds apply nothing, so submodules stay clean.

| Submodule | Fork | Upstream |
|---|---|---|
| `cores/fceumm` | `LJCOOL/libretro-fceumm` | `libretro/libretro-fceumm` (`master`) |
| `cores/beetle_supafaust` | `LJCOOL/supafaust` | `libretro/supafaust` (`master`) |
| `cores/dsperate` | `LJCOOL/DSperate` | `beebono/DSperate` (`main`) |

Unpatched cores track upstream directly.

## One-time setup per submodule

```sh
cd cores/fceumm
git remote add upstream https://github.com/libretro/libretro-fceumm.git
git config rerere.enabled true   # remember conflict resolutions across bumps
git switch argon
```

## Bumping a core

```sh
cd cores/fceumm
git fetch upstream
git rebase upstream/master        # resolve conflicts like any rebase
git push --force-with-lease origin argon
cd ../..
make cores
git add cores/fceumm
git commit -m "chore(fceumm): update core"
```

## Adding or changing a patch

Commit on `argon` inside the submodule, push, then commit the new submodule
pointer in this repo. Use `git commit --fixup` plus `git rebase -i --autosquash`
to amend an existing patch commit.

## Per-device patches

All device profiles share `argon` today. When a device needs changes that conflict with
another device's:

1. In the fork, branch `argon-<device>` from `argon` and commit the device changes.
2. Add a submodule pinned to it:
   `git submodule add -b argon-<device> https://github.com/LJCOOL/<fork>.git cores/<core>-<device>`
3. In `cores/Makefile`, make that core's `_DIR` depend on `PROFILE`.

Bump order then becomes: rebase `argon` onto upstream, then rebase each
`argon-<device>` onto `argon`, and commit every affected submodule pointer.
