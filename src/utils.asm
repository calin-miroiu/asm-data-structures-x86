extern printf
section .note.GNU-stack

section .data
    msg_heavy db "The number is heavy", 10, 0
    msg_not_heavy db "The number is not heavy", 10, 0
    fmt db "%d", 10, 0

section .text
    global ave
    global switch_cases
    global heavy
    global flat_matrix

ave:
    push rbp
    mov rbp, rsp
    push r15
    push r14

    mov r15d, edx
    ; Initialize counter to 0
    mov rcx, 0

ave_loop:
    xor rax, rax
    mov al, byte [rdi + rcx]
    
    ; End of string check
    cmp rax, 0
    je end_ave

    sub eax, 'A'
    add eax, r15d
    
    ; Check if sum is positive
    cmp eax, 0
    jge is_positive

    ; Set sign bits for negative
    mov edx, -1
    jmp do_modulo

is_positive:
    ; Set sign bits for positive
    mov edx, 0

do_modulo:
    ; Apply mathematical formula
    mov r14d, 31
    idiv r14d
    add edx, 'A'

    mov byte [rsi + rcx], dl
    inc rcx
    jmp ave_loop

end_ave:
    ; Append string terminator
    mov byte [rsi + rcx], 0
    pop r14
    pop r15
    leave
    ret

switch_cases:
    push rbp
    mov rbp, rsp
    ; Initialize counter to 0
    mov rcx, 0

switch_loop:
    mov al, byte [rdi + rcx]
    ; String terminator
    cmp al, 0
    je end_switch

    cmp al, 'A'
    jl check_lowercase
    cmp al, 'Z'
    jg check_lowercase

    ; Convert uppercase to lowercase
    add al, 32
    jmp store_char

check_lowercase:
    cmp al, 'a'
    jl store_char
    cmp al, 'z'
    jg store_char

    ; Convert lowercase to uppercase
    sub al, 32

store_char:
    mov byte [rsi + rcx], al
    inc rcx
    jmp switch_loop

end_switch:
    ; String terminator
    mov byte [rsi + rcx], 0
    leave
    ret

heavy:
    push rbp
    mov rbp, rsp

    ; Check if number is negative
    cmp edi, 0
    jge not_heavy

    mov eax, edi
    ; 16-bit shift to isolate upper half
    shr eax, 16

    ; Bit swapping
    mov cl, ah
    mov ah, al
    mov al, cl

    ; Value comparison
    cmp eax, 255
    jle not_heavy

    mov rdi, msg_heavy
    xor rax, rax
    call printf
    jmp end_heavy

not_heavy:
    mov rdi, msg_not_heavy
    xor rax, rax
    call printf

end_heavy:
    leave
    ret

flat_matrix:
    push rbp
    mov rbp, rsp

    push r12
    push r13
    push r14
    push r15

    mov r15, rdi
    mov r13d, esi
    
    ; Initialize i
    mov r14, 0

loop_i:
    cmp r14, r13
    jge end_flat

    mov rcx, r14
    mov r8d, dword [r15+ rcx * 4]
    
    ; Initialize j
    mov r12, 0

loop_j:
    cmp r12, r13
    jge print_max
    
    mov eax, dword [r15 + rcx * 4]
    cmp eax, r8d
    jle skip_update
    mov r8d, eax

skip_update:
    add rcx, r13
    inc r12
    jmp loop_j

print_max:
    mov rdi, fmt
    mov esi, r8d
    xor rax, rax
    call printf

    inc r14
    jmp loop_i

end_flat:
    pop r15
    pop r14
    pop r13
    pop r12
    leave
    ret