`timescale 1ns / 1ps

module parent #(parameter inputs = 256, parameter SIM_MODE = 0)(
    input clock,
    input reset,
    input white, black, brown, red, gameRst, erase, draw,
    input speedInc, speedDec,
    input sw,
    output sck,
    output sda,
    output res,
    output dc,
    output cs,
    output [3:0] speedOut
);

    wire divClock, halfClock;
    clockDivider CLOCK_DIVIDER(
        .clock(clock), .reset(reset),
        .speedInc(speedInc), .speedDec(speedDec),
        .divClock(divClock), .halfClock(halfClock),
        .speedOut(speedOut)
        
);

    wire right, left, up, down;
    analogTranslator ANALOG_TRANSLATOR (
        .white(white), .black(black), .brown(brown), .red(red),
        .right(right), .left(left), .up(up), .down(down)
    );



    wire [31:0] r1, r2, r3, r4;
    wire [inputs-1:0] memMappedIO = {{(inputs-7){1'b0}}, gameRst, erase, draw, down, up, left, right};
    wire [8191:0] framebuffer_unused;

    pipeline #(.inputs(inputs)) PIPELINE (
        .clock(divClock), .reset(reset),
        .memMappedIO(memMappedIO),
        .framebuffer(framebuffer_unused),
        .r1(r1), .r2(r2), .r3(r3), .r4(r4)
    );

    wire [8191:0] fb;
    pongFrameBuffer PONG_FB (
        .p1Y(r1), .p2Y(r2), .puckX(r3), .puckY(r4),
        .fb(fb)
    );

    spi SPI (
        .clock(halfClock), .reset(reset),
        .fb(fb),
        .sck(sck), .sda(sda), .res(res), .dc(dc), .cs(cs)
    );

endmodule