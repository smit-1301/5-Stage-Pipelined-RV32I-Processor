`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2026 23:52:21
// Design Name: 
// Module Name: dmem
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

module dmem (
    input  wire        clk,
    input  wire        reset,
    input  wire        WE,
    input  wire [31:0] A,
    input  wire [31:0] WD,
    output wire [31:0] RD
);
    reg [31:0] mem [0:1023];
    integer i;

    initial begin
        for (i = 0; i < 1024; i = i + 1) mem[i] = 32'h0;
    end

    always @(posedge clk) begin
        if (WE) mem[A[11:2]] <= WD;
    end

    assign RD = !reset ? mem[A[11:2]] : 32'h0;

endmodule


