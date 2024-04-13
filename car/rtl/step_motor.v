module step_motor (StepDrive,pause,waitL, clk, Dir, start, speedup,rst);
//定义模块，输入端口为StepDrive，clk，Dir，start和rst；

    input clk; 
    //输入时钟信号clk；
    input Dir; 
    //输入方向信号Dir；
    input wire start;
    //输入步进电机使能信号start；
    input rst; 
    //输入复位信号rst；
	 input wire pause;
	 input wire waitL;
	 input wire [1:0] speedup;
    output[3:0] StepDrive; 
    //输出步进电机的控制信号StepDrive，4位二进制信号；
     
    reg[3:0] StepDrive;
    //定义4位二进制寄存器StepDrive；
    reg[2:0] state; 
    //定义3位二进制寄存器state；
    reg[31:0] StepCounter = 32'b0; 
    //定义32位二进制寄存器StepCounter，并将其初始化为全0；
    parameter[31:0] StepLockOut = 32'd1041667;             
    //定义参数StepLockOut，值为32位十进制数200000；
    //该参数用于控制步进电机的转速，即每次更新状态的时间间隔，此处为500us（1/250Hz）；
    reg Internalstart; 
    //定义1位二进制寄存器Internalstart；
    always @(posedge clk or posedge rst)
    //always块，当时钟信号变为正边沿或复位信号变为负边沿时执行；
    begin 
        if (rst)    
        //如果复位信号为1，则执行以下操作；
         begin 
             StepDrive <= 4'b0;
             //将StepDrive寄存器的值初始化为全0；
             state <= 3'b0;
             //将state寄存器的值初始化为全0；
             StepCounter <= 32'b0;
             //将StepCounter寄存器的值初始化为全0；
            end
 
         else  
         //如果复位信号不为0，则执行以下操作；
        begin
            if (start)    
				Internalstart <= 1'b1 ; 
                case(speedup)
						  2'b0_0: begin StepCounter <= StepCounter + 31'b001;   end    // speedup=00，距离增加1
                    2'b0_1: begin StepCounter <= StepCounter + 31'b010;   end    // speedup=01，距离增加2
                    2'b1_0: begin StepCounter <= StepCounter + 31'b011;   end    // speedup=10，距离增加3
                    2'b1_1: begin StepCounter <= StepCounter + 31'b100;   end    // speedup=11，距离增加4
                endcase
                 
                //将StepCounter寄存器的值加1；
                if (StepCounter >= StepLockOut)
                //如果StepCounter寄存器的值大于等于StepLockOut参数的值，则执行以下操作；
            begin
                 StepCounter <= 32'b0 ; 
                 //将StepCounter寄存器的值清零；

                if (Internalstart == 1'b1 && !waitL && !pause)
                 //如果Internalstart寄存器的值为1，则执行以下操作；
                begin
                    Internalstart <= start ; 
                     //将Internalstart寄存器的值设置为start寄存器的值；
                    if (Dir == 1'b1)
					// 	  case(speedup)
					// 			2'b0_0: begin state <= state + 3'b001 ;  end    // speedup=00，距离增加1
                    //     2'b0_1: begin state <= state + 3'b010 ;  end    // speedup=01，距离增加2
                    //     2'b1_0: begin state <= state + 3'b011 ;  end    // speedup=10，距离增加3
                    //     2'b1_1: begin state <= state + 3'b100 ;  end    // speedup=11，距离增加4
                    // endcase
						  begin state <= state + 3'b001 ;  end 
                     //如果方向信号为1，则将state寄存器的值加1；
                    else if (Dir == 1'b0)       
					// 	  case(speedup)
					// 			2'b0_0: begin state <= state - 3'b001 ;  end    // speedup=00，距离增加1
                    //     2'b0_1: begin state <= state - 3'b010 ;  end    // speedup=01，距离增加2
                    //     2'b1_0: begin state <= state - 3'b011 ;  end    // speedup=10，距离增加3
                    //     2'b1_1: begin state <= state - 3'b100 ;  end    // speedup=11，距离增加4
                    // endcase
                    begin state <= state - 3'b001 ;
					case (state)
							3'b000 : StepDrive <= 4'b0001; // 对应状态输出控制信号
							3'b001 : StepDrive <= 4'b0011;
							3'b010 : StepDrive <= 4'b0010;
							3'b011 : StepDrive <= 4'b0110;
							3'b100 : StepDrive <= 4'b0100;
							3'b101 : StepDrive <= 4'b1100;
							3'b110 : StepDrive <= 4'b1000;
							3'b111 : StepDrive <= 4'b1001;
							endcase
                    end
				end
			end
		end
	end
endmodule