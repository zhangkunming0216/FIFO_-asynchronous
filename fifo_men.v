`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/08/26 13:21:06
// Design Name: 
// Module Name: fifo_men
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


module fifo_men#(
	parameter              FIFO_DEPTH_Bit = 8,
	parameter              FIFO_WIDTH_Bit = 16
)(
	input [FIFO_WIDTH_Bit-1:0]                 wr_data,			
	input                					   wr_clk,			
	input                					   wr_full,			
	input                					   wr_en,			
	input [FIFO_DEPTH_Bit-1:0]                 wr_addr,		
	input									   rd_clk,
	input [FIFO_DEPTH_Bit-1:0]                 rd_addr,			
	output [FIFO_WIDTH_Bit-1:0]                rd_data
    );
	

bram_depth256_16bit your_instance_name (
  .clka(wr_clk),    // input wire clka
  .ena(wr_en&& !wr_full),      // input wire ena
  .wea(wr_en&& !wr_full),      // input wire [0 : 0] wea
  .addra(wr_addr),  // input wire [7 : 0] addra
  .dina(wr_data),    // input wire [15 : 0] dina
  .clkb(rd_clk),    // input wire clkb
  .addrb(rd_addr),  // input wire [7 : 0] addrb
  .doutb(rd_data)  // output wire [15 : 0] doutb
);

endmodule
