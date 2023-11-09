module Palette ( input logic [1:0]	addr,
						output logic [11:0]	data
					 );


				
	always_comb begin		
	case(addr)
	2'b00:
        data = 12'h808; // background
	2'b01:
        data = 12'hD00;   //red
	2'b10:
        data = 12'hFA0;  // yellow
	2'b11:
        data = 12'h660;  // green

	endcase;

	
	end
endmodule  