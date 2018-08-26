`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/08/26 12:49:28
// Design Name: 
// Module Name: rd_ctl
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


module rd_ctl#(
	parameter FIFO_DEPTH = 8
)(
	input 									rd_en,
	input 									rd_clk,
	input 									rd_rst_n,
	input	[FIFO_DEPTH   :0]       		wr_addr_glay,
	output	[FIFO_DEPTH-1 :0]       		rd_addr_bin,
	output	[FIFO_DEPTH   :0]       		rd_addr_glay,
	output	reg					    		rd_empty
    );
	//output  ram addr_bin
	reg  [FIFO_DEPTH : 0]                    rd_addr_bin_r;
	wire [FIFO_DEPTH : 0]                    rd_addr_bin_wire;
	assign rd_addr_bin_wire = rd_addr_bin_r +(!rd_empty && rd_en); 
	
	always @(posedge rd_clk) begin
		if(!rd_rst_n)
			rd_addr_bin_r <= 0;
		else
			rd_addr_bin_r <= rd_addr_bin_wire;
	end
	assign  rd_addr_bin = rd_addr_bin_r;
	
	//output ram_addr_glay
	wire [FIFO_DEPTH : 0]              rd_addr_glay_wire;
	assign  rd_addr_glay_wire = (rd_addr_bin_wire>>1) ^ rd_addr_bin_wire;
	reg [FIFO_DEPTH : 0]              rd_addr_glay_r;
	always @(posedge rd_clk) begin
		if(!rd_rst_n)
			rd_addr_glay_r <= 0;
		else
			rd_addr_glay_r <= rd_addr_glay_wire;
	end
	assign rd_addr_glay = rd_addr_glay_r;
	//output   fifo rd_empty
	reg [FIFO_DEPTH :0 ] wr_addr_glay_r1;
	reg [FIFO_DEPTH :0 ] wr_addr_glay_r2;
	always @(posedge rd_clk)begin
		if(!rd_rst_n)
			{wr_addr_glay_r2,wr_addr_glay_r1} <= 0;
		else 
			{wr_addr_glay_r2,wr_addr_glay_r1} <= {wr_addr_glay_r1, wr_addr_glay};
	end
	
	wire rd_empty_wire;
	assign rd_empty_wire =  wr_addr_glay_r2== rd_addr_glay_wire;
	always @(posedge rd_clk) begin
		if(!rd_rst_n)
			rd_empty <= 0;
		else
			rd_empty <= rd_empty_wire;
	end
	
endmodule
