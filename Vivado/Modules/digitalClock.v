`timescale 1ns / 1ps
/*******************************************************************
*
* Module: digitalClock.v
* Project: Alarm_Clock
* Author: Islam  islamemara@aucegypt.edu
          Aly    alyelaswad@aucegypt.edu
          Ismail ismailsabry@aucegypt.edu
* Description: The main module that conncets the modules: mux4x1, minSecCount, pushButtonDetector, clockDivider and SevenSegDecWithEn
*
* Change history: 05/13/24 – built the module, added the MUX, added the clockdivider, added the MUX and added the minSecCount  
*                 05/15/24 – Changed the Pushbutton clock, adjsuted the decimal point and adjusted the LEDs   
*                 05/16/24 - Fixed an issue in the decimal point, adjsuted Buzzer output and fixed issues in the different clocks used 
**********************************************************************/


module digitalClock(
input clk, rst, en,C,L,R,U,D, // Inputs for the clock, reset, enable and the buttons
output [6:0] segments, [3:0] anode_active, // Output for the segments display and anode active
output LD0,buzzer,LD12,LD13,LD14,LD15,  // Output for the LEDs 
output reg dp); // Output for the decimal point

wire dp1; // wire to disable the decimal point in adjust mode
wire [13:0]  count; // The count output of the hour and minutes counters of the clock OR the output of the hour minutes of the alarm
wire outC,outD,outU,outL,outR; // The output of the pushbuttons
clockDivider #(500000)div2(clk, rst, clk_buttons); // The clockdivider for the clock of the pushbuttons

pushButtonDetector C_btn (clk_buttons,rst, C , outC); // The center pushbutton
pushButtonDetector D_btn(clk_buttons,rst, D, outD);  // The Down pushbutton
pushButtonDetector U_btn(clk_buttons,rst, U, outU);  // The Up pushbutton
pushButtonDetector L_btn(clk_buttons,rst, L, outL);  // The left pushbutton
pushButtonDetector R_btn(clk_buttons,rst, R, outR);  // The right pushbutton
 
 
minSecCount mrClock( .clk(clk),.clkBTN(clk_buttons), .rst(rst), .en(en),.C(outC),.L(outL),.R(outR),.U(outU),.D(outD), .MUX_count(count),
.LD0(LD0),.LD12(LD12),.LD13(LD13),.LD14(LD14),.buzzer(buzzer),.LD15(LD15),.dp1(dp1)); // The module that otput the count of the clock and the alarm
wire [3:0] f4 = count[3:0]; // wires used to put the count in the MUX 
wire [2:0] t3 = count[6:4]; // wires used to put the count in the MUX
wire [3:0] s2 = count[10:7]; // wires used to put the count in the MUX
wire [2:0] f1 = count[13:11]; // wires used to put the count in the MUX
wire [1:0] s; // Wire for the 2 bit binary counter used for the MUX and the 2x4 decoder 
wire[3:0] muxOut; // Wire for the multiplexer output 
wire clk_out, // clock for the 2 bit binary counter 
clk_out2 // clock for the decimal point 
,clk_buttons; // clock for the push buttons  


clockDivider #(250000)div(clk, rst, clk_out); // The clockdivider for the clock of the 2 bit binary counter
counter_x_bit #(2,4) select(.clk(clk_out), .reset(rst),.en(en), .count(s)); // 2 bit binary counter used for the MUX and the 2x4 decoder 

mux4x1 Mux(.data_in_0(f4),.data_in_1({1'b0,t3}),.data_in_2(s2),.data_in_3({1'b0,f1}),.sel(s), .data_out(muxOut)); // The MUX for the multiplexed display of the clock

SevenSegDecWithEn segf4(.en(s),.in(muxOut),.segments(segments), .anode_active(anode_active)); // Seven segment module for the display of the alarm and the clock




clockDivider #(50000000)DUUT(.clk(clk), .rst(rst), .clk_out(clk_out2)); // The clockdivider for the clock of the decimal point
always @(*) // Assigning the the decimal point with the clock in clock mode and assigining it with 0 in the adjust mode
begin
if(anode_active==4'b1101&& dp1) 
dp= clk_out2;   
else  dp= 1; 
end

endmodule
