`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2026 22:58:48
// Design Name: 
// Module Name: stage_if
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


module stage_if (
    input  wire        clk,
    input  wire        reset,
    input  wire        StallF,
    input  wire        FlushD,
    input  wire        PCSrcE,
    input  wire [31:0] PCTargetE,
    output wire [31:0] InstrD,
    output wire [31:0] PCD,
    output wire [31:0] PCPlus4D
);
    wire [31:0] PCF, PCPlus4F, InstrF, PC_Next;

    mux2 PC_MUX (
        .a(PCPlus4F),
        .b(PCTargetE),
        .s(PCSrcE),
        .c(PC_Next)
    );

    // PC Register (Active-High Reset)
    reg [31:0] PC_reg;
    always @(posedge clk or posedge reset) begin
        if (reset)
            PC_reg <= 32'h0000_0000;
        else
            PC_reg <= PC_Next;
    end
    assign PCF = PC_reg;

    // Instruction Memory
    imem IMEM (
        .reset(reset),
        .A(PCF),
        .RD(InstrF)
    );

    // PC Adder
    assign PCPlus4F = PCF + 32'h0000_0004;

    // IF/ID Register
    reg [31:0] InstrF_r, PCF_r, PCPlus4F_r;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            InstrF_r   <= 32'h0000_0013; // NOP
            PCF_r      <= 32'h0;
            PCPlus4F_r <= 32'h0;
        end else if (FlushD) begin
            InstrF_r   <= 32'h0000_0013; // NOP
            PCF_r      <= PCF;
            PCPlus4F_r <= PCPlus4F;
        end else if (!StallF) begin
            InstrF_r   <= InstrF;
            PCF_r      <= PCF;
            PCPlus4F_r <= PCPlus4F;
        end
    end

    assign InstrD   = InstrF_r;
    assign PCD      = PCF_r;
    assign PCPlus4D = PCPlus4F_r;

endmodule
