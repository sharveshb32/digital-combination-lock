
module control_path(input clk,rst,input data_valid,output reg [1:0] key_sel,output reg unlock);
reg [1:0] state;
parameter s0=2'b00,s1=2'b01,s2=2'b10,s3=2'b11;
always @(posedge clk or posedge rst)
begin
if(rst)state<=2'b00;
else
begin
case (state)
2'b00:if(data_valid)state<=2'b01;
2'b01:if(data_valid)state<=2'b10;else state<=2'b00;
2'b10:if(data_valid)state<=2'b11; else state<=2'b00;
2'b11:state<=2'b11;
default:state<=1'b0;
endcase
end
end
always @(*)
begin
unlock=1'b0;
key_sel=2'b00;
case(state)
2'b00:key_sel=2'b00;
2'b01:key_sel=2'b01;
2'b10:key_sel=2'b10;
2'b11:unlock=1'b1;
default:key_sel=2'b00;
endcase

end
endmodule
