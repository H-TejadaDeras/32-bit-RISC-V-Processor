/* 
 *  Processor Registers
 *
 *  Declares Conventional RISC-V RV32I Registers
 *  Registers:
 *  Reg. Name   | Abb.  | Conventional Function   | Reg. Address
 *  x0          | Zero  | Constant Zero           | 0x00000000
 *  x1          | ra    | Return Address          | 0x00000001
 *  x2          | sp    | Stack Pointer           | 0x00000002
 *  x3          | gp    | Global Pointer (Unused) | 0x00000003
 *  x4          | tp    | Thread Pointer (Unused) | 0x00000004
 *  x5-7, 28-31 | t0-6  | Temporary Registers     | 0x00000005 ...
 *  x8-9, 18-27 | s0-11 | Saved Registers         | 0x00000008 ...
 *  x10-17      | a0-7  | Function Arguments      | 0x0000000A ...
 * 
 *  Inputs:
 *  logic clk: Clock signal
 *  logic [31:0] reg_address: Register address for requested operation.
 *  logic [31:0] reg_input: Input to register. Used only in write operations.
 *  logic [31:0] reg_operation: Operation for register. 1'b0 is for read, 1'b1
 *      is for write.
 *  
 *  Outputs:
 *  logic [31:0] reg_output: Output from register. Used only in 
 */

 module registers (
    input clk,
    input  logic [31:0] reg_address,
    input  logic [31:0] reg_input,
    input  logic        reg_operation,
    output logic [31:0] reg_output
 );
    // Variable Declarations
    localparam READ_REG = 1'b0;
    localparam WRITE_REG = 1'b1;
    logic [31:0][31:0] registers = 0;

    // Perform Requested Register Operation
    always_comb begin
        if (reg_address == READ_REG) begin
            reg_output = registers[reg_address];
        end else begin
            if (reg_address == 32'h0) begin // Ensure Register Zero is read only
                reg_output = 0;
            end else begin
                reg_output = 0;
                registers[reg_address] = reg_input;
            end
        end
    end
 endmodule