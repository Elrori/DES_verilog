module S3_ROM(address, sout);

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
					0: sout = 10;
					1: sout = 0;
					2: sout = 9;
					3: sout = 14;
					4: sout = 6;
					5: sout = 3;
					6: sout = 15;
					7: sout = 5;
					8: sout = 1;
					9: sout = 13;
					10: sout = 12;
					11: sout = 7;
					12: sout = 11;
					13: sout = 4;
					14: sout = 2;
					15: sout = 8;
				endcase

			1:
				case(col)
                                        0: sout = 13;
                                        1: sout = 7;
                                        2: sout = 0;
                                        3: sout = 9;
                                        4: sout = 3;
                                        5: sout = 4;
                                        6: sout = 6;
                                        7: sout = 10;
                                        8: sout = 2;
                                        9: sout = 8;
                                        10: sout = 5;
                                        11: sout = 14;
                                        12: sout = 12;
                                        13: sout = 11;
                                        14: sout = 15;
                                        15: sout = 1;
				endcase

			2:
				case(col)
                                        0: sout = 13;
                                        1: sout = 6;
                                        2: sout = 4;
                                        3: sout = 9;
                                        4: sout = 8;
                                        5: sout = 15;
                                        6: sout = 3;
                                        7: sout = 0;
                                        8: sout = 11;
                                        9: sout = 1;
                                        10: sout = 2;
                                        11: sout = 12;
                                        12: sout = 5;
                                        13: sout = 10;
                                        14: sout = 14;
                                        15: sout = 7;

				endcase

			3:
				case(col)
                                        0: sout = 1;
                                        1: sout = 10;
                                        2: sout = 13;
                                        3: sout = 0;
                                        4: sout = 6;
                                        5: sout = 9;
                                        6: sout = 8;
                                        7: sout = 7;
                                        8: sout = 4;
                                        9: sout = 15;
                                        10: sout = 14;
                                        11: sout =  3;
                                        12: sout = 11;
                                        13: sout = 5;
                                        14: sout = 2;
                                        15: sout = 12;

				endcase
		endcase
	end 	

endmodule
