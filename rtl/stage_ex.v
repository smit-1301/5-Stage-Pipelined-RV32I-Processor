`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2026 23:26:02
// Design Name: 
// Module Name: stage_ex
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


module stage_ex (
    input  wire        clk,
    input  wire        reset,
    input  wire        RegWriteE,
    input  wire        ALUSrcE,
    input  wire        MemWriteE,
    input  wire        BranchE,
    input  wire        JumpE,
    input  wire        JalrE,
    input  wire        AUIPCE,
    input  wire [1:0]  ResultSrcE,
    input  wire [1:0]  ForwardAE,
    input  wire [1:0]  ForwardBE,
    input  wire [3:0]  ALUControlE,
    input  wire [2:0]  Funct3E,
    input  wire [4:0]  RdE,
    input  wire [31:0] PCE,
    input  wire [31:0] PCPlus4E,
    input  wire [31:0] ResultW,
    input  wire [31:0] RD1E,
    input  wire [31:0] RD2E,
    input  wire [31:0] ImmExtE,

    output wire        PCSrcE,
    output wire        RegWriteM,
    output wire        MemWriteM,
    output wire [1:0]  ResultSrcM,
    output wire [4:0]  RdM,
    output wire [31:0] PCPlus4M,
    output wire [31:0] WriteDataM,
    output wire [31:0] ALUResultM,
    output wire [31:0] PCTargetE,
    output wire [31:0] ImmExtM
);
    wire [31:0] SrcA_fwd, SrcA, SrcB_fwd, SrcB, ResultE;
    wire ZeroE, NegativeE;

    // Forwarding MUX A
    mux3 srca_mux (
        .a(RD1E), .b(ResultW), .c(ALUResultM),
        .s(ForwardAE), .d(SrcA_fwd)
    );

    // AUIPC: force SrcA = PCE
    mux2 srca_final_mux (
        .a(SrcA_fwd), .b(PCE), .s(AUIPCE), .c(SrcA)
    );

    // Forwarding MUX B
    mux3 srcb_mux (
        .a(RD2E), .b(ResultW), .c(ALUResultM),
        .s(ForwardBE), .d(SrcB_fwd)
    );

    mux2 alu_src_mux (
        .a(SrcB_fwd), .b(ImmExtE), .s(ALUSrcE), .c(SrcB)
    );

    // ALU
    alu ALU_UNIT (
        .A(SrcA), .B(SrcB), .Result(ResultE),
        .ALUControl(ALUControlE), .Zero(ZeroE), .Negative(NegativeE)
    );

    // Repository Exact Branch Comparator
    wire [31:0] br_diff = SrcA_fwd - SrcB_fwd;
    wire brEq = (br_diff == 32'h0);
    wire brLt = (SrcA_fwd[31] ^ SrcB_fwd[31]) ? SrcA_fwd[31] : br_diff[31];
    wire brLtU = (~SrcA_fwd[31] & SrcB_fwd[31]) | ((SrcA_fwd[31] ~^ SrcB_fwd[31]) & br_diff[31]);

    reg branch_taken;
    always @(*) begin
        case (Funct3E)
            3'b000: branch_taken =  brEq;  // BEQ
            3'b001: branch_taken = ~brEq;  // BNE
            3'b100: branch_taken =  brLt;  // BLT
            3'b101: branch_taken = ~brLt;  // BGE
            3'b110: branch_taken =  brLtU; // BLTU
            3'b111: branch_taken = ~brLtU; // BGEU
            default: branch_taken = 1'b0;
        endcase
    end

    assign PCSrcE = JumpE | (BranchE & branch_taken);

    // Target Calculation
    wire [31:0] jalr_target  = (SrcA_fwd + ImmExtE) & 32'hFFFF_FFFE;
    wire [31:0] other_target = PCE + ImmExtE;
    assign PCTargetE = JalrE ? jalr_target : other_target;

    // EX/MEM Register
    reg RegWriteM_r, MemWriteM_r;
    reg [1:0] ResultSrcM_r;
    reg [4:0] RdM_r;
    reg [31:0] PCPlus4M_r, WriteDataM_r, ALUResultM_r, ImmExtM_r;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWriteM_r   <= 1'b0;
            MemWriteM_r   <= 1'b0;
            ResultSrcM_r  <= 2'b00;
            RdM_r         <= 5'h0;
            PCPlus4M_r    <= 32'h0;
            WriteDataM_r  <= 32'h0;
            ALUResultM_r  <= 32'h0;
            ImmExtM_r     <= 32'h0;
        end else begin
            RegWriteM_r   <= RegWriteE;
            MemWriteM_r   <= MemWriteE;
            ResultSrcM_r  <= ResultSrcE;
            RdM_r         <= RdE;
            PCPlus4M_r    <= PCPlus4E;
            WriteDataM_r  <= SrcB_fwd; // Store Data
            ALUResultM_r  <= ResultE;
            ImmExtM_r     <= ImmExtE;
        end
    end

    assign RegWriteM  = RegWriteM_r;
    assign MemWriteM  = MemWriteM_r;
    assign ResultSrcM = ResultSrcM_r;
    assign RdM        = RdM_r;
    assign PCPlus4M   = PCPlus4M_r;
    assign WriteDataM = WriteDataM_r;
    assign ALUResultM = ALUResultM_r;
    assign ImmExtM    = ImmExtM_r;

endmodule

