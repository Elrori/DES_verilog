module S8_ROM(address, sout);

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
					0: sout = 13;
					1: sout = 2;
					2: sout = 8;
					3: sout = 4;
					4: sout = 6;
					5: sout = 15;
					6: sout = 11;
					7: sout = 1;
					8: sout = 10;
					9: sout = 9;
					10: sout = 3;
					11: sout = 14;
					12: sout = 5;
					13: sout = 0;
					14: sout = 12;
					15: sout = 7;
				endcase

			1:
				case(col)
                                        0: sout = 1;
                                        1: sout = 15;
                                        2: sout = 13;
                                        3: sout = 8;
                                        4: sout = 10;
                                        5: sout = 3;
                                        6: sout = 7;
                                        7: sout = 4;
                                        8: sout = 12;
                                        9: sout = 5;
                                        10: sout = 6;
                                        11: sout = 11;
                                        12: sout = 0;
                                        13: sout = 14;
                                        14: sout = 9;
                                        15: sout = 2;
				endcase

			2:
				case(col)
                                        0: sout = 7;
                                        1: sout = 11;
                                        2: sout = 4;
                                        3: sout = 1;
                                        4: sout = 9;
                                        5: sout = 12;
                                        6: sout = 14;
                                        7: sout = 2;
                                        8: sout = 0;
                                        9: sout = 6;
                                        10: sout = 10;
                                        11: sout = 13;
                                        12: sout = 15;
                                        13: sout = 3;
                                        14: sout = 5;
                                        15: sout = 8;

				endcase

			3:
				case(col)
                                        0: sout = 2;
                                        1: sout = 1;
                                        2: sout = 14;
                                        3: sout = 7;
                                        4: sout = 4;
                                        5: sout = 10;
                                        6: sout = 8;
                                        7: sout = 13;
                                        8: sout = 15;
                                        9: sout = 12;
                                        10: sout = 9;
                                        11: sout = 0;
                                        12: sout = 3;
                                        13: sout = 5;
                                        14: sout = 6;
                                        15: sout = 11;
				endcase
		endcase
	end 	

endmodule
