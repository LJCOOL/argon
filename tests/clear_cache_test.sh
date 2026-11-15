#!/bin/sh
# Checks that aarch64 cores linked through the zig wrappers carry the
# barriered __clear_cache, not zig compiler-rt's, which omits the dsb after
# its ic loop and lets JIT cores run stale instructions.
set -eu

root=$(cd "$(dirname "$0")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

fail() { echo "FAIL: $*"; exit 1; }

cat > "$tmp/jit.c" <<'EOF'
void flush(char *start, char *end) { __builtin___clear_cache(start, end); }
EOF

# Prints the __clear_cache address unless compiler-rt's copy sits at it.
own_clear_cache() {
    syms=$(nm "$1")
    addr=$(echo "$syms" | awk '$3 == "__clear_cache" { print $1 }')
    [ -n "$addr" ] || return 1
    echo "$syms" | awk -v a="$addr" '$1 == a && $3 ~ /^compiler_rt\./ { found = 1 } END { exit found ? 1 : 0 }'
}

for wrapper in zig-cc-wrapper.sh zig-cxx-wrapper.sh; do
    "$root/cores/$wrapper" -target aarch64-linux-gnu.2.17.0 -fPIC -c -o "$tmp/jit.o" "$tmp/jit.c"
    "$root/cores/$wrapper" -target aarch64-linux-gnu.2.17.0 -fPIC -shared -o "$tmp/jit.so" "$tmp/jit.o"
    own_clear_cache "$tmp/jit.so" || fail "$wrapper: aarch64 core uses compiler-rt __clear_cache"

    "$root/cores/$wrapper" -target arm-linux-gnueabihf.2.17.0 -fPIC -c -o "$tmp/jit32.o" "$tmp/jit.c"
    "$root/cores/$wrapper" -target arm-linux-gnueabihf.2.17.0 -fPIC -shared -o "$tmp/jit32.so" "$tmp/jit32.o"
    ! own_clear_cache "$tmp/jit32.so" || fail "$wrapper: armv7 core gained the aarch64 __clear_cache"
done

echo "clear_cache tests passed"
