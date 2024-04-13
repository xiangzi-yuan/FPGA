`timescale 1ns / 1ns

module tb_car();
  reg reset;
  reg clk_M;
  reg start;
  reg pause;
  reg waitL;
  reg [1:0] speedup;
  reg p_m;
  reg  Dir;
  reg [3:0] row;
  wire [3:0] StepDrive;
  wire [3:0] col;
  wire [15:0] distance_b;
  wire [15:0] fee_b;
  wire [15:0] s_fee_b;
  wire [15:0] g_fee_b;
  reg  [4:0] key;
  // defparam uut.keyboard.CNT1_MAX = 10;
  // Instantiate the car module

always #20 clk_M=!clk_M;

  // Testbench stimulus
  initial begin
    clk_M = 1;
    reset = 1;
    key   = 5'h10;  // MSB=1 stands for no key pressed 
    row   = 4'b1111;
    #1000
    p_m = 0;
    reset = 0;
    start = 1;
    pause = 0;
    waitL = 0;
    speedup = 00;
    row = 0;
    Dir = 0;
    #240000000
    pause = 1;
    #200000000
    pause = 0;
    waitL = 1;
    #400000000
    waitL = 0;
    #20000000
    reset = 1;//复位
    #1000
    reset = 0;
    speedup = 01;//调试速度功能
    #40000000//两个里程后
    reset = 1;//复位
    #1000
    reset = 0;
    start = 0;
    p_m = 0;//修改里程单价
    key = 5'h03;//修改单价
    speedup = 00;
    #1000000//消抖
    key = 5'h10;//松开
    #10000000;
    start = 1;
    #400000000
    reset = 1;
    #10000000
    $stop(0);	


    

    
  

  end

  always @(*) begin
    case (key)
      5'h10:   row = 4'b1111;
      5'h00:   row = {1'b1, 1'b1, 1'b1, col[0]};
      5'h01:   row = {1'b1, 1'b1, 1'b1, col[1]};
      5'h02:   row = {1'b1, 1'b1, 1'b1, col[2]};
      5'h03:   row = {1'b1, 1'b1, 1'b1, col[3]};
      5'h04:   row = {1'b1, 1'b1, col[0], 1'b1};
      5'h05:   row = {1'b1, 1'b1, col[1], 1'b1};
      5'h06:   row = {1'b1, 1'b1, col[2], 1'b1};
      5'h07:   row = {1'b1, 1'b1, col[3], 1'b1};
      5'h08:   row = {1'b1, col[0], 1'b1, 1'b1};
      5'h09:   row = {1'b1, col[1], 1'b1, 1'b1};
      5'h0a:   row = {1'b1, col[2], 1'b1, 1'b1};
      5'h0b:   row = {1'b1, col[3], 1'b1, 1'b1};
      5'h0c:   row = {col[0], 1'b1, 1'b1, 1'b1};
      5'h0d:   row = {col[1], 1'b1, 1'b1, 1'b1};
      5'h0e:   row = {col[2], 1'b1, 1'b1, 1'b1};
      5'h0f:   row = {col[3], 1'b1, 1'b1, 1'b1};
      default: row = 4'b1111;
    endcase
  end

  car uut (
    .reset(reset),
    .clk_M(clk_M),
    .start(start),
    .pause(pause),
    .waitL(waitL),
    .speedup(speedup),
    .p_m(p_m),
    .Dir(Dir),
    .row(row),
    .StepDrive(StepDrive),
    .col(col),
    .distance_b(distance_b),
    .fee_b(fee_b),
    .s_fee_b(s_fee_b),
    .g_fee_b(g_fee_b),
    .flag   (flag)
  );

endmodule