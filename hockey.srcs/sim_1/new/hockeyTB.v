`timescale 1ns / 1ps

module hockeyTB;

    reg  clock, reset;
    reg  white, black, brown, red;
    reg  gameRst, erase, draw;
    reg  speedInc, speedDec, sw;

    wire sck, sda, res, dc, cs;
    wire [3:0] speedOut;

    parent #(.SIM_MODE(1)) DUT (
        .clock(clock), .reset(reset),
        .white(white), .black(black), .brown(brown), .red(red),
        .gameRst(gameRst), .erase(erase), .draw(draw),
        .speedInc(speedInc), .speedDec(speedDec), .sw(sw),
        .sck(sck), .sda(sda), .res(res), .dc(dc), .cs(cs),
        .speedOut(speedOut)
    );

    always #4 clock = ~clock;  // 125 MHz -> ~62 MHz after TFF

    initial begin
        clock=0; reset=1;
        white=0; black=1; brown=0; red=1;
        gameRst=0; erase=0; draw=0;
        speedInc=0; speedDec=0; sw=0;
        #100 reset=0;
        #1000000 $finish;
    end

endmodule