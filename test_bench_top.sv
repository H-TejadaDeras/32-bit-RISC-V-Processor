/*
 *  RISC-V RV32I Processor Test Bench
 *  Henry Tejada Deras - 11-05-2025
 */
`timescale 10ns/10ns
`include "top.sv"

module test_bench_top;
    logic clk = 0;
    logic LED;
    logic RGB_R;
    logic RGB_G;
    logic RGB_B;

    top u0 (
        .clk    (clk), 
        .LED    (LED),
        .RGB_R  (RGB_R),
        .RGB_G  (RGB_G),
        .RGB_B  (RGB_B)
    );

    initial begin
        $dumpfile("processor.vcd");
        $dumpvars(0, u0);
        #60000000
        $finish;
    end

    always begin
        #2
        clk = ~clk;
    end
    endmodule