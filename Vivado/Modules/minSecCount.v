
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2024 03:36:25 PM
// Design Name: 
// Module Name: minSecCount
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

module minSecCount(input clk, clkBTN, rst, en, C,L,R,U,D, output [13:0] MUX_count,output reg LD0,LD9,LD12,LD13,LD14,LD15);
//[13:0] A_count,

 clockDivider #(50000000)div(clk, rst, clk_out1HZ);
reg visited=0;
reg clicked;
wire [3:0] secount;
wire [2:0] secount2;
wire MUXclk;
reg adj;
wire [13:0] count;
wire [13:0] A_count;
wire [13:0] MUX_count;
//assign MUXclk = (state!=CLK)? (U|D): clk;
//wire [5:0] time_minutes = count[5:0];
//wire [2:0] t3 = count[6:4];
//wire [3:0] s2 = count[10:7];
//wire [2:0] f1 = count[13:11];



reg [2:0] state, nextState; 
parameter [2:0] CLK= 3'b000, TH = 3'b001, TM = 3'b010, AH=3'b011, AM=3'b100, AS=3'b101; // States Encoding
always @ (*) begin
case (state)
CLK: if ({R,L,C}==3'b001) nextState = TH;
    else if (!visited & count==A_count) nextState= AS;
 else nextState = CLK;
 
TH: if ({R,L,C}==3'b100) nextState = TM;
 else if ({R,L,C}==3'b010) nextState = AM;
 else if ({R,L,C}==3'b001) nextState = CLK;
 else nextState =TH;
 
TM: if ({R,L,C}==3'b100) nextState = AH;
 else if ({R,L,C}==3'b010) nextState = TH;
 else if ({R,L,C}==3'b001) nextState = CLK;
 else nextState =TM;
 
AH: if ({R,L,C}==3'b100) nextState = AM;
 else if ({R,L,C}==3'b010) nextState = TM;
 else if ({R,L,C}==3'b001) nextState = CLK;
 else nextState =AH;
 
AM: if ({R,L,C}==3'b100) nextState = TH;
 else if ({R,L,C}==3'b010) nextState = AH;
 else if ({R,L,C}==3'b001) nextState = CLK;
 else nextState =AM;
//default: nextState= CLK;
AS:if(U|D|R|L|C) nextState=CLK;
else nextState =AS;
endcase
end
always @ (posedge clkBTN or  posedge rst) begin
if(rst)
state <= CLK;
else
state <= nextState;
end
reg ENC,ENTH,ENTM,ENAM,ENAH;
reg clkAdjst;
//wire clk_out5;
// clockDivider #(50000000)div33(clk, rst, clk_out5);
reg btnPressed,BTN;
wire dec;
always @(*)
begin
BTN = (state==CLK&A_count==count&(U|D|R|L|C));
if(state==CLK)
    begin
        {LD12,LD13,LD14,LD15}=5'b0000;
        ENC=en;
        ENTH=0;
        ENTM=0;
        ENAM=0;
        ENAH=0;
         LD0 = 0;
         LD9 = 0;
//        if(!clicked)
//       begin
//        LD0 = (A_count == count) ? clk_out1HZ : 1'b0;
//         LD9 = (A_count == count) ? clk_out1HZ : 1'b0;
//        end
    end
else begin
        ENC=0;
         visited=0;
   end     
//if (state==AS) begin

//end

//if(state==clk&A_count==count&!BTN)
//begin 
//clicked=1;
//end
//if(clicked)begin
//LD0=0;
//LD9=0;
//end
if(state==AS) begin visited=1;
  LD0 = (A_count == count) ? clk_out1HZ : 1'b0;
  LD9 = (A_count == count) ? clk_out1HZ : 1'b0;
end
else if (state==TH) begin
{LD0,LD12,LD13,LD14,LD15}=5'b11000;
ENTH=U|D;
end
else if (state==TM) begin 
{LD0,LD12,LD13,LD14,LD15}=5'b10100;
ENTM=U|D;
end
else if (state==AH)begin
{LD0,LD12,LD13,LD14,LD15}=5'b10010;
ENAH=U|D;
end
else if (state==AM) begin
{LD0,LD12,LD13,LD14,LD15}=5'b10001;
ENAM=U|D;
end

if(state==CLK) clkAdjst=clk_out1HZ;
else clkAdjst = clkBTN;
end
assign dec = (ENTH & D) & (count[10:7]==0) & (count[13:11] ==0); 
assign dec2 = (ENAH & D) & (A_count[10:7]==0) & (A_count[13:11] ==0);
modulo10 secu( .clk(clkAdjst), .rst(rst),.en(ENC),.dec(dec),.D(D),.tens(0),.count(secount));
modulo6 sect( .clk(clkAdjst), .rst(rst), .en((secount==9)&ENC),.dec(dec),.tens(0),.D(D),.count(secount2));




wire en_hours_mins;
assign  en_hours_mins = ENC ?(secount==9)&(count[3:0]==9)&(secount2==5): count[3:0]==9 & ENTM&!D| (ENTM&(D&count[3:0]==0));

modulo10 minu( .clk(clkAdjst), .rst(rst),.en(((secount==9)&(secount2==5)&ENC)|ENTM),.dec(dec),.tens(0),.D(D),.count(count[3:0]));
modulo6 mint( .clk(clkAdjst), .rst(rst), .en(en_hours_mins),.dec(dec),.tens(0),.D(D),.count(count[6:4]));

modulo10 hrsu( .clk(clkAdjst), .rst(rst|((count[10:7]==4)&(count [13:11]==2))),
 .en(ENC ? (count[6:4]==5)&(secount==9)&(count[3:0]==9)&(secount2==5):ENTH),.dec(dec),.tens(0),.D(D),.count(count[10:7]));
wire en_hours_tens;
assign  en_hours_tens = ENC ? count[10:7]==9&(count[6:4]==5)&(secount==9)&(count[3:0]==9)&(secount2==5): (count[10:7]==9 & ENTH &U) | (ENTH &(D&count[10:7]== 0));
modulo_3 hrst( .clk(clkAdjst), .rst(rst|((count[10:7]==4)&(count [13:11]==2))), .en(en_hours_tens),.dec(0),.tens(1),.D(D),.count(count[13:11]));



modulo10 minuTO( .clk(clkAdjst), .rst(rst),.en(ENAM),.dec(dec2),.tens(0),.D(D),.count(A_count[3:0]));
modulo6 mintO( .clk(clkAdjst), .rst(rst), .en(A_count[3:0]==9 & ENAM&!D| (ENAM&(D&A_count[3:0]==0))),.dec(dec2),.tens(0),.D(D),.count(A_count[6:4]));

modulo10 hrsuO( .clk(clkAdjst), .rst(rst|((A_count[10:7]==4)&(A_count [13:11]==2))),
 .en(ENAH),.dec(dec2),.tens(0),.D(D),.count(A_count[10:7]));

modulo_3 hrstO( .clk(clkAdjst), .rst(rst|((A_count[10:7]==4)&(A_count [13:11]==2))), .en((A_count[10:7]==9 & ENAH &U) | (ENAH &(D&A_count[10:7]== 0))),.dec(0),.tens(1),.D(D),.count(A_count[13:11]));

//modulo10 A_minu( .clk(clk), .rst(rst), .en(ENAM),.count(A_count[3:0]),.dec(dec2),.tens(0),.D(D));
//modulo6 A_mint( .clk(clk), .rst(rst), .en((A_count[3:0]==9)&ENAM),.dec(dec2),.count(A_count[6:4]),.D(D));

//modulo10 A_hrsu( .clk(clk), .rst(rst|((A_count[10:7]==4)&(A_count [13:11]==2))),.dec(dec2), .en(ENAH),.count(A_count[10:7]),.D(D));
//modulo_3 A_hrst( .clk(clk), .rst(rst|((A_count[10:7]==4)&(A_count [13:11]==2))),.dec(0),.en((A_count[10:7]==9&ENAH)),.D(D),.count(A_count[13:11]));

assign MUX_count = (state == AH |state == AM) ? A_count : count;


endmodule
