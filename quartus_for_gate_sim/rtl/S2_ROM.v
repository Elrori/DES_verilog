module S2_ROM(address, sout);

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
					0: sout = 15; 
					1: sout = 1;
					2: sout = 8;
					3: sout = 14;
					4: sout = 6;
					5: sout = 11;
					6: sout = 3;
					7: sout = 4;
					8: sout = 9;
					9: sout = 7;
					10: sout = 2;
					11: sout = 13;
					12: sout = 12;
					13: sout = 0;
					14: sout = 5;
					15: sout = 10;
				endcase

			1:
				case(col)
                                        0: sout = 3;
                                        1: sout = 13;
                                        2: sout = 4;
                                        3: sout = 7;
                                        4: sout = 15;
                                        5: sout = 2;
                                        6: sout = 8;
                                        7: sout = 14;
                                        8: sout = 12;
                                        9: sout = 0;
                                        10: sout = 1;
                                        11: sout = 10;
                                        12: sout = 6;
                                        13: sout = 9;
                                        14: sout = 11;
                                        15: sout = 5;
				endcase

			2:
				case(col)
                                        0: sout = 0;
                                        1: sout = 14;
                                        2: sout = 7;
                                        3: sout = 11;
                                        4: sout = 10;
                                        5: sout = 4;
                                        6: sout = 13;
                                        7: sout = 1;
                                        8: sout = 5;
                                        9: sout = 8;
                                        10: sout = 12;
                                        11: sout = 6;
                                        12: sout = 9;
                                        13: sout = 3;
                                        14: sout = 2;
                                        15: sout = 15;

				endcase

			3:
				case(col)
                                        0: sout = 13;
                                        1: sout = 8;
                                        2: sout = 10;
                                        3: sout = 1;
                                        4: sout = 3;
                                        5: sout = 15;
                                        6: sout = 4;
                                        7: sout = 2;
                                        8: sout = 11;
                                        9: sout = 6;
                                        10: sout = 7;
                                        11: sout = 12;
                                        12: sout = 0;
                                        13: sout = 5;
                                        14: sout = 14;
                                        15: sout = 9;

				endcase
		endcase
	end 	

endmodule
