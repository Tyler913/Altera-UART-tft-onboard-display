module UART_RX # (
    parameter BAUD_RATE = 'd 9600,
    parameter CLOCK_FREQ = 'd 50_000_000
)
(
    input wire system_clock,
    input wire system_reset_n,
    input wire uart_rx,

    output reg [7:0] data_received,
    output reg received_flag
);


parameter BAUD_COUNTER_MAX = CLOCK_FREQ / BAUD_RATE;


reg rx_reg1;
reg rx_reg2;
reg rx_reg3;
reg start_flag;
reg working_enabled;
reg [15:0] baud_counter;
reg bit_flag;
reg [3:0] bit_counter;
reg [7:0] rx_data_buffer;
reg rx_flag;


always @(posedge system_clock or negedge system_reset_n) begin
    if (system_reset_n == 1 'b 0) begin
        rx_reg1 <= 1 'b 1;
    end
    else begin
        rx_reg1 <= uart_rx;
    end
end

always @(posedge system_clock or negedge system_reset_n) begin
    if (system_reset_n == 1 'b 0) begin
        rx_reg2 <= 1 'b 1;
    end
    else begin
        rx_reg2 <= rx_reg1;
    end
end

always @(posedge system_clock or negedge system_reset_n) begin
    if (system_reset_n == 1 'b 0) begin
        rx_reg3 <= 1 'b 1;
    end
    else begin
        rx_reg3 <= rx_reg2;
    end
end

always @(posedge system_clock or negedge system_reset_n) begin
    if (system_reset_n == 1 'b 0) begin
        start_flag <= 1 'b 0;
    end
    else begin
        if (rx_reg2 == 1 'b 0 && rx_reg3 == 1 'b 1 && working_enabled == 1 'b 0) begin
            start_flag <= 1 'b 1;
        end
        else begin
            start_flag <= 1 'b 0;
        end
    end
end

always @(posedge system_clock or negedge system_reset_n) begin
    if (system_reset_n == 1 'b 0) begin
        working_enabled <= 1 'b 0;
        bit_counter <= 4 'd 0;
    end
    else if (start_flag && !working_enabled) begin
        working_enabled <= 1'b 1;
        bit_counter <= 4 'd 0;
    end
    else if (working_enabled && bit_flag) begin
        if (bit_counter < 9) begin
            bit_counter <= bit_counter + 1;
        end
        else begin
            working_enabled <= 1 'b 0;
            bit_counter <= 4 'd 0;
        end
    end
end

always @(posedge system_clock or negedge system_reset_n) begin
    if (system_reset_n == 1 'b 0)
        baud_counter <= 16 'd 0;
    else if (!working_enabled || baud_counter == BAUD_COUNTER_MAX - 1)
        baud_counter <= 16 'd 0;
    else
        baud_counter <= baud_counter + 1;
end

always @(posedge system_clock or negedge system_reset_n) begin
    if (system_reset_n == 1 'b 0) begin
        bit_flag <= 1 'b 0;
    end
    else begin
        if (baud_counter == BAUD_COUNTER_MAX / 2 - 1) begin
            bit_flag <= 1 'b 1;
        end
        else begin
            bit_flag <= 1 'b 0;
        end
    end
end

always @(posedge system_clock or negedge system_reset_n) begin
    if (system_reset_n == 1 'b 0)
        rx_data_buffer <= 8 'd 0;
    else if (working_enabled && bit_flag && (bit_counter >= 1) && (bit_counter <= 8)) begin
        rx_data_buffer <= {rx_reg3, rx_data_buffer[7:1]};
    end
end


always @(posedge system_clock or negedge system_reset_n) begin
    if (system_reset_n == 1 'b 0)
        rx_flag <= 1 'b 0;
    else begin
        if (working_enabled && bit_flag && (bit_counter == 9) && (rx_reg3 == 1 'b 1))
            rx_flag <= 1 'b 1;
        else
            rx_flag <= 1 'b 0;
    end
end

always @(posedge system_clock or negedge system_reset_n) begin
    if (system_reset_n == 1 'b 0)
        data_received <= 8 'd 0;
    else if (rx_flag)
        data_received <= rx_data_buffer;
end


always @(posedge system_clock or negedge system_reset_n) begin
    if (system_reset_n == 1 'b 0)
        received_flag <= 1 'b 0;
    else
        received_flag <= rx_flag;
end

endmodule
