`timescale 1ns / 1ps
module data_path(input [1:0]data,input [1:0]key_sel,output reg data_valid);
parameter key1=2'b01,key2=2'b00,key3=2'b11;
always @(*)
begin
case (key_sel)
2'b00:data_valid=(data==key1);
2'b01:data_valid=(data==key2);
2'b10:data_valid=(data==key3);
default:data_valid=1'b0;
endcase
end
endmodule
