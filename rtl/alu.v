`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2026 23:23:20
// Design Name: 
// Module Name: alu
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

module alu (
    input  wire [31:0] A, B,
    input  wire [3:0]  ALUControl,
    output reg  [31:0] Result,
    output wire        Zero, Negative
);
    wire signed [31:0] As = A;
    wire signed [31:0] Bs = B;

    always @(*) begin
        case (ALUControl)
            4'b0000: Result = A + B;
            4'b0001: Result = A - B;
            4'b0010: Result = A & B;
            4'b0011: Result = A | B;
            4'b0100: Result = A ^ B;
            4'b0101: Result = (As < Bs) ? 32'd1 : 32'd0;
            4'b0110: Result = (A  < B ) ? 32'd1 : 32'd0;
            4'b0111: Result = A << B[4:0];
            4'b1000: Result = A >> B[4:0];
            4'b1001: Result = As >>> B[4:0];
            default: Result = 32'h0;
        endcase
    end

    assign Zero     = (Result == 32'h0);
    assign Negative = Result[31];

endmodule



