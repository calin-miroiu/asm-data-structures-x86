extern scanf
extern printf
extern atol
section .note.GNU-stack

section .data
    format db "%s", 0
    format_out db "%ld", 10, 0

section .bss
    ; Buffer size
    buffer resb 64

section .text
    global reverse_polish_notation

reverse_polish_notation:
    push rbp
    mov rbp, rsp
    xor rax, rax
    
    push r12

read_loop:
    lea rdi, [rel format]
    lea rsi, [rel buffer] 
    xor rax, rax

    mov r12, rsp
    ; Align stack to 16 bytes
    and rsp, -16
    call scanf
    mov rsp, r12
    
    ; End of file check
    cmp eax, 0
    jle end_rpn

    ; Operand type check
    cmp byte [rel buffer], '+'
    je do_add
    cmp byte [rel buffer], '*'
    je do_mul
    cmp byte [rel buffer], '/'
    je do_div
    cmp byte [rel buffer], '-'
    jne parse_number
    
    ; Check if '-' is an operator or number sign
    cmp byte [rel buffer + 1], 0
    je do_sub

parse_number:
    lea rdi, [rel buffer]

    mov r12, rsp
    ; Align stack to 16 bytes
    and rsp, -16

    call atol
    mov rsp, r12
    push rax
    jmp read_loop

do_sub:
    pop rcx
    pop rax
    sub rax, rcx
    push rax
    jmp read_loop

do_add:
    pop rcx
    pop rax
    add rax, rcx
    push rax
    jmp read_loop

do_mul:
    pop rcx
    pop rax
    imul rax, rcx
    push rax
    jmp read_loop

do_div:
    pop rcx
    pop rax
    ; Check if dividend is negative
    cmp rax, 0
    jl is_negative
    
    ; Clear rdx
    mov rdx, 0
    jmp perform_div

is_negative:
    ; Set sign bits for negative
    mov rdx, -1

perform_div:
    idiv rcx
    push rax
    jmp read_loop

end_rpn:
    pop rsi
    lea rdi, [rel format_out]
    xor rax, rax
    
    mov r12, rsp
    ; Align stack to 16 bytes
    and rsp, -16

    call printf
    mov rsp, r12
    
    ; Stack index for r12
    mov r12, [rbp - 8]
    leave
    ret