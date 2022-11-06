// Test LCD ST
module lcd_tester
(
    input  wire       i_dclk,
    input  wire       i_reset,
    output wire       o_lcd_vs,
    output wire       o_lcd_hs,
    output wire       o_lcd_de,
    output wire [7:0] o_lcd_r,
    output wire [7:0] o_lcd_g,
    output wire [7:0] o_lcd_b  
);

// HS generator --------------------------------------------
reg [10:0] hs_cnt  = 0;
reg        hs      = 0;
reg        de_line = 0;

always @(posedge i_dclk)
begin
    if (i_reset) begin
        hs      <= 0;
        hs_cnt  <= 0;
        de_line <= 0;
    end else begin
    case(hs_cnt)
    0:
    begin
        hs <= 0;
        hs_cnt <= hs_cnt + 1'b1;
    end

    40:
    begin
        hs <= 1;
        hs_cnt <= hs_cnt + 1'b1;
    end

    46:
    begin
        de_line <= 1;
        hs_cnt <= hs_cnt + 1'b1;
    end

    800 + 40:
    begin
        de_line <= 0;
        hs_cnt <= hs_cnt + 1'b1;
    end

    800 + 40 + 210:
    begin
        hs <= 0;
        hs_cnt <= 0;
    end

    default:
        hs_cnt <= hs_cnt + 1'b1;

    endcase
    end // if
end

// VS generator -----------------------------------
reg [1:0] hs_pipe = 0;
reg       hs_tick = 0;


// Tick new line (HS)
always @(posedge i_dclk)
begin
    if (i_reset) begin
        hs_pipe[1:0] <= 2'b00;
        hs_tick <= 0;
    end else begin
        hs_pipe[1:0] <= {hs_pipe[0], hs};
        if (hs_pipe == 2'b10)
            hs_tick <= 1;
        else
            hs_tick <= 0;
    end
end

reg [9:0] vs_cnt = 0;
reg       vs     = 0;
reg       de_vs  = 0;

always @(posedge i_dclk)
begin
    if (i_reset) begin
        vs_cnt <= 0;
        vs <= 0;
        de_vs <= 0;
    end else begin
    if (hs_tick)
    case(vs_cnt)
    0:
    begin
        vs <= 0;
        vs_cnt <= vs_cnt + 1'b1;
    end

    20:
    begin
        vs <= 1;
        vs_cnt <= vs_cnt + 1'b1;
    end

    23:
    begin
        de_vs <= 1;
        vs_cnt <= vs_cnt + 1'b1;
    end

    20 + 480:
    begin
        de_vs <= 0;
        vs_cnt <= vs_cnt + 1'b1;
    end

    20 + 480 + 22:
    begin
        vs <= 0;
        vs_cnt <= 0;
    end

    default:
        vs_cnt <= vs_cnt + 1'b1;

    endcase
    end // if
end


reg [1:0] vs_pipe = 0;
reg [7:0] frame_cnt  = 0;
reg [2:0] reg_color = 0;

// Color counter 
always @(posedge i_dclk)
begin
    if (i_reset) begin
        vs_pipe[1:0] <= 2'b00;
        frame_cnt    <= 0;
        reg_color    <= 0;
    end else begin
        vs_pipe[1:0] <= {vs_pipe[0], vs};
        if (vs_pipe == 2'b10) begin
            if (frame_cnt != 25) begin // Смена цвета каждый 25 кадр.
                frame_cnt <= frame_cnt + 1'b1;
            end else begin
                reg_color <= reg_color + 1'b1;
                frame_cnt <= 0;
            end
        end
    end
end

assign o_lcd_de = de_line & de_vs;
assign o_lcd_hs = hs;
assign o_lcd_vs = vs;
assign o_lcd_r  = reg_color[0] ? 8'hff : 0;
assign o_lcd_g  = reg_color[1] ? 8'hff : 0;
assign o_lcd_b  = reg_color[2] ? 8'hff : 0;


endmodule
