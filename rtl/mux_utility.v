`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2026 02:02:39
// Design Name: 
// Module Name: mux_utility
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


module mux2 (
    input  wire [31:0] a, b,
    input  wire        s,
    output wire [31:0] c
);
    assign c = s ? b : a;
endmodule

module mux3 (
    input  wire [31:0] a, b, c,
    input  wire [1:0]  s,
    output reg  [31:0] d
);
    always @(*) begin
        case (s)
            2'b00:   d = a;
            2'b01:   d = b;
            2'b10:   d = c;
            default: d = 32'h0;
        endcase
    end
endmodule

module mux4 (
    input  wire [31:0] a, b, c, d,
    input  wire [1:0]  s,
    output reg  [31:0] e
);
    always @(*) begin
        case (s)
            2'b00:   e = a;
            2'b01:   e = b;
            2'b10:   e = c;
            default: e = d;
        endcase
    end
endmodule
