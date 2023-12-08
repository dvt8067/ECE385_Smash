/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module zero_health_ROM
(

		input [11:0] read_address,
		input Clk,

		output logic  data_Out
);

// mem has width of 2 bits and a total of 4800 addresses
logic [1:0] mem [0:2249];

initial
begin
	 $readmemh("0_health_image.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule