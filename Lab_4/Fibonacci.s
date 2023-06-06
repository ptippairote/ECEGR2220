.data

intA: .word 3
intB: .word 10
intC: .word 20


.text
lw a0, intA #fib(intA) ans in s9
jal Fib
mv s9,a0
lw a0, intB #fib(intB) ans in s10
jal Fib
mv s10,a0
lw a0, intC #fib(intC) ans in s11
jal Fib
mv s11,a0

li a7, 10
ecall


Fib: #pass int n in a0
addi sp,sp, -12 #save s regs to stack
sw s0,0(sp)
sw s1, 4(sp) 
sw ra, 8(sp)
mv s0, a0 #put n in s0
li t0, 0
bgt s0, t0, Fib0 # value = 0 if n = 0
li a0, 0 # 
j endFib #
Fib0:
addi t0,t0,1 
bgt s0, t0, Fib1 # value = 1 if n = 1
li a0, 1 #
j endFib #
Fib1:
addi a0,s0,-1 #n-1 then call function
jal Fib
mv s1,a0 #put result into s1
addi a0,s0,-2 #n-2 then call fib
jal Fib
add a0,a0,s1 #fib(n-1)+fib(n-2)
endFib:
lw s0, 0(sp) #restore regs
lw s1, 4(sp)
lw ra, 8(sp)
addi sp,sp, 12
jr ra #return