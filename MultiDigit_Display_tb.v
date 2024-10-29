`timescale 1ns / 1ps

module MultiDigit_Display_tb();
    reg clk;
    reg [15:0] bcd_in;
    wire [3:0] seg_anode;
    wire [6:0] seg_cathode;
   
    MultiDigit_Display uut1(clk, bcd_in, seg_cathode,seg_anode);
   
    integer i = 0;
    parameter T = 2;
   
    always begin
        clk = 1'b0;
        #(T/2);
        clk = 1'b1;
        #(T/2);
    end
   
    initial begin
           assign bcd_in = i;
           #1024;
           for (i = 1; i < 10; i = i*2)
           begin
               assign bcd_in = i;
               #1024;
               assign bcd_in = i << 4;
               #1024;
               assign bcd_in = i << 8;
               #1024;
               assign bcd_in = i << 12;
               #1024;
           end
            #128 $stop;
    end
endmodule
