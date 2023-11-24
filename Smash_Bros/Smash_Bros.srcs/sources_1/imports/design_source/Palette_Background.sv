module Palette_Background ( input logic [2:0]	addr,
						output logic [11:0]	data
					 );



	always_comb begin
	data = 12'h000; //Protecting against an inferred latch
	case(addr)
    3'b000:
        data = 12'h808; 
	3'b001:
       data = 12'h68F; // teal blue, We dont need a background in this case since it has no empty space
	3'b010:
        data = 12'h0A9; // greenish blue
	3'b011:
        data = 12'hEEF; // white
	3'b100:
        data = 12'hC50; // brown
    3'b101:
       data = 12'h000;  // black

	// 4'b0100:
    //     

	// 4'b0101:
    //     

	// 4'b0110:
    //     

	// 4'b0111:
	// 	

	// 4'b1000:
    //     data = 12'h000;  // black

	endcase;


	end
endmodule
