`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2026 23:17:33
// Design Name: 
// Module Name: control_unit
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

module control_unit (
    input  wire [6:0] op,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output wire        RegWriteD,
    output wire        ALUSrcD,
    output wire        MemWriteD,
    output wire        BranchD,
    output wire        JumpD,
    output wire        JalrD,
    output wire        AUIPCD,
    output wire        UsesRs1D,
    output wire        UsesRs2D,
    output wire [2:0]  ImmSrcD,
    output wire [1:0]  ResultSrcD,
    output wire [3:0]  ALUControlD
);

    wire [1:0] ALUOp;

    Main_Decoder main (
        .Op(op),
        .RegWrite(RegWriteD),
        .ALUSrc(ALUSrcD),
        .MemWrite(MemWriteD),
        .Branch(BranchD),
        .Jump(JumpD),
        .Jalr(JalrD),
        .AUIPC(AUIPCD),
        .UsesRs1(UsesRs1D),
        .UsesRs2(UsesRs2D),
        .ImmSrc(ImmSrcD),
        .ResultSrc(ResultSrcD),
        .ALUOp(ALUOp)
    );

    ALU_Decoder alu_dec (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .op(op),
        .ALUControl(ALUControlD)
    );

endmodule



