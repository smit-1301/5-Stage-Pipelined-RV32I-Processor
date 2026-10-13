`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2026 22:58:48
// Design Name: 
// Module Name: hazard_unit
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

module hazard_unit (
    input  wire       reset,
    input  wire       RegWriteM,
    input  wire       RegWriteW,
    input  wire [4:0] RD_M,
    input  wire [4:0] RD_W,
    input  wire [4:0] Rs1_E,
    input  wire [4:0] Rs2_E,
    input  wire [4:0] Rs1_D,
    input  wire [4:0] Rs2_D,
    input  wire [4:0] RD_E,
    input  wire       UsesRs1D,
    input  wire       UsesRs2D,
    input  wire       ResultSrcE_load,
    input  wire       PCSrcE,

    output reg  [1:0] ForwardAE,
    output reg  [1:0] ForwardBE,
    output reg        StallF,
    output reg        StallD,
    output reg        FlushD,
    output reg        FlushE
);

    // 1. Forwarding to Operand A
    always @(*) begin
        if (RegWriteM && (RD_M != 5'h0) && (RD_M == Rs1_E))
            ForwardAE = 2'b10; // Forward from MEM stage
        else if (RegWriteW && (RD_W != 5'h0) && (RD_W == Rs1_E))
            ForwardAE = 2'b01; // Forward from WB stage
        else
            ForwardAE = 2'b00;
    end

    // 2. Forwarding to Operand B
    always @(*) begin
        if (RegWriteM && (RD_M != 5'h0) && (RD_M == Rs2_E))
            ForwardBE = 2'b10; // Forward from MEM stage
        else if (RegWriteW && (RD_W != 5'h0) && (RD_W == Rs2_E))
            ForwardBE = 2'b01; // Forward from WB stage
        else
            ForwardBE = 2'b00;
    end

    // 3. Qualified Load-Use Hazard Condition
    wire lwStall = ResultSrcE_load && (RD_E != 5'h0) &&
                   ((UsesRs1D && (Rs1_D == RD_E)) || (UsesRs2D && (Rs2_D == RD_E)));

    // 4. Stall & Flush Control Logic (Active-High Reset)
    always @(*) begin
        if (reset) begin
            StallF = 1'b0; StallD = 1'b0;
            FlushD = 1'b0; FlushE = 1'b0;
        end else begin
            StallF = lwStall & ~PCSrcE;
            StallD = lwStall & ~PCSrcE;
            FlushE = lwStall | PCSrcE;
            FlushD = PCSrcE;
        end
    end

endmodule

