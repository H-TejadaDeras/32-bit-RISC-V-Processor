# Misc. Instructions (lui, auipc, jal, jalr) Test Program
# Available Instructions: All except ecall, ebreak, csrrw, csrrs, csrrc, 
# csrrwi, csrrsi, csrrci
# Program makes use of tester_dmem.hex
# Henry Tejada Deras - 11-27-2025
add x2, x0, x0 # Set stack pointer
lw x5, 0(x2) # 01234567 -> x5
lw x6, 4(x2) # 76543210 -> x6
lw x28, 44(x2) # 00000010 -> x28
auipc x8, 16 # Move 4 Instructions down
addi x9, x9, 10 # 61A80 -> 61A90
addi x9, x9, 1 # 61A90 -> 61A91
jal x10, 8 # Move 2 instructions down
lui x9, 400000
jalr x10, -16(x28) # Move 4 instructions up
addi x9, x9, 1 # 61A91 -> 61A92