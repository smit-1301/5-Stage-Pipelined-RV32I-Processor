`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2026 23:56:22
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top (
    input  wire        clk,
    input  wire        reset,
    output wire [15:0] Result_Debug,
    output wire [31:0] Instr_Debug,
    output wire [31:0] PC_Debug,
    output wire        RegWrite_Debug
);

    // Instantiate CPU Core (Pipeline_top logic)
    rv32i_core CORE (
        .clk(clk),
        .reset(reset),
        .Result_Debug(Result_Debug),
        .Instr_Debug(Instr_Debug),
        .PC_Debug(PC_Debug),
        .RegWrite_Debug(RegWrite_Debug)
    );

endmodule

