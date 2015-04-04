ODIR = obj
ASM = nasm
ASMFLAGS = -f elf32
CC = g++
CFLAGS = -m32 -c
LFLAGS = -m elf_i386 -T link.ld
DEBUG = -g

make:
	mkdir -p $(ODIR) 
	#kernel
	$(ASM) $(ASMFLAGS) kernel/kernel.asm -o $(ODIR)/kasm.o
	$(CC) $(CFLAGS) kernel/kernel.cpp -o $(ODIR)/kc.o
	
	#keyboard
	$(ASM) $(ASMFLAGS) keyboard/keyboard.asm -o $(ODIR)/keyasm.o
	$(CC) $(CFLAGS) keyboard/keyboard.cpp -I keyboard -o $(ODIR)/keyc.o
	
	#link
	ld $(LFLAGS) $(ODIR)/keyasm.o $(ODIR)/keyc.o $(ODIR)/kasm.o $(ODIR)/kc.o -o particle

clean:
	rm -f particle $(ODIR)/*.o
