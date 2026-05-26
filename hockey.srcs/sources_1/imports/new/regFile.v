`timescale 1ns / 1ps
module regFile(
    input clock, reset, regWrite,
    input  [4:0]  rn1, rn2, wn,
    input  [31:0] wd,
    output [31:0] rd1, rd2,
    output [31:0] r1, r2, r3, r4
);
    reg [31:0] regBank [31:0];
    integer i;
    assign rd1 = (regWrite && wn != 5'd0 && wn == rn1) ? wd : regBank[rn1];
    assign rd2 = (regWrite && wn != 5'd0 && wn == rn2) ? wd : regBank[rn2];
    assign r1 = regBank[1]; assign r2 = regBank[2];
    assign r3 = regBank[3]; assign r4 = regBank[4];
    always @(posedge clock or posedge reset) begin
        if (reset) for (i = 0; i < 32; i = i + 1) regBank[i] <= 32'd0;
        else if (regWrite && wn != 5'd0) regBank[wn] <= wd;
    end
endmodule