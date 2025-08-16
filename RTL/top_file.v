module top_file(
    input wire system_clock,
    input wire system_reset_n,
    input wire uart_rx,

    output wire [15:0] rgb_tft,
    output wire horizontal_sync,
    output wire vertical_sync,
    output wire tft_clock,
    output wire tft_data_enable,
    output wire tft_background_light
);


localparam MAX_NAME_LENGTH = 10;


wire [7:0] data_received;
wire received_flag;
wire [(8 * MAX_NAME_LENGTH) - 1:0] name_buffer;
wire [5:0] name_length;
wire [1:0] font_size;
wire name_ready;
wire locked;
wire tft_clock_9m;
wire [9:0] pix_x;
wire [9:0] pix_y;
wire [15:0] glyph_data;


UART_RX #(
    .BAUD_RATE(9600),
    .CLOCK_FREQ(50000000)
) 
uart_rx_inst (
    .system_clock(system_clock),
    .system_reset_n(system_reset_n),
    .uart_rx(uart_rx),

    .data_received(data_received),
    .received_flag(received_flag)
);


Name_Manipulation #(
    .MAX_NAME_LENGTH(MAX_NAME_LENGTH),
    .MAX_FONT_SIZE(3),
    .MIN_FONT_SIZE(0)
)
name_manipulation_inst (
    .system_clock(system_clock),
    .system_reset_n(system_reset_n),
    .data_received(data_received),
    .received_flag(received_flag),

    .name_buffer(name_buffer),
    .name_length(name_length),
    .font_size(font_size),
    .name_ready(name_ready)
);


// pll_clock_gen_9MHz	pll_clock_gen_9MHz_inst (
// 	.inclk0 ( system_clock ),

// 	.c0 ( tft_clock_9m ),
// 	.locked ( locked )
// 	);


pll_clock_gen_9mhz	pll_clock_gen_9mhz_inst (
	.areset ( ~ system_reset_n ),
	.inclk0 ( system_clock ),
	.c0 ( tft_clock_9m ),
	.locked ( locked )
	);



Glyph_Renderer #(
    .MAX_NAME_LENGTH(MAX_NAME_LENGTH)
)
glyph_renderer_inst (
    .tft_clock_9m(tft_clock_9m),
    .system_reset_n(system_reset_n & locked),
    .name_buffer(name_buffer),
    .name_length(name_length),
    .font_size(font_size),
    .pix_x(pix_x),
    .pix_y(pix_y),

    .glyph_data(glyph_data)
);


tft_control tft_control_inst (
    .locked(locked),
    .tft_clock_9m(tft_clock_9m),
    .system_reset_n(system_reset_n & locked),
    .glyph_data(glyph_data),

    .pix_x(pix_x),
    .pix_y(pix_y),
    .rgb_tft(rgb_tft),
    .horizontal_sync(horizontal_sync),
    .vertical_sync(vertical_sync),
    .tft_clock(tft_clock),
    .tft_data_enable(tft_data_enable),
    .tft_background_light(tft_background_light)
);

endmodule
