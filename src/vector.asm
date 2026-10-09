extern malloc
extern printf
extern realloc
extern free

section .note.GNU-stack

section .data
    err_len db "Error: len <= %d", 10, 0
    err_empty db "The vector is empty", 10, 0
    print_start db "v -> {(", 0
    print_elem  db "[%d]", 0
    print_empty db "[]", 0
    print_end   db "), %d, %d}", 10, 0

section .text
    global new_vector
    global set_element
    global get_element
    global push_element
    global pop_element
    global print_vector
    global free_vector

new_vector:
    push rbp
    mov rbp, rsp
    push r15
    push rbx

    mov ebx, edi
    ; Allocate 16 bytes for the vector struct
    mov rdi, 16
    call malloc
    mov r15, rax

    mov edi, ebx
    ; Multiply by 4 (sizeof int)
    shl rdi, 2
    call malloc

    mov qword [r15], rax
    ; Initialize len (offset 8) to 0
    mov dword [r15 + 8], 0
    ; Initialize capacity (offset 12)
    mov dword [r15 + 12], ebx
    mov rax, r15

    pop rbx
    pop r15
    leave
    ret

set_element:
    push rbp
    mov rbp, rsp
    push rbx
    push r15

    mov rbx, rdi
    ; len
    mov ecx, [rbx + 8]
    cmp edx, ecx
    jb skip_error_set

    mov esi, edx
    lea rdi, [rel err_len]
    xor rax, rax
    call printf
    ; Error code
    mov rax, -1
    pop r15
    pop rbx
    leave
    ret

skip_error_set:
    mov rcx, qword [rbx]
    mov eax, edx
    mov dword [rcx + rax * 4], esi
    mov eax, edx

    pop r15
    pop rbx
    leave
    ret

get_element:
    push rbp
    mov rbp, rsp
    push rbx
    push r15

    mov rbx, rdi
    ; len
    mov ecx, [rbx + 8]
    cmp esi, ecx
    jb skip_error_get

    lea rdi, [rel err_len]
    xor rax, rax
    call printf
    ; Error code
    mov rax, -1
    pop r15
    pop rbx
    leave
    ret

skip_error_get:
    mov rcx, [rbx]
    mov eax, esi
    mov eax, [rcx + rax * 4]
    
    pop r15
    pop rbx
    leave
    ret

push_element:
    push rbp
    mov rbp, rsp
    push r15
    push rbx

    mov ebx, esi
    mov r15, rdi
    
    ; len and capacity
    mov ecx, [r15 + 8]
    mov edx, [r15 + 12]
    cmp ecx, edx
    jl skip_realloc_push

    ; Double the capacity
    shl edx, 1
    jnz capacity_ok
    ; Default starting capacity if 0
    mov edx, 1

capacity_ok:
    mov [r15 + 12], edx
    mov rdi, [r15]
    xor rsi, rsi
    mov esi, edx
    ; Multiply by sizeof(int)
    shl rsi, 2
    call realloc

    mov [r15], rax

skip_realloc_push:
    xor rdx, rdx
    mov edx, [r15 + 8]
    mov rcx, [r15]
    mov [rcx + rdx * 4], ebx
    mov eax, edx
    ; Increment len
    inc dword [r15 + 8]

    pop rbx
    pop r15
    leave
    ret

pop_element:
    push rbp
    mov rbp, rsp
    push r15
    push rbx

    mov r15, rdi
    mov ecx, [r15 + 8]
    
    ; Check if vector is empty
    cmp ecx, 0
    jg has_elements

    lea rdi, [rel err_empty]
    xor rax, rax
    call printf

    ; Error code
    mov eax, -1
    pop rbx
    pop r15
    leave
    ret

has_elements:
    xor rcx, rcx
    mov ecx, [r15 + 8]
    dec ecx
    mov [r15 + 8], ecx

    mov rdi, [r15]
    mov ebx, [rdi + rcx * 4]
    xor rdx, rdx
    mov edx, [r15 + 12]
    
    ; Check if it's the first element
    cmp edx, 1
    jle skip_realloc_pop

    mov rax, rcx
    shl rax, 1
    cmp rax, rdx
    jg skip_realloc_pop

    ; Halve the capacity
    shr edx, 1
    mov [r15 + 12], edx
    mov rdi, [r15]
    xor rsi, rsi
    mov esi, edx
    shl rsi, 2

    call realloc
    mov [r15], rax

skip_realloc_pop:
    mov rax, rbx
    pop rbx
    pop r15
    leave
    ret

print_vector:
    push rbp
    mov rbp, rsp
    push rbx
    push r14
    push r13
    push r12

    mov rbx, rdi
    mov r13d, [rbx + 8]
    mov r14d, [rbx + 12]
    
    lea rdi, [rel print_start]
    xor rax, rax
    call printf

    xor r12, r12

print_elements_loop:
    cmp r12d, r13d
    jge print_empty_loop
    lea rdi, [rel print_elem]
    mov rcx, [rbx]
    mov esi, [rcx + r12 * 4]
    xor rax, rax
    call printf

    inc r12
    jmp print_elements_loop

print_empty_loop:
    cmp r12d, r14d
    jge print_footer
    lea rdi, [rel print_empty]
    xor rax, rax
    call printf

    inc r12
    jmp print_empty_loop

print_footer:
    lea rdi, [rel print_end]
    mov esi, r13d
    mov edx, r14d
    xor rax, rax
    call printf

    pop r12
    pop r13
    pop r14
    pop rbx
    leave
    ret

free_vector:
    push rbp
    mov rbp, rsp
    push rbx
    push r15

    mov rbx, rdi
    ; Check if NULL
    cmp rbx, 0
    je end_free

    mov r15, [rbx]
    cmp r15, 0
    je end_free

    mov rdi, [r15]
    call free

    mov rdi, r15
    call free

    ; Set to NULL
    mov qword [rbx], 0

end_free:
    pop r15
    pop rbx
    leave
    ret
