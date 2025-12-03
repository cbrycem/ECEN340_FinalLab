`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 10:01:22 AM
// Design Name: 
// Module Name: morse_code
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


module morse_code(
    input clk,
    input btnU, //Send
    input btnD, //Clear
    input btnL, //Dot = 0
    input btnR, //Dash = 1
    output reg [6:0] seg,
    output dp,
    output reg [3:0] an,
    output reg [15:0] led,
    
    //Outputs for the VGA
    output reg [4:0] curr_morse_bits,
    output reg [2:0] curr_morse_len,
    output sent_pulse,
    output [7:0] decoded_out
    );
    
    wire clkd;
    wire [7:0] decoder_output;
    reg [7:0] digit0 = 8'hFF;
    reg [7:0] digit1 = 8'hFF;
    reg [7:0] digit2 = 8'hFF;
    reg [7:0] digit3 = 8'hFF;
    reg [4:0] morse_enable = 5'b11111;
    reg [4:0] morse5 = 5'b00000;
    reg [3:0] morse4 = 4'b0000;
    reg [2:0] morse3 = 3'b000;
    reg [1:0] morse2 = 2'b00;
    reg morse1 = 1'b0;
    reg btnL_prev = 0, btnR_prev = 0, btnD_prev = 0, btnU_prev = 0;
    wire btnL_edge, btnR_edge, btnD_edge, btnU_edge;
    wire btnU_db, btnD_db, btnL_db, btnR_db;

    debounce #(.WIDTH(4), .COUNT_MAX(1_000_000)) db_inst (
        .clk(clk),
        .noisy({btnU, btnD, btnL, btnR}),
        .clean({btnU_db, btnD_db, btnL_db, btnR_db})
    );
    
    clk_gen U1 (.clk(clk), .clk_div(clkd));
    
    reg [1:0] digit_select = 2'b00;     //This is to choose which of the 4 7-segs to push to
    
    always @(posedge clk) begin
        // simple edge detectors
        btnL_prev <= btnL_db;
        btnR_prev <= btnR_db;
        btnD_prev <= btnD_db;
        btnU_prev <= btnU_db;
    end
    
    assign btnL_edge = btnL_db & ~btnL_prev;
    assign btnR_edge = btnR_db & ~btnR_prev;
    assign btnD_edge = btnD_db & ~btnD_prev;
    assign btnU_edge = btnU_db & ~btnU_prev;
    
    reg sent_pulse_r;
    assign sent_pulse = sent_pulse_r;
    
    always @(posedge clk) begin
    
        sent_pulse_r <= 1'b0;
        if (btnD_edge) begin
            // clear
            morse_enable <= 5'b11111;
            morse1 <= 1'b0;
            morse2 <= 2'b00;
            morse3 <= 3'b000;
            morse4 <= 4'b0000;
            morse5 <= 5'b00000;
            led <= 16'h0000;
        end
        else if (btnL_edge) begin
            // dot
            case (morse_enable)
                5'b11111: begin morse_enable <= 5'b11110; morse1 <= 1'b0; end
                5'b11110: begin morse_enable <= 5'b11101; morse2 <= {morse1, 1'b0}; end
                5'b11101: begin morse_enable <= 5'b11011; morse3 <= {morse2, 1'b0}; end
                5'b11011: begin morse_enable <= 5'b10111; morse4 <= {morse3, 1'b0}; end
                5'b10111: begin morse_enable <= 5'b01111; morse5 <= {morse4, 1'b0}; end
            endcase
        end
        else if (btnR_edge) begin
            // dash
            case (morse_enable)
                5'b11111: begin morse_enable <= 5'b11110; morse1 <= 1'b1; end
                5'b11110: begin morse_enable <= 5'b11101; morse2 <= {morse1, 1'b1}; end
                5'b11101: begin morse_enable <= 5'b11011; morse3 <= {morse2, 1'b1}; end
                5'b11011: begin morse_enable <= 5'b10111; morse4 <= {morse3, 1'b1}; end
                5'b10111: begin morse_enable <= 5'b01111; morse5 <= {morse4, 1'b1}; end
            endcase
        end
        else if(btnU_edge) begin
            digit0 <= decoder_output; //recombined_data[3:0];     //Set the new value to our 4 sets of bit
            digit1 <= digit0; //recombined_data[7:4];
            digit2 <= digit1; //recombined_data[11:8];
            digit3 <= digit2; //recombined_data[15:12];
            morse_enable <= 5'b11111;
            morse5 <= 5'b00000;
            morse4 <= 4'b0000;
            morse3 <= 3'b000;
            morse2 <= 2'b00;
            morse1 <= 1'b0;
            sent_pulse_r <= 1'b1;
        end
        
        led <= 16'h0000;
        case (morse_enable)
            5'b11110: begin 
                if (morse1 == 0)
                    led[0] <= 1'b1;
                else
                    led[1:0] <= 2'b11;
            end
            5'b11101: begin 
                if (morse2[1] == 1'b0)
                    led[0] <= 1'b1; 
                else
                    led[1:0] <= 2'b11;
                if (morse2[0] == 1'b0)
                    led[3] <= 1'b1;
                else
                    led[4:3] <= 2'b11;
            end
            5'b11011: begin 
                if (morse3[2] == 1'b0)
                    led[0] <= 1'b1; 
                else
                    led[1:0] <= 2'b11;
                if (morse3[1] == 1'b0)
                    led[3] <= 1'b1;
                else
                    led[4:3] <= 2'b11;
                if (morse3[0] == 1'b0)
                    led[6] <= 1'b1;
                else
                    led[7:6] <= 2'b11;
            end
            5'b10111: begin 
                if (morse4[3] == 1'b0)
                    led[0] <= 1'b1; 
                else
                    led[1:0] <= 2'b11;
                if (morse4[2] == 1'b0)
                    led[3] <= 1'b1;
                else
                    led[4:3] <= 2'b11;
                if (morse4[1] == 1'b0)
                    led[6] <= 1'b1;
                else
                    led[7:6] <= 2'b11;
                if (morse4[0] == 1'b0)
                    led[9] <= 1'b1;
                else
                    led[10:9] <= 2'b11;
            end
            5'b01111: begin 
                if (morse5[4] == 1'b0)
                    led[0] <= 1'b1; 
                else
                    led[1:0] <= 2'b11;
                if (morse5[3] == 1'b0)
                    led[3] <= 1'b1;
                else
                    led[4:3] <= 2'b11;
                if (morse5[2] == 1'b0)
                    led[6] <= 1'b1;
                else
                    led[7:6] <= 2'b11;
                if (morse5[1] == 1'b0)
                    led[9] <= 1'b1;
                else
                    led[10:9] <= 2'b11;
                if (morse5[0] == 1'b0)
                    led[12] <= 1'b1;
                else
                    led[13:12] <= 2'b11;
            end
        endcase
        
    end
    
    decoder U2 (.morse_enable(morse_enable), .morse5(morse5), .morse4(morse4), .morse3(morse3), .morse2(morse2), .morse1(morse1), .decoder_output(decoder_output));

    assign dp = 1'b1;       //Turn off decimal
    
    always @(posedge clkd) begin       //Assign our digit_select
        digit_select = digit_select + 1;
    end   
    
    always @(digit_select) begin       //Turn on the right 7-seg display
        case (digit_select)
            2'b00: an = 4'b1110;
            2'b01: an = 4'b1101;
            2'b10: an = 4'b1011;
            2'b11: an = 4'b0111;
        endcase
    end
    
    reg [7:0] current_digit;
    always @(*) begin       //Get the current digit for the current display
        case(digit_select)
            2'b00: current_digit = digit0;
            2'b01: current_digit = digit1;
            2'b10: current_digit = digit2;
            2'b11: current_digit = digit3;
        endcase
    end
    
    always @(current_digit) begin       //Assign to display
        case(current_digit)
            8'h00: seg = 7'b1000000; //0
            8'h01: seg = 7'b1111001; //1
            8'h02: seg = 7'b0100100; //2
            8'h03: seg = 7'b0110000; //3
            8'h04: seg = 7'b0011001; //4
            8'h05: seg = 7'b0010010; //5
            8'h06: seg = 7'b0000010; //6
            8'h07: seg = 7'b1111000; //7
            8'h08: seg = 7'b0000000; //8
            8'h09: seg = 7'b0010000; //9
            8'h0A: seg = 7'b0001000; //A
            8'h0B: seg = 7'b0000011; //B
            8'h0C: seg = 7'b1000110; //C
            8'h0D: seg = 7'b0100001; //D
            8'h0E: seg = 7'b0000110; //E
            8'h0F: seg = 7'b0001110; //F
            8'h10: seg = 7'b1000010; //g
            8'h11: seg = 7'b0001001; //H 
            8'h12: seg = 7'b1111001; //I
            8'h13: seg = 7'b1110001; //J
            8'h14: seg = 7'b0001010; //K 
            8'h15: seg = 7'b1000111; //L
            8'h16: seg = 7'b0101010; //M
            8'h17: seg = 7'b0101011; //n
            8'h18: seg = 7'b1000000; //o 
            8'h19: seg = 7'b0001100; //P
            8'h1A: seg = 7'b0011000; //Q
            8'h1B: seg = 7'b0101111; //R
            8'h1C: seg = 7'b0010010; //S
            8'h1D: seg = 7'b0000111; //T
            8'h1E: seg = 7'b1000001; //U
            8'h1F: seg = 7'b1100011; //V
            8'h20: seg = 7'b0010101; //W
            8'h21: seg = 7'b1101011; //X
            8'h22: seg = 7'b0010001; //Y
            8'h23: seg = 7'b0100100; //Z
            
            default: seg = 7'b1111111; //default case
        endcase
    end
    
    //Output assignments fro VGA port
//    always @(*) begin
//        curr_morse_bits = 5'b00000;
//        if (morse_enable != 5'b11111) begin
//            if (morse_enable == 5'b11110) curr_morse_bits = {4'b0000, morse1}; //len = 1 at LSB
            
    
    
endmodule
