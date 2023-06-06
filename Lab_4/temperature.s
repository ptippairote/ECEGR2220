.data
fahrenheit: .float 69.0
thirtytwo: .float 32.0
five: .float 5.0
nine: .float 9.0
kelvinValue: .float 273.15
fString:	.asciz	"Fahreneit to convert: \n"
cString: .asciz "Celcius: "
kString: .asciz "\nKelvin: "
doubleline: .asciz "\n\n"

.text
main:
li a7, 4
la a0, fString
ecall
#flw fa0, fahrenheit, t0
#li a7, 2
#ecall
li a7, 6
ecall
#convert to C
jal Convert
#print Celsius
li a7, 4
la a0, cString
ecall
li a7, 2
ecall

#convert to K
jal Kelvin
#print Kelvin
li a7, 4
la a0, kString
ecall
li a7, 2
ecall

li a7, 4
la a0, doubleline
ecall
j main #repeat


Convert:
fmv.s ft0,fa0
flw ft1, thirtytwo, t0
fsub.s ft0, ft0, ft1 # Fahrenheit - 32
flw  ft1, five, t0
fmul.s ft0,ft0,ft1 # * 5
flw ft1, nine t0
fdiv.s fa0,ft0,ft1 # / 9 = Celsius
jr ra

Kelvin: 
flw ft1, kelvinValue, t0
fadd.s fa0,fa0,ft1 # K = C + 273.15
jr ra