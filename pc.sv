/*
 *  Program Counter
 *  Anika Mahesh - 11-05-2025
 *  
 *  Program Counter for RISC-V Processor
 *  returns the instruction to be run.
 */

module program_counter (
    input logic clk, 
    input logic [1:0] instruction_completed,
    input logic [31:0] imem_address,
    input logic [31:0] increment,
    output logic [31:0] instruction
);

    always_ff @(negedge clk) begin
        if (instruction_completed) begin
            instruction <= imem_address + increment;
        end
    end

endmodule

