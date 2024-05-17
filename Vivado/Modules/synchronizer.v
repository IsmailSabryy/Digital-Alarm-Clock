`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2024 03:56:42 PM
// Design Name: 
// Module Name: synchronizer
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



module synchronizer(input SIG,clk,output SIG1);
wire META;
wire METAb;
wire SIG1b;
DFF dff1(.clk(clk),.d(SIG),.q(META),.nq(METAb));
DFF dff2(.clk(clk),.d(META),.q(SIG1),.nq(SIG1b));
endmodule


