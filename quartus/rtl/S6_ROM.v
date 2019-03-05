module S6_ROM(address, sout);

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
					0: sout = 12;
					1: sout = 1;
					2: sout = 10;
					3: sout = 15;
					4: sout = 9;
					5: sout = 2;
					6: sout = 6;
					7: sout = 8;
					8: sout = 0;
					9: sout = 13;
					10: sout = 3;
					11: sout = 4;
					12: sout = 14;
					13: sout = 7;
					14: sout = 5;
					15: sout = 11;
				endcase

			1:
				case(col)
                                        0: sout = 10;
                                        1: sout = 15;
                                        2: sout = 4;
                                        3: sout = 2;
                                        4: sout = 7;
                                        5: sout = 12;
                                        6: sout = 9;
                                        7: sout = 5;
                                        8: sout = 6;
                                        9: sout = 1;
                                        10: sout = 13;
                                        11: sout = 14;
                                        12: sout = 0;
                                        13: sout = 11;
                                        14: sout = 3;
                                        15: sout = 8;
				endcase

			2:
				case(col)
                                        0: sout = 9;
                                        1: sout = 14;
                                        2: sout = 15;
                                        3: sout = 5;
                                        4: sout = 2;
                                        5: sout = 8;
                                        6: sout = 12;
                                        7: sout = 3;
                                        8: sout = 7;
                                        9: sout = 0;
                                        10: sout = 4;
                                        11: sout = 10;
                                        12: sout = 1;
                                        13: sout = 13;
                                        14: sout = 11;
                                        15: sout = 6;

				endcase

			3:
				case(col)
                                        0: sout = 4;
                                        1: sout = 3;
                                        2: sout = 2;
                                        3: sout = 12;
                                        4: sout = 9;
                                        5: sout = 5;
                                        6: sout = 15;
                                        7: sout = 10;
                                        8: sout = 11;
                                        9: sout = 14;
                                        10: sout = 1;
                                        11: sout = 7;
                                        12: sout = 6;
                                        13: sout = 0;
                                        14: sout = 8;
                                        15: sout = 13;

				endcase
		endcase
	end 	

endmodule
