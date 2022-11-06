// Test LCD ST
module top
(
    input  wire       i_clk,
    output wire       o_clk,
    input  wire       i_reset,
    output wire       o_lcd_vs,
    output wire       o_lcd_hs,
    output wire       o_lcd_de,
//    output wire [7:0] o_lcd_r,
//    output wire [7:0] o_lcd_g,
//    output wire [7:0] o_lcd_b  
    output wire o_lcd_r,
    output wire o_lcd_g,
    output wire o_lcd_b  
);


lcd_tester LCD_TEST
(
    .i_dclk   ( i_clk    ),
//    .i_reset  ( i_reset  ),
    .i_reset  ( 1'b0  ),
    .o_lcd_vs ( o_lcd_vs ),
    .o_lcd_hs ( o_lcd_hs ),
    .o_lcd_de ( o_lcd_de ),
    .o_lcd_r  ( o_lcd_r  ),
    .o_lcd_g  ( o_lcd_g  ),
    .o_lcd_b  ( o_lcd_b  )  
);

assign o_clk = i_clk;

endmodule
