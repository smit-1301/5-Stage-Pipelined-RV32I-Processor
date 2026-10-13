`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2026 23:08:33
// Design Name: 
// Module Name: imm_gen
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

module imm_gen (
    input  wire [31:0] InstrD,
    input  wire [2:0]  ImmSrcD,
    output reg  [31:0] ImmExtD
);
    always @(*) begin
        case (ImmSrcD)
            3'b000: ImmExtD = {{20{InstrD[31]}}, InstrD[31:20]};                              // I
            3'b001: ImmExtD = {{20{InstrD[31]}}, InstrD[31:25], InstrD[11:7]};                   // S
            3'b010: ImmExtD = {{19{InstrD[31]}}, InstrD[31], InstrD[7], InstrD[30:25], InstrD[11:8], 1'b0}; // B
            3'b011: ImmExtD = {{11{InstrD[31]}}, InstrD[31], InstrD[19:12], InstrD[20], InstrD[30:21], 1'b0}; // J
            3'b100: ImmExtD = {InstrD[31:12], 12'b0};                                            // U
            default: ImmExtD = 32'h0;
        endcase
    end
endmodule

