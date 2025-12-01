`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 10:42:27 AM
// Design Name: 
// Module Name: decoder
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


module decoder(
    input [4:0] morse_enable,
    input [4:0] morse5,
    input [3:0] morse4,
    input [2:0] morse3,
    input [1:0] morse2,
    input morse1,
    output reg [3:0] decoder_output
    );
    
    parameter n = 5;
    localparam LEN1 = 1;
    localparam LEN2 = 2;
    localparam LEN3 = 3;
    localparam LEN4 = 4;
    localparam LEN5 = 5;
    
    wire [3:0] morse_out [4:0];
    
    wire [4:0] morse_inputs [4:0];
    
    assign morse_inputs[0] = {{(5-LEN1){1'b0}}, morse1};
    assign morse_inputs[1] = {{(5-LEN2){1'b0}}, morse2};
    assign morse_inputs[2] = {{(5-LEN3){1'b0}}, morse3};
    assign morse_inputs[3] = {{(5-LEN4){1'b0}}, morse4};
    assign morse_inputs[4] = {{(5-LEN5){1'b0}}, morse5};
    
    //morse_out[i]
    
    genvar i;
    generate
        for(i = 0; i < n; i = i + 1)
            begin
                translator stage_i(.morse_bits(morse_inputs[i]), .morse_len(i+1), .decoded(morse_out[i]));
            end
    endgenerate
    
    
    always @(*) begin
        case (morse_enable)
            5'b11110: decoder_output = morse_out[0];
            5'b11101: decoder_output = morse_out[1];
            5'b11011: decoder_output = morse_out[2];
            5'b10111: decoder_output = morse_out[3];
            5'b01111: decoder_output = morse_out[4];
            default: decoder_output = 4'b1111;
        endcase
    end
endmodule
