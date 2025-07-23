// Morris Huang, Hudson Wong
// 05/22/2025
// EE 271
// Lab 6 10-bit LFSR

// The LFSR module implements a 10-bit Linear Feedback Shift Register (LFSR)
//   using XNOR feedback logic. It shifts right on every clock cycle and
//   inserts a new bit into the MSB (bit 9) calculated as the XNOR of
//   bit 0 and bit 3. When reset, it goes to a predetermined seed that is passed in
module seeded_LFSR(clk, reset, out, seed);
	input logic clk, reset;
	input logic [9:0] seed;
	output logic [9:0] out;

    // LFSR logic triggered on the rising edge of the clock
	always_ff @(posedge clk) 
		begin
			if(reset)
			out<=seed;
			else 
				begin
				// Perform right shift on the entire register
				out <= out>>1;
				// Insert feedback bit at MSB (bit 9) using XNOR of bits 0 and 3 or
				// bits 7 and 10.
				out[9] <= ~(out[0] ^ out[3]);
			end
		end
		
	endmodule
	
//   This testbench verifies the shift and xnor logic of the LFSR.
//   It provides a clock signal and applies a synchronous reset, then
//   allows the LFSR to run for 1024 clock cycles to observe its output.
module seeded_LFSR_testbench();
	logic CLOCK_50;
	logic reset;
	logic [9:0] out, seed;
	
	// Instantiate the LFSR module DUT
	seeded_LFSR dut(CLOCK_50, reset, out, seed);
	
	parameter clock_period = 100;

    // toggle CLOCK_50 every half cycle
	initial begin
			CLOCK_50 <= 0;
			forever #(clock_period /2) CLOCK_50 <= ~CLOCK_50;
		
		end
		
	// apply reset and then run the LFSR
	initial begin
		seed <= 10'b0000000000;
	    // Apply reset for one clock cycle
		reset <= 1;	@(posedge CLOCK_50);
		reset <= 0;	@(posedge CLOCK_50);
		 // Let the LFSR run for 1024 clock cycles
		repeat(1024) @(posedge CLOCK_50);
		
		seed <= 10'b0100011100; // Test different seeds
	    // Apply reset for one clock cycle
		reset <= 1;	@(posedge CLOCK_50);
		reset <= 0;	@(posedge CLOCK_50);
		 // Let the LFSR run for 1024 clock cycles
		repeat(20) @(posedge CLOCK_50);
		
		seed <= 10'b0110011101; // Test different seeds
	    // Apply reset for one clock cycle
		reset <= 1;	@(posedge CLOCK_50);
		reset <= 0;	@(posedge CLOCK_50);
		 // Let the LFSR run for 1024 clock cycles
		repeat(20) @(posedge CLOCK_50);
										
		$stop;
		end
		
	endmodule
	