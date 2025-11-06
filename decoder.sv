/*
 *  Instruction Decoder Module
 *  
 *  Decodes RISC-V RV32I Instructions
 *  Implemented Instructions:
 *  ...
 */
module decoder (
    input logic [31:0] instruction,
    output logic [6:0] opcode,
    output logic [4:0] rd,
    output logic [2:0] funct3,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [6:0] funct7,
    output logic [19:0] imm_i,
    output logic [11:0] imm_s,
    output logic [6:0] imm_b,
    output logic [4:0] imm_u,
    output logic [31:0] imm_j
);

    always_comb begin
        opcode <= instruction[0:6];
        case (opcode)
            0110111: begin    // lui
                imm_i <= instruction[12:31];
                rd <= instruction[7:11];
            end
            0010111: begin    // auipc
                imm_i <= instruction[12:31];
                rd <= instruction[7:11];
            end
            1101111: begin    // jal
                imm_i <= instruction[12:31];
                rd <= instruction[7:11];
            end 
            1100111: begin    // jalr
                imm_s <= instruction[20:31];
                rs1 <= instruction[15:19];
                funct3 <= instruction[12:14];
                imm_u <= instruction[7:11];
            end 
            
            1100011: begin    // beq, bne, blt, bge, bltu, bgeu
                imm_b <= instruction[31:25];
                rs2 <= instruction[20:24];
                rs1 <= instruction[15:19];
                funct3 <= instruction[12:14];
                imm_u <= instruction[7:11];
            end 
        endcase

    end

endmodule

