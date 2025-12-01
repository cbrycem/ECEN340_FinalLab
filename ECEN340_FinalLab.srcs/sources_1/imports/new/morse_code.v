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
    output reg [15:0] led
    );
    
    wire clkd;
    wire [3:0] decoder_output;
    reg [3:0] digit0 = 4'hF;
    reg [3:0] digit1 = 4'hF;
    reg [3:0] digit2 = 4'hF;
    reg [3:0] digit3 = 4'hF;
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
    
    always @(posedge clk) begin
    
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
//    reg [4:0] morse_inputs [4:0];
//    always @(posedge clkd) begin
//        morse_inputs[0] = {{(4){1'b0}}, morse1};
//        morse_inputs[1] = {{(3){1'b0}}, morse2};
//        morse_inputs[2] = {{(2){1'b0}}, morse3};
//        morse_inputs[3] = {{(1){1'b0}}, morse4};
//        morse_inputs[4] = {{(0){1'b0}}, morse5};
//    end
    
//    always @(posedge clk) begin
//        led <= 16'h0000;
//        case (morse_enable)
//            5'b11110: begin 
//                if (morse1 == 0)
//                    led[0] <= 1'b1;
//                else
//                    led[1:0] <= 2'b11;
//            end
//            5'b11101: begin 
//                if (morse2[1] == 1'b0)
//                    led[0] <= 1'b1; 
//                else
//                    led[1:0] <= 2'b11;
//                if (morse2[0] == 1'b0)
//                    led[3] <= 1'b1;
//                else
//                    led[4:3] <= 2'b11;
//            end
//            5'b11011: begin 
//                if (morse3[2] == 1'b0)
//                    led[0] <= 1'b1; 
//                else
//                    led[1:0] <= 2'b11;
//                if (morse3[1] == 1'b0)
//                    led[3] <= 1'b1;
//                else
//                    led[4:3] <= 2'b11;
//                if (morse3[0] == 1'b0)
//                    led[6] <= 1'b1;
//                else
//                    led[7:6] <= 2'b11;
//            end
//            5'b10111: begin 
//                if (morse4[3] == 1'b0)
//                    led[0] <= 1'b1; 
//                else
//                    led[1:0] <= 2'b11;
//                if (morse4[2] == 1'b0)
//                    led[3] <= 1'b1;
//                else
//                    led[4:3] <= 2'b11;
//                if (morse4[1] == 1'b0)
//                    led[6] <= 1'b1;
//                else
//                    led[7:6] <= 2'b11;
//                if (morse4[0] == 1'b0)
//                    led[9] <= 1'b1;
//                else
//                    led[10:9] <= 2'b11;
//            end
//            5'b01111: begin 
//                if (morse5[4] == 1'b0)
//                    led[0] <= 1'b1; 
//                else
//                    led[1:0] <= 2'b11;
//                if (morse5[3] == 1'b0)
//                    led[3] <= 1'b1;
//                else
//                    led[4:3] <= 2'b11;
//                if (morse5[2] == 1'b0)
//                    led[6] <= 1'b1;
//                else
//                    led[7:6] <= 2'b11;
//                if (morse5[1] == 1'b0)
//                    led[9] <= 1'b1;
//                else
//                    led[10:9] <= 2'b11;
//                if (morse5[0] == 1'b0)
//                    led[12] <= 1'b1;
//                else
//                    led[13:12] <= 2'b11;
//            end
//        endcase
//    end
    
    assign dp = 1'b1;       //Turn off decimal
//    always @(posedge clk) begin
//        if(btnU_edge) begin
//            digit0 <= decoder_output; //recombined_data[3:0];     //Set the new value to our 4 sets of bit
//            digit1 <= digit0; //recombined_data[7:4];
//            digit2 <= digit1; //recombined_data[11:8];
//            digit3 <= digit2; //recombined_data[15:12];
//            morse_enable <= 5'b11111;
//            morse5 <= 5'b00000;
//            morse4 <= 4'b0000;
//            morse3 <= 3'b000;
//            morse2 <= 2'b00;
//            morse1 <= 1'b0;
//        end
//    end
    
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
    
    reg [3:0] current_digit;
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
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            4'hA: seg = 7'b0001000;
            4'hB: seg = 7'b0000011;
            4'hC: seg = 7'b1000110;
            4'hD: seg = 7'b0100001;
            4'hE: seg = 7'b0001100;
            4'hF: seg = 7'b1111111; //Space
            default: seg = 7'b1111111;
        endcase
    end
    
    
endmodule
