`timescale 1ns / 1ps
/*
  pongFrameBuffer - combinatorial renderer
  R1=p1Y, R2=p2Y, R3=puckX, R4=puckY
  128x64 display. pixel(x,y) = bit y*128+x
  Top wall: rows 0-2. Bottom wall: rows 61-63.
  Player1: cols 3-5, rows p1Y..p1Y+9
  Player2: cols 122-124, rows p2Y..p2Y+9
  Puck: 2x2 at (puckX,puckY)
*/
module pongFrameBuffer(
    input  [31:0] p1Y, p2Y, puckX, puckY,
    output reg [8191:0] fb
);
    integer x, y, px, py;
    always @(*) begin
        fb = 8192'b0;
        for (y=0; y<3; y=y+1) for (x=0; x<128; x=x+1) fb[y*128+x]=1'b1;
        for (y=61; y<64; y=y+1) for (x=0; x<128; x=x+1) fb[y*128+x]=1'b1;
        for (y=0; y<10; y=y+1) for (x=3; x<=5; x=x+1)
            if ((p1Y+y)<64) fb[(p1Y+y)*128+x]=1'b1;
        for (y=0; y<10; y=y+1) for (x=122; x<=124; x=x+1)
            if ((p2Y+y)<64) fb[(p2Y+y)*128+x]=1'b1;
        for (py=0; py<2; py=py+1) for (px=0; px<2; px=px+1)
            if ((puckX+px)<128 && (puckY+py)<64)
                fb[(puckY+py)*128+(puckX+px)]=1'b1;
    end
endmodule