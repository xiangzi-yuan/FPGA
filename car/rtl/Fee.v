// 定义一个名为 Fee 的模块
// 该模块用于计算车费
module Fee(
    // 输入时钟信号
    input wire clk,
    // 输入重置信号
    input wire reset,
    // 输入等待红灯信号
    input wire waitL,
    // 输入暂停信号
    input wire pause,
    // 输入计时使能信号
    input wire time_enable,
    // 输入行驶距离，最大为 1023
    input wire [9:0] distance,
    // 输入开始行驶信号
    
	 input wire[9:0] s_fee,      // 起步价，共10位
	 input wire[9:0] g_fee,      // 单价，共10位 
	 input wire start,
	 
    output reg [9:0] fee_before
);
    reg prev_time_enable;
	 // 初始化车费为 0
    initial begin fee_before <= 10'b0; end
    // 定义起步价为 60 元
	
    // 声明一个时序逻辑块，响应时钟上升沿和重置信号
    always @(posedge reset or posedge clk)
    begin
        // 如果重置信号为 1
        if(reset)
            begin
                // 车费清零
                fee_before <= 10'd0;
            end
        // 如果开始行驶信号为 1，且不等待红灯且未暂停
        else if(start && !waitL && !pause)
            begin
                // 如果行驶距离小于等于 10 公里
                if(distance <= 10)
                    begin
                        // 车费为起步价
                        fee_before <= s_fee;
                    end
                else
                    begin
                        // 计算车费，每 1 公里加价 g_fee 元
                        fee_before <= s_fee + g_fee * (distance - 10);
                    end
            end
        // 如果计时使能信号为 1
        else if (time_enable && !prev_time_enable) 
				begin
  
                fee_before <= fee_before + 10'd5;
            end
				prev_time_enable <= time_enable;
    end
endmodule