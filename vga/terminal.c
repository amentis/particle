#include "vga/terminal.h"
#include "vga/vga.h"
#include "clib/string.h"

static size_t VGA_WIDTH = 80;
static size_t VGA_HEIGHT = 25;

static size_t terminal_row;
static size_t terminal_column;
static uint8_t terminal_color;
static uint16_t* terminal_buffer;

void terminal_initialize(const size_t vga_width, const size_t vga_height) {
	VGA_WIDTH = vga_width;
	VGA_HEIGHT = vga_height;
	terminal_row = 0;
	terminal_column = 0;
	terminal_color = vga_entry_color(VGA_COLOR_BLACK, VGA_COLOR_WHITE);
	terminal_buffer = (uint16_t*) 0xB8000;
	for (register size_t y = 0; y < VGA_HEIGHT; y++) {
		for (register size_t x = 0; x < VGA_WIDTH; x++) {
			const size_t index = y * VGA_WIDTH + x;
			terminal_buffer[index] = vga_entry(' ', terminal_color);
		}
	}
}

void terminal_setcolor(uint8_t color) {
	terminal_color = color;
}

static void terminal_scroll() {
	for (terminal_row = 1; terminal_row < VGA_HEIGHT; terminal_row++) {
		for (terminal_column = 0; terminal_column < VGA_WIDTH; terminal_column++) {
			register size_t from_index = terminal_row * VGA_WIDTH + terminal_column;
			register size_t to_index = (terminal_row - 1) * VGA_WIDTH + terminal_column;
			terminal_buffer[to_index] = terminal_buffer[from_index];
		}
	}
}

static void terminal_putentryat(char c, uint8_t color, size_t x, size_t y) {
	const size_t index = y * VGA_WIDTH + x;
	terminal_buffer[index] = vga_entry(c, color);
}

static void terminal_newline(){
	if (terminal_row == VGA_HEIGHT) {
		terminal_scroll();
	} else {
		terminal_row++;
		terminal_column = 0;
	}
}

static void terminal_putchar(char c) {
	if (c == '\n'){
		terminal_newline();
		return;
	}
	terminal_putentryat(c, terminal_color, terminal_column, terminal_row);
	if (++terminal_column == VGA_WIDTH) {
		terminal_column = 0;
		if (++terminal_row == VGA_HEIGHT){
			terminal_row = 0;
		}
	}
}

void terminal_write(const char* data, size_t size) {
	for (size_t i = 0; i < size; i++)
		terminal_putchar(data[i]);
}

void terminal_writestring(const char* data) {
	terminal_write(data, strlen(data));
}
