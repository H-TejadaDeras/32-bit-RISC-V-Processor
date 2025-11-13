/*
 *  RISC-V Processor with RV32I Instructions
 */

`include "memory.sv"
`include "pc.sv"
`include "registers.sv"
`include "decoder.sv"

module top (
    input logic clk, 
    output logic LED, 
    output logic RGB_R, 
    output logic RGB_G, 
    output logic RGB_B
);
    // Variable Declarations
    localparam FETCH_INSTRUCTION = 3'b000;
    localparam FETCH_REGISTERS = 3'b001;
    localparam EXECUTE_INSTRUCTION = 3'b010;
    localparam WRITE_BACK = 3'b011;

    localparam HIGH = 1'b1;
    localparam LOW = 1'b0;

    // Net Declarations
    logic reset;
    logic led;
    logic red;
    logic green;
    logic blue;
    logic [2:0] processor_state = FETCH_INSTRUCTION;
    logic w_funct3;
    logic w_dmem_wren;
    logic [31:0] w_dmem_address;
    logic [31:0] w_dmem_data_in;
    logic [31:0] w_imem_address;
    logic [31:0] w_imem_data_out;
    logic [31:0] w_dmem_data_out;

    // Register Declarations
    logic [31:0] current_instruction; // Current instruction being executed by processor

    // Module Declarations
    program_counter u1 (
        .clk                       (clk), 
        .instruction_completed     (instruction_completed),
        .imem_address              (imem_address[31:0]),
        .increment                 (increment[31:0]),
        .instruction               (instruction_output[31:0])
    );

    memory #(
        .IMEM_INIT_FILE_PREFIX  ("example/rv32i_test")
    ) u3 (
        .clk            (clk), 
        .funct3         (w_funct3), 
        .dmem_wren      (w_dmem_wren), 
        .dmem_address   (w_dmem_address[31:0]), 
        .dmem_data_in   (w_dmem_data_in[31:0]), 
        .imem_address   (w_imem_address[31:0]), 
        .imem_data_out  (w_imem_data_out[31:0]), 
        .dmem_data_out  (w_dmem_data_out[31:0]), 
        .reset          (reset), 
        .led            (led), 
        .red            (red), 
        .green          (green), 
        .blue           (blue)
    );

    decoder u3 (
        .instruction    (current_instruction[31:0]),
        .opcode         (opcode),
        .rd             (decoder_rd),
        .funct3         (funct3),
        .rs1            (rs1),
        .rs2            (rs2),
        .funct7         (funct7),
        .imm_i          (imm_i),
        .imm_s          (imm_s),
        .imm_b          (imm_b),
        .imm_u          (imm_u),
        .imm_j          (imm_j)
    );

    // Processor State Machine
    always_comb begin
        case (processor_state)
            FETCH_INSTRUCTION: begin
                w_dmem_wren = LOW;
                w_funct3 = 3'b010;
                w_imem_address = instruction_output[31:0]; // Get instr. address from pc
                current_instruction = w_imem_data_out; // Save current instruction for use by decoder
            end

            FETCH_REGISTERS: begin
            end

            EXECUTE_INSTRUCTION: begin
            end

            WRITE_BACK: begin
                // Update pc
                // Store Word
            end
        endcase
    end

    /////////////////////// Data Memory Operations ////////////////////////////
    always_ff @(posedge clk) begin
        if (processor_state == EXECUTE_INSTRUCTION) begin
            case (opcode)
                default: begin
                    w_dmem_wren <= LOW;
                    w_funct3 <= 3'b0;
                    w_dmem_address <= 32'b0;
                end

                7'b0000011: begin // lb, lh, lw, lbu, lhu
                    w_dmem_wren <= LOW; // Read Operation
                    w_funct3 <= funct3;
                    w_dmem_address <= registers[rs1] + imm_i;
                    registers[rd] <= w_dmem_data_out;
                end

                7'b0100011: begin // sb, sh, sw
                    w_dmem_wren <= HIGH; // Write Operation
                    w_funct3 <= funct3;
                end
            endcase
        end
    end

    ////////////////////////////// Registers //////////////////////////////////
    logic [31:0][31:0] registers = 0;

    // Maintain Zero Register Equal to Zero
    always_comb begin
        registers[0] = 32'b0;
    end

    ////////////////////////////// Update PC //////////////////////////////////
    always_ff @(posedge clk) begin
        if (opcode == 1101111) begin // jal
        end else if (opcode == 1100111) begin // jalr
        end else if (opcode == 1100011) begin // beq, bne, blt, bge, bltu, bgeu
        end else begin // All other instructions
            increment <= 32'd4;
        end
    end

    ///////////////////////////////////////////////////////////////////////////
    assign LED = ~led;
    assign RGB_R = ~red;
    assign RGB_G = ~green;
    assign RGB_B = ~blue;

endmodule