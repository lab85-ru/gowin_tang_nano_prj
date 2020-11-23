module tx_string(
    input wire i_clk,
    input wire i_en,
    input wire [15:0] i_div,
    output wire o_u_tx,
    output wire o_busy
);

// TX string --------------------------------------------------------------------------------------------------------------------------------------
//                                  H       e      l      l      0      1      2      3      4       5      6      7     8       9      0     \n
wire [16 * 8 - 1:0] TX_STRING = { 8'h48, 8'h65, 8'h6c, 8'h6c, 8'h6f, 8'h31, 8'h32, 8'h33, 8'h34, 8'h35, 8'h36, 8'h37, 8'h38, 8'h39, 8'h30, 8'h0d};

wire       u_busy;
wire       u_tx;

reg [7:0]  u_tx_data = 0;
reg        busy      = 0;
reg [3:0]  st        = 0;
reg [3:0]  mux_index = 0;
reg        u_we      = 0;

uart_tx UTX(
    .i_clk         (i_clk),        // Clk input
    .i_en_h        (1'b1),         // module enable active-HIGH
    .i_div         (i_div),        // div speed uart-rx. (baud = clk / div)
    .i_tx_data     (u_tx_data),    // data out
    .i_we_h        (u_we),         // we strob Active HIGH, tx_data write to modul

    .i_parity_en_h (1'b0),         // bit parity disable(0) / enable (1)
    .i_parity_type_el_oh(1'b0),    // bit parity type E (Even parity) — proverka na chetnost O (Odd parity) — proverka na NE chetnost;
	 
    .o_int_h       (),             // strob interupt active-HIGH, rx->data out
    .o_tx          (u_tx),         // rs-232 output
    .o_busy_h      (u_busy)        // (STATUS) busy=1 uart tx byte
 
);

always @(posedge i_clk)
begin
    case(st)
    0:
    begin
        if (i_en) begin
            mux_index <= 0;
            busy <= 1;
            st <= 1;
        end else 
            busy <= 0;
    end

    1:
    begin
        case (mux_index)

        0:  u_tx_data <= TX_STRING[16*8-1 : 8*15];
        1:  u_tx_data <= TX_STRING[15*8-1 : 8*14];
        2:  u_tx_data <= TX_STRING[14*8-1 : 8*13];
        3:  u_tx_data <= TX_STRING[13*8-1 : 8*12];
        4:  u_tx_data <= TX_STRING[12*8-1 : 8*11];
        5:  u_tx_data <= TX_STRING[11*8-1 : 8*10];
        6:  u_tx_data <= TX_STRING[10*8-1 : 8*9];
        7:  u_tx_data <= TX_STRING[9*8-1  : 8*8];
        8:  u_tx_data <= TX_STRING[8*8-1  : 8*7];
        9:  u_tx_data <= TX_STRING[7*8-1  : 8*6];
        10: u_tx_data <= TX_STRING[6*8-1  : 8*5];
        11: u_tx_data <= TX_STRING[5*8-1  : 8*4];
        12: u_tx_data <= TX_STRING[4*8-1  : 8*3];
        13: u_tx_data <= TX_STRING[3*8-1  : 8*2];
        14: u_tx_data <= TX_STRING[2*8-1  : 8*1];
        15: u_tx_data <= TX_STRING[1*8-1  : 8*0];

        default:
            u_tx_data <= 0;
        endcase

        st <= 2;
    end

    2:
    begin
        u_we <= 1;
        st <= 3;
    end

    3:
    begin
        u_we <= 0;
        st <= 4;
    end

    4:
    begin
        st <= 5;
    end

    5:
    begin
        if(u_busy == 0) st <= 6;
    end

    6:
    begin
        if (mux_index != 15) begin
            mux_index <= mux_index + 1'b1; 
            st <= 1;
        end else
            st <= 0;
    end

    default: st <= 0;

    endcase
end

assign o_busy = busy;
assign o_u_tx = u_tx;

endmodule
