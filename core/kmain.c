#include "vga/terminal.h"

static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;

void kernel_main(void) {
	terminal_initialize(VGA_WIDTH, VGA_HEIGHT);

	terminal_writestring("Particle\n\n");
}
