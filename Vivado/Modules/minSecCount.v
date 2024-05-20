
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
/*******************************************************************
*
* Module: minSecCount.v
* Project: Alarm_Clock
* Author: Islam  islamemara@aucegypt.edu
          Aly    alyelaswad@aucegypt.edu
          Ismail ismailsabry@aucegypt.edu
* Description: The module that outputs the count for the alarm, count for the clock, the LED signals and the buzzer signal
*
* Change history: 05/13/24 - Built the module and added the hour units and counter hour tens counter
*                 05/15/24 - Adjusted the states logic by using 5 states (the states: clock, time hour, time minute, alarm hour, and the alarm minute),
                  added the alarm counters, adjusted different clocks and added a MUX for the alarm and clock count.    
*                 05/16/24 - Fixed major errors in the buzzer, fixed errors in the decimal point, added the alarm state to disable the alarm upon pressing any button  
**********************************************************************/

module minSecCount(
input clk, clkBTN, rst, en, C,L,R,U,D, // input for the regular clock, the clock of buttons, reset, enable and buttons 
output [13:0] MUX_count, // The count outout: either the alarm or the clock
output reg LD0,buzzer,LD12,LD13,LD14,LD15,dp1); // output of the LEDs and the decimal point 

clockDivider #(50000000)div(clk, rst, clk_out1HZ); // Clock divider for the 1 Hz clock   
reg visited=0; // register to check if the alarm visited  
wire [3:0] secount; // count for the seconds units
wire [2:0] secount2; // count for the seconds tens
wire [13:0] count; // Count for the Time hour and minutes
wire [13:0] A_count; // Count for the Alarm hour and minutes
wire [13:0] MUX_count; // Count for either the Time hour and minutes or Alarm hour and minutes




reg [2:0] state, nextState; // Registers for the current and next states
parameter [2:0] CLK= 3'b000, TH = 3'b001, TM = 3'b010, AH=3'b011, AM=3'b100, AS=3'b101; // States Encoding
always @ (*) begin
case (state) // Combinational logic for the states stage

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

AS: if(U|D|R|L|C) nextState=CLK;
    else if(count!=A_count)  nextState=CLK;
    else nextState =AS;

endcase
end

always @ (posedge clkBTN or  posedge rst) begin // Sequential logic for the next state 
    if(rst)
        state <= CLK;
    else
        state <= nextState;
    end

reg ENC;  // Enable for the clock and alarm states
reg ENTH, // Enable for the Time hour states   
    ENTM, // Enable for the Time minute states
    ENAM, // Enable for the Alarm mintue states
    ENAH; // Enable for the alarm hour states

reg clkAdjst; // Clock for the counters

reg BTN; 
wire dec; // wire for the decrement 
always @(*)
    begin
        BTN = (state==CLK&A_count==count&(U|D|R|L|C));
        if(state==CLK) // Clock state
        begin
            {LD12,LD13,LD14,LD15}=5'b0000; 
            ENC=en;
            ENTH=0;
            ENTM=0;
            ENAM=0;
            ENAH=0;
            dp1=0;
            LD0 = 0;
            buzzer = 0;
            dp1=1;
        end
        
    else
        visited=0;    
    
    if(state==AS) begin // Alarm state
       visited=1;
       LD0 = (A_count == count) ? clk_out1HZ : 1'b0;
       buzzer = (A_count == count) ? clk_out1HZ : 1'b0;
       dp1=1;
       ENC=en;
       ENTH=0;
       ENTM=0;
       ENAM=0;
       ENAH=0;
    end
    
    else if (state==TH) begin  // Time hour state
       {LD0,LD12,LD13,LD14,LD15}=5'b11000;
       ENTH=U|D;
       dp1=0;
       ENC=0;
       ENTM=0;
       ENAM=0;
       ENAH=0;
    end
    
    else if (state==TM) begin // Time minutes state
       {LD0,LD12,LD13,LD14,LD15}=5'b10100;
       ENTM=U|D;
       dp1=0;
       ENC=0;
       ENAM=0;
       ENAH=0;
    end
    
    else if (state==AH) begin // Alarm hour state 
       {LD0,LD12,LD13,LD14,LD15}=5'b10010; 
       ENAH=U|D;
       dp1=0;
       ENC=0;
       ENTM=0;
       ENAM=0;
    end
    
    else if (state==AM) begin // Alarm minutes state
       {LD0,LD12,LD13,LD14,LD15}=5'b10001;
       ENAM=U|D;
       dp1=0;
       ENC=0;
       ENTM=0;
       ENAH=0;
    end
    
    if(state==CLK|state==AS) clkAdjst=clk_out1HZ; // Adjusting the clock for the counters based on the states
    else clkAdjst = clkBTN;
end

assign dec = (ENTH & D) & (count[10:7]==0) & (count[13:11] ==0); // Decrement for the clock 

assign dec2 = (ENAH & D) & (A_count[10:7]==0) & (A_count[13:11] ==0); // Decrement for the Alarm

modulo10 secu( .clk(clkAdjst), .rst(rst),.en(ENC),.dec(dec),.D(D),.tens(0),.count(secount)); // Counter for the secounds units

modulo6 sect( .clk(clkAdjst), .rst(rst), .en((secount==9)&ENC),.dec(dec),.tens(0),.D(D),.count(secount2)); // Counter for the secounds tens

wire en_hours_mins; // enable for the hour minute counter 

assign  en_hours_mins = ENC ?(secount==9)&(count[3:0]==9)&(secount2==5): count[3:0]==9 & ENTM&!D| (ENTM&(D&count[3:0]==0));

modulo10 minu( .clk(clkAdjst), .rst(rst),.en(((secount==9)&(secount2==5)&ENC)|ENTM),.dec(dec),.tens(0),.D(D),.count(count[3:0])); // Counter for the time minutes units
modulo6 mint( .clk(clkAdjst), .rst(rst), .en(en_hours_mins),.dec(dec),.tens(0),.D(D),.count(count[6:4])); // Counter for the time minutes tens

modulo10 hrsu( .clk(clkAdjst), .rst(rst|((count[10:7]==4)&(count [13:11]==2))),
 .en(ENC ? (count[6:4]==5)&(secount==9)&(count[3:0]==9)&(secount2==5):ENTH),.dec(dec),.tens(0),.D(D),.count(count[10:7])); // Counter for the time hours units

wire en_hours_tens; // enable for the hour tens counter

assign  en_hours_tens = ENC ? count[10:7]==9&(count[6:4]==5)&(secount==9)&
(count[3:0]==9)&(secount2==5): (count[10:7]==9 & ENTH &U) | (ENTH &(D&count[10:7]== 0));

modulo_3 hrst( .clk(clkAdjst), .rst(rst|((count[10:7]==4)&(count [13:11]==2))), 
.en(en_hours_tens),.dec(0),.tens(1),.D(D),.count(count[13:11]));  // Counter for the time hours tens



modulo10 minuTO( .clk(clkAdjst), .rst(rst),.en(ENAM),.dec(dec2),.tens(0),.D(D),.count(A_count[3:0])); // Counter for the alarm minutes units

modulo6 mintO( .clk(clkAdjst), .rst(rst), .en(A_count[3:0]==9 & ENAM&!D | (ENAM&(D&A_count[3:0]==0))),
.dec(dec2),.tens(0),.D(D),.count(A_count[6:4])); // Counter for the alarm hours tens

modulo10 hrsuO( .clk(clkAdjst), .rst(rst|((A_count[10:7]==4)&(A_count [13:11]==2))),
 .en(ENAH),.dec(dec2),.tens(0),.D(D),.count(A_count[10:7])); // Counter for the alarm hours units

modulo_3 hrstO( .clk(clkAdjst), .rst(rst|((A_count[10:7]==4)&(A_count [13:11]==2))), .en((A_count[10:7]==9 & ENAH &U)
 | (ENAH &(D&A_count[10:7]== 0))),.dec(0),.tens(1),.D(D),.count(A_count[13:11])); // Counter for the alarm hours tens



assign MUX_count = (state == AH |state == AM) ? A_count : count; // Choosing the count based on the state

endmodule
