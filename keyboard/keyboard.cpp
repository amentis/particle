#include "keyboard_map.h"

#define KEYBOARD_DATA_PORT 0x60
#define KEYBOARD_STATUS_PORT 0x64
#define IDT_SIZE 256
#define INTERRUPT_GATE 0x8e
#define KERNEL_CODE_SEGMENT_OFFSET 0x08

#define ENTER_KEY_CODE 0x1C

unsigned int cursor_position = 0;

extern void kprint_newline();
extern char *video_memory_start;
extern unsigned char keyboard_map[128];
extern unsigned long keyboard_handler();
extern char read_port(unsigned short port);
extern void write_port(unsigned short port, unsigned char data);
extern void load_idt(unsigned long *idt_ptr);

struct IDT_entry {
    unsigned short offset_lowerbits;
    unsigned short selector;
    unsigned char zero;
    unsigned char type_attr;
    unsigned short offset_higherbits;
};

struct IDT_entry IDT[IDT_SIZE];


extern "C"
void idt_init() {
    unsigned long keyboard_address;
    unsigned long idt_address;
    unsigned long idt_ptr[2];
    
    //populate IDT entry of keyboard interupts
    keyboard_address = (unsigned long) keyboard_handler();
    IDT[0x21].offset_lowerbits = keyboard_address & 0xffff;
    IDT[0x21].selector = 0x08;
    IDT[0x21].zero = 0;
    IDT[0x21].type_attr = 0x8e;
    IDT[0x21].offset_higherbits = (keyboard_address & 0xffff0000) >> 16;
    
    write_port(0x20, 0x11);
    write_port(0xA0, 0x11);
    
    write_port(0x21 , 0x20);
    write_port(0xA1 , 0x28);
    
    write_port(0x21 , 0x00);
    write_port(0xA1 , 0x00);
    
    write_port(0x21 , 0x01);
    write_port(0xA1 , 0x01);
    
    write_port(0x21 , 0xff);
    write_port(0xA1 , 0xff);
    
    idt_address = (unsigned long)IDT ;
    idt_ptr[0] = (sizeof (struct IDT_entry) * IDT_SIZE) + ((idt_address & 0xffff) << 16);
    idt_ptr[1] = idt_address >> 16 ;
    
    load_idt(idt_ptr);
}

extern "C"
void kb_init(){
    write_port(0x21 , 0xFD);
}

extern "C"
void keyboard_handler_main() {
    unsigned char status;
    char keycode;
    
    /* write EOI */
    write_port(0x20, 0x20);
    
    status = read_port(KEYBOARD_STATUS_PORT);
    /* Lowest bit of status will be set if buffer is not empty */
    if (status & 0x01) {
        keycode = read_port(KEYBOARD_DATA_PORT);
        if(keycode < 0)
            return;
        
        if(keycode == ENTER_KEY_CODE) {
            kprint_newline();
            return;
        }
        
                        video_memory_start[cursor_position++] = keyboard_map[(unsigned char) keycode];
                        video_memory_start[cursor_position++] = 0x07;
    }
}