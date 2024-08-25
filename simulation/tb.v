`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.04.2024 12:26:19
// Design Name: 
// Module Name: tb
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


module tb();

wire [20:0]outr,outi;
reg [20:0]in;
reg clk,rst;

FFT DFT( outr,outi,in,clk,rst );

initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial
begin
    rst = 1;
    #100
    rst = 0;
    in = 21'b0_0000000001_0000000000;
    #20
    in = 21'b0_0000000010_0000000000;
    #20 
    in = 21'b0_0000000011_0000000000;
    #20
    in = 21'b0_0000000100_0000000000;
    #20 
    in = 21'b0_0000000001_0000000000;
    #20
    in = 21'b0_0000000010_0000000000;
    #20 
    in = 21'b0_0000000011_0000000000;
    #20
    in = 21'b0_0000000100_0000000000;
end
endmodule
