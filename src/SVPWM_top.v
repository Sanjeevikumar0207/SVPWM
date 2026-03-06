`timescale 1ns / 1ps

/*
Top module for SVPWM inverter control
Compatible with Spartan-6 XC6SLX25
Generates 6 PWM signals for 3-phase inverter
*/

module svpwm_top(
    input clk,
    input reset,

    output PWM_A,
    output PWM_A_BAR,
    output PWM_B,
    output PWM_B_BAR,
    output PWM_C,
    output PWM_C_BAR
);

wire clk_enable;
assign clk_enable = 1'b1;

/* -----------------------------
   Modulating Wave Outputs
--------------------------------*/

wire signed [15:0] mod_a;
wire signed [15:0] mod_b;
wire signed [15:0] mod_c;

/* -----------------------------
   Carrier Wave Output
--------------------------------*/

wire signed [15:0] carrier;

/* -----------------------------
   Comparator Outputs
--------------------------------*/

wire pwm_a_raw;
wire pwm_b_raw;
wire pwm_c_raw;

/* -----------------------------
   Deadtime Outputs
--------------------------------*/

wire pwm_a_dt;
wire pwm_b_dt;
wire pwm_c_dt;

wire pwm_a_bar_dt;
wire pwm_b_bar_dt;
wire pwm_c_bar_dt;

/* --------------------------------
   MODULATING WAVES MODULE
----------------------------------*/

ModulatingWaves mod_wave_gen (
    .clk(clk),
    .reset(reset),
    .clk_enable(clk_enable),
    .ce_out(),
    .Out1_0(mod_a),
    .Out1_1(mod_b),
    .Out1_2(mod_c)
);

/* --------------------------------
   TRIANGULAR CARRIER MODULE
----------------------------------*/

TriangularWaves carrier_gen (
    .clk(clk),
    .reset(reset),
    .clk_enable(clk_enable),
    .ce_out(),
    .Out5(carrier)
);

/* --------------------------------
   COMPARATORS
----------------------------------*/

Comparator compA (
    .In1(mod_a),
    .In2(carrier),
    .Out1(pwm_a_raw)
);

Comparator compB (
    .In1(mod_b),
    .In2(carrier),
    .Out1(pwm_b_raw)
);

Comparator compC (
    .In1(mod_c),
    .In2(carrier),
    .Out1(pwm_c_raw)
);

/* --------------------------------
   DEAD TIME / DELAY BLOCK
----------------------------------*/

DelayBlock delayA (
    .clk(clk),
    .pwm_in(pwm_a_raw),
    .pwm_high(pwm_a_dt),
    .pwm_low(pwm_a_bar_dt)
);

DelayBlock delayB (
    .clk(clk),
    .pwm_in(pwm_b_raw),
    .pwm_high(pwm_b_dt),
    .pwm_low(pwm_b_bar_dt)
);

DelayBlock delayC (
    .clk(clk),
    .pwm_in(pwm_c_raw),
    .pwm_high(pwm_c_dt),
    .pwm_low(pwm_c_bar_dt)
);

/* --------------------------------
   FINAL OUTPUTS
----------------------------------*/

assign PWM_A     = pwm_a_dt;
assign PWM_A_BAR = pwm_a_bar_dt;

assign PWM_B     = pwm_b_dt;
assign PWM_B_BAR = pwm_b_bar_dt;

assign PWM_C     = pwm_c_dt;
assign PWM_C_BAR = pwm_c_bar_dt;

endmodule