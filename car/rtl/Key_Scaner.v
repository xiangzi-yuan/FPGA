module Key_Scaner(clk_scan,
                  clk_debounce,
                  row,
                  col,
                  Key_out);
  input [3:0]col;
  input clk_scan,clk_debounce;  // key_scan:20Hz; key_debounce:200Hz;
  output [3:0]row;
  output[4:0]Key_out;
  
  wire [3:0]R;
  reg [3:0]col_debounced;
  reg [3:0]row;
  reg [4:0]key_value;
  reg [4:0]Key_out;
  
  reg [3:0]key_temp1,key_temp2,key_temp3;
  reg [1:0]count;
  
  always @( posedge clk_scan )
  begin
    Key_out <= key_value;
    count   <= count + key_value[4];
  end
  
  always @( count ) begin
    case( count )
      2'b00: row <= 4'b1110;
      2'b01: row <= 4'b1101;
      2'b10: row <= 4'b1011;
      2'b11: row <= 4'b0111;
    endcase
  end
  
  
  always @( posedge clk_debounce )begin
    key_temp1 <= col;
    key_temp2 <= key_temp1;
    key_temp3 <= key_temp2;
  end
  
  assign R = ( key_temp1 | key_temp2 | key_temp3 );
  
  always @( posedge clk_debounce )
    case( R )
      4'b0111: col_debounced <= 4'b0111;
      4'b1011: col_debounced <= 4'b1011;
      4'b1101: col_debounced <= 4'b1101;
      4'b1110: col_debounced <= 4'b1110;
      default: col_debounced <= 4'b1111;
    endcase
  
  always @( row or col_debounced )
    case( col_debounced )
      4'b1110:
      begin
        case( row )
          4'b1110: key_value = 5'd0;
          4'b1101: key_value = 5'd4;
          4'b1011: key_value = 5'd8;
          4'b0111: key_value = 5'd12;
          default: key_value = 5'd31;
        endcase
      end
      4'b1101:
      begin
        case( row )
          4'b1110: key_value = 5'd1;
          4'b1101: key_value = 5'd5;
          4'b1011: key_value = 5'd9;
          4'b0111: key_value = 5'd13;
          default: key_value = 5'd31;
        endcase
      end
      4'b1011:
      begin
        case( row )
          4'b1110: key_value = 5'd2;
          4'b1101: key_value = 5'd6;
          4'b1011: key_value = 5'd10;
          4'b0111: key_value = 5'd14;
          default: key_value = 5'd31;
        endcase
      end
      4'b0111:
      begin
        case( row )
          4'b1110: key_value = 5'd3;
          4'b1101: key_value = 5'd7;
          4'b1011: key_value = 5'd11;
          4'b0111: key_value = 5'd15;
          default: key_value = 5'd31;
        endcase
      end
      default: key_value = 5'd31;
    endcase
  
endmodule

/*
这段代码是一个Verilog模块(Key_Scaner)，它用于检测矩阵键盘上按键的状态，并将按键值传输到输出端口Key_out上。该模块有四个输入端口(clk_scan, clk_debounce, col, key_out)和两个输出端口(row和key_out)。其中，clk_scan和clk_debounce是时钟信号，col是用于输入扫描的列信息，row是输出的行信息，key_out是按键值的输出。该模块的工作原理如下：

首先，在时钟信号clk_scan的上升沿触发的always块中，将key_value赋值给Key_out，并且将count加上key_value[4]。这个操作是用于计算按键持续的时间，具体来说，如果按键被按下，则key_value[4]为1，否则为0。
接着，在always @(count)块中，根据count的值更新row的值。具体来说，如果count的值为00，则row的值为1110，如果count的值为01，则row的值为1101，如果count的值为10，则row的值为1011，如果count的值为11，则row的值为0111。
然后，在时钟信号clk_debounce的上升沿触发的always块中，通过将col的值反复复制三次，将key_temp1、key_temp2和key_temp3的值更新为当前扫描到的列信息，然后根据这三个值的逻辑或运算的结果R，得到消抖后的列信息col_debounced。
接下来，在根据row和col_debounced的值，得到key_value的值。具体来说，首先判断col_debounced的值，如果为1110，则根据row的值来更新key_value的值，如row的值为1110，则key_value的值为0，如row的值为1101，则key_value的值为4，以此类推。如果col_debounced的值不在上述四个值中，则key_value的值为31。同样的方法被应用到其他列的情况下。
该模块实现了基于矩阵键盘的按键检测功能，并可以将按键值输出到外部电路中，可以被用于实现各种类型的数字电路设计。

*/
