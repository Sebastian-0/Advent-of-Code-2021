
# Compile & run with: gcc -no-pie test.s && ./a.out

# Function args: RDI, RSI, RDX, RCX, R8, R9 
# Function returns: RAX and RDX
# Untouched vars: RBX, RSP, RBP, and R12–R15

# -fPIE / PIE: https://stackoverflow.com/questions/2463150/what-is-the-fpie-option-for-position-independent-executables-in-gcc-and-ld

# Stack pointer must be 16-byte aligned in x64 Linux, call pushes 8 bytes so make sure to be off by 8 when calling

.global main

.section .rodata   
input_format:
    .asciz "%10s %d"
output_format:
    .asciz "Depth * position = %d\n"

.section .data
number_buffer:
    .long 0
direction_buffer:
    .zero 11
    
.section .text
main:
    sub $8, %rsp # 16-byte align
    push %r12 # Save registers that we modify
    push %r13
    
    mov $0, %r12 # depth
    mov $0, %r13 # position
    
loop:
    call read_command
    cmp $2, %rax 
    jne print_result
    
    cmpb $'u, direction_buffer
    je go_up
    cmpb $'d, direction_buffer
    je go_down
    cmpb $'f, direction_buffer
    je go_forward
    jmp loop
    
go_up:
    sub number_buffer, %r12
    jmp loop
go_down:
    add number_buffer, %r12
    jmp loop
go_forward:
    add number_buffer, %r13
    jmp loop
    
print_result:
    mov $output_format, %rdi
    mov %r12, %rsi
    imul %r13, %rsi
    mov $0, %rax
    call printf
    jmp exit
    
exit:
    pop %r13 # Restore registers we have modified
    pop %r12
    add $8, %rsp # Revert alignment
    
    mov $0, %rax # Return code
    ret
    
    
# Functions    
#-----------
read_command:
    sub $8, %rsp # 16-byte align
    
    mov $input_format, %rdi
    mov $direction_buffer, %rsi
    mov $number_buffer, %rdx
    mov $0, %rax
    call scanf
    
    add $8, %rsp # Restore alignment
    ret
