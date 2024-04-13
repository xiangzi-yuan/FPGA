// 分频模块 输入 reset、clk_M，输出 clk_out
// 1s
module Fdiv(
    input wire reset,      // 复位信号
    input wire clk_M,      // 输入时钟  50MHz
    output reg clk_out     // 输出时钟
);

    reg [31:0] counter;    
    initial begin counter = 32'd0; end   
    initial begin clk_out = 0; end


    always @(posedge reset or posedge clk_M)
        begin
            if(reset)       // 高电平复位
                begin
                    counter <= 32'd0;       
                    clk_out <= 1'b0;
                end
            else if(counter == 32'd500_000)
                begin
                    clk_out <= ~clk_out;
                    counter <= 32'd0;
                end
            else 
                begin
                    counter <= counter + 1'b1;
                    clk_out <= 0;
                end
        end
endmodule