extern putc
extern stdout
section .note.GNU-stack

section .text
    global my_printf

my_printf:
    push rbp
    mov rbp, rsp

    push rsi
    push rdx
    push rcx
    push r8
    push r9
    push r12
    push r13
    push rbx

    xor rax, rax
    mov r12, rdi
    xor r13, r13

parse_loop:
    xor r15, r15
    mov r15b, byte [r12]
    
    ; '\0' string terminator
    cmp r15, 0
    je end_printf

    cmp r15, '%'
    je format_type

    mov rdi, r15
    mov rsi, [rel stdout]
    call putc
    inc r12
    jmp parse_loop

format_type:
    inc r12
    inc r13

    xor r14, r14
    mov r14b, byte [r12]

    cmp r14, 'c'
    je handle_char
    cmp r14, 'l'
    je handle_number
    cmp r14, 's'
    je handle_string

handle_char:
    jmp check_args_count

handle_number:
    inc r12
    jmp check_args_count

handle_string:
    jmp check_args_count

check_args_count:
    ; Check if there are more than 5 arguments
    cmp r13, 5
    jg stack_arg
    cmp r13, 5
    je arg_5
    cmp r13, 4
    je arg_4
    cmp r13, 3
    je arg_3
    cmp r13, 2
    je arg_2

arg_1:
    mov rax, [rbp - 8]
    jmp choose_print

arg_2:
    mov rax, [rbp - 16]
    jmp choose_print

arg_3:
    mov rax, [rbp - 24]
    jmp choose_print

arg_4:
    mov rax, [rbp - 32]
    jmp choose_print

arg_5:
    mov rax, [rbp - 40]
    jmp choose_print

stack_arg:
    mov r11, r13
    ; Adjustment for offset calculation
    sub r11, 4
    mov rax, [rbp + r11 * 8]
    jmp choose_print

choose_print:
    cmp r14, 'c'
    je print_c
    cmp r14, 'l'
    je print_l
    cmp r14, 's'
    je print_s

print_c:
    mov rdi, rax
    mov rsi, [rel stdout]
    call putc
    inc r12
    jmp parse_loop

print_l:
    ; Base 10 division
    mov r10, 10
    ; Digit counter
    mov r11, 0
    
    cmp rax, 0
    je print_zero

extract_digits:
    cmp rax, 0
    je print_digits

    xor rdx, rdx
    div r10
    push rdx
    inc r11
    jmp extract_digits

print_digits:
    cmp r11, 0
    jle done_print

    pop rdi
    add rdi, '0'
    push r11
    push r11
    mov rsi, [rel stdout]
    call putc
    pop r11
    pop r11
    dec r11
    jmp print_digits

print_zero:
    mov rdi, '0'
    mov rsi, [rel stdout]
    call putc

done_print:
    inc r11
    inc r12
    jmp parse_loop

print_s:
    xor rdi, rdi
    mov dil, byte [rax]
    
    ; End of string check
    cmp rdi, 0
    je done_string

    push rax
    push rax
    mov rsi, [rel stdout]
    call putc
    pop rax
    pop rax
    inc rax
    jmp print_s

done_string:
    inc r12
    jmp parse_loop

end_printf:
    pop rbx
    pop r13
    pop r12
    
    ; Free 40 bytes (5 * 8)
    add rsp, 40

    xor rax, rax
    leave
    ret