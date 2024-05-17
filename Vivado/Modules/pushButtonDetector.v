`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2024 03:54:47 PM
// Design Name: 
// Module Name: pushButtonDetector
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


module pushButtonDetector(input clk,rst, x, output z);
wire out1,out2;
debouncer debounce(clk, rst, x, out1);
synchronizer synchronize(out1,clk, out2);
rising_edge riseEdge(clk, rst, out2, z);
endmodule
