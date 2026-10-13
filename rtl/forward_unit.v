`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2026 23:29:19
// Design Name: 
// Module Name: forward_unit
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

module forward_unit (
    input  wire [4:0] Rs1E,
    input  wire [4:0] Rs2E,
    input  wire [4:0] RdM,
    input  wire [4:0] RdW,
    input  wire       RegWriteM,
    input  wire       RegWriteW,
    output reg  [1:0] ForwardAE,
    output reg  [1:0] ForwardBE
);

    always @(*) begin
        // Forwarding to SrcAE
        if (RegWriteM && (RdM != 5'b0) && (RdM == Rs1E))
            ForwardAE = 2'b10; // Forward from MEM stage
        else if (RegWriteW && (RdW != 5'b0) && (RdW == Rs1E))
            ForwardAE = 2'b01; // Forward from WB stage
        else
            ForwardAE = 2'b00; // No forwarding

        // Forwarding to WriteDataE
        if (RegWriteM && (RdM != 5'b0) && (RdM == Rs2E))
            ForwardBE = 2'b10; // Forward from MEM stage
        else if (RegWriteW && (RdW != 5'b0) && (RdW == Rs2E))
            ForwardBE = 2'b01; // Forward from WB stage
        else
            ForwardBE = 2'b00; // No forwarding
    end

endmodule
