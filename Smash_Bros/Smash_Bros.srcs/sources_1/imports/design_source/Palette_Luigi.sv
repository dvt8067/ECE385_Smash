module Palette_Luigi ( input logic [1:0]	addr,
						output logic [11:0]	data
					 );



	always_comb begin
	case(addr)
	2'b00:
        data = 12'h808; // background
	2'b01:
        data = 12'h0F0;   //Green
	2'b10:
        data = 12'hFA0;  // yellow
	2'b11:
        data = 12'h660;  // green

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
