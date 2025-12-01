`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 10:59:26 AM
// Design Name: 
// Module Name: translator
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


module translator(
    input [4:0] morse_bits,
    input [2:0] morse_len,
    output reg [3:0] decoded
    );
    
    always @(*) begin
        case ({morse_len, morse_bits})
            {3'd2, 5'b00001}: decoded = 4'hA; //A
            {3'd4, 5'b01000}: decoded = 4'hB; //B
            {3'd4, 5'b01010}: decoded = 4'hC; //C
            {3'd5, 5'b01111}: decoded = 4'h1; //1
            {3'd5, 5'b00111}: decoded = 4'h2; //2
            {3'd5, 5'b00011}: decoded = 4'h3; //3
            {3'd4, 5'b00110}: decoded = 4'hE; //P
            {3'd5, 5'b11111}: decoded = 4'h0; //0
            {3'd3, 5'b00111}: decoded = 4'h0; //O
            default: decoded = 4'hF;
        endcase
    end 
endmodule
