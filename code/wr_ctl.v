`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/08/26 12:20:00
// Design Name: 
// Module Name: wr_ctl
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
// 8bit 256 ,
//////////////////////////////////////////////////////////////////////////////////


module wr_ctl#(
	parameter           FIFO_DEPTH = 8
)(
	input 									wr_en,
	input 									wr_clk,
	input 									wr_rst_n,
	input	[FIFO_DEPTH   :0]       		rd_addr_glay,
	output	[FIFO_DEPTH-1 :0]       		wr_addr_bin,
	output	[FIFO_DEPTH   :0]       		wr_addr_glay,
	output	reg					    		wr_full
    );
	
   //output ram   addr	
	reg [FIFO_DEPTH :0]  wr_addr_bin_r;
	wire [FIFO_DEPTH :0]  wr_addr_bin_wire;
	assign wr_addr_bin_wire = wr_addr_bin_r +(!wr_full && wr_en);
	
	always @(posedge wr_clk) begin
		if(!wr_rst_n)
			wr_addr_bin_r <= 0;
		else
			wr_addr_bin_r <= wr_addr_bin_wire;
	end
	
	assign wr_addr_bin =  wr_addr_bin_r;
	
	//output glay addr
	wire [FIFO_DEPTH :0]  wr_addr_glay_wire;
	assign wr_addr_glay_wire = (wr_addr_bin_wire>>1)^wr_addr_bin_wire;
	reg [FIFO_DEPTH :0]  wr_addr_glay_r;
	
	always @(posedge wr_clk) begin
		if(!wr_rst_n)
			wr_addr_glay_r <= 0;
		else 
			wr_addr_glay_r <= wr_addr_glay_wire;
	end
	assign wr_addr_glay = wr_addr_glay_r;
	//output wr_full
	reg [FIFO_DEPTH :0]  rd_addr_glay_r1;
	reg [FIFO_DEPTH :0]  rd_addr_glay_r2;
	
	always @(posedge wr_clk) begin
		if(!wr_rst_n)
			{rd_addr_glay_r2,rd_addr_glay_r1} <= 0;
		else 
			{rd_addr_glay_r2,rd_addr_glay_r1} <= {rd_addr_glay_r1,rd_addr_glay};
	end
	wire wr_full_w;
	wire [FIFO_DEPTH :0] wr_addr_glay_wire1;
	assign wr_addr_glay_wire1={~wr_addr_glay_wire[FIFO_DEPTH:FIFO_DEPTH-1],wr_addr_glay_wire[FIFO_DEPTH-2:0]};//并没有按位取反，
	assign wr_full_w = wr_addr_glay_wire1==rd_addr_glay_r2;
	always @(posedge wr_clk) begin
		if(!wr_rst_n)
			wr_full <= 0;
		else	
			wr_full <=  wr_full_w;
	end
endmodule
