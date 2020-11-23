// TOP ----------------------------------------------------------
// i_clk = 24 MHz
//
// Тестер UART портов.
// Предназначен для определения работоспособности UART приемника.
//
// Один раз в секунду выводит в порт строку "Hello1234567890\n"
// Один вывод платы - одна фиксирования скорость.
// Во время передачи загорается светодиод.
// Передача с параметрами: 8N1
// Диапазон скоростей: 1200,2400,4800,9600,19200,57600,115200
// ПЛИС: Gowin GW1N
// Плата: Tang Nano
// (C) 2020 info@lab85.ru Georgy Sviridov
//----------------------------------------------------------------

module top (
    input  wire i_clk,
    output wire o_led_tx_l,
    output wire o_uart_1200,
    output wire o_uart_2400,
    output wire o_uart_4800,
    output wire o_uart_9600,
    output wire o_uart_19200,
    output wire o_uart_38400,
    output wire o_uart_57600,
    output wire o_uart_115200
);

localparam CLK = 24_000_000; // входной тактовый сигнал

reg m_uart_1200   = 1;
reg m_uart_2400   = 1;
reg m_uart_4800   = 1;
reg m_uart_9600   = 1;
reg m_uart_19200  = 1;
reg m_uart_38400  = 1;
reg m_uart_57600  = 1;
reg m_uart_115200 = 1;

wire       u_tx;

reg        led_l      = 1;
reg        u_en       = 0;
reg [15:0] div        = 0;
reg [24:0] timer_cnt  = 0;
reg        timer_tick = 0;
reg [2:0]  uart_speed_index = 0;

// Таймер секундных интервалов, для запуска передачи строки
always @(posedge i_clk)
begin
    if (timer_cnt == 25'd24_000_000) begin
        timer_cnt <= 0;
        timer_tick <= 1;
    end else begin
        timer_cnt <= timer_cnt + 1'b1;
        timer_tick <= 0;
    end
end

// Модуль передачи строки
tx_string TX_STRING
(
    .i_clk   (i_clk),
    .i_en    (u_en),
    .i_div   (div),
    .o_u_tx  (u_tx),
    .o_busy  (busy)
);


always @(posedge i_clk)
begin
    case (uart_speed_index)
    0:
    begin
        m_uart_1200   <= u_tx;
        m_uart_2400   <= 1;
        m_uart_4800   <= 1;
        m_uart_9600   <= 1;
        m_uart_19200  <= 1;
        m_uart_38400  <= 1;
        m_uart_57600  <= 1;
        m_uart_115200 <= 1;
    end

    1:
    begin
        m_uart_1200   <= 1;
        m_uart_2400   <= u_tx;
        m_uart_4800   <= 1;
        m_uart_9600   <= 1;
        m_uart_19200  <= 1;
        m_uart_38400  <= 1;
        m_uart_57600  <= 1;
        m_uart_115200 <= 1;
    end

    2:
    begin
        m_uart_1200   <= 1;
        m_uart_2400   <= 1;
        m_uart_4800   <= u_tx;
        m_uart_9600   <= 1;
        m_uart_19200  <= 1;
        m_uart_38400  <= 1;
        m_uart_57600  <= 1;
        m_uart_115200 <= 1;
    end

    3:
    begin
        m_uart_1200   <= 1;
        m_uart_2400   <= 1;
        m_uart_4800   <= 1;
        m_uart_9600   <= u_tx;
        m_uart_19200  <= 1;
        m_uart_38400  <= 1;
        m_uart_57600  <= 1;
        m_uart_115200 <= 1;
    end

    4:
    begin
        m_uart_1200   <= 1;
        m_uart_2400   <= 1;
        m_uart_4800   <= 1;
        m_uart_9600   <= 1;
        m_uart_19200  <= u_tx;
        m_uart_38400  <= 1;
        m_uart_57600  <= 1;
        m_uart_115200 <= 1;
    end

    5:
    begin
        m_uart_1200   <= 1;
        m_uart_2400   <= 1;
        m_uart_4800   <= 1;
        m_uart_9600   <= 1;
        m_uart_19200  <= 1;
        m_uart_38400  <= u_tx;
        m_uart_57600  <= 1;
        m_uart_115200 <= 1;
    end

    6:
    begin
        m_uart_1200   <= 1;
        m_uart_2400   <= 1;
        m_uart_4800   <= 1;
        m_uart_9600   <= 1;
        m_uart_19200  <= 1;
        m_uart_38400  <= 1;
        m_uart_57600  <= u_tx;
        m_uart_115200 <= 1;
    end

    7:
    begin
        m_uart_1200   <= 1;
        m_uart_2400   <= 1;
        m_uart_4800   <= 1;
        m_uart_9600   <= 1;
        m_uart_19200  <= 1;
        m_uart_38400  <= 1;
        m_uart_57600  <= 1;
        m_uart_115200 <= u_tx;
    end

    default:
    begin
        m_uart_1200   <= u_tx;
        m_uart_2400   <= 1;
        m_uart_4800   <= 1;
        m_uart_9600   <= 1;
        m_uart_19200  <= 1;
        m_uart_38400  <= 1;
        m_uart_57600  <= 1;
        m_uart_115200 <= 1;
    end

    endcase
end



reg [5:0] st = 0;
always @(posedge i_clk)
begin
    case (st)
    0:
    begin
        if (timer_tick) st <= 1;
    end

    1:
    begin
        case (uart_speed_index)
        0: div <= CLK / (4 * 1200);
        1: div <= CLK / (4 * 2400);
        2: div <= CLK / (4 * 4800);
        3: div <= CLK / (4 * 9600);
        4: div <= CLK / (4 * 19200);
        5: div <= CLK / (4 * 38400);
        6: div <= CLK / (4 * 57600);
        7: div <= CLK / (4 * 115200);
        endcase
        st <= 2;
    end

    2:
    begin
        if (busy == 0) begin
            led_l <= 0;
            u_en <= 1;
            st <= 3;
        end
    end

    3:
    begin
        u_en <= 0;
        st <= 4;
    end

    4:
    begin
        st <= 5;
    end

    5:
    begin
        if (busy == 0) st <= 6;
    end

    6:
    begin
        led_l <= 1;
        if (uart_speed_index == 7) begin 
            uart_speed_index <= 0;
            st <= 0;
        end else begin
            uart_speed_index <= uart_speed_index + 1'b1;
            st <= 1;
        end
    end

    default: st <= 0;

    endcase
end

assign o_uart_1200   = m_uart_1200;
assign o_uart_2400   = m_uart_2400;
assign o_uart_4800   = m_uart_4800;
assign o_uart_9600   = m_uart_9600;
assign o_uart_19200  = m_uart_19200;
assign o_uart_38400  = m_uart_38400;
assign o_uart_57600  = m_uart_57600;
assign o_uart_115200 = m_uart_115200;

assign o_led_tx_l = led_l;

endmodule
