.data
A: .word 15
B: .word 15
C: .word 10
Z: .word 0

.text
lw a0, A
lw a1, B
lw a2, C
lw a3, Z

#if else statements
blt a0, a1, if1LessThan
j if2
if1LessThan:
li t0,5
bgt a2, t0, if1True
j if2
if1True:
li t2,1
j switch

if2:
bgt a0,a1, if2True
li t0,1
li t1,7
add t0, t0, a2
beq t0,t1,if2True
li t2,3
j switch
if2True:
li t2,2

#switch statement
switch:
li t0,1
beq t2, t0, case1
li t0,2
beq t2, t0, case2
li t0,3
beq t2, t0, case3
li t0,0
sw t0,Z,t1
j end

case1:
li t0,-1
j end
case2:
li t0,-2
j end
case3:
li t0,-3


end:
sw t0,Z,t1
li a7, 10	
ecall
