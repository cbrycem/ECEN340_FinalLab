`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2025 10:21:15 AM
// Design Name: 
// Module Name: clk_gen
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


module clk_gen(
    input clk,
    output reg clk_out,
    output clk_div
    );
    
    reg [17:0] refresh_counter = 18'b000000000000000000; //To allow us to push to only one 7-seg display at a time
    reg [1:0] d = 2'd0;
    
    always @(posedge clk) begin     //Clock to change refresh_counter to determine which 7-seg to push to
       
//        if (rst)
//            refresh_counter <= 18'b000000000000000000;
//        else
        refresh_counter <= refresh_counter +1;
        d <= d + 1;
        if ( d == 2'd1) clk_out <= ~clk_out;
            
    end 
    
    assign clk_div = refresh_counter[16];
    
    
endmodule
