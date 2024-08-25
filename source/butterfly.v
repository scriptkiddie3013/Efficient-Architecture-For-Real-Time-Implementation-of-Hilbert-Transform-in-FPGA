`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.04.2024 10:44:10
// Design Name: 
// Module Name: butterfly
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


module butterfly( output [20:0]real_outa,imag_outa,real_outb,
                               imag_outb,
                  input [20:0]real_ina,imag_ina,
                              real_inb,imag_inb);
                
assign real_outa = real_ina+real_inb;
assign real_outb = real_ina + ~(real_inb)+1;
assign imag_outa = imag_ina+imag_inb;
assign imag_outb = imag_ina+ ~(imag_inb)+1;
endmodule
