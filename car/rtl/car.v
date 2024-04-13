module car(reset, clk_M, start, pause, waitL, speedup,p_m, Dir, row, StepDrive, col,distance_b,fee_b,s_fee_b,g_fee_b,flag);
    input reset;         //异步复位信号
    input clk_M;         //主时钟信号
    input start;         //开始计程信号
    input pause;         //暂停计程信号
    input waitL;         //等待红绿灯信号
    input [1:0] speedup; //速度设置信号
	 input p_m;
	 input Dir;           //方向
	 input [3:0] row; 
	 output [3:0] StepDrive; //步进电机输出
	 output [3:0] col;
	 output [15:0] distance_b;//里程的BCD码
	 output  [15:0] fee_b;  //费用的BCD码
	 output [15:0] s_fee_b;       
    output [15:0] g_fee_b;
	 output flag;
    //定义中间信号
    wire [9:0] fee_before;      //计费前里程信号
    wire [9:0] distance_before; //计程前里程信号 
    wire time_enable;           //时间使能信号
    wire clk_out;               //输出时钟信号
	 wire [9:0] s_fee_before;
	 wire [9:0] g_fee_before;
	 wire [9:0] key_num;


	 
    //调用子模块
    Fdiv u1(reset, clk_M, clk_out);   //主时钟分频器
	 keyboard u2( clk_M, reset, row, key_num, col, flag);
    Distance u3(clk_out, reset, start, speedup, waitL, pause, distance_before);  //计程模块
    Time u4(clk_out, reset, pause, waitL, time_enable);     //等待红绿灯时间模块
	 price u5(clk_M, reset, flag, p_m, start,key_num, s_fee_before, g_fee_before);   // 设置价格模块
    Fee u6(clk_M, reset, waitL, pause, time_enable, distance_before, s_fee_before, g_fee_before, start, fee_before);  //计费模块
    Binary u8(distance_before, distance_b);                //二进制转BCD码模块
    Binary u9(fee_before, fee_b);                            //二进制转BCD码模块
	 Binary u10(s_fee_before, s_fee_b);
	 Binary u11(g_fee_before, g_fee_b);

	 step_motor u13(StepDrive, pause, waitL, clk_M, Dir, start, speedup, reset);   //步进电机模块
	 
	 
endmodule
