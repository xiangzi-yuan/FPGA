**数字系统综合设计 （数电课设）**
*出租车行程计费器*
设计要求：设计一个出租车计价器，能显示里程和费用。
（1）乘客上车后，按下启动键，开始计费，到达目的
地后再次按启动，停止计费。
（2）起步价可以设置，里程单价可以设置。
（3）根据出租车上的速度传感器传来的脉冲个数
（对应里程）和设置的里程单价来计算
对应的总价格，并将总价格和里程通过LED实时显示。





*等精度数字频率计*
使用Verilog设计一个等精度数字频率计
方案一：
传统测频是在一段闸门时间内直接对输入信号的周期进行计数，也被叫做直接测频法。设闸门信号为gate，检测待测信号上升沿，然后判断gate是否为高电平，若为高电平便开始计数。这就存在gate的时间和待测信号周期数可能不成整数倍，导致产生+1hz或-1hz的误差。
方案二：
等精度测频可以弥补传统测频的缺点，它保证了闸门时间永远是被测信号周期的整数倍。设预设闸门信号为base，实际闸门信号为gate，检测待测信号上升沿，当base为高电平时，实际闸门打开，gate为高电平，此时两个计数器同时对标准信号和待测信号的周期进行计数。当base为低电平，实际闸门关闭，gate为低电平计数器停止计数
