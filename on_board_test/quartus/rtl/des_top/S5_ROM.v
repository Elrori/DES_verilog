module S5_ROM(address, sout);

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
					0: sout = 2;
					1: sout = 12;
					2: sout = 4;
					3: sout = 1;
					4: sout = 7;
					5: sout = 10;
					6: sout = 11;
					7: sout = 6;
					8: sout = 8;
					9: sout = 5;
					10: sout = 3;
					11: sout = 15;
					12: sout = 13;
					13: sout = 0;
					14: sout = 14;
					15: sout = 9;
				endcase

			1:
				case(col)
                                        0: sout = 14;
                                        1: sout = 11;
                                        2: sout = 2;
                                        3: sout = 12;
                                        4: sout = 4;
                                        5: sout = 7;
                                        6: sout = 13;
                                        7: sout = 1;
                                        8: sout = 5;
                                        9: sout = 0;
                                        10: sout = 15;
                                        11: sout = 10;
                                        12: sout = 3;
                                        13: sout = 9;
                                        14: sout = 8;
                                        15: sout = 6;
				endcase

			2:
				case(col)
                                        0: sout = 4;
                                        1: sout = 2;
                                        2: sout = 1;
                                        3: sout = 11;
                                        4: sout = 10;
                                        5: sout = 13;
                                        6: sout = 7;
                                        7: sout = 8;
                                        8: sout = 15;
                                        9: sout = 9;
                                        10: sout = 12;
                                        11: sout = 5;
                                        12: sout = 6;
                                        13: sout = 3;
                                        14: sout = 0;
                                        15: sout = 14;

				endcase

			3:
				case(col)
                                        0: sout = 11;
                                        1: sout = 8;
                                        2: sout = 12;
                                        3: sout = 7;
                                        4: sout = 1;
                                        5: sout = 14;
                                        6: sout = 2;
                                        7: sout = 13;
                                        8: sout = 6;
                                        9: sout = 15;
                                        10: sout = 0;
                                        11: sout = 9;
                                        12: sout = 10;
                                        13: sout = 4;
                                        14: sout = 5;
                                        15: sout = 3;
				endcase
		endcase
	end 	

endmodule
