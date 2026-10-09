## x86_64 Assembly Toolkit
# What it does
Implements a collection of low-level algorithms and data structures entirely in x86_64 assembly language (NASM). The program uses a C wrapper to test and demonstrate the assembly modules.
The core architecture features:   Modular design: Separated into individual assembly files for specific operations, alongside main.c for testing.   Memory safety: The dynamic vector utilizes explicit memory management (malloc, realloc, free) to automatically scale capacity and prevent leaks upon termination. 

## Core Operations & Logic
- DYNAMIC_VECTOR: Allocates a resizable array. Supports pushing elements with capacity doubling, popping elements with capacity halving, and safe memory freeing.
- CUSTOM_PRINTF: Parses variadic stack arguments to print characters (%c), base-10 integers (%l), and strings (%s) directly to the standard output.
- RPN_EVALUATOR: Reads standard input to process and calculate mathematical expressions written in Reverse Polish Notation using basic operators (+, -, *, /).
- LANGFORD_CHECK: Validates whether a given array of integers forms a correct Langford sequence through iterative array traversal.
- UTILITIES: Includes helper algorithms to swap string cases, identify heavy numbers using bitwise shifts, and process maximums in flattened matrices.

# Usage
A Makefile is provided for automated assembly compilation.
To assemble the object files:
```
make build
```
To compile and link the executable with GCC:
```
gcc main.c vector.o custom_printf.o rpn_evaluator.o langford.o utils.o -no-pie -o main
```
Execute the binary:
```
./main
```
Execute the binary:
```
make clean
```
# Requirements:
- NASM (Netwide Assembler)
- GCC (GNU Compiler Collection)
- GNU Make
