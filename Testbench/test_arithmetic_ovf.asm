addi r1,r0,#2 ;r1=2
subi r2,r1,#1 ;r2=1 FORWARD r1
addi r3,r1,#-4 ;r3=-2 FORWARD r1
subi r4,r3,#-1 ;r4=-1 FORWARD r3
addui r5,r1,#4 ;r5=6
subui r6,r5,#3 ;r6=3 FORWARD r5
add r7,r1,r2 ;r7=3
sub r8,r5,r6 ;r8=3
addu r9,r6,r1 ;r9=5
sge r10,r1,r2 ;r10=1 [r1=2>=r2=1] ok greater-equal
sge r10,r2,r1 ;r10=0 [r1=2>=r2=1] No greater-equal
sge r10,r1,r1	; r10=1 ok, equal
sle r10,r1,r2	; r10=0 Not less-equal
sle r10,r2,r1	; r10=1 ok less-equal {106 ns}
sle r10,r1,r1	; r10=1 ok equal
sne r10,r1,r1	; r10=0 Not (not equal)-->they are equal
sne r10,r1,r2	; r10=1 Ok (not equal)
seq r10,r1,r2	; r10=0 Not equal
seq r10,r1,r1	; r10=1 ok equal
sgt r10,r2,r1	; r10=0 not greater
sgt r10,r1,r2	; r10=1 ok greater  {134 ns}
slt r10,r2,r1	; r10=1 ok smaller
slt r10,r1,r2	; r10=0 not smaller
sgeu r10,r1,r3	; r10=0 r1=2 != r3=-2 -->Unsigned r3 is greater
sgeu r10,r3,r1	; r10=1 Unsigned r3 is greater than r1
sgtu r10,r1,r3	; r10=0 Unsigned r3 is greater than r1
sgtu r10,r3,r1	; r10=1 Unsigned r3 is greater than r1
sltu r10,r3,r1	; r10=0 Unsigned r3 is greater than r1
sltu r10,r1,r3	; r10=1 Unsigned r3 is greater than r1
sgei r10,r1,#4	; r10=0 because r1=2
sgei r10,r1,#1	; r10=1 because r1=2
slei r10,r1,#0	; r10=0 because r1=2
slei r10,r1,#2	; r10=1 because r1=2 {182 ns}
snei r10,r1,#1	; r10=1 because r1=2
snei r10,r1,#2	; r10=0 because r1=2
seqi r10,r1,#0	; r10=0 because r1=2 
seqi r10,r1,#2	; r10=1 because r1=2 
sgti r10,r1,#3	; r10=0 because r1=2
sgti r10,r1,#1	; r10=1 because r1=2
slti r10,r1,#1	; r10=0 because r1=2
slti r10,r1,#3	; r10=1 because r1=2
sgeui r10,r1,#4	; r10=0 because r1=2
sgeui r10,r1,#1	; r10=1 because r1=2
sgtui r10,r1,#3	; r10=0 because r1=2
sgtui r10,r1,#1	; r10=1 because r1=2
sltui r10,r1,#1	; r10=0 because r1=2
sltui r10,r1,#3	; r10=1 because r1=2
addui r11,r0,#65535	; r11= 65535 UNSIGNED
addi r12,r0,#65535  ; r12=-1  signed 65535=FFFF=> signed==>-1
or r13,r11,r12      ; r13= -1 (ffff ffff)every bit set to "1"
ori r14,r12,#65535  ; r14= -1 (ffff ffff)every bit set to "1"
and r15,r14,r2      ; r15= 1 (r2=1)
andi r16,r14,#1     ; r16= 1 
sll r17,r16,r2      ; r17= 2  (r2=1)
slli r18,r16,#1     ; r18= 2
srl r19,r16,r2      ; r19= 0  (r2=1)
srli r20,r16,#1     ; r20= 2
sra r21,r12,r2      ; r21=-1 (r12="111...11"  r2=1)
srai r22,r12,#1     ; r21=-1 (r12="111...11")
addi r23,r0, #12    ; r23=2
xor r24,r1,r1       ; r24=0
xori r25,r1,#2      ; r25=0 (r1=2)
nop
nop
addi r1, r0, 16
addi r2, r0, 30
addi r16, r0, 1
addi r3, r0, oxffff ;r3=-1 #2003ffff
addi r4, r4, oxffff ;r4=-1 _____________________#sll r4, r3, r1 #most 16 significant bits are at '1'#00612004 
addiu r5, r4, 1 ; UNSIGNED overflow required -->oxffffffff+1 
addi r6, r4, 1 ; SIGNED overflow not required --> -1+1=0
sll r17,r16,r2 ; 010000...00 (shift r16=1 by 30 position)
addi r16, r17, 1 ;010000...01
nop
nop
nop
nop
add r31, r16, r17 ;SIGNED overflow required cout=0, r31=10000....1 (without c_out, r31 seem negative, but in reality is positive. c_out=0 is required)
sub r31, r16, r17
addi r2, r0, 1
sll r17,r16,r2 ;10000...10 (negative)
addi r16, r17, 1 ;10000...11 (negative)
add r31, r16, r17 ;SIGNED overflow required cout=1, r31=00000....101 (without c_out, r31 seems positive, but in reality should be negative. need c_out=1)
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop