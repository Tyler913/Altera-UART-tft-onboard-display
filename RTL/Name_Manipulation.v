module Name_Manipulation #(
    parameter MAX_NAME_LENGTH = 10,
    parameter MAX_FONT_SIZE = 3,
    parameter MIN_FONT_SIZE = 0
) 
(
    input wire system_clock,
    input wire system_reset_n,
    input wire [7:0] data_received,
    input wire received_flag,

    output reg [(8 * MAX_NAME_LENGTH) - 1:0] name_buffer,
    output reg [5:0] name_length,
    output reg [1:0] font_size,
    output reg name_ready
);


localparam [7:0] PLUS = 8 'h 2B;
localparam [7:0] MINUS = 8 'h 2D;
localparam [7:0] CLEAR = 8 'h 23;


always @(posedge system_clock or negedge system_reset_n) begin
    if (system_reset_n == 1 'b 0) begin
        name_buffer <= 'd 0;
        name_length <= 'd 0;
    end
    else if ((received_flag == 1 'b 1) && (data_received == CLEAR)) begin
        name_buffer <= 'd 0;
        name_length <= 'd 0;
    end
    else begin
        if ((received_flag == 1 'b 1) && (name_length < MAX_NAME_LENGTH)
            && (data_received != PLUS) && (data_received != MINUS)) begin
            name_buffer[(8 * name_length) +: 8] <= data_received;
            name_length <= name_length + 1;
        end
    end
end

always @(posedge system_clock or negedge system_reset_n) begin
    if (system_reset_n == 1 'b 0) begin
        name_ready <= 1 'b 0;
    end
    else if ((received_flag == 1 'b 1) && (data_received == CLEAR)) begin
        name_ready <= 1 'b 0;
    end
    else begin
        if (((name_length == MAX_NAME_LENGTH -1) || (data_received == PLUS) || (data_received == MINUS))
            && (received_flag == 1 'b 1)) begin
            name_ready <= 1 'b 1;
        end
        else begin
            name_ready <= 1 'b 0;
        end
    end
end

always @(posedge system_clock or negedge system_reset_n) begin
    if (system_reset_n == 1 'b 0) begin
        font_size <= MIN_FONT_SIZE;
    end
    else if ((received_flag == 1 'b 1) && (data_received == CLEAR)) begin
        font_size <= MIN_FONT_SIZE;
    end
    else begin
        if ((data_received == PLUS) && (font_size < MAX_FONT_SIZE) 
            && (received_flag == 1 'b 1)) begin
            font_size <= font_size + 1;
        end
        else if ((data_received == MINUS) && (font_size > MIN_FONT_SIZE) 
                && received_flag == 1 'b 1) begin
            font_size <= font_size - 1;
        end
    end
end

endmodule
