`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2024 03:32:28 PM
// Design Name: 
// Module Name: modulo5
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


module modulo5(input clk, rst, en,up_down,output [2:0] count);
wire clk_out;
clockDivider clockDiv(.clk(clk), .rst(rst), .clk_out(clk_out));
counter_x_bit  #(3,5) mod10 (.clk(clk_out), .reset(rst), .en(en),.up_down(up_down),.count(count));
endmodule