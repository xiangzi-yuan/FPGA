module Frequency_measure (
    //system clock
    input sys_clk,   // 时钟信号
    input sys_rst_n, // 复位信号

    //cymometer interface
    input        clk_fx,  // 被测时钟
    input  [1:0] d_m,     //数码管选择信号
    //段选
    output [31:0] data_fx_b,
    output [31:0] data_tm_b,
    output [31:0] data_zk_b
);

  //parameter define
  parameter CLK_FS = 32'd5000_0000;  // 基准时钟频率值

  //*****************************************************
  //** main code
  //*****************************************************
  wire [31:0] fx_cnt;
  wire [31:0] data_fx;  //频率大小
  wire [31:0] data_tm;  //脉冲宽度
  wire [31:0] data_zk;  //占空比

  //例化等精度频率计模块
  cymometer #(
      .CLK_FS(CLK_FS)  // 基准时钟频率值
  ) u_cymometer (
      //system clock
      .clk_fs(sys_clk),  // 基准时钟信号
      .rst_n(sys_rst_n),  // 复位信号
      //cymometer interface
      .clk_fx(clk_fx),  // 被测时钟信号
      .fx_cnt(fx_cnt),
      .data_fx(data_fx)  // 被测时钟频率输出
  );
  reg [31:0] num1, num2;
  always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) num1 <= 32'd0;
    else if (clk_fx == 1) num1 <= num1 + 1;
    else num1 <= 0;
  end

  always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) num2 <= 0;
    else if (clk_fx == 1) num2 <= 0;
    else num2 <= num2 + 1;
  end

  reg [31:0] high_count, low_count;
  always @(negedge clk_fx or negedge sys_rst_n) begin
    if (!sys_rst_n) high_count <= 0;
    else high_count <= num1;
  end

  always @(posedge clk_fx or negedge sys_rst_n) begin
    if (!sys_rst_n) low_count <= 0;
    else low_count <= num2;
  end

  assign data_tm = high_count * 20;
  assign data_zk = (high_count * 100) / (high_count + low_count);
  Binary u8 (
      data_fx,
      data_fx_b
  );  //二进制转BCD码模块
  Binary u9 (
      data_tm,
      data_tm_b
  );  //二进制转BCD码模块
  Binary u10 (
      data_zk,
      data_zk_b
  );  //二进制转BCD码模块


endmodule
