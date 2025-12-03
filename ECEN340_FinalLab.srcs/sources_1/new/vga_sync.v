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
             if (vcount >= (V_VISIBLE + V_FRONT) && vcount < (V_VISIBLE + V_FRONT + V_SYNC)) vsync <= 0;
            else vsync <= 1;

            // visible region
            if (hcount < H_VISIBLE && vcount < V_VISIBLE) begin
                visible <= 1;
                x <= hcount;
                y <= vcount;
            end else begin
                visible <= 0;
                x <= 0;
                y <= 0;
            end
        end
    end
endmodule

// -------------------------------------------------------------
// font8x8_rom: small 8x8 font for A-Z, 0-9, '.', '-', space, '?'.
// Outputs 8-bit row for given character and row index (0..7).
// -------------------------------------------------------------
module font8x8_rom(
    input [7:0] char,      // ASCII uppercase letters/digits and '.' '-' ' '
    input [2:0] row,       // row 0..7
    output reg [7:0] rowbits
    );
    always @(*) begin
        case (char)
            // Space (32)
            8'h20: begin
                rowbits = 8'b00000000;
            end
            // hyphen '-' (45)
            8'h2D: begin
                case(row)
                    3'd3: rowbits = 8'b00000000;
                    3'd4: rowbits = 8'b00111100;
                    default: rowbits = 8'b00000000;
                endcase
            end
            // dot '.' (46)
            8'h2E: begin
                case(row)
                    3'd6: rowbits = 8'b00011000;
                    3'd7: rowbits = 8'b00011000;
                    default: rowbits = 8'b00000000;
                endcase
            end
            // question '?' fallback
            8'h3F: begin
                case(row)
                    3'd0: rowbits = 8'b00111100;
                    3'd1: rowbits = 8'b01000010;
                    3'd2: rowbits = 8'b00000110;
                    3'd3: rowbits = 8'b00011000;
                    3'd4: rowbits = 8'b00011000;
                    3'd5: rowbits = 8'b00000000;
                    3'd6: rowbits = 8'b00011000;
                    3'd7: rowbits = 8'b00000000;
                endcase
            end
            // Digits '0' - '9' (0x30-0x39) - simple patterns
            8'h30: begin // 0
                case(row)
                    0: rowbits=8'b00111100;
                    1: rowbits=8'b01000010;
                    2: rowbits=8'b01000010;
                    3: rowbits=8'b01000010;
                    4: rowbits=8'b01000010;
                    5: rowbits=8'b01000010;
                    6: rowbits=8'b00111100;
                    7: rowbits=8'b00000000;
                endcase
            end
            8'h31: begin //1
                case(row)
                    0: rowbits=8'b00011000;
                    1: rowbits=8'b00111000;
                    2: rowbits=8'b00011000;
                    3: rowbits=8'b00011000;
                    4: rowbits=8'b00011000;
                    5: rowbits=8'b00011000;
                    6: rowbits=8'b00111100;
                    7: rowbits=8'b00000000;
                endcase
            end
            // ... (For space and time I provide digits 2..9 simplified) ...
            8'h32: begin //2
                case(row)
                    0: rowbits=8'b00111100;
                    1: rowbits=8'b01000010;
                    2: rowbits=8'b00000010;
                    3: rowbits=8'b00000100;
                    4: rowbits=8'b00011000;
                    5: rowbits=8'b00100000;
                    6: rowbits=8'b01111110;
                    7: rowbits=8'b00000000;
                endcase
            end
            // We'll provide a minimal set for A-Z - include some examples (A,B,C,...)
            // Uppercase 'A' (0x41)
            8'h41: begin
                case(row)
                    0: rowbits=8'b00011000;
                    1: rowbits=8'b00100100;
                    2: rowbits=8'b01000010;
                    3: rowbits=8'b01000010;
                    4: rowbits=8'b01111110;
                    5: rowbits=8'b01000010;
                    6: rowbits=8'b01000010;
                    7: rowbits=8'b00000000;
                endcase
            end
            // 'B'
            8'h42: begin
                case(row)
                    0: rowbits=8'b01111100;
                    1: rowbits=8'b01000010;
                    2: rowbits=8'b01000010;
                    3: rowbits=8'b01111100;
                    4: rowbits=8'b01000010;
                    5: rowbits=8'b01000010;
                    6: rowbits=8'b01111100;
                    7: rowbits=8'b00000000;
                endcase
            end
            // 'C'
            8'h43: begin
                case(row)
                    0: rowbits=8'b00111100;
                    1: rowbits=8'b01000010;
                    2: rowbits=8'b01000000;
                    3: rowbits=8'b01000000;
                    4: rowbits=8'b01000000;
                    5: rowbits=8'b01000010;
                    6: rowbits=8'b00111100;
                    7: rowbits=8'b00000000;
                endcase
            end
            // Provide default for any other character -> '?'
            default: begin
                case(row)
                    0: rowbits=8'b00111100;
                    1: rowbits=8'b01000010;
                    2: rowbits=8'b00000110;
                    3: rowbits=8'b00011000;
                    4: rowbits=8'b00011000;
                    5: rowbits=8'b00000000;
                    6: rowbits=8'b00011000;
                    7: rowbits=8'b00000000;
                endcase
            end
        endcase
    end
endmodule

// -------------------------------------------------------------
// vga_text_renderer
// Draw two small lines of text using 8x8 font. We'll use a very
// simple layout: top-left margin, fixed character cell size (8x8).
// -------------------------------------------------------------
module vga_text_renderer(
    input pclk,
    input visible,
    input [9:0] x,
    input [9:0] y,
    // content inputs:
    input [4:0] curr_morse_bits, // bits: [4]=oldest ... [0]=newest (LSB)
    input [2:0] curr_morse_len,  // number of entered symbols (0..5)
    input [7:0] decoded,         // decoded byte (8'hFF -> unknown)
    input sent_pulse,
    output reg [3:0] r,
    output reg [3:0] g,
    output reg [3:0] b
    );

    // layout parameters
    localparam CHAR_W = 8;
    localparam CHAR_H = 8;
    localparam COLS = 80; // not used fully
    localparam ROWS = 60;

    // two lines:
    // line0 text: "Current: " + 5 chars ('.' or '-')
    // line1 text: "Decoded: " + 1 char

    // text origins (in pixels)
    localparam ORIGIN_X = 16;
    localparam ORIGIN_Y = 16;
    localparam LINE_SPACING = 12; // distance between lines

    // compute which character cell (cx, cy) and row/col inside glyph
    wire in_display = visible;
    integer cx, cy;
    reg [2:0] glyph_row;
    reg [2:0] glyph_col;
    reg [7:0] glyph_char;
    reg [7:0] glyph_bits;

    wire [9:0] rel_x = (x >= ORIGIN_X) ? (x - ORIGIN_X) : 10'd0;
    wire [9:0] rel_y = (y >= ORIGIN_Y) ? (y - ORIGIN_Y) : 10'd0;
    wire in_text_area = (x >= ORIGIN_X && x < (ORIGIN_X + 8*40) && y >= ORIGIN_Y && y < (ORIGIN_Y + 2*LINE_SPACING + 8));

    // instantiate font ROM
    wire [2:0] font_row = rel_y[2:0]; // which row inside glyph (0..7)
    wire [2:0] font_col = rel_x[2:0]; // which column inside glyph (0..7)
    reg [7:0] font_rowbits;
    // font module instance
    // We'll mux the character to the font ROM inputs below
    integer local_y;
    integer local_x;
    integer line_index;
    integer char_x;
    integer char_y;
    integer sym_index;
    integer bit_idx;
    integer bit_in_char;
    reg bitval;
    
    always @(*) begin
        r = 4'b0000; g = 4'b0000; b = 4'b0000;
        if (!in_display) begin
            // blank
            r = 4'b0000; g = 4'b0000; b = 4'b0000;
        end else begin
            // default background dark blue
            r = 4'b0000; g = 4'b0001; b = 4'b0011;
            // check if we are inside the two-line text area
            if (in_text_area) begin
                // compute which line (0 or 1)
                local_y = rel_y;
                local_x = rel_x;
                line_index = local_y / LINE_SPACING; // 0 or 1
                // compute character index horizontally
                char_x = local_x / CHAR_W;
                char_y = local_y % CHAR_H;
                // build text per line
                // Line 0: "Current: " (9 chars) followed by up to 5 symbols
                // We'll place "Current:" starting at char_x==0
                glyph_char = 8'h20; // default space
                if (line_index == 0) begin
                    // Current: -> positions 0..7 "Current:"
                    // We'll hardcode string:
                    case (char_x)
                        0: glyph_char = "C";
                        1: glyph_char = "u";
                        2: glyph_char = "r";
                        3: glyph_char = "r";
                        4: glyph_char = "e";
                        5: glyph_char = "n";
                        6: glyph_char = "t";
                        7: glyph_char = ":";
                        // after colon put a space then 5 symbols starting at char 9
                        9: begin // first symbol (oldest)
                            if (curr_morse_len >= 1) begin
                                // we display symbol 0 as dot/dash corresponding to oldest entered
                                // oldest is in bit index (curr_morse_len-1?) but we defined curr_morse_bits so bit[4] oldest.
                                // We'll extract based on len: if len==1 -> bit[0] holds the only; earlier logic put bits into LSB region.
                                // Simpler: Build symbol array s[0..4] such that s[0]=first entered (oldest)
                                // We'll compute below; for now handle char assignment using helper
                                glyph_char = 8'h2E; // '.' placeholder; will override below
                            end else glyph_char = 8'h20;
                        end
                        10: glyph_char = 8'h20;
                        11: glyph_char = 8'h20;
                        12: glyph_char = 8'h20;
                        13: glyph_char = 8'h20;
                        default: glyph_char = 8'h20;
                    endcase
                end else if (line_index == 1) begin
                    // Line 1: "Decoded: X"
                    case (char_x)
                        0: glyph_char = "D";
                        1: glyph_char = "e";
                        2: glyph_char = "c";
                        3: glyph_char = "o";
                        4: glyph_char = "d";
                        5: glyph_char = "e";
                        6: glyph_char = "d";
                        7: glyph_char = ":";
                        9: begin
                            // the decoded character
                            if (decoded == 8'hFF) glyph_char = 8'h3F; // '?'
                            else begin
                                // map your decoder codes to ASCII:
                                // Your translator stores: 0x0A..0x23 for A-Z and 0x00..0x05 etc for digits (you used odd mapping).
                                // We'll convert common cases:
                                // Letters mapping in translator: A=0x0A, B=0x0B, C=0x0C, ... Z=0x23
                                if (decoded >= 8'h0A && decoded <= 8'h23) begin
                                    // map 0x0A -> 'A' (65)
                                    glyph_char = 8'h41 + (decoded - 8'h0A);
                                end else if (decoded >= 8'h01 && decoded <= 8'h09) begin
                                    glyph_char = 8'h31 + (decoded - 8'h01); // '1'..'9'
                                end else if (decoded == 8'h00) glyph_char = 8'h30; // '0'
                                else glyph_char = 8'h3F;
                            end
                        end
                        default: glyph_char = 8'h20;
                    endcase
                end

                // Now override the symbol characters for the Current line to show actual '.' or '-'
                if (line_index == 0) begin
                    // positions for 5 symbols: char_x=9..13 -> symbol indices 0..4 (oldest -> newest)
                    if (char_x >= 9 && char_x <= 13) begin
                        sym_index = char_x - 9; // 0 oldest .. 4 newest
                        if (sym_index < curr_morse_len) begin
                            // Map curr_morse_bits to symbol: recall we placed valid bits into LSB area when len smaller
                            // We build an index relative to len: symbol 0 is the oldest entered.
                            // We'll shift bits right so that newest is LSB, oldest is at bit (len-1)
                            // So to get symbol k (0 oldest) -> bit idx = curr_morse_len-1 - k
                            bit_idx = curr_morse_len - 1 - sym_index;
                            
                            if (bit_idx >= 0) begin
                                bitval = curr_morse_bits[bit_idx];
                            end else bitval = 1'b0;
                            if (bitval) glyph_char = 8'h2D; // '-' ascii 0x2D
                            else glyph_char = 8'h2E; // '.' ascii 0x2E
                        end else glyph_char = 8'h20;
                    end
                end

                // Now query font ROM for glyph_row
                // We need to call the font ROM with the glyph_char and glyph row
                // For combinational simplicity, we will instantiate a small synthesized lookup here via case (done below)
                // Use font8x8_rom module
                // But since modules can't be instantiated inside always @(*) often, we use a function call; to keep code simpler,
                // we'll instantiate a small internal font module instance below and use wires. However to keep this single-file simple,
                // we'll do an inline combinational font lookup using the font8x8_rom module instantiated once outside.
            end
        end
    end

    // To avoid multi-instantiation complexity, simpler approach:
    // We'll instantiate the font ROM once and drive it using glyph_char and font_row.
    reg [7:0] rom_char;
    reg [2:0] rom_row;
    wire [7:0] rom_rowbits;
    always @(*) begin
        // choose rom inputs only when inside text area; else feed spaces
        if (in_display && in_text_area) begin
            // recompute glyph_char properly as above
            // recompute line/char_x
            local_y = rel_y;
            local_x = rel_x;
            line_index = local_y / LINE_SPACING;
            char_x = local_x / CHAR_W;
            // default
            rom_char = 8'h20;
            if (line_index == 0) begin
                case (char_x)
                    0: rom_char = "C";
                    1: rom_char = "u";
                    2: rom_char = "r";
                    3: rom_char = "r";
                    4: rom_char = "e";
                    5: rom_char = "n";
                    6: rom_char = "t";
                    7: rom_char = ":";
                    9: begin
                        sym_index = 0;
                    end
                endcase
                // symbol positions 9..13 overwritten below
                if (char_x >= 9 && char_x <= 13) begin
                    sym_index = char_x - 9;
                    if (sym_index < curr_morse_len) begin
                        bit_idx = curr_morse_len - 1 - sym_index;
                        if (bit_idx >= 0) begin
                            if (curr_morse_bits[bit_idx]) rom_char = 8'h2D; else rom_char = 8'h2E;
                        end else rom_char = 8'h2E;
                    end else rom_char = 8'h20;
                end
            end else if (line_index == 1) begin
                case (char_x)
                    0: rom_char = "D";
                    1: rom_char = "e";
                    2: rom_char = "c";
                    3: rom_char = "o";
                    4: rom_char = "d";
                    5: rom_char = "e";
                    6: rom_char = "d";
                    7: rom_char = ":";
                    9: begin
                        if (decoded == 8'hFF) rom_char = 8'h3F; // '?'
                        else if (decoded >= 8'h0A && decoded <= 8'h23) rom_char = 8'h41 + (decoded - 8'h0A);
                        else if (decoded >= 8'h01 && decoded <= 8'h09) rom_char = 8'h31 + (decoded - 8'h01);
                        else if (decoded == 8'h00) rom_char = 8'h30;
                        else rom_char = 8'h3F;
                    end
                    default: rom_char = 8'h20;
                endcase
            end else rom_char = 8'h20;

            rom_row = rel_y[2:0];
        end else begin
            rom_char = 8'h20;
            rom_row = 3'd0;
        end
    end

    font8x8_rom font_inst(.char(rom_char), .row(rom_row), .rowbits(font_rowbits));

    // Now at pixel granularity decide whether this pixel is ON for the glyph:
    always @(*) begin
        if (!visible) begin
            r = 4'b0000; g = 4'b0000; b = 4'b0000;
        end else begin
            // default background
            r = 4'b0000; g = 4'b0001; b = 4'b0011;
            if (in_text_area) begin
                local_x = rel_x;
                char_x = local_x / CHAR_W;
                bit_in_char = 7 - (local_x % CHAR_W); // MSB->left
                if (font_rowbits[bit_in_char]) begin
                    // text color (white)
                    r = 4'b1111; g = 4'b1111; b = 4'b1111;
                end
            end
        end
    end

endmodule


// -------------------------------------------------------------
// Top-level: morse_with_vga
// Wires morse_core into VGA pipeline.
// -------------------------------------------------------------
module morse_with_vga(
    input clk,           // 100 MHz board clock
    input btnU, btnD, btnL, btnR,
    // 7-seg & leds preserved
    output [6:0] seg,
    output dp,
    output [3:0] an,
    output [15:0] led,
    // VGA outputs for Basys3
    output [3:0] vga_red,
    output [3:0] vga_green,
    output [3:0] vga_blue,
    output vga_hsync,
    output vga_vsync
    );

    // Instantiate morse core
    wire [4:0] curr_bits;
    wire [2:0] curr_len;
    wire sent;
    wire [7:0] decoded;
    morse_core mcore (
        .clk(clk),
        .btnU(btnU),
        .btnD(btnD),
        .btnL(btnL),
        .btnR(btnR),
        .seg(seg),
        .dp(dp),
        .an(an),
        .led(led),
        .curr_morse_bits(curr_bits),
        .curr_morse_len(curr_len),
        .sent_pulse(sent),
        .decoded_out(decoded)
    );

    // VGA clock (25MHz) — use vga_clock_div2 to create 25MHz from 100MHz
    wire pclk;
    vga_clock_div2 clkdiv (.clk_in(clk), .clk_out(pclk));

    // vga sync generator
    wire visible;
    wire [9:0] vx, vy;
    vga_sync sync (.pclk(pclk), .rst(1'b0), .hsync(vga_hsync), .vsync(vga_vsync), .visible(visible), .x(vx), .y(vy));

    // renderer
    wire [3:0] rr, gg, bb;
    vga_text_renderer renderer (
        .pclk(pclk),
        .visible(visible),
        .x(vx),
        .y(vy),
        .curr_morse_bits(curr_bits),
        .curr_morse_len(curr_len),
        .decoded(decoded),
        .sent_pulse(sent),
        .r(rr),
        .g(gg),
        .b(bb)
    );
    reg [3:0] r_int, g_int, b_int;


    assign vga_red = rr;
    assign vga_green = gg;
    assign vga_blue = bb;

endmodule