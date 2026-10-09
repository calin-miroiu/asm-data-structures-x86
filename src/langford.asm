section .note.GNU-stack

section .text
    global check_langford
    global generate_langford_sequences

check_langford:
    push rbp
    mov rbp, rsp

    ; Array address
    mov r10, rdi
    ; Length
    mov r11, rsi
    mov r12, r11
    
    ; Bitwise check for odd/even
    and r12, 1
    cmp r12, 1
    je is_false

    ; Initialize outer counter
    mov rcx, 0

outer_loop:
    cmp rcx, r11
    jge is_true
    
    ; Initialize inner counter
    mov r15, 0

inner_loop:
    cmp r15, rcx
    jge check_first

    mov eax, dword [r10 + 4 * r15]
    cmp eax, dword [r10 + 4 * rcx]
    je check_second

    inc r15
    jmp inner_loop

check_first:
    mov r13, rcx
    inc r13

    mov eax, dword [r10 + 4 * rcx]
    add r13, rax
    cmp r13, r11
    jge is_false

    mov r14d, dword [r10 + 4 * r13]
    cmp r14d, eax
    jne is_false
    jmp is_valid

check_second:
    mov r13, r15
    inc r13
    add r13, rax
    cmp r13, rcx
    jne is_false
    jmp is_valid

is_valid:
    inc rcx
    jmp outer_loop

is_true:
    mov rax, 1
    leave
    ret

is_false:
    mov rax, 0
    leave
    ret

generate_langford_sequences:
    push rbp
    mov rbp, rsp
    xor rax, rax
    ; Unimplemented stub
    leave
    ret