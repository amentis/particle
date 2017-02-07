ODIR = obj
BDIR = build
ASM = ./particle-cc/bin/i686-elf-as
CC = ./particle-cc/bin/i686-elf-gcc
CFLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra -I ./include -c
LINKER = ./particle-cc/bin/i686-elf-gcc
LFLAGS = -ffreestanding -O2 -nostdlib
DEBUG = -g

OBJS = $(ODIR)/boot.o $(ODIR)/kmain.o $(ODIR)/terminal.o $(ODIR)/vga.o \
$(ODIR)/string.o
CRTI_OBJ=$(ODIR)/ctri.o
CRTBEGIN_OBJ:=$(shell $(CC) $(CFLAGS) -print-file-name=crtbegin.o)
CRTEND_OBJ:=$(shell $(CC) $(CFLAGS) -print-file-name=crtend.o)
CRTN_OBJ=$(ODIR)/ctrn.o
OBJ_LINK_LIST:=$(CRTI_OBJ) $(CRTBEGIN_OBJ) $(OBJS) $(CRTEND_OBJ) $(CRTN_OBJ)

make:
	mkdir -p $(ODIR)
	mkdir -p $(BDIR)

	#core
	$(ASM) core/ctri.s -o $(ODIR)/ctri.o
	$(ASM) core/ctrn.s -o $(ODIR)/ctrn.o
	$(ASM) core/boot.s -o $(ODIR)/boot.o
	$(CC) $(CFLAGS) core/kmain.c -o $(ODIR)/kmain.o

	#vga
	$(CC) $(CFLAGS) vga/terminal.c -o $(ODIR)/terminal.o
	$(CC) $(CFLAGS) vga/vga.c -o $(ODIR)/vga.o

	#clib
	$(CC) $(CFLAGS) clib/string.c -o $(ODIR)/string.o

	#link
	$(LINKER) $(LFLAGS) -T linker.ld -o $(BDIR)/particle $(LFLAGS) \
	$(OBJ_LINK_LIST) -lgcc

clean:
	rm -rf $(BDIR)/particle $(ODIR)/*.o $(BDIR) $(ODIR)
