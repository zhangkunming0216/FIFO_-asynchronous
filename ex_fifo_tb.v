`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/08/26 14:55:41
// Design Name: 
// Module Name: ex_fifo_tb
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


module ex_fifo_tb#(
		parameter              FIFO_DEPTH_Bit = 8,
		parameter              FIFO_WIDTH_Bit = 16,
		parameter 			   FIFO_DEPTH = 8

)();
		reg 				  					   wr_clk  ;
		reg									   wr_rst_n;
		reg 				   					   wr_en   ;
		reg [FIFO_WIDTH_Bit-1:0] 				   wr_data ;
		wire									   wr_full ;
		                                                   ;
		reg									   rd_clk  ;
		reg									   rd_rst_n;
		reg									   rd_en   ;
		wire [FIFO_WIDTH_Bit-1:0]				   rd_data ;
		wire 									   rd_empty;
    localparam 			CLK_P	=		2;
	//instant
	ex_fifo#(
		.FIFO_DEPTH_Bit (FIFO_DEPTH_Bit),
		.FIFO_WIDTH_Bit (FIFO_WIDTH_Bit),
		.FIFO_DEPTH (FIFO_DEPTH)
	)ex_fifo_ins(	
		.wr_clk 		(wr_clk),   //input 				  					   
		.wr_rst_n	(wr_rst_n), //input									   
		.wr_en		(wr_en),    //input 				   					   
		.wr_data		(wr_data),  //input [FIFO_WIDTH_Bit-1:0] 				   
		.wr_full		(wr_full),  //output									   
									//
		.rd_clk		(rd_clk),   //input									   
		.rd_rst_n	(rd_rst_n), //input									   
		.rd_en		(rd_en),    //input									   
		.rd_data		(rd_data),  //output [FIFO_WIDTH_Bit-1:0]				   
		.rd_empty    (rd_empty)//output 									   
    );
	//time generate
	always # CLK_P   wr_clk = ~ wr_clk;
	always # CLK_P   rd_clk = ~ rd_clk;
	
	initial begin
		wr_clk = 0;
		rd_clk = 0;
		wr_rst_n =0;
		rd_rst_n =0;
		#100
		wr_rst_n =1;
		rd_rst_n =1;
	end

	initial begin
		wr_en =0;
		wr_data =0;
		#300
		write_data(257);
	end
	initial begin
		rd_en =0;
		#300
		@(posedge wr_full)
		read_data(257);
	end
	
	task write_data(len);
		integer len,i;
		begin
			for(i=0;i<len;i=i+1)begin
				@(posedge wr_clk)
				wr_en  = 1;
				wr_data = i;
			end
			@(posedge wr_clk)
				wr_en =0;
				wr_data =0;
		end
	endtask
	
	task read_data(len);
		integer len,i;
		begin
			for(i=0;i<len;i=i+1)begin
				@(posedge rd_clk)
				rd_en  = 1;
			end
			@(posedge rd_clk)
			rd_en=0;
		end
	endtask
endmodule
