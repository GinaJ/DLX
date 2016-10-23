addi r1,r0,#1   ;r1=1
addi r2,r0,#31  ;r2=32
addi r1,r1,#1   ;r1=2 [forward r1]
nop
add r3,r1,r0    ;r3=r1=2
bnez r2,#4      ;jump 4+1 instructions forward (11th line) and flush the fetch stage
subi r2,r2,#1   ;not computed-FLUSH
nop
nop
nop
addi r11, r0, #1 ;target jump
addi r12, r0, #2
addi r14, r0, #4
nop
nop
beqz r0,#9     ;jump 9+1 instructions forward (26th line)
nop            ;not computed-FLUSH
nop
nop
nop
nop
nop
nop
nop
nop
j 36          ;target jump. Jump to (36+4)/4=10 instructions forward
nop           ;not computed-FLUSH
nop
nop
nop
nop
nop
nop
nop
nop
addi r4,r0,#184 
jr r4         ;stall one cycle to forward the value of r4
nop           ;and jump to address 184/4=46 of iram 
nop           ;(which is 47th line of this file)
nop           ;and flush the next instruction
nop
nop
nop
nop
nop
nop
jal #36       ;target jump. Jump to (36+4)/4=10 instructions forward 
nop           ;and save PC+8 into R31. (R31 points to the 49th line of this file)
nop           ;the next instruction is computed
nop
nop
nop
nop
nop
nop
nop                     ;line 57, 1st time
jalr r31                ;^jump backwards to (49th line) and save PC+8 into R31
addi r3,r0,#24          ;^(R31 points to the 59th line of this file)
addi r4,r0,#4                   ;^the next instruction is computed
nop
nop                     ;^line 57, 2nd time
nop                     ;^jump to r31-->59th line while computing the next
nop                     ;^instruction (line 58)
nop
sw 4(r4), r3    ;on memory (4/4=2) write 24
lw r2, 4(r4)    ;write 24 into r2
bnez r2,#3              ;r2=24 jump 3+1 instructions forward
addi r11, r0, #1        ;^lose 2 cycle to get the value of r2 (available in MEM stage but needed in decode stage) 
addi r12, r0, #2        ;^lose one cycle to flush instruction in FETCH stage (branch taken)
addi r14, r0, #4            
addi r5,r0,#5           ;Target jump
addi r6,r0,#6
addi r7,r0,#7
sw 16(r6), r5 ; on memory ((16+6)/4-->5) write 5
lw r15, 20(r0) ; from memory(5) writes 5 into r15
nop ;############################################################################################
nop ; sw immediate(Reg_1), reg_2 --forwarding for reg_1, reg_2 can be done from 1 and 2 cycles before
nop 
addi r3,r0,#3
addi r4,r0,#4
sw 4(r4), r3 ;forward registers r4 and r3 (on memory((4+4)/4--->2) write 3) 
addi r8,r0,#8
addi r9,r0,#9
sw 4(r8), r9 ;forward registers r8 and r9 (on memory((4+8)/4--->3) write 9)
lw r19, 4(r8) ;r19 must have 9
sw 4(r0), r19 ; forward r19 (on memory ((4+0)/4--->1) write 9) 
nop ;############################################################################################
nop ;________________________________________________________________________________________
nop ;lw reg_1, immediate(reg_2)// sw immediate(Reg_1), reg_2 //stall for reg_1 because it is available after MEM stage of lw, but needed at EXE stage of sw (to compute address)
lw r13, 4(r4) ;r13 must have 3
sw 16(r13), r13 ;stall one cycle. Need the value r13 on EXE stage to compute the memory address, but it is available after the Mem stage of last instruction
nop             ; On memory((16+3)/4--->4) write 3
nop ;__________________________________________________________________________
nop
lw r29, 4(r8)  ;r29 must have 9
subi r25, r29, #4 ;Stall one cycle (r29 not yet available). r25 must have 5
nop ;r29 is available after MEM stage of lw, but needed at EXE stage of subi
nop
nop
addi r2,r0,#2
lw r24, 8(r2) ;forward r2.  from mem((8+2)/4--->2) writes 3 into r24
addi r1,r0,#1
addi r24, r24, #1
lw r23, 8(r1) ;forward r1.  from mem((8+1)/4--->1) writes 3 into r23
nop
nop   ;overall
nop   ;mem(5) = 5
nop   ;mem(4) = 3
nop   ;mem(3) = 9
nop   ;mem(2) = 3 
nop   ;mem(1) = 9
nop   ;
nop   ;r1,r11 =1
nop   ;r2,r12 =2
nop   ;r3,r13, r23 =3
nop   ;r4,r14, r24 =4
nop   ;r5,r15, r25 =5
nop   ;r6 = 6
nop   ;r7 = 7
nop   ;r8 = 8
nop   ;r9, r19, r29 = 9
nop
nop
nop
nop
nop
nop
nop