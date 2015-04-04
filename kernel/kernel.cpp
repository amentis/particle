#define LINES 25
#define COLUMNS_IN_LINE 80
#define BYTES_FOR_EACH_ELEMENT 2
#define SCREENSIZE BYTES_FOR_EACH_ELEMENT * COLUMNS_IN_LINE * LINES

extern unsigned int cursor_position;
char *video_memory_start = (char*)0xb8000;

extern void kb_init();
extern void idt_init();

void clear_screen(){
    unsigned int i = 0;
    while (i < SCREENSIZE) {
        video_memory_start[i++] = ' ';
        		video_memory_start[i++] = 0xff;
    }
}

void kprint(const char *str){
    unsigned int i = 0;
    while (str[i] != '\0') {
        video_memory_start[cursor_position++] = str[i++];
        video_memory_start[cursor_position++] = 0xf0;
    }
}

void kprint_newline(){
    unsigned int line_size = BYTES_FOR_EACH_ELEMENT * COLUMNS_IN_LINE;
    cursor_position = cursor_position + (line_size - cursor_position % (line_size));
}

extern "C"
void kmain(){
    const char *str = "Particle";
    clear_screen();
    kprint(str);
    kprint_newline();
    kprint_newline();
    
    idt_init();
    kb_init();
    
    while(1);
}
