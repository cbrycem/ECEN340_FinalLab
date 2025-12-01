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
    output reg [7:0] decoded
    );
    
    always @(*) begin
        case ({morse_len, morse_bits})
            {3'd2, 5'b00001}: decoded = 8'h0A; //A
            {3'd4, 5'b01000}: decoded = 8'h0B; //B
            {3'd4, 5'b01010}: decoded = 8'h0C; //C
            {3'd3, 5'b00100}: decoded = 8'h0D; //D
            {3'd1, 5'b00000}: decoded = 8'h0E; //E
            {3'd4, 5'b00010}: decoded = 8'h0F; //F
            {3'd3, 5'b00110}: decoded = 8'h10; //G
            {3'd4, 5'b00000}: decoded = 8'h11; //H
            {3'd2, 5'b00000}: decoded = 8'h12; //I
            {3'd4, 5'b00111}: decoded = 8'h13; //J
            {3'd3, 5'b00101}: decoded = 8'h14; //K
            {3'd4, 5'b00100}: decoded = 8'h15; //L
            {3'd2, 5'b00011}: decoded = 8'h16; //M
            {3'd2, 5'b00010}: decoded = 8'h17; //N
            {3'd3, 5'b00111}: decoded = 8'h18; //O
            {3'd4, 5'b00110}: decoded = 8'h19; //P
            {3'd4, 5'b01101}: decoded = 8'h1A; //Q
            {3'd3, 5'b00010}: decoded = 8'h1B; //R
            {3'd3, 5'b00000}: decoded = 8'h1C; //S
            {3'd1, 5'b00001}: decoded = 8'h1D; //T
            {3'd3, 5'b00001}: decoded = 8'h1E; //U
            {3'd4, 5'b00001}: decoded = 8'h1F; //V
            {3'd3, 5'b00011}: decoded = 8'h20; //W
            {3'd3, 5'b01001}: decoded = 8'h21; //X
            {3'd4, 5'b01011}: decoded = 8'h22; //Y
            {3'd4, 5'b01100}: decoded = 8'h23; //Z
    
            {3'd5, 5'b01111}: decoded = 8'h01; //1
            {3'd5, 5'b00111}: decoded = 8'h02; //2
            {3'd5, 5'b00011}: decoded = 8'h03; //3
            {3'd5, 5'b00001}: decoded = 8'h04; //4
            {3'd5, 5'b00000}: decoded = 8'h05; //5
            {3'd5, 5'b10000}: decoded = 8'h06; //6
            {3'd5, 5'b11000}: decoded = 8'h07; //7
            {3'd5, 5'b11100}: decoded = 8'h08; //8
            {3'd5, 5'b11110}: decoded = 8'h09; //9
            {3'd5, 5'b11111}: decoded = 8'h00; //0
            default: decoded = 8'hFF;
        endcase
    end 
endmodule
