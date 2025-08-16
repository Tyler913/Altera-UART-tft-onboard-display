module tft_control (
    input wire locked,
    input wire tft_clock_9m,
    input wire system_reset_n,
    input wire [15:0] glyph_data,

    output wire [15:0] rgb_tft,
    output wire horizontal_sync,
    output wire vertical_sync,
    output wire tft_clock,
    output wire tft_data_enable,
    output wire tft_background_light,
    output wire [9:0] pix_x,
    output wire [9:0] pix_y
);


parameter HORIZONTAL_SYNC = 10 'd 41;
parameter HORIZONTAL_BACK = 10 'd 2;
parameter HORIZONTAL_VALID = 10 'd 480;
parameter HORIZONTAL_FRONT = 10 'd 2;
parameter HORIZONTAL_TOTAL = 10 'd 525;

parameter VERTICAL_SYNC = 10 'd 10;
parameter VERTICAL_BACK = 10 'd 2;
parameter VERTICAL_VALID = 10 'd 272;
parameter VERTICAL_FRONT = 10 'd 2;
parameter VERTICAL_TOTAL = 10 'd 286;


wire rgb_valid;
wire pix_data_request;

reg [9:0] count_horizontal;
reg [9:0] count_vertical;


assign tft_clock = tft_clock_9m;
assign tft_data_enable = rgb_valid;
assign tft_background_light = system_reset_n;


always @(posedge tft_clock_9m or negedge system_reset_n) begin
    if (system_reset_n == 1 'b 0) begin
        count_horizontal <= 10 'b 0;
    end
    else if (count_horizontal == HORIZONTAL_TOTAL - 1 'd 1) begin
        count_horizontal <= 10 'd 0;
    end
    else begin
        count_horizontal <= count_horizontal + 1 'd 1;
    end
end

assign horizontal_sync = (count_horizontal <= HORIZONTAL_SYNC - 1 'd 1) ? 1 'b 1 : 1 'b 0;

always @(posedge tft_clock_9m or negedge system_reset_n) begin
    if (system_reset_n == 1 'b 0) begin
        count_vertical <= 10 'b 0;
    end
    else if ((count_vertical == VERTICAL_TOTAL - 1 'd 1) && (count_horizontal == HORIZONTAL_TOTAL - 1 'd 1)) begin
        count_vertical <= 10 'd 0;
    end
    else if (count_horizontal == HORIZONTAL_TOTAL - 1 'd 1) begin
        count_vertical <= count_vertical + 1 'd 1;
    end
    else begin
        count_vertical <= count_vertical;
    end
end

assign vertical_sync = (count_vertical <= VERTICAL_SYNC - 1 'd 1) ? 1 'b 1 : 1 'b 0;

assign rgb_valid = (((count_horizontal >= HORIZONTAL_SYNC + HORIZONTAL_BACK) &&
                    (count_horizontal < HORIZONTAL_SYNC + HORIZONTAL_BACK + HORIZONTAL_VALID)) &&
                    ((count_vertical >= VERTICAL_SYNC + VERTICAL_BACK) &&
                    (count_vertical < VERTICAL_SYNC + VERTICAL_BACK + VERTICAL_VALID))) 
                    ? 1 'b 1 : 1 'b 0;

assign pix_data_request = (((count_horizontal >= HORIZONTAL_SYNC + HORIZONTAL_BACK - 1 'd 1) &&
                            (count_horizontal < HORIZONTAL_SYNC + HORIZONTAL_BACK + HORIZONTAL_VALID - 1 'd 1)) &&
                            ((count_vertical >= VERTICAL_SYNC + VERTICAL_BACK) &&
                            (count_vertical < VERTICAL_SYNC + VERTICAL_BACK + VERTICAL_VALID))) 
                            ? 1 'b 1 : 1 'b 0;

assign pix_x = (pix_data_request == 1 'b 1) ? (count_horizontal - (HORIZONTAL_SYNC + HORIZONTAL_BACK - 1 'b 1)) : 10 'h 3ff;

assign pix_y = (pix_data_request == 1 'b 1) ? (count_vertical - (VERTICAL_SYNC + VERTICAL_BACK)) : 10 'h 3ff;

assign rgb_tft = (rgb_valid == 1 'b 1) ? glyph_data : 16 'd 0;

endmodule
