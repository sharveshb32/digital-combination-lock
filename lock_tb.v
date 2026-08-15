`timescale 1ns / 1ps
module lock_tb();
reg [1:0] data;
reg clk;
wire unlock;
reg rst;
wire[1:0]key_sel;
control_path a1(clk,rst,data_valid,key_sel,unlock);
data_path a2(data,key_sel,data_valid);
always #5clk=~clk;
initial
begin
clk=0;
#2 rst=1;
#10 rst=0;data=2'b01;
#10 data=2'b00;
#10 data=2'b11;
#10 rst=1;
#10 rst=0;data=2'b00;
#10 data=2'b01;
#10 data=2'b11;
#10 data=2'b01;
#10 data=2'b00;
#10 data=2'b10;
#10 $finish;
end
endmodule
