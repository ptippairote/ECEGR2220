.data
dataA: .word 0x01234567
addtestval: .word 0x11223344
subtestval: .word 0x00123456
andtestval: .word 0x01244567
ortestval: .word 0x96969696
shifttestval: .word 0x00000001
newline: .asciz " \n"

.text
addtest:
lw t0,dataA
lw t1, addtestval
add a0, t0, t1
jal printhex

additest:
lw t0,dataA
addi, a0, t0, 96
jal printhex

subtest:
lw t0,dataA
lw t1, subtestval
sub a0, t0, t1
jal printhex

zerotest:
lw t0, dataA
sub a0,t0,t0
jal printhex

andtest:
lw t0,dataA
lw t1, andtestval
and a0, t0, t1
jal printhex

anditest:
lw t0,dataA
andi a0, t0, 96
jal printhex

ortest:
lw t0,dataA
lw t1, ortestval
or a0, t0, t1
jal printhex

oritest:
lw t0,dataA
ori a0, t0, 96
jal printhex

slltest:
lw t0,dataA
lw t1, shifttestval
sll a0, t0, t1
jal printhex

sllitest:
lw t0,dataA
slli a0, t0, 3
jal printhex

srltest:
lw t0,dataA
lw t1, shifttestval
srl a0, t0, t1
jal printhex

srlitest:
lw t0,dataA
srli a0, t0, 3
jal printhex



li a7, 10
ecall

printhex:
li a7, 34
ecall
la a0, newline
li a7, 4
ecall
ret