module Glyph_Renderer # (
    parameter MAX_NAME_LENGTH = 10
)
(
    input wire tft_clock_9m,
    input wire system_reset_n,
    input wire [(8 * MAX_NAME_LENGTH) - 1:0] name_buffer,
    input wire [5:0] name_length,
    input wire [1:0] font_size,
    input wire [9:0] pix_x,
    input wire [9:0] pix_y,

    output reg [15:0] glyph_data
);


localparam FONT_WiDTH = 8;
localparam FONT_HEIGHT = 16;
localparam BACK_GROUND_COLOR = 16 'h 0000;
localparam FONT_COLOR = 16 'h FFFF;


parameter HORIZONTAL_VALID = 10 'd 480;
parameter VERTICAL_VALID = 10 'd 272;


wire [7:0] char_code [0 : MAX_NAME_LENGTH - 1];

wire [3:0] column;
wire [3:0] row_in_glyph;
wire [2:0] bit_in_row;
wire valid;
wire [5:0] index;
wire [9:0] cell_width = FONT_WiDTH * (font_size + 1);
wire [9:0] cell_height = FONT_HEIGHT * (font_size + 1);
wire [9:0] y_in_cell = pix_y % cell_height;
wire [9:0] x_in_cell = pix_x % cell_width;
wire pixel_on;

wire [9:0] rom_address;
wire [7:0] rom_row_data;

wire valid_comb;
wire [2:0] bit_in_row_comb;


reg valid_reg1;
reg valid_reg2;
reg [2:0] bit_in_row_reg1;
reg [2:0] bit_in_row_reg2;


ROM_All_Characters_880x8	ROM_All_Characters_880x8_inst (
	.address ( rom_address ),
	.clock ( tft_clock_9m ),
	.q ( rom_row_data )
);



genvar iteration;
generate
    for (iteration = 0 ; iteration < MAX_NAME_LENGTH ; iteration = iteration + 1) begin : MAP
        assign char_code[iteration] = name_buffer[(8 * iteration) +: 8];
    end
endgenerate


function [5:0] ascii2index;
    input [7:0] ascii_code;
    begin
        if (ascii_code == 8 'd 32) begin
            ascii2index = 6 'd 0;
        end
        else if (ascii_code == 8 'd 43) begin
            ascii2index = 6 'd 1;
        end
        else if (ascii_code == 8 'd 45) begin
            ascii2index = 6 'd 2;
        end
        else if (ascii_code >= 8 'd 65 && ascii_code <= 8 'd 90) begin
            ascii2index = ascii_code - 8 'd 62;
        end
        else if (ascii_code >= 8 'd 97 && ascii_code <= 8 'd 122) begin
            ascii2index = ascii_code - 8 'd 68;
        end
        else begin
            ascii2index = 6 'd 0;
        end
    end
endfunction


assign column = pix_x / cell_width;

assign row_in_glyph = y_in_cell / (font_size + 1);

assign valid_comb = (column < name_length) && (pix_x < HORIZONTAL_VALID) && (pix_y < cell_height);

assign index = valid_comb ? ascii2index(char_code[column]) : 6 'd 0;

assign rom_address = index * FONT_HEIGHT + row_in_glyph;

assign bit_in_row_comb = x_in_cell / (font_size + 1);


always @(posedge tft_clock_9m) begin
    valid_reg1 <= valid_comb;
    valid_reg2 <= valid_reg1;

    bit_in_row_reg1 <= bit_in_row_comb;
    bit_in_row_reg2 <= bit_in_row_reg1;
end


always @(posedge tft_clock_9m or negedge system_reset_n) begin
    if (system_reset_n == 1'b0) begin
        glyph_data <= 16'd0;
    end
    else begin
        if (!valid_reg2) begin
            glyph_data <= BACK_GROUND_COLOR;
        end
        else if (rom_row_data[7 - bit_in_row_reg2]) begin
            glyph_data <= FONT_COLOR;
        end
        else begin
            glyph_data <= BACK_GROUND_COLOR;
        end
    end
end

endmodule
