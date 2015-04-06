ODIR = obj
BDIR = build
ASM = nasm
ASMFLAGS = -f elf32
CX = g++
CC = gcc
CFLAGS = -m32 -c
CXFLAGS = $(CFLAGS)
LFLAGS = -m elf_i386 -T link.ld
DEBUG = -g

make:
	mkdir -p $(ODIR)
	mkdir -p $(BDIR) 
	#kernel
	$(ASM) $(ASMFLAGS) kernel/kernel.asm -o $(ODIR)/kasm.o
	$(CX) $(CXFLAGS) kernel/kernel.cpp -o $(ODIR)/kc.o
	
	#keyboard
	$(ASM) $(ASMFLAGS) keyboard/keyboard.asm -o $(ODIR)/keyasm.o
	$(CC) $(CFLAGS) keyboard/keyboard.c -I keyboard -o $(ODIR)/keyc.o
	
	#link
	ld $(LFLAGS) $(ODIR)/kc.o $(ODIR)/keyasm.o $(ODIR)/keyc.o $(ODIR)/kasm.o -o $(BDIR)/particle

clean:
	rm -rf $(BDIR)/particle $(ODIR)/*.o $(BDIR) $(ODIR)
