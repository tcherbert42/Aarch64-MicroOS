// External functions provided by libos.a
extern void wait_msec(unsigned int msec);
extern void print_to(unsigned int row, unsigned int col, const char *msg);
extern void putc_to(unsigned int row, unsigned int col, char c);

// External assembly function prototype
extern int print_progress(unsigned int row, unsigned int column, const char *message, unsigned int percent, unsigned int width);

// Function prototypes
void boot_win(void);
int strlen(const char *s);

void boot_win(void) {
    print_to(1, 1, "+------------------------------------------------------+");
    print_to(2, 1, "|                                                      |");
    print_to(3, 1, "|  [OK] Console                                        |");
    print_to(4, 1, "|  [-]  Memory                                         |");
    print_to(5, 1, "|  [-]  Kernel                                         |");
    print_to(6, 1, "|  [-]  Interrupts                                     |");
    print_to(7, 1, "|  [-]  Processes                                      |");
    print_to(8, 1, "|                                                      |");
    print_to(9, 1, "|                                                      |");
    print_to(10, 1, "|                                                      |");
    print_to(11, 1, "+------------------------------------------------------+");
}

int strlen(const char *s) {
    int length = 0;
    while (s[length] != '\0') {
        length++;
    }
    return length;
}

int main(void) {
    boot_win();
    
    // Loop forever
    while (1) {
        // Loop from perc from 10 to 100 in steps of 10 
        for (unsigned int perc = 10; perc <= 100; perc += 10) {
            // Updated to row 9, column 4, with "Memory: " as the message
            print_progress(9, 4, "Memory: ", perc, 10);
            wait_msec(500000);
        }
    }
    
    return 0;
}
