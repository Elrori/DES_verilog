module S7_ROM(address, sout);

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
					0: sout = 4;
					1: sout = 11;
					2: sout = 2;
					3: sout = 14;
					4: sout = 15;
					5: sout = 0;
					6: sout = 8;
					7: sout = 13;
					8: sout = 3;
					9: sout = 12;
					10: sout = 9;
					11: sout = 7;
					12: sout = 5;
					13: sout = 10;
					14: sout = 6;
					15: sout = 1;
				endcase

			1:
				case(col)
                                        0: sout = 13;
                                        1: sout = 0;
                                        2: sout = 11;
                                        3: sout = 7;
                                        4: sout = 4;
                                        5: sout = 9;
                                        6: sout = 1;
                                        7: sout = 10;
                                        8: sout = 14;
                                        9: sout = 3;
                                        10: sout = 5;
                                        11: sout = 12;
                                        12: sout = 2;
                                        13: sout = 15;
                                        14: sout = 8;
                                        15: sout = 6;
				endcase

			2:
				case(col)
                                        0: sout = 1;
                                        1: sout = 4;
                                        2: sout = 11;
                                        3: sout = 13;
                                        4: sout = 12;
                                        5: sout = 3;
                                        6: sout = 7;
                                        7: sout = 14;
                                        8: sout = 10;
                                        9: sout = 15;
                                        10: sout = 6;
                                        11: sout = 8;
                                        12: sout = 0;
                                        13: sout = 5;
                                        14: sout = 9;
                                        15: sout = 2;

				endcase

			3:
				case(col)
                                        0: sout = 6;
                                        1: sout = 11;
                                        2: sout = 13;
                                        3: sout = 8;
                                        4: sout = 1;
                                        5: sout = 4;
                                        6: sout = 10;
                                        7: sout = 7;
                                        8: sout = 9;
                                        9: sout = 5;
                                        10: sout = 0;
                                        11: sout = 15;
                                        12: sout = 14;
                                        13: sout = 2;
                                        14: sout = 3;
                                        15: sout = 12;

				endcase
		endcase
	end 	

endmodule
