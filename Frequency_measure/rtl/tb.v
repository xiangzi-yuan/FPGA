`timescale 1 ns / 1 ns
//------------<模块及端口声明>----------------------------------------
module tb ();

  reg sys_clk;
  reg sys_rst_n;
  reg clk_fx;


  wire [31:0] data_fx;
  wire [31:0] data_tm;
  wire [31:0] data_zk;

  //------------<例化被测试模块>----------------------------------------                          
  Frequency_measure Frequency_measure (
      .sys_clk(sys_clk),
      .sys_rst_n(sys_rst_n),
      .clk_fx(clk_fx),
      .data_fx_b(data_fx),
      .data_tm_b(data_tm),
      .data_zk_b(data_zk)

  );
  //------------<设置初始测试条件>----------------------------------------
  initial begin
    sys_clk = 1'b0;
    clk_fx <= 1'b0;
    sys_rst_n  <= 1'b0;
    #100
    sys_rst_n <= 1'b1;

  end
  //------------<设置时钟>----------------------------------------------                                                   
  always #10 sys_clk <= ~sys_clk; //50Mhz
  //待测
  always begin  //10hz
    #15 clk_fx <=0;
    #15 clk_fx <=1;     
  end 
endmodule
