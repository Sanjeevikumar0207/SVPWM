`timescale 1ns / 1ps

/*
Clock Divider
Converts 50 MHz FPGA clock to 1 MHz clock
Used for SVPWM control logic timing
*/

module clock_divider(
    input clk_in,        // 50 MHz input clock
    input reset,
    output reg clk_out   // 1 MHz output clock
);

parameter DIV_COUNT = 25;   // half-period count for 1MHz

reg [5:0] counter;

always @(posedge clk_in or posedge reset)
begin
    if(reset)
    begin
        counter <= 0;
        clk_out <= 0;
    end
    else
    begin
        if(counter == DIV_COUNT-1)
        begin
            counter <= 0;
            clk_out <= ~clk_out;
        end
        else
            counter <= counter + 1;
    end
end

endmodule