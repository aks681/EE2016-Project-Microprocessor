`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:30:37 10/19/2017
// Design Name:   microprocessor
// Module Name:   D:/executionunit/microtest.v
// Project Name:  executionunit
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: microprocessor
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module microtest;

	// Inputs
   reg clk;
	// Outputs
	wire write_enable,ldi,read_enable,st;

	// Instantiate the Unit Under Test (UUT)
	microprocessor uut (
		.clk(clk),
		.ldi(ldi),
		.write_enable(write_enable),
		.read_enable(read_enable),
		.st(st)

		);

	initial begin
		clk = 0;
	end
	
		always #1 clk = ~clk;

      
endmodule

