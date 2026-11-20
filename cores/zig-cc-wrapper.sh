#!/bin/sh







# Answers -dumpmachine for the -target the build passes (without its glibc version).
ZIG_TARGET="arm-linux-gnueabihf"
want_target=false
for arg in "$@"; do
  if [ "$want_target" = true ]; then ZIG_TARGET="${arg%%.*}"; want_target=false; fi
  [ "$arg" = "-target" ] && want_target=true
done

for arg in "$@"; do
  [ "$arg" = "-dumpversion" ] && exec zig cc -dumpversion
  [ "$arg" = "-dumpmachine" ] && exec zig cc -target "$ZIG_TARGET" -dumpmachine
done

# Links the barriered __clear_cache into aarch64 shared libraries (see aarch64_clear_cache.c).
EXTRA=""
case "$ZIG_TARGET" in
  aarch64-*)
    is_shared=false
    for arg in "$@"; do
      case "$arg" in
        -shared) is_shared=true ;;
        -c) is_shared=false; break ;;
      esac
    done
    [ "$is_shared" = true ] && EXTRA="$(cd "$(dirname "$0")" && pwd)/aarch64_clear_cache.c"
    ;;
esac

exec zig cc -Wno-error=date-time "$@" ${EXTRA:+"$EXTRA"}
