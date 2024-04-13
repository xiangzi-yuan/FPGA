// 定义一个名为 Time 的模块
// 该模块用于等待红灯时计时
module Time(
    // 输入时钟信号
    input wire clk,
    // 输入重置信号
    input wire reset,
    // 输入暂停信号
    input wire pause,
    // 输入等待红灯信号
    input wire waitL,
    // 输出计时使能信号
    output reg time_enable
);
    // 定义一个 8 位寄存器，用于计数
    reg [7:0]count;
    // 初始化计数器为 0
    initial begin count = 8'd0; end
    // 初始化计时使能信号为 0
    initial begin time_enable = 0; end
    // 声明一个时序逻辑块，响应时钟上升沿和重置信号
    always @(posedge reset or posedge clk)
    begin
        // 如果重置信号为 1
        if(reset)
            begin
                // 计数器清零
                count <= 8'd0;
                // 计时使能信号清零
                time_enable <= 0; 
            end
        // 如果计数器达到 10
        else if(count == 8'd10)//调小便于仿真
            begin
                // 计时使能信号反转
                time_enable <= ~time_enable;
                // 计数器清零
                count <= 8'd0;
            end
        // 如果暂停信号为 0，且等待红灯信号为 1
        else if(!pause && waitL)
            begin
                // 计数器加 1
                count <= count + 1'd1;
                // 计时使能信号清零
                time_enable <= 0;
            end
    end
endmodule

 
