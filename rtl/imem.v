`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2026 23:51:35
// Design Name: 
// Module Name: imem
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


module imem (
    input  wire        reset,
    input  wire [31:0] A,
    output wire [31:0] RD
);
    reg [31:0] mem [0:1023];
    integer i;

    initial begin
        for (i = 0; i < 1024; i = i + 1)
            mem[i] = 32'h00000013; // Pre-fill with NOP
        $readmemh("imem.mem", mem);
    end

    // Direct combinational read from RAM array
    assign RD = mem[A[11:2]];

endmodule


