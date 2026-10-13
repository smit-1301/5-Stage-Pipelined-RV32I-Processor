`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2026 23:07:09
// Design Name: 
// Module Name: regfile
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


module regfile (
    input  wire        clk,
    input  wire        RegWriteW,
    input  wire [4:0]  A1, A2, A3,
    input  wire [31:0] WD3,
    output wire [31:0] RD1, RD2
);
    reg [31:0] Register [0:31];
    integer i;

    initial begin
        for (i = 0; i < 32; i = i + 1) Register[i] = 32'h0;
    end

    // Write on falling edge (negedge clk) to resolve WB-to-ID hazard
    always @(negedge clk) begin
        if (RegWriteW && (A3 != 5'h00))
            Register[A3] <= WD3;
    end

    // Combinational Read
    assign RD1 = (A1 == 5'h00) ? 32'h0 : Register[A1];
    assign RD2 = (A2 == 5'h00) ? 32'h0 : Register[A2];

endmodule

