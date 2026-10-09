.PHONY: all build clean

all: build

build:
	nasm -f elf64 src/vector.asm -o vector.o
	nasm -f elf64 src/custom_printf.asm -o custom_printf.o
	nasm -f elf64 src/rpn_evaluator.asm -o rpn_evaluator.o
	nasm -f elf64 src/langford.asm -o langford.o
	nasm -f elf64 src/utils.asm -o utils.o

clean:
	rm -f *.o