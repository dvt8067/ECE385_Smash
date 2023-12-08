module Palette_Score ( input logic 	addr,
						output logic [11:0]	data
					 );



	always_comb begin
	case(addr)
	1'b0:
        data = 12'h808; // background
	1'b1:
        data = 12'hFFF;   //White


	// 4'b0100:
    //     data = 12'h68F; // teal blue

	// 4'b0101:
    //     data = 12'h0A9; // greenish blue

	// 4'b0110:
    //     data = 12'hEEF; // white

	// 4'b0111:
	// 	data = 12'hC50; // brown

	// 4'b1000:
    //     data = 12'h000;  // black

	endcase;


	end
endmodule
