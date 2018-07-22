// Assembler.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include<iostream>
#include<conio.h>
#include<fstream>
#include<string>
#include<vector>
using namespace std;
/*
  MOV Ri(from)  Rj(to)
  LDI Ri(address of internal register) value
  ILDI R(Rx) value
  LOAD Ri(address of external ram from which to read) Xj(Address of internal register to which to write)
  ST Ri(read address of internal register) Rj(write address of register in external ram)
  INC Ri (increment value in internal register)
  DEC Ri (increment value in internal register)
  BRNZ location (Branch if not zero)
  BRNN location (Branch if not negative)
  BRNO location (Branch if not overflow)
  BRNU location (Branch if not underflow (shift right underflow) )
  ( Following alu operations: read from Ri and Rj and store result in Rk)
  ADD Ri Rj Rk
  SUB Ri Rj Rk
  AND Ri Rj Rk
  OR Ri Rj Rk
  SLEFT Ri Rj Rk
  SRIGHT Ri Rj Rk
  END (end the program)
*/
fstream fout, fin;

void load(string &res) {
	string op1;
	int op2;
	int i, ctr;
	res.append("0001");
	fin >> op1;
	res.push_back('_');
	if (op1.size() == 2)
		ctr = op1[1] - '0';
	else
		ctr = (op1[1] - '0') * 10 + op1[2] - '0';
	i = 7;
	while (i >= 0)
	{
		if (ctr - pow(2, i) >= 0)
		{
			ctr -= pow(2, i);
			res.push_back('1');
		}
		else
			res.push_back('0');
		i--;
	}
	res.push_back('_');
	fin >> op2;
	i = 7;
	ctr = op2;
	while(i>=0)
	{
		if (ctr - pow(2, i) >= 0)
		{
			ctr -= pow(2, i);
			res.push_back('1');
		}
		else
			res.push_back('0');
		i--;
	}
}

void move(string &res) {
	string op;
	int i, ctr;
	res.append("0000");
	fin >> op;
	res.push_back('_');
	if (op.size() == 2)
		ctr = op[1] - '0';
	else
		ctr = (op[1] - '0') * 10 + op[2] - '0';
	i = 7;
	while (i >= 0)
	{
		if (ctr - pow(2, i) >= 0)
		{
			ctr -= pow(2, i);
			res.push_back('1');
		}
		else
			res.push_back('0');
		i--;
	}
	fin >> op;
	res.push_back('_');
	if (op.size() == 2)
		ctr = op[1] - '0';
	else
		ctr = (op[1] - '0') * 10 + op[2] - '0';
	i = 7;
	while (i >= 0)
	{
		if (ctr - pow(2, i) >= 0)
		{
			ctr -= pow(2, i);
			res.push_back('1');
		}
		else
			res.push_back('0');
		i--;
	}
}

void alu(string &res)
{
	string op;
	int i, ctr;
	fin >> op;
	res.push_back('_');
	if (op.size() == 2)
		ctr = op[1] - '0';
	else
		ctr = (op[1] - '0') * 10 + op[2] - '0';
	i = 7;
	while (i >= 0)
	{
		if (ctr - pow(2, i) >= 0)
		{
			ctr -= pow(2, i);
			res.push_back('1');
		}
		else
			res.push_back('0');
		i--;
	}
	fin >> op;
	res.push_back('_');
	if (op.size() == 2)
		ctr = op[1] - '0';
	else
		ctr = (op[1] - '0') * 10 + op[2] - '0';
	i = 7;
	while (i >= 0)
	{
		if (ctr - pow(2, i) >= 0)
		{
			ctr -= pow(2, i);
			res.push_back('1');
		}
		else
			res.push_back('0');
		i--;
	}
	fin >> op;
	res.push_back('_');
	if (op.size() == 2)
		ctr = op[1] - '0';
	else
		ctr = (op[1] - '0') * 10 + op[2] - '0';
	i = 7;
	while (i >= 0)
	{
		if (ctr - pow(2, i) >= 0)
		{
			ctr -= pow(2, i);
			res.push_back('1');
		}
		else
			res.push_back('0');
		i--;
	}
}

void inc_dec(string &res)
{
	string op,buf;
	int i, ctr;
	fin >> op;
	res.push_back('_');
	if (op.size() == 2)
		ctr = op[1] - '0';
	else
		ctr = (op[1] - '0') * 10 + op[2] - '0';
	i = 7;
	while (i >= 0)
	{
		if (ctr - pow(2, i) >= 0)
		{
			ctr -= pow(2, i);
			buf.push_back('1');
		}
		else
			buf.push_back('0');
		i--;
	}
	res.append(buf);
	res.push_back('_');
	res.append("00011111");
	res.push_back('_');
	res.append(buf);
}


void main()
{
	string s,op1;
	int num,ctr,ctr1,k,j;
	fout.open("./progmemory.v", fstream::in | fstream::out | fstream::trunc);
	fin.open("./input.txt", fstream::in | fstream::out | fstream::app);
	int i = 0,n;
	bool cmd = false;
	vector<string> res;
	vector<pair<string, int> > stack;
	while (fin >> s)
	{
		string ctr;
		if (s.compare("LDI") == 0)
		{
			load(ctr);
			ctr.append("_00000000");
			ctr.push_back(';');
		}
		else if (s.compare("ILDI") == 0)
		{
			load(ctr);
			ctr[2] = '1';
			ctr.append("_00000000");
			ctr.push_back(';');
		}
		else if (s.compare("INC") == 0)
		{
			ctr.append("0001_00011111_00000001_00000000;");
			res.push_back(ctr);
			i++;
			ctr = "";
			ctr.append("1000");
			inc_dec(ctr);
			ctr.push_back(';');
		}
		else if (s.compare("DEC") == 0)
		{
			ctr.append("0001_00011111_00000001_00000000;");
			res.push_back(ctr);
			i++;
			ctr = "";
			ctr.append("1001");
			inc_dec(ctr);
			ctr.push_back(';');
		}
		else if (s.compare("MOV") == 0)
		{
			move(ctr);
			ctr.append("_00000000");
			ctr.push_back(';');
		}
		else if (s.compare("ST") == 0)
		{
			move(ctr);
			ctr[0] = ctr[1] = ctr[3] = '0';
			ctr[2] = '1';
			ctr.append("_00000000");
			ctr.push_back(';');
		}
		else if (s[0] == 'B')
		{
			ctr.append("01");
			if (s[3] == 'Z')
				ctr.append("10");
			else if (s[3] == 'N')
				ctr.append("01");
			else if (s[3] == 'O')
				ctr.append("00");
			else if (s[3] == 'U')
				ctr.append("11");
			fin >> op1;
			ctr.push_back('_');
			k = 7;
			j = i + 1;
			while (k >= 0)
			{
				if (j - pow(2, k) >= 0)
				{
					j -= pow(2, k);
					ctr.push_back('1');
				}
				else
					ctr.push_back('0');
				k--;
			}
			bool ans = false;
			for (j = 0; j < stack.size(); j++) {
				if (stack[j].first.compare(op1) == 0) {
					ctr.push_back('_');
					k = 7;
					ans = true;
					while (k >= 0)
					{
						if (stack[j].second - pow(2, k) >= 0)
						{
							stack[j].second -= pow(2, k);
							ctr.push_back('1');
						}
						else
							ctr.push_back('0');
						k--;
					}
				}
			}
			if (!ans)
			{
				cout << "Tag doesn't exist in the program" << endl;
				exit(0);
			}
			ctr.append("_00000000");
			ctr.push_back(';');
		}
		else if (s.compare("END") == 0)
		{
			ctr.append("1111_11111111_11111111_11111111;");
			res.push_back(ctr);
			break;
		}
		else if (s.compare("ADD") == 0)
			{
				ctr.append("1000");
				alu(ctr);
				ctr.push_back(';');
			}
			else if (s.compare("SUB") == 0)
			{
				ctr.append("1001");
				alu(ctr);
				ctr.push_back(';');
			}
			else if (s.compare("AND") == 0)
			{
				ctr.append("1010");
				alu(ctr);
				ctr.push_back(';');
			}
			else if (s.compare("OR") == 0)
			{
				ctr.append("1011");
				alu(ctr);
				ctr.push_back(';');
			}
			else if (s.compare("SLEFT") == 0)
			{
				ctr.append("1100");
				alu(ctr);
				ctr.push_back(';');
			}
			else if (s.compare("SRIGHT") == 0)
			{
				ctr.append("1101");
				alu(ctr);
				ctr.push_back(';');
			}
			else if (s.compare("LOAD") == 0)
			{
				move(ctr);
				ctr[0] = '1'; ctr[1] = '1'; ctr[2] = '1'; ctr[3] = '0';
				ctr.append("_00000000");
				ctr.push_back(';');
			}
			else {
				s.pop_back();
				stack.push_back(make_pair(s, i));
				i--;
			}
			i++;

			if(!ctr.empty())
			res.push_back(ctr);
	}
	fout << "`timescale 1ns / 1ps \n module progmemory(clk, pc, inst); \n 	reg[27:0] pmemory[0:31]; output reg[27:0] inst; input wire[4:0]pc; input wire clk; initial begin " << endl;
	for (i = 0; i < res.size(); i++)
	{
		fout<<"pmemory["<<i<<"]=28'b"<<res[i]<<endl;
	}
	fout << "end \n 		always @(*) begin \n 		inst = pmemory[pc]; end \n endmodule " << endl;
	fout.close();
	fin.close();
	_getch;
}

