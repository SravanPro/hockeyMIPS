`timescale 1ns / 1ps
/*
  pongFrameBuffer - sequential renderer
  Inputs: p1Y, p2Y, puckX, puckY  (sampled on phase 0)
  Output: fb (8192-bit, stable when phase==6)

  Phases:
    0  : latch inputs, clear fb              (1 cycle)
    1  : top wall    row 0,  x=0..127        (128 cycles)
    2  : bottom wall row 63, x=0..127        (128 cycles)
    3  : player1     cols 3-5, y=0..13       (42 cycles)
    4  : player2     cols 122-124, y=0..13   (42 cycles)
    5  : puck 2x2, cnt=0..3                  (4 cycles)
    6  : idle - restarts when inputs change

  Total latency: 1+128+128+42+42+4 = 345 cycles
  py*128 == {py[5:0], 7'b0} - zero LUTs for multiply.
*/
module pongFrameBuffer (
    input             clock,
    input             reset,
    input      [31:0] p1Y,
    input      [31:0] p2Y,
    input      [31:0] puckX,
    input      [31:0] puckY,
    output reg [8191:0] fb
);

    // Latched inputs
    reg [5:0] r_p1Y, r_p2Y;
    reg [6:0] r_puckX;
    reg [5:0] r_puckY;

    // FSM
    reg [2:0] phase;
    reg [7:0] cnt;
    reg [3:0] pad_y;    // 0..13  (for player phases)
    reg [1:0] pad_col;  // 0..2

    // Hoisted temporaries (combo wires from regs - avoids reg-in-begin)
    wire [6:0] col3  = 7'd3   + {5'b0, pad_col};
    wire [6:0] row3  = {1'b0, r_p1Y} + {3'b0, pad_y};
    wire [6:0] col4  = 7'd122 + {5'b0, pad_col};
    wire [6:0] row4  = {1'b0, r_p2Y} + {3'b0, pad_y};
    wire [7:0] px5   = {1'b0, r_puckX} + {7'b0, cnt[0]};
    wire [6:0] py5   = {1'b0, r_puckY} + {6'b0, cnt[1]};

    // Flat pixel addresses
    wire [13:0] flat1  = {6'd0,  7'b0} | {6'b0,  cnt[6:0]};               // top wall
    wire [13:0] flat2  = {6'd63, 7'b0} | {6'b0,  cnt[6:0]};               // bot wall
    wire [13:0] flat3  = {row3[5:0], 7'b0} | {7'b0, col3[6:0]};           // p1
    wire [13:0] flat4  = {row4[5:0], 7'b0} | {7'b0, col4[6:0]};           // p2
    wire [13:0] flat5  = {py5[5:0],  7'b0} | {7'b0, px5[6:0]};            // puck

    wire ok3 = (row3 < 7'd64);
    wire ok4 = (row4 < 7'd64);
    wire ok5 = (px5  < 8'd128) && (py5 < 7'd64);

    wire inputs_changed = (p1Y[5:0]   != r_p1Y)  ||
                          (p2Y[5:0]   != r_p2Y)  ||
                          (puckX[6:0] != r_puckX) ||
                          (puckY[5:0] != r_puckY);

    always @(posedge clock) begin
        if (reset) begin
            phase    <= 3'd0;
            cnt      <= 8'd0;
            pad_y    <= 4'd0;
            pad_col  <= 2'd0;
            r_p1Y    <= 6'd0;
            r_p2Y    <= 6'd0;
            r_puckX  <= 7'd0;
            r_puckY  <= 6'd0;
            fb       <= 8192'b0;
        end else begin
            case (phase)

                // ---- Phase 0: latch inputs, clear fb ----
                3'd0: begin
                    r_p1Y   <= p1Y[5:0];
                    r_p2Y   <= p2Y[5:0];
                    r_puckX <= puckX[6:0];
                    r_puckY <= puckY[5:0];
                    fb      <= 8192'b0;
                    cnt     <= 8'd0;
                    pad_y   <= 4'd0;
                    pad_col <= 2'd0;
                    phase   <= 3'd1;
                end

                // ---- Phase 1: top wall row 0 ----
                3'd1: begin
                    fb[flat1] <= 1'b1;
                    if (cnt == 8'd127) begin cnt <= 8'd0; phase <= 3'd2; end
                    else                    cnt <= cnt + 8'd1;
                end

                // ---- Phase 2: bottom wall row 63 ----
                3'd2: begin
                    fb[flat2] <= 1'b1;
                    if (cnt == 8'd127) begin cnt <= 8'd0; phase <= 3'd3; end
                    else                    cnt <= cnt + 8'd1;
                end

                // ---- Phase 3: player1 cols 3-5 ----
                3'd3: begin
                    if (ok3) fb[flat3] <= 1'b1;
                    if (pad_col == 2'd2) begin
                        pad_col <= 2'd0;
                        if (pad_y == 4'd13) begin pad_y <= 4'd0; phase <= 3'd4; end
                        else                     pad_y <= pad_y + 4'd1;
                    end else begin
                        pad_col <= pad_col + 2'd1;
                    end
                end

                // ---- Phase 4: player2 cols 122-124 ----
                3'd4: begin
                    if (ok4) fb[flat4] <= 1'b1;
                    if (pad_col == 2'd2) begin
                        pad_col <= 2'd0;
                        if (pad_y == 4'd13) begin pad_y <= 4'd0; cnt <= 8'd0; phase <= 3'd5; end
                        else                     pad_y <= pad_y + 4'd1;
                    end else begin
                        pad_col <= pad_col + 2'd1;
                    end
                end

                // ---- Phase 5: puck 2x2 (cnt 0..3) ----
                // cnt[0]=px offset, cnt[1]=py offset
                3'd5: begin
                    if (ok5) fb[flat5] <= 1'b1;
                    if (cnt == 8'd3) begin cnt <= 8'd0; phase <= 3'd6; end
                    else             cnt <= cnt + 8'd1;
                end

                // ---- Phase 6: idle, restart on input change ----
                3'd6: begin
                    if (inputs_changed) phase <= 3'd0;
                end

                default: phase <= 3'd0;
            endcase
        end
    end

endmodule