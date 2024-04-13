module Binary(bin,bcd); //声明模块名和端口
    input wire [9:0] bin; //声明输入端口，10位二进制数
    output reg [15:0] bcd; //声明输出端口，16位BCD码
    initial begin bcd = 16'b0; end //初始化BCD码为0
    always @(*) //始终执行以下语句
         begin
              bcd [3:0]  = bin % 10; //计算个位，将余数赋给BCD码低四位
              bcd [7:4]  = bin /10 % 10; //计算十位，将商的余数赋给BCD码次低四位
              bcd [11:8] = bin / 100 % 10; //计算百位，将商的余数赋给BCD码次高四位
              bcd [15:12] = bin / 1000 % 10; //计算千位，将商的余数赋给BCD码高四位
         end 
endmodule
