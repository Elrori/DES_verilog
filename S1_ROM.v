module S1_ROM(address, sout);

	input [5:0] address;
	output reg [3:0] sout;

	wire [1:0] row;
	wire [3:0] col;

	assign row = {address[5], address[0]};
	assign col = address[4:1];

	always @(address) begin
		case(row)

			0:
				case(col)
					0: sout = 14;
					1: sout = 4;
					2: sout = 13;
					3: sout = 1;
					4: sout = 2;
					5: sout = 15;
					6: sout = 11;
					7: sout = 8;
					8: sout = 3;
					9: sout = 10;
					10: sout = 6;
					11: sout = 12;
					12: sout = 5;
					13: sout = 9;
					14: sout = 0;
					15: sout = 7;
				endcase

			1:
				case(col)
                                        0: sout = 0;
                                        1: sout = 15;
                                        2: sout = 7;
                                        3: sout = 4;
                                        4: sout = 14;
                                        5: sout = 2;
                                        6: sout = 13;
                                        7: sout = 1;
                                        8: sout = 10;
                                        9: sout = 6;
                                        10: sout = 12;
                                        11: sout = 11;
                                        12: sout = 9;
                                        13: sout = 5;
                                        14: sout = 3;
                                        15: sout = 8;
				endcase

			2:
				case(col)
                                        0: sout = 4;
                                        1: sout = 1;
                                        2: sout = 14;
                                        3: sout = 8;
                                        4: sout = 13;
                                        5: sout = 6;
                                        6: sout = 2;
                                        7: sout = 11;
                                        8: sout = 15;
                                        9: sout = 12;
                                        10: sout = 9;
                                        11: sout = 7;
                                        12: sout = 3;
                                        13: sout = 10;
                                        14: sout = 5;
                                        15: sout = 0;

				endcase

			3:
				case(col)
                                        0: sout = 15;
                                        1: sout = 12;
                                        2: sout = 8;
                                        3: sout = 2;
                                        4: sout = 4;
                                        5: sout = 9;
                                        6: sout = 1;
                                        7: sout = 7;
                                        8: sout = 5;
                                        9: sout = 11;
                                        10: sout = 3;
                                        11: sout =  14;
                                        12: sout = 10;
                                        13: sout = 0;
                                        14: sout = 6;
                                        15: sout = 13;

				endcase
		endcase
	end 	

endmodule
