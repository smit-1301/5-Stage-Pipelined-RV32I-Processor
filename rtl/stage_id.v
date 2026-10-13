`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2026 23:19:38
// Design Name: 
// Module Name: stage_id
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

module stage_id (
    input  wire        clk,
    input  wire        reset,
    input  wire        FlushE,
    input  wire [31:0] InstrD,
    input  wire [31:0] PCD,
    input  wire [31:0] PCPlus4D,
    input  wire        RegWriteW,
    input  wire [4:0]  RdW,
    input  wire [31:0] ResultW,

    output wire        UsesRs1D,
    output wire        UsesRs2D,
    output reg         RegWriteE,
    output reg         ALUSrcE,
    output reg         MemWriteE,
    output reg         BranchE,
    output reg         JumpE,
    output reg         JalrE,
    output reg         AUIPCE,
    output reg  [1:0]  ResultSrcE,
    output reg  [3:0]  ALUControlE,
    output reg  [2:0]  Funct3E,
    output reg  [31:0] RD1E,
    output reg  [31:0] RD2E,
    output reg  [31:0] ImmExtE,
    output reg  [4:0]  Rs1E,
    output reg  [4:0]  Rs2E,
    output reg  [4:0]  RdE,
    output reg  [31:0] PCE,
    output reg  [31:0] PCPlus4E
);
    wire RegWriteD, ALUSrcD, MemWriteD, BranchD, JumpD, JalrD, AUIPCD;
    wire [1:0] ResultSrcD;
    wire [2:0] ImmSrcD;
    wire [3:0] ALUControlD;
    wire [31:0] RD1D, RD2D, ImmExtD;

    control_unit CONTROL (
        .op(InstrD[6:0]),
        .funct3(InstrD[14:12]),
        .funct7(InstrD[31:25]),
        .RegWriteD(RegWriteD),
        .ALUSrcD(ALUSrcD),
        .MemWriteD(MemWriteD),
        .BranchD(BranchD),
        .JumpD(JumpD),
        .JalrD(JalrD),
        .AUIPCD(AUIPCD),
        .UsesRs1D(UsesRs1D),
        .UsesRs2D(UsesRs2D),
        .ImmSrcD(ImmSrcD),
        .ResultSrcD(ResultSrcD),
        .ALUControlD(ALUControlD)
    );

    regfile RF (
        .clk(clk),
        .RegWriteW(RegWriteW),
        .A1(InstrD[19:15]),
        .A2(InstrD[24:20]),
        .A3(RdW),
        .WD3(ResultW),
        .RD1(RD1D),
        .RD2(RD2D)
    );

    imm_gen EXT (
        .InstrD(InstrD),
        .ImmSrcD(ImmSrcD),
        .ImmExtD(ImmExtD)
    );

    // ID/EX Register
    always @(posedge clk or posedge reset) begin
        if (reset || FlushE) begin
            RegWriteE   <= 1'b0; ALUSrcE <= 1'b0; MemWriteE <= 1'b0;
            BranchE     <= 1'b0; JumpE   <= 1'b0; JalrE     <= 1'b0; AUIPCE <= 1'b0;
            ResultSrcE  <= 2'b00; ALUControlE <= 4'b0000; Funct3E <= 3'b000;
            RD1E        <= 32'h0; RD2E <= 32'h0; ImmExtE <= 32'h0;
            Rs1E        <= 5'h0;  Rs2E <= 5'h0;  RdE     <= 5'h0;
            PCE         <= 32'h0; PCPlus4E <= 32'h0;
        end else begin
            RegWriteE   <= RegWriteD; ALUSrcE <= ALUSrcD; MemWriteE <= MemWriteD;
            BranchE     <= BranchD;   JumpE   <= JumpD;   JalrE     <= JalrD; AUIPCE <= AUIPCD;
            ResultSrcE  <= ResultSrcD; ALUControlE <= ALUControlD;
            Funct3E     <= InstrD[14:12];
            RD1E        <= RD1D; RD2E <= RD2D; ImmExtE <= ImmExtD;
            Rs1E        <= InstrD[19:15]; Rs2E <= InstrD[24:20]; RdE <= InstrD[11:7];
            PCE         <= PCD; PCPlus4E <= PCPlus4D;
        end
    end

endmodule




