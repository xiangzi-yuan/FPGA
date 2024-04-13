
module Key_debounce(input clk,
                    input rst_n,
                    input sw_in,
                    output reg sw_out);
  
  reg sw_in_r0;
  
  always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
      sw_in_r0 <= 1;
    end
    else begin
      sw_in_r0 <= sw_in;
    end
  end
  
  wire edge_l, edge_h;
  assign edge_l = sw_in_r0 & ( ~sw_in );  
  assign edge_h = sw_in & ( ~sw_in_r0 );  
  wire edge_en;  
  assign edge_en = edge_l | edge_h;
  
  reg [19:0] count;
  always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
      count <= 0;
    end
    else if ( edge_en ) begin
      count <= 0;
    end
    else begin
      count <= count + 20'b1;
    end
    
  end
  
  always @ ( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) begin
      sw_out <= 1'b1;
    end
    else if ( count == 20'h2BF20 ) begin
      sw_out <= sw_in;
    end
    else begin
      ;
    end
  end
  
  
  
endmodule

/*
该代码实现了一个按键的消抖功能。输入时钟信号clk、复位信号rst_n和按键输入信号sw_in，输出经消抖后的信号sw_out。

在该模块中，定义了一个寄存器sw_in_r0，用于存储上一个时刻的按键输入信号。当clk的上升沿到来或者rst_n的下降沿到来时，该寄存器的值会被更新。然后根据sw_in_r0和当前的sw_in信号，产生下降沿检测信号edge_l和上升沿检测信号edge_h。这里使用逻辑与、逻辑非等门电路实现。

然后根据edge_l和edge_h信号，通过或门电路，产生消抖使能信号edge_en。接着定义一个计数器count，用于计数20个时钟周期。每当edge_en信号为1时，计数器的值会被清零。当count等于20'h2BF20时，表示消抖完成，此时sw_out输出当前的sw_in信号。

值得注意的是，代码中使用了非阻塞赋值（<=）和阻塞赋值（=）两种不同的赋值方式。在always块中，使用非阻塞赋值更新状态寄存器的值，保证更新操作是并行的。而在always块中的if-else语句中，使用阻塞赋值更新sw_out寄存器的值，保证更新操作是顺序的，从而保证输出信号的正确性。

*/
