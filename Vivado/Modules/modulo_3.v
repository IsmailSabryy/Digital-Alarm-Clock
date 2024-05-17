`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2024 03:33:46 PM
// Design Name: 
// Module Name: modulo_3
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


module modulo_3(input clk, rst, en,dec,tens,D,output [1:0] count);
//wire clk_out;
//clockDivider clockDiv(.clk(clk), .rst(rst), .clk_out(clk_out));
counter_x_bit  #(2,3) mod10 (.clk(clk), .reset(rst), .en(en),.tens(tens),.dec(dec),.D(D),.count(count));
endmodule