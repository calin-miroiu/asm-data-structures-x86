#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int custom_printf(const char *format, ...);

struct vector {
    int *arr;
    int len;
    int cap;
};

extern struct vector* new_vector(int cap);
extern int push_element(struct vector *vec, int elem);
extern void print_vector(struct vector *vec);
extern void free_vector(struct vector **vec);
extern void switch_cases(char *src, char *dest);
extern void heavy(int number);


int main() {
    printf("=== 1. Testing Custom Printf (custom_printf.asm) ===\n");
    my_printf("Hello %s, the magic number is %lu%c\n", "GitHub User", 42, '!');
    printf("\n");

    printf("=== 2. Testing Dynamic Vector (vector.asm) ===\n");
    struct vector *vec = new_vector(2);
    
    push_element(vec, 10);
    push_element(vec, 20);
    push_element(vec, 30);
    
    print_vector(vec);
    
    free_vector(&vec);
    printf("\n");

    printf("=== 3. Testing String Case Switch (utils.asm) ===\n");
    char src[] = "AsSeMbLy Is AwEsOmE!";
    char dest[50] = {0};
    
    switch_cases(src, dest);
    
    printf("Original: %s\n", src);
    printf("Switched: %s\n", dest);
    printf("\n");

    printf("=== 4. Testing Heavy Number Logic (utils.asm) ===\n");
    printf("Testing with 100: \n");
    heavy(100); 
    
    printf("Testing with -2: \n");
    heavy(-2);

    return 0;
}