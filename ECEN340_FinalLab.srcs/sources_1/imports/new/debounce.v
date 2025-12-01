`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2025 11:11:42 AM
// Design Name: 
// Module Name: debounce
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


module debounce #(
    parameter WIDTH = 1,
    parameter COUNT_MAX = 1_000_000  // ~5ms at 100 MHz clock
)(
    input clk,
    input [WIDTH-1:0] noisy,
    output reg [WIDTH-1:0] clean
);
    reg [WIDTH-1:0] sync_0;
    reg [WIDTH-1:0] sync_1;
    reg [$clog2(COUNT_MAX):0] count [WIDTH-1:0];

    integer i;
    always @(posedge clk) begin
        for (i = 0; i < WIDTH; i = i + 1) begin
            // Synchronize to clock domain (avoid metastability)
            sync_0[i] <= noisy[i];
            sync_1[i] <= sync_0[i];

            // Debounce counter
            if (sync_1[i] == clean[i]) begin
                count[i] <= 0;
            end else begin
                count[i] <= count[i] + 1;
                if (count[i] >= COUNT_MAX)
                    clean[i] <= sync_1[i];
            end
        end
    end
endmodule

