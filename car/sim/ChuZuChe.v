module ChuZuChe;
	// Inputs
	reg reset;         // 重置信号
	reg clk_M;         // M时钟信号
	reg start;         // 启动信号
	reg pause;         // 暂停信号
	reg waitL;         // 等待L信号
	reg [1:0] speedup; // 速度加倍信号
	reg d_m;           // 数码管显示值

	// Outputs
	wire [7:0] Seg;    // 数码管段选信号
	wire [3:0] AN;     // 数码管位选信号

	// Instantiate the Unit Under Test (UUT)
	sy_last_code uut (  // 实例化待测试的模块sy_last_code，命名为uut
		.reset(reset), 
		.clk_M(clk_M), 
		.start(start), 
		.pause(pause), 
		.waitL(waitL), 
		.speedup(speedup), 
		.d_m(d_m), 
		.Seg(Seg), 
		.AN(AN)
	);

	always begin #10 clk_M = ~clk_M; end  // M时钟信号反转，周期为10个时间单位
	
	initial begin
		// Initialize Inputs
		reset = 1;          // 开始时将重置信号置为1
		clk_M = 0;          // 开始时将M时钟信号置为0
		start = 1;          // 开始时将启动信号置为1
		pause = 0;          // 开始时将暂停信号置为0
		waitL = 0;          // 开始时将等待L信号置为0
		speedup = 0;        // 开始时将速度加倍信号置为00
		d_m = 0;            // 开始时将数码管显示值置为0

		// Wait 100 ns for global reset to finish
		#100;               // 等待100个时间单位，完成全局重置
		reset = 0;          // 全局重置完成后将重置信号置为0
		start = 1;          // 开始信号仍为1
		pause = 0;          // 暂停信号仍为0
		waitL = 0;          // 等待L信号仍为0
		speedup = 2'b00;    // 将速度加倍信号置为00
		d_m = 1;            // 将数码管显示值置为1
	end
endmodule
