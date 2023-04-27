.data
A: .word 0
B: .word 0
C: .word 0

.text
li t0,5
li t1,10

add a0,zero,t0
jal AddItUp
add s0,zero,a0
add a0,zero,t1
jal AddItUp
add s1,zero,a0
add s2,s0,s1

sw s0,A,t0
sw s1,B,t0
sw s2,C,t0

li a7, 10	
ecall


AddItUp:
addi sp,sp,-8
sw t0, 0(sp)
sw t1, 4(sp)


li t0, 0
li t1, 0
loop:

add, t1,t1,t0
addi t1,t1,1

addi t0,t0,1
blt t0,a0,loop

add a0,zero,t1

lw t0, 0(sp)
lw t1, 4(sp)
addi sp,sp,8
jr ra