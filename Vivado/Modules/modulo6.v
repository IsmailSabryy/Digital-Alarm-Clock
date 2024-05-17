`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2024 03:38:10 PM
// Design Name: 
// Module Name: modulo6
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


module modulo6(input clk, rst, en,dec,tens,D,output [2:0] count);
//wire clk_out;
//clockDivider clockDiv(.clk(clk), .rst(rst), .clk_out(clk_out));
counter_x_bit  #(3,6) mod6 (.clk(clk), .reset(rst), .en(en),.tens(tens),.dec(dec),.D(D),.count(count));
endmodule
