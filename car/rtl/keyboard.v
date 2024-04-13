// 键盘扫描模块
module keyboard(
   input wire clk_M,            // 输入时钟信号
   input wire reset,            // 输入复位信号
   input wire [3:0] row,        // 输入行信号，共4位
   output reg [9:0] key_num,    // 输出按键编号，共10位
   output reg [3:0] col,        // 输出列信号，共4位
   output reg flag              // 输出标志位，表示是否有键按下，1位
);

	parameter CNT1_MAX = 50;  // 定义计数器CNT1的最大值
	parameter CNT2_MAX = 20;      // 定义计数器CNT2的最大值
	localparam S0 = 3'b001;       // 定义状态S0，占3位
	localparam S1 = 3'b010;       // 定义状态S1，占3位
	localparam S2 = 3'b100;       // 定义状态S2，占3位

	reg [2:0] state;              // 定义状态寄存器state，占3位
	reg [15:0] cnt1;              // 定义计数器CNT1，占16位
	reg [4:0] cnt2;               // 定义计数器CNT2，占5位
	reg [7:0] row_col;            // 定义行列组合信号，共8位

	wire flag_1ms;                // 定义标志位，表示1ms时间到达，1位
	always @(posedge clk_M, posedge reset) begin    // 时序逻辑模块，检测时钟和复位信号的变化
		 if (reset)
			  cnt1 <= 0;
		 else if (cnt1 < CNT1_MAX - 1)
			  cnt1 <= cnt1 + 1'b1;
		 else
			  cnt1 <= 0;
	end

	
	assign flag_1ms = (cnt1 == CNT1_MAX - 1) ? 1'b1 : 1'b0; // flag_1ms指示是否达到1ms

	always @(posedge clk_M, posedge reset) begin // 状态机始终在时钟上升沿时工作
		 if (reset) begin // 如果接收到复位信号
			  cnt2 <= 0; // 计数器清零
			  col <= 4'b0000; // 列地址清零
			  row_col <= 8'b1111_0000; // 行和列的拼接信号
			  flag <= 0; // 标志位清零
			  state <= S0; // 状态机状态设为S0
		 end
		 else begin // 否则按照状态机的状态进行操作
			  case (state) // 根据状态机状态选择对应的分支
					S0: if (flag_1ms == 0) // S0状态下，如果未达到1ms
							  state <= S0; // 保持S0状态
						 else if (row == 4'b1111) // 如果行地址为全1，说明按键没有按下
							  state <= S0; // 保持S0状态
						 else if (cnt2 < CNT2_MAX - 1)  // 如果计数器没有达到CNT2_MAX
							  cnt2 <= cnt2 + 1'b1; // 计数器加1
						 else begin // 否则执行以下操作
							  cnt2 <= 0; // 计数器清零
							  col <= 4'b1110; // 列地址为4b1110
							  state <= S1; // 状态机状态设为S1
						 end
					S1: if (flag_1ms == 0) // S1状态下，如果未达到1ms
							  state <= S1; // 保持S1状态
						 else if (row == 4'b1111) // 如果行地址为全1，说明按键没有按下
							  col <= {col[2:0], col[3]}; // 列地址循环左移1位
						 else begin // 否则执行以下操作
							  row_col <= {row, col}; // 将行地址和列地址拼接为一个8位信号
							  col <= 4'b0000; // 列地址清零
							  flag <= 1; // 标志位设为1，表示已经获取到一个键值
							  state <= S2; // 状态机状态设为S2
						 end
					S2: if (flag_1ms == 0) begin // S2状态下，如果未达到1ms
							  flag <= 0; // 标志位清零
							  state <= S2; // 保持S2状态
						 end
						 else if (row != 4'b1111) // 如果行地址不为全1，说明按键没有松开
							  state <= S2; // 保持S2状态
						 else if (cnt2 < CNT2_MAX - 1)  // 如果计数器没有达到CNT2_MAX
							  cnt2 <= cnt2 + 1'b1; // 计数器加1
						 else begin // 计数器清零
							  cnt2 <= 0; // 计数器清零
							  col <= 4'b0000;
							  state <= S0;
						 end
			  endcase
		 end
	end


	always @ (*)
	// 始终在输入信号变化时执行以下代码块
		begin
		  if (reset)
		  // 如果复位信号为1（高电平），则将按键编号清零
			 key_num <= 10'h0;
		  else
		  // 如果复位信号为0（低电平），则根据输入的行列信号确定按键编号
			 case (row_col)
				8'b1110_1110: key_num = 10'd0;  // 行4列4
				8'b1110_1101: key_num = 10'd1; // 行4列3
				8'b1110_1011: key_num = 10'd2; // 行4列2
				8'b1110_0111: key_num = 10'd3; // 行4列1
				8'b1101_1110: key_num = 10'd4; // 行3列4
				8'b1101_1101: key_num = 10'd5;  // 行3列3
				8'b1101_1011: key_num = 10'd6;  // 行3列2
				8'b1101_0111: key_num = 10'd7; // 行3列1
				8'b1011_1110: key_num = 10'd8; // 行2列4
				8'b1011_1101: key_num = 10'd9; // 行2列3
				8'b1011_1011: key_num = 10'd10; // 行2列2
				8'b1011_0111: key_num = 10'd11; // 行2列1
				8'b0111_1110: key_num = 10'd12; // 行1列4
				8'b0111_1101: key_num = 10'd13; // 行1列3
				8'b0111_1011: key_num = 10'd14; // 行1列2
				8'b0111_0111: key_num = 10'd15; // 行1列1
				default: key_num = 10'd0; // 如果行列信号不符合以上任何一种情况，则将按键编号清零
			 endcase
		end

endmodule
