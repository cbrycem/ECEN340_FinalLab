`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2025 10:18:28 AM
// Design Name: 
// Module Name: morse_code_tb
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


module morse_code_tb(

    );
    
    reg clk = 0;
    reg btnU = 0;   //Send
    reg btnD = 0;   //Clear
    reg btnL = 0;   //Dot = 0
    reg btnR = 0;   //Dash = 1
    wire [6:0] seg;
    wire dp;
    wire [3:0] an;
    wire [15:0] led;
    
    morse_code U1 (clk, btnU, btnD, btnL, btnR, seg, dp, an, led);
    
    initial forever
    #5 clk = ~clk; 
    
    initial
    begin
        btnD = 1;
        #20 btnD = 0;
        #20 btnL = 1;       //Test "A"
        #20 btnL = 0;
        #20 btnR = 1;
        #20 btnR = 0;
        #20 btnU = 1;
        #20 btnU = 0;
        
        #20 btnR = 1;   //Test Clear and "B"
        #20 btnR = 0;
        #20 btnL = 1;
        #20 btnL = 0;
        #20 btnD = 1;
        #20 btnD = 0;
        #20 btnR = 1;
        #20 btnR = 0;
        #20 btnL = 1;
        #20 btnL = 0;
        #20 btnL = 1;
        #20 btnL = 0;
        #20 btnL = 1;
        #20 btnL = 0;
        #20 btnU = 1;
        #20 btnU = 0;
        
        #20 btnU = 1;   //Space
        #20 btnU = 0;
        
        #20 btnL = 1;   //Send a "1"
        #20 btnL = 0;
        #20 btnR = 1;
        #20 btnR = 0;
        #20 btnR = 1;
        #20 btnR = 0;
        #20 btnR = 1;
        #20 btnR = 0;
        #20 btnR = 1;
        #20 btnR = 0;
        #20 btnU = 1;
        #20 btnU = 0;
        
        #50 $finish;
    end
    
endmodule
