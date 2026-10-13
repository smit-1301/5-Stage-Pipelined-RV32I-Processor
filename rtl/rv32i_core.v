`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2026 23:34:01
// Design Name: 
// Module Name: rv32i_core
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

module rv32i_core (
    input  wire        clk,
    input  wire        reset,
    output wire [15:0] Result_Debug,
    output wire [31:0] Instr_Debug,
    output wire [31:0] PC_Debug,
    output wire        RegWrite_Debug
);

    wire PCSrcE, RegWriteE, ALUSrcE, MemWriteE, BranchE, JumpE, JalrE, AUIPCE;
    wire RegWriteM, MemWriteM, RegWriteW, StallF, StallD, FlushD, FlushE;
    wire [1:0] ResultSrcE, ResultSrcM, ResultSrcW, ForwardAE, ForwardBE;
    wire [3:0] ALUControlE;
    wire [2:0] Funct3E;
    wire UsesRs1D, UsesRs2D;

    wire [4:0]  RdE, RdM, RdW, Rs1E, Rs2E;
    wire [31:0] PCTargetE, InstrD, PCD, PCPlus4D, RD1E, RD2E, ImmExtE, PCE, PCPlus4E;
    wire [31:0] PCPlus4M, WriteDataM, ALUResultM, ImmExtM, PCPlus4W, ALUResultW, ReadDataW, ImmExtW;
    wire [31:0] ResultW;

    wire [4:0] Rs1D = InstrD[19:15];
    wire [4:0] Rs2D = InstrD[24:20];
    wire ResultSrcE_load = (ResultSrcE == 2'b01);

    stage_if Fetch (
        .clk(clk), .reset(reset),
        .StallF(StallF), .FlushD(FlushD),
        .PCSrcE(PCSrcE), .PCTargetE(PCTargetE),
        .InstrD(InstrD), .PCD(PCD), .PCPlus4D(PCPlus4D)
    );

    stage_id Decode (
        .clk(clk), .reset(reset), .FlushE(FlushE),
        .InstrD(InstrD), .PCD(PCD), .PCPlus4D(PCPlus4D),
        .RegWriteW(RegWriteW), .RdW(RdW), .ResultW(ResultW),
        .UsesRs1D(UsesRs1D), .UsesRs2D(UsesRs2D),
        .RegWriteE(RegWriteE), .ALUSrcE(ALUSrcE), .MemWriteE(MemWriteE),
        .BranchE(BranchE), .JumpE(JumpE), .JalrE(JalrE), .AUIPCE(AUIPCE),
        .ResultSrcE(ResultSrcE), .ALUControlE(ALUControlE), .Funct3E(Funct3E),
        .RD1E(RD1E), .RD2E(RD2E), .ImmExtE(ImmExtE),
        .Rs1E(Rs1E), .Rs2E(Rs2E), .RdE(RdE),
        .PCE(PCE), .PCPlus4E(PCPlus4E)
    );

    stage_ex Execute (
        .clk(clk), .reset(reset),
        .RegWriteE(RegWriteE), .ALUSrcE(ALUSrcE), .MemWriteE(MemWriteE),
        .BranchE(BranchE), .JumpE(JumpE), .JalrE(JalrE), .AUIPCE(AUIPCE),
        .ResultSrcE(ResultSrcE), .ALUControlE(ALUControlE), .Funct3E(Funct3E),
        .RdE(RdE),
        .PCE(PCE), .PCPlus4E(PCPlus4E), .ResultW(ResultW),
        .RD1E(RD1E), .RD2E(RD2E), .ImmExtE(ImmExtE),
        .ForwardAE(ForwardAE), .ForwardBE(ForwardBE),
        .PCSrcE(PCSrcE), .PCTargetE(PCTargetE),
        .RegWriteM(RegWriteM), .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM), .RdM(RdM),
        .PCPlus4M(PCPlus4M), .WriteDataM(WriteDataM),
        .ALUResultM(ALUResultM), .ImmExtM(ImmExtM)
    );

    stage_mem Memory (
        .clk(clk), .reset(reset),
        .RegWriteM(RegWriteM), .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM), .RdM(RdM),
        .PCPlus4M(PCPlus4M), .WriteDataM(WriteDataM),
        .ALUResultM(ALUResultM), .ImmExtM(ImmExtM),
        .RegWriteW(RegWriteW), .ResultSrcW(ResultSrcW),
        .RdW(RdW),
        .PCPlus4W(PCPlus4W), .ALUResultW(ALUResultW),
        .ReadDataW(ReadDataW), .ImmExtW(ImmExtW)
    );

    stage_wb WriteBack (
        .ResultSrcW(ResultSrcW),
        .PCPlus4W(PCPlus4W), .ALUResultW(ALUResultW),
        .ReadDataW(ReadDataW), .ImmExtW(ImmExtW),
        .ResultW(ResultW)
    );

    hazard_unit Hazard (
        .reset(reset),
        .RegWriteM(RegWriteM), .RegWriteW(RegWriteW),
        .RD_M(RdM), .RD_W(RdW),
        .Rs1_E(Rs1E), .Rs2_E(Rs2E),
        .Rs1_D(Rs1D), .Rs2_D(Rs2D), .RD_E(RdE),
        .UsesRs1D(UsesRs1D), .UsesRs2D(UsesRs2D),
        .ResultSrcE_load(ResultSrcE_load),
        .PCSrcE(PCSrcE),
        .ForwardAE(ForwardAE), .ForwardBE(ForwardBE),
        .StallF(StallF), .StallD(StallD),
        .FlushD(FlushD), .FlushE(FlushE)
    );

    assign Result_Debug    = ResultW[15:0];
    assign Instr_Debug     = InstrD;
    assign PC_Debug        = PCD;
    assign RegWrite_Debug  = RegWriteW;

endmodule

