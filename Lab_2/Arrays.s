.data
A: .word 0,0,0,0,0
B: .word 1,2,4,8,16

.text
# i 
li t6, 0

li t0 5
loop:
#find byte offset
li t2,4
mul t3,t6,t2
#A[i] memory address
la t1, A
add t1,t1,t3

#B[i] memory address
la t4, B
add t4,t4,t3
lw a0,(t4)

addi a0,a0,-1
sw a0,(t1) 

#increment i
addi t6,t6,1 
#for loop
blt t6,t0,loop

#decrement i
addi t6,t6,-1

li t1,0
loop2:
blt t6,t1,loop2end
#find byte offset
li t2,4
mul t3,t6,t2
#A[i] memory address
la t4, A
add t4,t4,t3
#B[i] memory address
la t5, B
add t5,t5,t3
lw a0, (t4)
lw a1, (t5)

# add together then *2
add a0,a0,a1
li t0,2
mul a0,a0,t0
sw a0,(t4)

# decrement i
addi t6,t6,-1
j loop2
loop2end:

li a7, 10	
ecall
