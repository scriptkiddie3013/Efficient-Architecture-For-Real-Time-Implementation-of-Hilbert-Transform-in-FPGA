`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.04.2024 10:42:12
// Design Name: 
// Module Name: FFT
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


module FFT( output reg [20:0]outr,outi,
            input [20:0]in,
            input clk,rst
    );

reg [3:0]state,nxt_state;
parameter s0 = 0,s1 = 1,s2 = 2,s3 =3,s4 =4,s5 = 5,s6 = 6;

reg [3:0]i,k,p,n,out;

reg [20:0]x[7:0];
reg done,done1;
reg [20:0]butterfly_in_r0[7:0];
reg [20:0]butterfly_in_i0[7:0];
wire [20:0]butterfly_out_r0[7:0];
wire [20:0]butterfly_out_i0[7:0];

reg [20:0]real_array[7:0];
reg [20:0]imag_array[7:0];

reg [41:0]dum[18:0];//12
reg [20:0]dum1[7:0];//3
wire [20:0]check = 21'd724;

butterfly b0(butterfly_out_r0[0],butterfly_out_i0[0],butterfly_out_r0[1],butterfly_out_i0[1]
             ,butterfly_in_r0[0],butterfly_in_i0[0],butterfly_in_r0[1],butterfly_in_i0[1]);
butterfly b1(butterfly_out_r0[2],butterfly_out_i0[2],butterfly_out_r0[3],butterfly_out_i0[3]
             ,butterfly_in_r0[2],butterfly_in_i0[2],butterfly_in_r0[3],butterfly_in_i0[3]);
butterfly b2(butterfly_out_r0[4],butterfly_out_i0[4],butterfly_out_r0[5],butterfly_out_i0[5]
             ,butterfly_in_r0[4],butterfly_in_i0[4],butterfly_in_r0[5],butterfly_in_i0[5]);
butterfly b3(butterfly_out_r0[6],butterfly_out_i0[6],butterfly_out_r0[7],butterfly_out_i0[7]
             ,butterfly_in_r0[6],butterfly_in_i0[6],butterfly_in_r0[7],butterfly_in_i0[7]);
             
always @(*)
begin
    if(butterfly_out_r0[6][20] == 1 ) 
    begin
        dum1[0] = (~butterfly_out_r0[6]+1);
        dum[1] = dum1[0]*check;
        dum[2] = ~dum[1]+1; // intermediate real
    end
    else dum[2] = (butterfly_out_r0[6])*check; 
    
    if(butterfly_out_i0[6][20] == 1 ) 
    begin
        dum1[1] = (~butterfly_out_i0[6]+1);
        dum[3] = dum1[1]*check;
        dum[4] = ~dum[3]+1;// intermediate img
    end
    else dum[4] = (butterfly_out_i0[6])*check; 
    
    dum[5] = dum[2] + dum[4];//real
    
    dum[6] = dum[4] + ~dum[2] + 1;//imag
    
    //
    
     if(butterfly_out_r0[7][20] == 1 ) 
    begin
        dum1[2] = (~butterfly_out_r0[7]+1);
        dum[7] = dum1[2]*check;
        dum[8] = ~dum[7]+1; // intermediate real
    end
    else dum[8] = (butterfly_out_r0[7])*check; 
    
    if(butterfly_out_i0[7][20] == 1 ) 
    begin
        dum1[3] = (~butterfly_out_i0[7]+1);
        dum[9] = dum1[3]*check;
        dum[10] = ~dum[9]+1;// intermediate img
    end
    else dum[10] = (butterfly_out_i0[7])*check; 
    
    dum[11] = dum[10] + ~dum[8] + 1;//real
    
    dum[12] = ~(dum[10] + dum[8]) + 1;//imag
    
    if(butterfly_out_r0[3][20] == 1) 
    begin
        dum1[4] = (~butterfly_out_r0[3]+1);
        dum[13] =  dum1[4]*check;
        dum[14] = ~dum[13]+1;
    end
    else dum[14] = butterfly_out_r0[3]*check;

    if(butterfly_out_i0[3][20] == 1 ) 
    begin
        dum1[5] = (~butterfly_out_i0[3]+1);
        dum[15] = dum1[5]*check;
        dum[16] = ~dum[15]+1;// intermediate img
    end
    else dum[16] = (butterfly_out_i0[3])*check; 
    
    dum[17] = dum[14] + ~dum[16] + 1;//real
    
    dum[18] = (dum[14] + dum[16]);//imag
    
    
end


                             
always @(posedge clk)
begin
    if(rst)
    begin
        state <= s0;
    end
    
    else
    begin
        state <= nxt_state;
        if(state == s0)
        begin
            i <= 0;
            k <= 0;
            p <= 0;
            done <= 0;
            done1 <= 0;
            n <= 0;
            out <= 0;
        end
        
        else if(state == s1)
        begin
            i <= i + 1;
        end
        
        else if(state == s2)
        begin
            x[i] <= in;
        end
        
        else if(state == s3)
        begin
            k <= k+1;
            if(k == 0)
            begin
                butterfly_in_r0[0] <= x[0];
                butterfly_in_r0[1] <= x[4];
                butterfly_in_r0[2] <= x[2];
                butterfly_in_r0[3] <= x[6];
                butterfly_in_r0[4] <= x[1];
                butterfly_in_r0[5] <= x[5];
                butterfly_in_r0[6] <= x[3];
                butterfly_in_r0[7] <= x[7];
                
                butterfly_in_i0[0] <= 0;
                butterfly_in_i0[1] <= 0;
                butterfly_in_i0[2] <= 0;
                butterfly_in_i0[3] <= 0;
                butterfly_in_i0[4] <= 0;
                butterfly_in_i0[5] <= 0;
                butterfly_in_i0[6] <= 0;
                butterfly_in_i0[7] <= 0;
            end
            else if(k == 1)
            begin
                butterfly_in_r0[0] <= butterfly_out_r0[0];
                butterfly_in_i0[0] <= butterfly_out_i0[0];
                butterfly_in_r0[2] <= butterfly_out_r0[1];//
                butterfly_in_i0[2] <= butterfly_out_i0[1];//
                butterfly_in_r0[1] <= butterfly_out_r0[2];
                butterfly_in_i0[1] <= butterfly_out_i0[2];
                butterfly_in_r0[3] <= butterfly_out_i0[3];//
                butterfly_in_i0[3] <= ~butterfly_out_r0[3]+1;//
                butterfly_in_r0[4] <= butterfly_out_r0[4];
                butterfly_in_i0[4] <= butterfly_out_i0[4];
                butterfly_in_r0[6] <= butterfly_out_r0[5];//
                butterfly_in_i0[6] <= butterfly_out_i0[5];//
                butterfly_in_r0[5] <= butterfly_out_r0[6];
                butterfly_in_i0[5] <= butterfly_out_i0[6];
                butterfly_in_r0[7] <= butterfly_out_i0[7];//
                butterfly_in_i0[7] <= ~butterfly_out_r0[7]+1;//
            end
            
            else if(k == 2)
            begin
                butterfly_in_r0[0] <= butterfly_out_r0[0];
                butterfly_in_i0[0] <= butterfly_out_i0[0];
                butterfly_in_r0[2] <= butterfly_out_r0[2];
                butterfly_in_i0[2] <= butterfly_out_i0[2];
                butterfly_in_r0[4] <= butterfly_out_r0[1];
                butterfly_in_i0[4] <= butterfly_out_i0[1];
                butterfly_in_r0[6] <= butterfly_out_r0[3];
                butterfly_in_i0[6] <= butterfly_out_i0[3];
                butterfly_in_r0[1] <= butterfly_out_r0[4];
                butterfly_in_i0[1] <= butterfly_out_i0[4];
                butterfly_in_i0[3] <= dum[6][30:10];
                butterfly_in_r0[3] <= dum[5][30:10];
                butterfly_in_r0[5] <= butterfly_out_i0[5];
                butterfly_in_i0[5] <= ~butterfly_out_r0[5]+1;
                butterfly_in_i0[7] <= dum[12][30:10];
                butterfly_in_r0[7] <= dum[11][30:10];
                done1 <= 1;
            end
        end
        
        else if(state == s4)
            begin
               if(p == 0)
               begin
                   real_array[0] <= butterfly_out_r0[0];
                   imag_array[0] <= butterfly_out_i0[0];
               end 
               
               else if(p == 1)
               begin
                   real_array[1] <= butterfly_out_r0[2]<<1;
                   imag_array[1] <= butterfly_out_i0[2]*2;
               end
               
               else if(p == 2)
               begin
                   real_array[2] <= butterfly_out_r0[4]<<1;
                   imag_array[2] <= butterfly_out_i0[4]*2;
               end
               
               else if(p == 3)
               begin
                   real_array[3] <= butterfly_out_r0[6]<<1;
                   imag_array[3] <= butterfly_out_i0[6]*2;
               end
               
               else if(p == 4)
               begin
                   real_array[4] <= butterfly_out_r0[1];
                   imag_array[4] <= 21'd0;
               end
               
               else 
               begin
                   real_array[p] <= 21'd0;
                   imag_array[p] <= 21'd0;
               end
               p <= p+1;
            end
            
            else if(state == s5)
            begin
            n <= n+1;
            if(n == 0)
            begin
                butterfly_in_r0[0] <= real_array[0];
                butterfly_in_r0[2] <= real_array[1];
                butterfly_in_r0[4] <= real_array[2];
                butterfly_in_r0[6] <= real_array[3];
                butterfly_in_r0[1] <= real_array[4];
                butterfly_in_r0[3] <= real_array[5];
                butterfly_in_r0[5] <= real_array[6];
                butterfly_in_r0[7] <= real_array[7];
                
                butterfly_in_i0[0] <= imag_array[0];
                butterfly_in_i0[2] <= imag_array[1];
                butterfly_in_i0[4] <= imag_array[2];
                butterfly_in_i0[6] <= imag_array[3];
                butterfly_in_i0[1] <= imag_array[4];
                butterfly_in_i0[3] <= imag_array[5];
                butterfly_in_i0[5] <= imag_array[6];
                butterfly_in_i0[7] <= imag_array[7];
            end
            else if(n == 1)
            begin
                butterfly_in_r0[0] <= butterfly_out_r0[0];
                butterfly_in_i0[0] <= butterfly_out_i0[0];
                butterfly_in_r0[2] <= butterfly_out_r0[2];
                butterfly_in_i0[2] <= butterfly_out_i0[2];
                butterfly_in_r0[1] <= butterfly_out_r0[4];//
                butterfly_in_i0[1] <= butterfly_out_i0[4];//
                butterfly_in_r0[3] <= butterfly_out_r0[6];
                butterfly_in_i0[3] <= butterfly_out_i0[6];
                butterfly_in_r0[4] <= butterfly_out_r0[1];
                butterfly_in_i0[4] <= butterfly_out_i0[1];
//                butterfly_in_i0[6] <= dum[6][35:15];
//                butterfly_in_r0[6] <= dum[5][35:15];
                butterfly_in_r0[6] <= dum[17][30:10];//
                butterfly_in_i0[6] <= dum[18][30:10];//
                butterfly_in_r0[5] <= ~butterfly_out_i0[5]+1;
                butterfly_in_i0[5] <= butterfly_out_r0[5];
//                butterfly_in_i0[7] <= dum[12][35:15];
//                butterfly_in_r0[7] <= dum[11][35:15];
                butterfly_in_i0[7] <= ~dum[11][30:10]+1;
                butterfly_in_r0[7] <= dum[12][30:10];
            end
            
            else if(n == 2)
            begin
                butterfly_in_r0[0] <= butterfly_out_r0[0];
                butterfly_in_i0[0] <= butterfly_out_i0[0];
                butterfly_in_r0[2] <= butterfly_out_r0[1];//
                butterfly_in_i0[2] <= butterfly_out_i0[1];//
                butterfly_in_r0[1] <= butterfly_out_r0[2];
                butterfly_in_i0[1] <= butterfly_out_i0[2];
                butterfly_in_r0[3] <= ~butterfly_out_i0[3]+1;//
                butterfly_in_i0[3] <= butterfly_out_r0[3];//
                butterfly_in_r0[4] <= butterfly_out_r0[4];
                butterfly_in_i0[4] <= butterfly_out_i0[4];
                butterfly_in_r0[6] <= butterfly_out_r0[5];//
                butterfly_in_i0[6] <= butterfly_out_i0[5];//
                butterfly_in_r0[5] <= butterfly_out_r0[6];
                butterfly_in_i0[5] <= butterfly_out_i0[6];
                butterfly_in_r0[7] <= ~butterfly_out_i0[7]+1;//
                butterfly_in_i0[7] <= butterfly_out_r0[7];//
                done <= 1;
            end
        end
        
        else if(state == s6)
        begin
            out <= out+1;
           if(out == 0)
           begin
               outr <= $signed(butterfly_out_r0[0])>>>3;
               outi <= $signed(butterfly_out_i0[0])>>>3;
           end 
           
           else if(out == 1)
           begin
               outr <= $signed(butterfly_out_r0[4])>>>3;
               outi <= $signed(butterfly_out_i0[4])>>>3;
           end
           
           else if(out == 2)
           begin
               outr <= $signed(butterfly_out_r0[2])>>>3;
               outi <= $signed(butterfly_out_i0[2])>>>3;
           end
           
           else if(out == 3)
           begin
               outr <= $signed(butterfly_out_r0[6])>>>3;
               outi <= $signed(butterfly_out_i0[6])>>>3;
           end
           
           else if(out == 4)
           begin
               outr <= $signed(butterfly_out_r0[1])>>>3;
               outi <= $signed(butterfly_out_i0[1])>>>3;
           end
           
           else if(out == 5)
           begin
               outr <= $signed(butterfly_out_r0[5])>>>3;
               outi <= $signed(butterfly_out_i0[5])>>>3;
           end
           
           else if(out == 6)
           begin
               outr <= $signed(butterfly_out_r0[3])>>>3;
               outi <= $signed(butterfly_out_i0[3])>>>3;
           end
           
           else if(out == 7)
           begin
               outr <= $signed(butterfly_out_r0[7])>>>3;
               outi <= $signed(butterfly_out_i0[7])>>>3;
           end
               
        end
        
        
        
            
    end
end

always @(*)
begin
    case(state)
    
        s0: if(done) nxt_state =  s0;
            else nxt_state = s2;
        
        s1: nxt_state = s2;
        
        s2: if(i == 7) nxt_state = s3;
            else nxt_state = s1;
            
        s3: if(done1 == 1) nxt_state = s4;
            else nxt_state = s3;
            
        s4: if(p == 8) nxt_state = s5;
            else nxt_state = s4;
        
        s5: if(done == 1) nxt_state = s6;
            else nxt_state = s5;
            
        s6: nxt_state = s6;
            
        default: nxt_state = s0;
            
    endcase
end
endmodule
