`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2024 04:07:08 PM
// Design Name: 
// Module Name: mux4x1
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

module mux4x1 (
    input [3:0] data_in_0,
    input [3:0] data_in_1,
    input [3:0] data_in_2,
    input [3:0] data_in_3,
    input [1:0] sel,
    output reg [3:0] data_out
);

always @(*) begin
    case(sel)
        2'b00: data_out = data_in_0;
        2'b01: data_out = data_in_1;
        2'b10: data_out = data_in_2;
        2'b11: data_out = data_in_3;
        default: data_out = 4'bxxxx; // Default case, can be don't care
    endcase
end

endmodule

