// 设置起步价和单价模块
module price(
   input wire clk,              // 输入时钟信号
   input wire reset,            // 输入复位信号
	input wire flag,              // 输出标志位，表示是否有键按下，1位
	input wire p_m,
	input start,
	input wire [9:0] key_num,    // 输出按键编号，共10位
   output reg [9:0] s_fee,      // 起步价，共10位
   output reg [9:0] g_fee       // 单价，共10位            
);

	always @(posedge clk or posedge reset) 
		begin    // 时序逻辑模块，检测时钟和复位信号的变化
			 if (reset)
			 begin
				  s_fee <= 10'd15;
				  g_fee <= 10'd5;
			 end
			 else if (p_m && flag && !start)
				  s_fee <= key_num;
			 
			 else if (!p_m && flag && !start)
				  g_fee <= key_num;
			 
			 else                 // 保持价格不变
				 begin
					  s_fee <= s_fee;
					  g_fee <= g_fee;  
				 end		  
	end
endmodule
