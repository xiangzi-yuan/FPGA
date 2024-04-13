module Smg(
    input wire d_m,           // 显示距离还是费用的选择信号，0表示显示费用，1表示显示距离
    input wire [15:0] fee,    // 费用信号，16位
    input wire [15:0] distance,  // 距离信号，16位
    input wire [1:0] Bit_Sel,    // 数码管位选信号，2位
    output reg [7:0] Seg,    // 数码管段选信号，8位
    output reg [2:0] AN      // 数码管位选信号，3位
);
    reg [3:0] Data_now;      // 当前需要显示的数据

    initial 
    begin 
        Data_now = 4'b0;    // 初始化当前需要显示的数据为0
			Seg = 8'b0;
    end
      
    always @(*)   // 根据位选信号控制数码管位选信号
    begin
        case(Bit_Sel)
            2'b00: AN<=3'b000;    // 选择第一位数码管
            2'b01: AN<=3'b001;    // 选择第二位数码管
            2'b10: AN<=3'b010;    // 选择第三位数码管
            2'b11: AN<=3'b011;    // 选择第四位数码管
            default: AN<=3'b111;  // 默认为不显示任何数码管
        endcase
    end
    
    always @(*)    // 根据显示距离还是费用的选择信号和位选信号，确定需要显示的数据
    begin
        if(d_m)   // 如果选择显示距离，则从距离信号中选择需要显示的数据
        begin
            case(Bit_Sel)
                2'b00: Data_now[3:0] <= distance[15:12];   // 选择距离信号的高4位
                2'b01: Data_now[3:0] <= distance[11:8];    // 选择距离信号的第2~5位
                2'b10: Data_now[3:0] <= distance[7:4];     // 选择距离信号的第6~9位
                2'b11: Data_now[3:0] <= distance[3:0];     // 选择距离信号的低4位
                default: Data_now[3:0] <= distance[3:0];   // 默认选择距离信号的低4位
            endcase
        end
        else   // 如果选择显示费用，则从费用信号中选择需要显示的数据
        begin
			   case(Bit_Sel)
					2'b00: Data_now[3:0] <= fee[15:12];      // 显示费用的千位
					2'b01: Data_now[3:0] <= fee[11:8];       // 显示费用的百位
					2'b10: Data_now[3:0] <= fee[7:4];        // 显示费用的十位
					2'b11: Data_now[3:0] <= fee[3:0];        // 显示费用的个位
					default: Data_now[3:0] <= fee[3:0];      // 选择无效，显示费用的个位
			  endcase
		  end
	 end
	 always @(*)
	 begin
		  begin
			   // 根据 Data_now 的低 4 位数字选择对应的信号，点亮数码管
			   case(Data_now[3:0])
					 // 数字 0 的信号
					 4'b0000: Seg[7:0] <= 8'b0011_1111;
					 
					 // 数字 1 的信号
					 4'b0001: Seg[7:0] <= 8'b0000_0110;
					 
					 // 数字 2 的信号
					 4'b0010: Seg[7:0] <= 8'b0101_1011;
					 
					 // 数字 3 的信号
					 4'b0011: Seg[7:0] <= 8'b0100_1111;

					 // 数字 4 的信号
					 4'b0100: Seg[7:0] <= 8'b0110_0110;
					 
					 
					 // 数字 5 的信号
					 4'b0101: Seg[7:0] <= 8'b0110_1101;
					 
					 //6
					 4'b0110: Seg[7:0] <= 8'b0111_1101;
					 //7
                4'b0111: Seg[7:0] <= 8'b0000_0111;
					 //8
                4'b1000: Seg[7:0] <= 8'b0111_1111;
					 //9
                4'b1001: Seg[7:0] <= 8'b0110_1111;
					 
                default: Seg[7:0] <= 8'b0100_0000;
            endcase
        end    
    end

endmodule
