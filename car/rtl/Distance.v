// 计程模块

// 模块名称和端口声明
module Distance(
    input wire clk,         // 时钟信号
    input wire reset,       // 复位信号
    input wire start,       // 启动信号
    input wire [1:0] speedup,    // 加速信号，2位
    input wire waitL,       // 等待信号（红绿灯等）
    input wire pause,       // 暂停信号
    output reg [9:0] distance   // 输出距离，10位
);
    initial begin distance = 10'b0; end    // 初始化输出距离为0

    // always 块
    always @(posedge reset or posedge clk)  // 每次检测到 reset 或者 clk 上升沿，开始计算距离
        begin
            if(reset)       // 如果 reset 为1，则将距离输出置为0
                begin
                    distance <= 10'd0;      // 距离输出清零
                end
            else if(start && !waitL && !pause)   // 如果 start 为1，waitL 和 pause 为0，则开始计算距离
                begin
                    case(speedup)   // 根据加速度不同，计算不同的距离增量
                        2'b0_0: begin distance <= distance + 10'd1; end    // speedup=00，距离增加1
                        2'b0_1: begin distance <= distance + 10'd2; end    // speedup=01，距离增加2
                        2'b1_0: begin distance <= distance + 10'd3; end    // speedup=10，距离增加3
                        2'b1_1: begin distance <= distance + 10'd4; end    // speedup=11，距离增加4
                    endcase
                end         
        end
endmodule
