#ifndef K_VGA_TERMINAL_H
#define K_VGA_TERMINAL_H

#include <stddef.h>
#include <stdint.h>

void terminal_initialize(const size_t, const size_t);

void terminal_setcolor(uint8_t);

void terminal_write(const char*, size_t);

void terminal_writestring(const char*);

#endif
