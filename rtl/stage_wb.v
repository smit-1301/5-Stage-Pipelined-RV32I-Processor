`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2026 23:29:19
// Design Name: 
// Module Name: stage_wb
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

module stage_wb (
    input  wire [1:0]  ResultSrcW,
    input  wire [31:0] PCPlus4W,
    input  wire [31:0] ALUResultW,
    input  wire [31:0] ReadDataW,
    input  wire [31:0] ImmExtW,
    output wire [31:0] ResultW
);

    mux4 result_mux (
        .a(ALUResultW),
        .b(ReadDataW),
        .c(PCPlus4W),
        .d(ImmExtW),
        .s(ResultSrcW),
        .e(ResultW)
    );

endmodule

