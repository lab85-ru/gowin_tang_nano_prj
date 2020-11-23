// TOP
module top (
    input wire i_clk,
    output wire o_led_r,
    output wire o_led_g,
    output wire o_led_b

);

reg [26:0] count = 0;

always @(posedge i_clk)
begin
    count <= count +1'b1;
end

assign o_led_r = count[26];
assign o_led_g = count[25];
assign o_led_b = count[24];

endmodule
