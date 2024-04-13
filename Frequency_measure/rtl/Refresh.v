// 分频刷新数码管 
module Refresh(
    input wire clk_M,    // 输入主时钟信号
    output reg [2:0] Bit_Sel  // 输出数码管选择信号
);
    // 定义计数器
    integer counter = 0;
    initial begin Bit_Sel <= 3'b000; end   // 初始化数码管选择信号为0
    always@(posedge clk_M)    // 主时钟上升沿触发
        begin
            counter <= counter + 1;   // 计数器加1
            // 50MHz 时钟脉冲，采用 62.5Hz 刷新频率，得到 16ms 一遍，每个数码管选通路的时间 4ms
            if(counter == 100000)   // 等待 4ms
            begin 
                Bit_Sel <= Bit_Sel + 3'b001;   // 数码管选择信号加 1
                counter <= 0;   // 计数器清零
            end
        end
endmodule
