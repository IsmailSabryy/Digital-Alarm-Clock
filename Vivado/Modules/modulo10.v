`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2024 02:48:10 PM
// Design Name: 
// Module Name: modulo10
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


module modulo10(input clk, rst, en,dec,tens,D,output [3:0] count);
//wire clk_out;
//clockDivider clockDiv(.clk(clk), .rst(rst), .clk_out(clk_out));
counter_x_bit  #(4,10) mod10 (.clk(clk), .reset(rst), .en(en),.tens(tens),.dec(dec),.D(D),.count(count));
endmodule
