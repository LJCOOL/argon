#!/bin/sh







# Answers -dumpmachine for the -target the build passes (without its glibc version).
ZIG_TARGET="arm-linux-gnueabihf"
want_target=false
for arg in "$@"; do
  if [ "$want_target" = true ]; then ZIG_TARGET="${arg%%.*}"; want_target=false; fi
  [ "$arg" = "-target" ] && want_target=true
done

for arg in "$@"; do
  [ "$arg" = "-dumpversion" ] && exec zig c++ -dumpversion
  [ "$arg" = "-dumpmachine" ] && exec zig c++ -target "$ZIG_TARGET" -dumpmachine
done





ZIG_LIB="$(zig env | sed -n 's/.*\.lib_dir = "\([^"]*\)".*/\1/p')"
ZIG_LIBCXX="${ZIG_LIB}/libcxx/include"
[ -d "$ZIG_LIBCXX" ] || ZIG_LIBCXX="/opt/homebrew/Cellar/zig/0.16.0_1/lib/zig/libcxx/include"

is_c_file=false
has_c_flag=false
for arg in "$@"; do
  case "$arg" in
    *.c) is_c_file=true ;;
    -c) has_c_flag=true ;;
  esac
done

if [ "$has_c_flag" = true ]; then
  if [ "$is_c_file" = true ]; then
    args=""
    for arg in "$@"; do
      case "$arg" in
        -std=gnu++17|-std=gnu++14|-std=gnu++11|-fno-rtti) ;;
        *) args="$args $arg" ;;
      esac
    done
    exec zig c++ -target "$ZIG_TARGET" -x c++ -I"$ZIG_LIBCXX" $args
  else
    exec zig c++ -target "$ZIG_TARGET" -I"$ZIG_LIBCXX" "$@"
  fi
else

  exec zig cc -target "$ZIG_TARGET" -lc++ "$@"
fi
