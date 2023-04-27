.data
i: .word 0
z: .word 2

.text
lw a0, i
lw a1 ,z

#for loop
li t0, 20
loop:
addi a1,a1,1
addi,a0,a0,2
ble a0,t0,loop

# do while loop
li t0, 100
loop2:
addi a1,a1,1
#while less than, loop
blt a1, t0, loop2

#while loop
li t0, 0
loop3:
#skip if while condition not met
ble a0,t0,loop3end
addi a1,a1,-1
addi,a0,a0,-1
j loop3
loop3end:

sw a0,i,t1
sw a1,z,t1

li a7, 10	
ecall


