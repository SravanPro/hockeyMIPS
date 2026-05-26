`timescale 1ns / 1ps

module clockDivider(

    input  wire clock,
    input  wire reset,

    input  wire speedInc,
    input  wire speedDec,

    output wire divClock,
    output wire halfClock,
    output wire [3:0] speedOut


);

    // 20-bit free running counter
    reg [19:0] counter;

    // Selects which counter bit becomes divClock
    // Default = 11  -> divide by 2^(11+1)=4096
    reg [4:0] divSelect;

    // Previous button states for edge detection
    reg prevInc, prevDec;

    // Counter always runs
    always @(posedge clock or posedge reset) begin

        if (reset) begin

            counter   <= 20'd0;
            divSelect <= 5'd11;

            prevInc <= 1'b0;
            prevDec <= 1'b0;

        end else begin

            // Free running divider counter
            counter <= counter + 1'b1;

            // Store previous button states
            prevInc <= speedInc;
            prevDec <= speedDec;

            // Positive edge detect for speedInc
            // Move toward smaller divider (faster clock)
            if (speedInc && !prevInc) begin

                if (divSelect > 4)
                    divSelect <= divSelect - 1'b1;

            end

            // Positive edge detect for speedDec
            // Move toward larger divider (slower clock)
            if (speedDec && !prevDec) begin

                if (divSelect < 19)
                    divSelect <= divSelect + 1'b1;

            end

        end

    end

    // Always divide-by-2 clock
    assign halfClock = counter[1];

    // Variable divided clock
    assign divClock = counter[divSelect];
    
    assign speedOut = divSelect - 4;

endmodule