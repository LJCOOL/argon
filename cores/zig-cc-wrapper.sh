#!/bin/sh







for arg in "$@"; do
  [ "$arg" = "-dumpversion" ] && exec zig cc -dumpversion
  [ "$arg" = "-dumpmachine" ] && exec zig cc -target arm-linux-gnueabihf -dumpmachine
done

exec zig cc -Wno-error=date-time "$@"
