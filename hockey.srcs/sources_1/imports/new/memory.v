`timescale 1ns / 1ps



module memory #(parameter memorySizeInBytes = 0, parameter ioWidth = 256)
(
    input  wire        clock, reset,
    input  wire        memWrite, memRead,
    input  wire [31:0] address,
    input  wire [31:0] writeData,
    input  wire [ioWidth-1:0] memMappedIO,
    output reg  [31:0] readData,
    output reg [8191:0] framebuffer
);
    integer i;
    reg [7:0] mem [memorySizeInBytes-1:0];

    initial begin
        for (i = 0; i < memorySizeInBytes; i = i + 1)
            mem[i] = 8'h00;
    end

    always @(*) begin
        if (memRead) begin
            if (address[31:8] != 24'hFFFFFF) begin
                readData = {mem[address], mem[address+1], mem[address+2], mem[address+3]};
            end else begin
                if (address[7:0] < ioWidth)
                    readData = {32{memMappedIO[address[7:0]]}};
                else
                    readData = 32'b0;
            end
        end else begin
            readData = 32'b0;
        end
    end

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            for (i = 0; i < memorySizeInBytes; i = i + 1)
                mem[i] <= 8'h00;
        end else begin
            if (memWrite && address[31:8] != 24'hFFFFFF) begin
                mem[address]   <= writeData[31:24];
                mem[address+1] <= writeData[23:16];
                mem[address+2] <= writeData[15:8];
                mem[address+3] <= writeData[7:0];
            end
        end
    end

    integer w;
    always @(*) begin
        for (w = 0; w < 256; w = w + 1) begin
            framebuffer[w*32 +: 32] = {mem[512 + w*4],
                                        mem[512 + w*4 + 1],
                                        mem[512 + w*4 + 2],
                                        mem[512 + w*4 + 3]};
        end
    end

endmodule