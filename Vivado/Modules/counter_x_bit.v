`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2024 01:18:37 PM
// Design Name: 
// Module Name: counter_x_bit
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

module counter_x_bit #(parameter x = 3, n = 6)(input clk, reset,en,dec,tens,D, output  [x-1:0] count);

//module counter_x_bit #(parameter x = 3, n = 6)(input clk, reset,en,D, output  [x-1:0] count);
//reg [x-1:0] count;
//always @(posedge clk, posedge reset) begin
// if (reset == 1)
// count <= 0; // non-blocking assignment
 
// // initialize flip flop here
// else
//  if(en==1)
//  begin
 
//     if (count == n-1&!D)
//    count <= 0; // non-blocking assignment
//    else if(D& count == 0)
//    count <=n-1;
//    // reach count end and get back to zero
//     else
//    if(D)
//    begin
//    count<= count - 1;
//    end else
//   count <= count + 1; // non-blocking assignment
// // normal operation
//    end
//end


//endmodule
reg [x-1:0] count;
always @(posedge clk, posedge reset) begin
 if (reset == 1)
 count <= 0; // non-blocking assignment
 
 // initialize flip flop here
 else
  if(en==1)
  begin
  
 
     if (count == n-1&!D)
    count <= 0; // non-blocking assignment
    else if(D& count == 0 &!dec)
    count <=n-1;
    else if(D& count == 0 & dec)
    count <=3; 
 
    // reach count end and get back to zero
 else  
    if(D)
    begin
    count<= count - 1;
    end else 
   count <= count + 1; // non-blocking assignment
 // normal operation
    end
end


endmodule