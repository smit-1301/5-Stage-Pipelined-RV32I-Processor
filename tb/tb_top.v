`timescale 1ns / 1ps

module tb_top;

    reg clk;
    reg reset;

    wire [15:0] Result_Debug;
    wire [31:0] Instr_Debug;
    wire [31:0] PC_Debug;
    wire        RegWrite_Debug;

    top uut (
        .clk(clk),
        .reset(reset),
        .Result_Debug(Result_Debug),
        .Instr_Debug(Instr_Debug),
        .PC_Debug(PC_Debug),
        .RegWrite_Debug(RegWrite_Debug)
    );

    integer pass_cnt;
    integer fail_cnt;
    integer wd;

    always #5 clk = ~clk;

    always @(posedge clk) begin
        wd = wd + 1;
        if (wd > 5000) begin
            $display("\n==================================================");
            $display("  FATAL: TIMEOUT - Simulation exceeded max cycles");
            $display("==================================================\n");
            $finish;
        end
    end

    task chk;
        input integer       idx;
        input [31:0]        exp;
        input [8*16:1]      nm;
        begin
            if (uut.CORE.Decode.RF.Register[idx] === exp) begin
                pass_cnt = pass_cnt + 1;
                $display("[PASS] %s x%0d=0x%08x", nm, idx, uut.CORE.Decode.RF.Register[idx]);
            end else begin
                fail_cnt = fail_cnt + 1;
                $display("[FAIL] %s x%0d=0x%08x exp 0x%08x", nm, idx, uut.CORE.Decode.RF.Register[idx], exp);
            end
        end
    endtask

    initial begin
        clk      = 0;
        reset    = 1;
        wd       = 0;
        pass_cnt = 0;
        fail_cnt = 0;

        // Deassert reset on negedge to avoid setup race condition at PC=0
        repeat (4) @(negedge clk);
        reset = 0;

        repeat (400) @(posedge clk);

        chk(1,  32'd5,          "ADDI");
        chk(2,  32'd3,          "ADDI");
        chk(3,  32'd8,          "ADD");
        chk(4,  32'd2,          "SUB");
        chk(5,  32'd1,          "AND");
        chk(6,  32'd7,          "OR");
        chk(7,  32'd6,          "XOR");
        chk(8,  32'd8,          "LW");
        chk(10, 32'd42,         "BEQ-skip");
        chk(11, 32'h00000034,   "JAL link");
        chk(13, 32'd1,          "post-JAL");
        chk(14, 32'hDEADB000,   "LUI");
        chk(15, 32'h00000048,   "AUIPC");

        $display("\n==================================================");
        $display("  VERIFICATION SUMMARY: PASS=%0d FAIL=%0d", pass_cnt, fail_cnt);
        if (fail_cnt == 0) begin
            $display("  ALL 13 TEST CHECKS PASSED SUCCESSFULLY!");
            $display("==================================================\n");
            $finish;
        end else begin
            $display("  TEST SUITE FAILED WITH %0d ERRORS", fail_cnt);
            $display("==================================================\n");
            $finish;
        end
    end

endmodule