`timescale 1ns / 1ps

module Multidigit_Display(     // top module
    input clk,
    input [15:0] bcd_in,
    output [6:0] seg_cathode,
    output [3:0] seg_anode
    );
    wire[6:0] sseg_o;
    wire[3:0] anode;
    wire en;
    wire [3:0] bcd_seg;
    anode_generator uut1(clk, en, anode);
    mux uut2(anode, bcd_seg, en,bcd_in, seg_anode);
    ss_decode ss_dec(clk, bcd_seg, seg_cathode);
    
endmodule

module anode_generator(clk, en, anode);
    input clk;
    output reg en;
    
    output[3:0] anode = 4'b0001;
    reg[3:0] bcd_seg = 4'b0000;
    reg[3:0] anode = 4'b0001;
    
    parameter g_s = 7;
    parameter gt = 6;
    reg[g_s-1:0]g_count =0;
    
    always @ (posedge clk)
    begin
        g_count = g_count + 1;
            if(g_count == 0)
                begin
                if(anode == 4'b0001)
                    begin
                    anode = 4'b1000;
                    end
                else
                    begin
                    anode = anode >>1;
                    end         
                end
    end       
    always @ (posedge clk)
    begin
    if(&g_count[g_s-1:gt])
        begin
        en = 1'b1;
        end
    else
        en = 1'b0;
    end
endmodule

module mux(anode,bcd_seg,en,bcd_in,seg_anode);
    input[15:0] bcd_in;
    input[3:0] anode;
    output[3:0] seg_anode;
    output reg [3:0] bcd_seg;
    input en;
    
    always @ (*)
    begin
    if(en)
        begin
        case(anode)
            4'b1000 : bcd_seg = bcd_in[15:12];
            4'b0100 : bcd_seg = bcd_in[11:8];
            4'b0010 : bcd_seg = bcd_in[7:4];
            4'b0001 : bcd_seg = bcd_in[3:0];
            default : bcd_seg = 4'b1111;
        endcase
        end
    end
    assign seg_anode = ~anode;
endmodule 

module ss_decode(clk, bcd,seg);
    input clk;
    input[3:0] bcd;
    output reg[6:0] seg;
    
    always @ (posedge clk)
    begin
    case(bcd)
        4'b0000 : seg = 7'b1000000; // abcdef
        4'b0001 : seg = 7'b1111001; // bc
        4'b0010 : seg = 7'b0100100; // abged
        4'b0011 : seg = 7'b0110000; // abcdg
        4'b0100 : seg = 7'b0011001; // bcfg
        4'b0101 : seg = 7'b0010010; // afgcd
        4'b0110 : seg = 7'b0000010; // acdefg
        4'b0111 : seg = 7'b1111000; // abc
        4'b1000 : seg = 7'b0000000; // abcdefg
        4'b1001 : seg = 7'b0010000; // abcdfg
        default : seg = 7'b1111111; // default
    endcase
    end
endmodule







