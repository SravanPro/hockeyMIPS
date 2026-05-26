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

    tff TFF (
        .clock(clock),
        .reset(reset),
        .t(1'b1),
        .q(t_ff_clk)
    );

    wire rightRaw, leftRaw, upRaw, downRaw, eraseRaw, drawRaw;
    analogTranslator ANALOG_TRANSLATOR (
        .white(white), .black(black), .brown(brown), .red(red),
        .right(rightRaw), .left(leftRaw), .up(upRaw), .down(downRaw)
    );

    wire right, left, up, down;
    wire right2, left2;
    movementDivider #(.SIM_MODE(SIM_MODE)) MOVEMENT_DIVIDER (
        .clock(t_ff_clk), .reset(reset),
        .rightRaw(rightRaw), .leftRaw(leftRaw), .upRaw(upRaw), .downRaw(downRaw),
        .eraseRaw(erase), .drawRaw(draw),
        .speedInc(speedInc), .speedDec(speedDec),
        .right(right), .left(left), .up(up), .down(down),
        .erase(right2), .draw(left2),
        .speedOut(speedOut)
    );

    wire [31:0] r1, r2, r3, r4;
    wire [inputs-1:0] memMappedIO = {{(inputs-7){1'b0}}, gameRst, right2, left2, down, up, left, right};
    wire [8191:0] framebuffer_unused;

    pipeline #(.inputs(inputs)) PIPELINE (
        .clock(t_ff_clk), .reset(reset),
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
        .clock(t_ff_clk), .reset(reset),
        .fb(fb),
        .sck(sck), .sda(sda), .res(res), .dc(dc), .cs(cs)
    );

endmodule