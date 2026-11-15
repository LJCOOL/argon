/* Replaces zig compiler-rt's weak aarch64 __clear_cache, which omits the
 * dsb ish between its ic ivau loop and isb. Without it the invalidation may
 * not complete before JIT output runs, so dynarec cores execute stale code.
 * The zig wrappers link this into every aarch64 shared library. */
#include <stdint.h>

void __clear_cache(void *start, void *end)
{
  uint64_t ctr, addr, line;

  __asm__ volatile("mrs %0, ctr_el0" : "=r"(ctr));
  /* CTR_EL0.IDC: data cache clean to PoU not required. */
  if (!((ctr >> 28) & 1)) {
    line = 4ull << ((ctr >> 16) & 15);
    for (addr = (uint64_t)start & ~(line - 1); addr < (uint64_t)end; addr += line)
      __asm__ volatile("dc cvau, %0" : : "r"(addr) : "memory");
  }
  __asm__ volatile("dsb ish" : : : "memory");
  /* CTR_EL0.DIC: instruction cache invalidation to PoU not required. */
  if (!((ctr >> 29) & 1)) {
    line = 4ull << (ctr & 15);
    for (addr = (uint64_t)start & ~(line - 1); addr < (uint64_t)end; addr += line)
      __asm__ volatile("ic ivau, %0" : : "r"(addr) : "memory");
    __asm__ volatile("dsb ish" : : : "memory");
  }
  __asm__ volatile("isb" : : : "memory");
}
