`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:11:23 10/18/2017 
// Design Name: 
// Module Name:    eu 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module microprocessor(clk,ldi,write_enable,read_enable,st);
wire[4:0] address;
wire[7:0] data_in;
wire [2:0] opcode;
wire [3:0] flag;
output wire write_enable,read_enable,ldi;
wire re;
output wire st;
wire ia;
input wire clk;
wire[7:0] out;
reg[7:0] ram[0:31];
initial begin
ram[0] = 5;    //this number is the source for base of exponent in the power program and the number for the factorial program
ram[1] = 3;		//this is the power for the power program
end
reg[7:0] in;


cu C(clk,address,data_in,write_enable,read_enable,opcode,ldi,st,ia,flag,re);
eu E(address,data_in,write_enable,read_enable,opcode,ldi,out,st,ia,flag,re,in);

   always @(*) begin
	     if(read_enable&re) begin
				in = ram[address];
		   end
        if (write_enable&st) begin
            ram[address] = out;
        end
   end
		 
endmodule


/* Program to find factorial of number stored in external memory(ram[0]) and store result in ram[5]
pmemory[0]=28'b1110_00000000_00000011_00000000;
pmemory[1]=28'b0001_00001000_00000001_00000000;
pmemory[2]=28'b0001_00000111_00000000_00000000;
pmemory[3]=28'b1001_00000011_00001000_00000110;
pmemory[4]=28'b0000_00000110_00000100_00000000;
pmemory[5]=28'b1000_00000111_00000011_00000111;
pmemory[6]=28'b0001_00011111_00000001_00000000;
pmemory[7]=28'b1001_00000100_00011111_00000100;
pmemory[8]=28'b0110_00001001_00000101_00000000;
pmemory[9]=28'b0000_00000111_00000011_00000000;
pmemory[10]=28'b0001_00000111_00000000_00000000;
pmemory[11]=28'b0001_00011111_00000001_00000000;
pmemory[12]=28'b1001_00000110_00011111_00000110;
pmemory[13]=28'b0110_00001110_00000100_00000000;
pmemory[14]=28'b0010_00000011_00000101_00000000;
pmemory[15]=28'b1111_11111111_11111111_11111111;
*/

/* Program to find ram[0] ^ ram[1] and store in ram[5]
pmemory[0]=28'b1110_00000000_00000100_00000000;
pmemory[1]=28'b1110_00000001_00000101_00000000;
pmemory[2]=28'b0001_00011111_00000001_00000000;
pmemory[3]=28'b1001_00000101_00011111_00000101;
pmemory[4]=28'b0001_00000111_00000000_00000000;
pmemory[5]=28'b0000_00000100_00001000_00000000;
pmemory[6]=28'b0000_00000100_00000110_00000000;
pmemory[7]=28'b1000_00000111_00001000_00000111;
pmemory[8]=28'b0001_00011111_00000001_00000000;
pmemory[9]=28'b1001_00000110_00011111_00000110;
pmemory[10]=28'b0110_00001011_00000111_00000000;
pmemory[11]=28'b0000_00000111_00001000_00000000;
pmemory[12]=28'b0001_00000111_00000000_00000000;
pmemory[13]=28'b0001_00011111_00000001_00000000;
pmemory[14]=28'b1001_00000101_00011111_00000101;
pmemory[15]=28'b0110_00010000_00000110_00000000;
pmemory[16]=28'b0010_00001000_00000101_00000000;
pmemory[17]=28'b1111_11111111_11111111_11111111;
*/


module cu(clk,address,data_in,write_enable,read_enable,opcode,ldi,st,ia,flag,re);
input wire clk;
output wire[4:0] address;
output wire[7:0] data_in;
input wire[3:0] flag;
output [2:0] opcode;
output wire write_enable,read_enable,ldi,st,ia,re;
wire[4:0] pc;
wire [4:0] pcaddr;
wire[27:0] inst;
wire pcout;

pccounter pcc(clk,pcout,pc,pcaddr);
instrdecoder id(inst,clk,address,data_in,write_enable,read_enable,opcode,ldi,st,ia,pcout,pcaddr,flag,re);
progmemory pm(clk,pc,inst);

endmodule

module pccounter(clk,pcout,pc,pcaddr);
input wire pcout,clk;
input wire[4:0] pcaddr;
output reg[4:0] pc;
initial begin
 pc = 0;
end
 always@(posedge (pcout)) begin
   if(pcaddr == 5'b11111)
	 pc = pc + 1;
	else
	 pc = pcaddr;
 end
endmodule

/*

0000 address operand - load
0001 add1 add2 - mov from add1 to add2
1000 op1 op2 op3 - add from address op1 and op2 and store in op3
*/
module instrdecoder(inst,clk,address,data_in,write_enable,read_enable,opcode,ldi,st,ia,pcout,pcaddr,flag,re);
input wire clk;
input wire[3:0] flag;
output reg pcout;
output reg [4:0] address,pcaddr;
output reg [7:0] data_in;
output reg [2:0] opcode;
output reg write_enable,read_enable,ldi,st,ia,re;
input wire[27:0] inst;
reg[3:0] s0,s1,s2,s3,s4,s5,s6,s7,state;
initial begin
 pcout = 0;
 s0 = 3'b000;
 s1 = 3'b001;
 s2 = 3'b010;
 s3 = 3'b011;
 s4 = 3'b100;
 s5 = 3'b101;
 s6 = 3'b110;
 s7 = 3'b111;
 state = s0;
 pcaddr = 5'b11111;
end
 always @(posedge(clk))
  begin
    ia = 0;write_enable = 0;read_enable = 0 ; ldi  = 0; st = 0;re=0;
	 if(state == s6)
		  state = s7;
		if(state == s5)
		  state = s6;
		if(state == s4)
		  state = s5;
	   if(state == s3)
		  state = s4;
		if(state == s2)
		  state = s3;	
		if(state == s1)
		  state = s2;
		if(state == s0) begin
		pcaddr = 5'b11111;
		  pcout = 0;
		  state = s1;
		  end

    case (inst[27:24])
      4'b0000  :     //MOV R1 R2 => move from r1 to r2
		 begin
		   if (state == s1) begin
		   address = inst[23:16];
			read_enable = 1;
			write_enable = 0;
			end
			if(state == s2) begin
			address = inst[15:8];
			read_enable = 0;
			write_enable = 1;
			state = s0;
			pcout = 1;
			end
			/*if(state == s3) begin
			write_enable = 0;
			pcout = 1;
			state = s0;
			end*/
		 end
		 
		 4'b0001  :    //Load value to internal register
		 begin
		   if(state == s1) begin
		   address = inst[23:16];
			data_in = inst[15:8];
			read_enable = 0;
			write_enable= 0;
			ldi = 1;
			st = 0;
			end
			if(state == s2) begin
			ldi = 0;
			write_enable = 1;
			state = s0;
			pcout = 1;
			end
			/*if(state == s3) begin
			write_enable= 0;
			pcout = 1;
			state = s0;
			end*/
		 end
		 
		 4'b0010  :    //Store value in external RAM
		 begin
		   if(state == s1) begin
		   address = inst[23:16];
			read_enable = 1; 
			write_enable = 0;
			ldi = 0;
			st = 1;
			end
			if(state == s2) begin
			st = 1;
			address = inst[15:8];
			write_enable = 1;
			read_enable = 0;
			pcout = 1;
			state = s0;
			end
			/*if(state == s3) begin
			write_enable = 0;
			st = 0;
			pcout = 1;
			state = s0;
			end*/
		 end
		 
		 4'b0011  :    //Indirect Addressing LOAD R(Rx) with a value 
		 begin
			if(state == s1) begin
		   address = inst[23:16];
			read_enable = 1; 
			write_enable = 0;
			end
			if(state == s2) begin
			read_enable = 0;
			ia = 1;
			end
			if(state == s3) begin
			data_in = inst[15:8];
			ia = 1;
			ldi = 1;
			end
			if(state == s4) begin
			ldi = 0;
			ia = 1;
			write_enable = 1;
			end
			if(state == s5) begin
			ia = 0;
			write_enable = 0;
			pcout = 1;
			state = s0;
			end
			/*if(state == s5) begin
			ia = 0;
			write_enable = 0;
			pcout = 1;
			state = s0;
			end*/
		 end
		 
		endcase
		
		 if (inst[27:26] == 2'b01)    //program memory jump subject to flag value
		  begin
		   if(state == s1) begin
		     if(flag[inst[25:24]] == 1'b1)
			   begin
				  pcaddr = inst[23:16];
				end
			  else begin
			    pcaddr = inst[15:8];
			  end
			end
			if(state == s2) begin
			pcout = 1;
			state = s0;
			end

		  end
		 
		 if (inst[27])    
		  begin
		   if(inst[27:24] == 4'b1111) begin   //end program
			  state = s7;
			  pcout = 0;
			end
			else if(inst[27:24] == 4'b1110) begin   // Load value from external ram
			   if(state == s1) begin
				address = inst[23:16];
				write_enable = 0;
				read_enable = 1;
				re = 1;
				end
				if(state == s2) begin
				address = inst[15:8];
				write_enable = 1;
				re = 1;
				end
				if(state == s3) begin
				pcout = 1;
				state = s0;
				end
			end
			else begin	//Do ALU operations
		   if(state == s1) begin
		   write_enable = 0;
		   read_enable = 1;
			address = inst[23:16];
			end
			if(state == s2) begin
			read_enable = 0; write_enable = 1; address = 4'b0000;
			end
			if(state == s3) begin
			read_enable = 1; write_enable = 0; address = inst[15:8];
			end
			if(state == s4) begin
			read_enable = 0; write_enable = 1; address = 4'b0001;
			end
			if(state == s5) begin
			write_enable = 0;
			opcode = inst[26:24];
			end
			if(state == s6) begin
			read_enable = 1;address = 4'b0010;
			end
			if(state == s7) begin
			read_enable = 0; write_enable = 1; address = inst[7:0];
			pcout = 1;
			state = s0;
			end
			end
		  end
		 
  end

endmodule


module eu(address,data_in,write_enable,read_enable,opcode,ldi,out,st,ia,flag,re,in);
input wire[4:0] address;
input wire[7:0] data_in,in;
input [2:0] opcode;
input write_enable,read_enable,ldi,st,ia,re;
output reg [7:0] out;
output reg [3:0] flag;
wire[7:0] a0,a1;
wire [7:0] a2;
wire [3:0] fl;
reg [7:0] memory [0:31];
reg [7:0] bus;
reg [4:0] addressbus;

assign a0 = memory[0];
assign a1 = memory[1];

alu a(a0,a1,a2,opcode,fl);


    always @(*) begin
	   if(!ia) begin
			addressbus = address;
		end
		if(ldi&!st) begin
				bus = data_in;
			end
			if(write_enable&!st&re) begin
				memory[address] = in;
			end
        if (write_enable&!st&!re) begin
            memory[addressbus] = bus;
        end
		  if (read_enable&!st&!re) begin
		     bus = memory[addressbus];
		  end
		  if (read_enable&st&!re) begin
		     out = memory[addressbus];
		  end
		  if (ia&!ldi&!read_enable&!write_enable) begin
			  addressbus = bus;
		  end
		   memory[2] = a2;
			flag <= fl;
    end
//always @(*) begin

//end

endmodule



module alu(a0,a1,a2,opcode,fl);
   input wire[7:0] a0, a1;
	input wire [2:0] opcode;
   output wire [7:0] a2;
	output wire [3:0] fl;
	reg[3:0] flag;
	reg[7:0] res,ctr;
   always @(*)
  begin
    case (opcode)
      3'b000  : begin 
						res = a0 + a1;
						if(res < a0 | res < a1) begin
							flag = 4'b0001;
						end
						else if(res == 0) begin
							flag = 4'b0100;
						end
						else begin
							flag = 4'b0000;
						end
					 end
      3'b001  : begin 
						res = a0 - a1;
						if(a1 > a0) begin
							flag = 4'b0010;
						end
						else if(res == 0) begin
						   flag = 4'b0100;
						end
						else begin
							flag = 4'b0000;
						end
					 end
		3'b010  : begin 
						res = a0 & a1;
						if(res == 0) begin
							flag = 4'b0100;
						end
						else begin
							flag = 4'b0000;
						end						  
					 end
		3'b011  : begin 
						res = a0 | a1;
						if(res == 0) begin
							flag = 4'b0100;
						end
						else begin
							flag = 4'b0000;
						end						  
					 end
		3'b100  : begin 
						res = a0 << a1;
						if(res < (a0 << (a1-1) ) ) begin
							flag = 4'b0001;
						end
					 end
		3'b101  :  begin 
						ctr = a0 >> (a1-1);
						res = a0 >> a1;
						if(ctr[0] == 1'b1 ) begin
							flag = 4'b1000;
						end
					 end 
		default : res = a2;
    endcase
  end
	assign a2 = res;
	assign fl = flag;
endmodule


/*module clkdiv(COUNT,CLK);
input CLK;
output COUNT;
reg[24:0] counter;
assign COUNT=counter[22:22];
always@(negedge CLK)
begin
counter <= counter+1;
end
endmodule */
