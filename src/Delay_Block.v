`timescale 1ns / 1ps

/*
Delay Block (Dead-Time Generator)

Purpose:
Adds dead-time between complementary PWM signals
to avoid shoot-through in inverter switches.

Input:
pwm_in  -> raw PWM from comparator

Outputs:
pwm_high -> upper switch gate signal
pwm_low  -> lower switch gate signal
*/

module DelayBlock(
    input clk,
    input pwm_in,

    output reg pwm_high,
    output reg pwm_low
);

parameter DEAD_TIME = 8;   // number of clock cycles delay

reg [7:0] dead_counter = 0;
reg pwm_prev = 0;

always @(posedge clk)
begin

    pwm_prev <= pwm_in;

    /* detect switching transition */
    if(pwm_prev != pwm_in)
    begin
        dead_counter <= DEAD_TIME;
        pwm_high <= 0;
        pwm_low  <= 0;
    end
    else
    begin

        if(dead_counter > 0)
        begin
            dead_counter <= dead_counter - 1;
            pwm_high <= 0;
            pwm_low  <= 0;
        end
        else
        begin
            pwm_high <= pwm_in;
            pwm_low  <= ~pwm_in;
        end

    end

end

endmodule