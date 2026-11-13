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

exec zig cc -Wno-error=date-time "$@"
