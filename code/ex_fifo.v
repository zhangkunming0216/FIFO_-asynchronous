`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/08/26 14:04:20
// Design Name: 
// Module Name: ex_fifo
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


module ex_fifo#(
		parameter              FIFO_DEPTH_Bit = 8,
		parameter              FIFO_WIDTH_Bit = 16,
		parameter 			   FIFO_DEPTH = 8
)(	
		input 				  					   wr_clk,
		input									   wr_rst_n,
		input 				   					   wr_en,
		input [FIFO_WIDTH_Bit-1:0] 				   wr_data,
		output									   wr_full,
		
		input									   rd_clk,
		input									   rd_rst_n,
		input									   rd_en,
		output [FIFO_WIDTH_Bit-1:0]				   rd_data,
		output 									   rd_empty
    );
	wire [FIFO_DEPTH:0]   wr_addr_glay;          
	wire [FIFO_DEPTH-1:0]   rd_addr_bin;          
	wire [FIFO_DEPTH-1:0]   wr_addr_bin;          
	wire [FIFO_DEPTH:0]   rd_addr_glay;          
	rd_ctl#(
		.FIFO_DEPTH(FIFO_DEPTH)
	)rd_ctl(
	    .rd_en(rd_en),        //input 								
	    .rd_clk(rd_clk),       //input 								
	    .rd_rst_n(rd_rst_n),   //input 								
	    .wr_addr_glay(wr_addr_glay),         //input	[FIFO_DEPTH   :0]       	
	    .rd_addr_bin(rd_addr_bin),          //output	[FIFO_DEPTH-1 :0]       	
	    .rd_addr_glay(rd_addr_glay),         //output	[FIFO_DEPTH   :0]       	
	    .rd_empty(rd_empty)              //output	reg					    	
    );
    wr_ctl#(
		.FIFO_DEPTH(FIFO_DEPTH)
	)wr_ctl(
	    .wr_en(wr_en),           //input 									
	    .wr_clk(wr_clk),          //input 									
	    .wr_rst_n(wr_rst_n),        //input 									
	    .rd_addr_glay(rd_addr_glay),    //input	[FIFO_DEPTH   :0]       		
	    .wr_addr_bin(wr_addr_bin),     //output	[FIFO_DEPTH-1 :0]       		
	    .wr_addr_glay(wr_addr_glay),    //output	[FIFO_DEPTH   :0]       		
	    .wr_full(wr_full)          //output	reg					    		
    );
	
	fifo_men#(
	    .FIFO_DEPTH_Bit(FIFO_DEPTH_Bit),
	    .FIFO_WIDTH_Bit(FIFO_WIDTH_Bit)
	)fifo_men(
	    .wr_data(wr_data),	//input [FIFO_WIDTH_Bit-1:0]                 		
	    .wr_clk(wr_clk),	//input                					   		
	    .wr_full(wr_full),	//input                					   		
	    .wr_en(wr_en),		//input                					   	
	    .wr_addr(wr_addr_bin),	//input [FIFO_DEPTH_Bit-1:0]                 	
	    .rd_clk(rd_clk),    //input									   
	    .rd_addr(rd_addr_bin),	//input [FIFO_DEPTH_Bit-1:0]                 		
	    .rd_data(rd_data)    //output [FIFO_WIDTH_Bit-1:0]                
    );
	
endmodule
