`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2025 10:47:21 AM
// Design Name: 
// Module Name: vga_sync
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


module vga_sync(
    input pclk,
    input rst,
    output reg hsync,
    output reg vsync,
    output reg visible,
    output reg [9:0] x, //pixel x
    output reg [9:0] y //pixel y
    );
    
    //timing constraints
    localparam H_VISIBLE = 640;
    localparam H_FRONT = 16;
    localparam H_SYNC = 96;
    localparam H_BACK = 48;
    localparam H_TOTAL = 800;
    
    localparam V_VISIBLE = 480;
    localparam V_FRONT = 10;
    localparam V_SYNC = 2;
    localparam V_BACK = 33;
    localparam V_TOTAL = 525;
    
    reg [10:0] hcount = 0;
    reg [9:0] vcount = 0;
    
    always @(posedge pclk or posedge rst) begin
        if (rst) begin
            hcount <= 0;
            vcount <= 0;
            hsync <= 1;
            vsync <= 1;
            visible <= 0;
            x <= 0;
            y <= 0;
         end else begin 
            if (hcount == H_TOTAL - 1) begin
                hcount <= 0;
                if (vcount == V_TOTAL - 1) vcount <= 0;
                else vcount <= vcount + 1;
            end else hcount <= hcount + 1;
            
            //generate hsync (active low)
            if (hcount >= (H_VISIBLE + H_FRONT) && hcount < (H_VISIBLE + H_FRONT + H_SYNC)) hsync <= 0;
    
    
    
    
    
    
endmodule
