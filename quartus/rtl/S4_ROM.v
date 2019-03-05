module S4_ROM(address, sout);

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
					0: sout = 7;
					1: sout = 13;
					2: sout = 14;
					3: sout = 3;
					4: sout = 0;
					5: sout = 6;
					6: sout = 9;
					7: sout = 10;
					8: sout = 1;
					9: sout = 2;
					10: sout = 8;
					11: sout = 5;
					12: sout = 11;
					13: sout = 12;
					14: sout = 4;
					15: sout = 15;
				endcase

			1:
				case(col)
                                        0: sout = 13;
                                        1: sout = 8;
                                        2: sout = 11;
                                        3: sout = 5;
                                        4: sout = 6;
                                        5: sout = 15;
                                        6: sout = 0;
                                        7: sout = 3;
                                        8: sout = 4;
                                        9: sout = 7;
                                        10: sout = 2;
                                        11: sout = 12;
                                        12: sout = 1;
                                        13: sout = 10;
                                        14: sout = 14;
                                        15: sout = 9;
				endcase

			2:
				case(col)
                                        0: sout = 10;
                                        1: sout = 6;
                                        2: sout = 9;
                                        3: sout = 0;
                                        4: sout = 12;
                                        5: sout = 11;
                                        6: sout = 7;
                                        7: sout = 13;
                                        8: sout = 15;
                                        9: sout = 1;
                                        10: sout = 3;
                                        11: sout = 14;
                                        12: sout = 5;
                                        13: sout = 2;
                                        14: sout = 8;
                                        15: sout = 4;

				endcase

			3:
				case(col)
                                        0: sout = 3;
                                        1: sout = 15;
                                        2: sout = 0;
                                        3: sout = 6;
                                        4: sout = 10;
                                        5: sout = 1;
                                        6: sout = 13;
                                        7: sout = 8;
                                        8: sout = 9;
                                        9: sout = 4;
                                        10: sout = 5;
                                        11: sout =  11;
                                        12: sout = 12;
                                        13: sout = 7;
                                        14: sout = 2;
                                        15: sout = 14;

				endcase
		endcase
	end 	

endmodule
