`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2026 23:29:19
// Design Name: 
// Module Name: stage_mem
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


module stage_mem (
    input  wire        clk,
    input  wire        reset,
    input  wire        RegWriteM,
    input  wire        MemWriteM,
    input  wire [1:0]  ResultSrcM,
    input  wire [4:0]  RdM,
    input  wire [31:0] PCPlus4M,
    input  wire [31:0] WriteDataM,
    input  wire [31:0] ALUResultM,
    input  wire [31:0] ImmExtM,

    output wire        RegWriteW,
    output wire [1:0]  ResultSrcW,
    output wire [4:0]  RdW,
    output wire [31:0] PCPlus4W,
    output wire [31:0] ALUResultW,
    output wire [31:0] ReadDataW,
    output wire [31:0] ImmExtW
);
    wire [31:0] ReadDataM;

    dmem DMEM (
        .clk(clk),
        .reset(reset),
        .WE(MemWriteM),
        .A(ALUResultM),
        .WD(WriteDataM),
        .RD(ReadDataM)
    );

    // MEM/WB Register
    reg RegWriteM_r;
    reg [1:0] ResultSrcM_r;
    reg [4:0] RdM_r;
    reg [31:0] PCPlus4M_r, ALUResultM_r, ReadDataM_r, ImmExtM_r;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWriteM_r   <= 1'b0;
            ResultSrcM_r  <= 2'b00;
            RdM_r         <= 5'h0;
            PCPlus4M_r    <= 32'h0;
            ALUResultM_r  <= 32'h0;
            ReadDataM_r   <= 32'h0;
            ImmExtM_r     <= 32'h0;
        end else begin
            RegWriteM_r   <= RegWriteM;
            ResultSrcM_r  <= ResultSrcM;
            RdM_r         <= RdM;
            PCPlus4M_r    <= PCPlus4M;
            ALUResultM_r  <= ALUResultM;
            ReadDataM_r   <= ReadDataM;
            ImmExtM_r     <= ImmExtM;
        end
    end

    assign RegWriteW  = RegWriteM_r;
    assign ResultSrcW = ResultSrcM_r;
    assign RdW        = RdM_r;
    assign PCPlus4W   = PCPlus4M_r;
    assign ALUResultW = ALUResultM_r;
    assign ReadDataW  = ReadDataM_r;
    assign ImmExtW    = ImmExtM_r;

endmodule

