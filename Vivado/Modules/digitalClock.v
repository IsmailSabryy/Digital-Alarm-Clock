`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2024 04:12:43 PM
// Design Name: 
// Module Name: digitalClock
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module digitalClock(input clk, rst, en,C, L , R , U , D ,
output [6:0] segments,output  [3:0] anode_active,output reg dp,output LD0,LD9,LD12,LD13,LD14,LD15);

wire [13:0]  count; 
wire outC,outD,outU,outL,outR; 
clockDivider #(500000)div2(clk, rst, clk_buttons);
//clockDivider div3(clk, rst, clk_buttonsU);

pushButtonDetector C_btn (clk_buttons,rst, C , outC);
pushButtonDetector D_btn(clk_buttons,rst, D, outD);
pushButtonDetector U_btn(clk_buttons,rst, U, outU);
pushButtonDetector L_btn(clk_buttons,rst, L, outL);
pushButtonDetector R_btn(clk_buttons,rst, R, outR);
 
 
minSecCount mrClock( .clk(clk),.clkBTN(clk_buttons), .rst(rst), .en(en),.C(outC),.L(outL),.R(outR),.U(outU),.D(outD), .MUX_count(count),
.LD0(LD0),.LD12(LD12),.LD13(LD13),.LD14(LD14),.LD9(LD9),.LD15(LD15));
wire [3:0] f4 = count[3:0];
wire [2:0] t3 = count[6:4];
wire [3:0] s2 = count[10:7];
wire [2:0] f1 = count[13:11];
wire [1:0] s;
wire[3:0] muxOut;
wire clk_out,clk_out2,clk_buttons,clk_buttonsU;


clockDivider #(250000)div(clk, rst, clk_out);
counter_x_bit #(2,4) select(.clk(clk_out), .reset(rst),.en(en), .count(s));

mux4x1 Mux(.data_in_0(f4),.data_in_1({1'b0,t3}),.data_in_2(s2),.data_in_3({1'b0,f1}),.sel(s), .data_out(muxOut));

SevenSegDecWithEn segf4(.en(s),.in(muxOut),.segments(segments), .anode_active(anode_active));




clockDivider #(50000000)DUUT(.clk(clk), .rst(rst), .clk_out(clk_out2));
always @(*)
begin
if(anode_active==4'b1101 && clk_out2) 
 dp =0;
 else dp=1;

end

endmodule
