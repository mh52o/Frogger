// Morris Huang, Hudson Wong
// 06/07/2025
// EE 271
// Lab 6 clock_divider

// Takes in a clock signal, divides the clock cycle and outputs 32
// divided clock signals of varying frequency.
// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ...
// [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (clock, divided_clocks);
	
	input logic clock;
	output logic [31:0] divided_clocks = 32'b0;
	
	// Adds 1 to the logic divided_clocks at the
	// positive edge of each clock cycle. 
	// Given the nature of 32 bit numbers,
	// the lowest bit toggles between 1 and 0 twice as fast
	// as the next bit, the next bit toggles twice as fast 
	// as the next higher bit, and so on. This allows
	// the clock divider to halve the frequency up to 31 times.
	always_ff @(posedge clock) begin
		divided_clocks <= divided_clocks + 1;
	end
endmodule

// Tests whether the clock divider, given an initialized
// clock, properly outputs the divided frequency signals. 
module clock_divider_testbench();
	logic clock;
	logic [31:0] divided_clocks;
	
	clock_divider dut (.clock(clock), .divided_clocks(divided_clocks));
	
	// Sets up a clock that toggles every 10 nanoseconds
	initial begin
		clock <= 0;
		forever #10 clock <= ~clock;
					
	end //initial
		
		integer i;
		initial begin
		
		// Iterates through 2^32 clock cycles to test whether
		// each divided clock cycle is twice as long as the previous.
		// Due to processing limitations, does not test the maximum
		// clock cycles. 
		for(i=0; i<2**32;i++) begin
		 @(posedge clock);
		end // for loop
		
		$stop;
	end // initial
endmodule
