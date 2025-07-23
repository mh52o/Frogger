// Morris Huang, Hudson Wong
// 06/05/2025
// EE 271
// Lab 6 crossy_road

// This module simulates the logic for the cars running across the LED matrix using an FSM.
// It moves each car (LED) to the right every clock cycle. 
// By passing in a random "output" from the LFSR, it can also randomly spawn cars
module crossy_road (clk, reset, NL, red_LED);

	// Initializes the logic. NL represents the LED to the left,
	// or in the case of the starting LED, the LFSR output
	input logic clk, reset, NL;
	output logic red_LED;
	
	// Starts the FSM logic
	enum {S0, S1} ps, ns;
	
	// If the left LED is on, turns the current LED to red. 
	// Otherwise, turns off. This effectively shifts the car right every clock cycle
	always_comb begin
		case (ps)
			S0: if (NL) ns = S1;
							else ns = S0;
			S1: ns = S0;

		endcase
	end
	
	assign red_LED = (ps == S1);
	
	// Toggles reset such that the light does not turn on. 
	always_ff @(posedge clk) begin
		if (reset)
			ps <= S0;
		else
			ps <= ns;
	end
	
endmodule

// This module functions as a test bench for the crossy_road module.
// Verifies that the crossy_road LED turns on for exactly one clock cycle 
// when the LED to the left of it is turned on. 
module crossy_road_testbench();
    logic CLOCK_50, reset, NL, red_LED; // Initializes the logic
	
	crossy_road dut(CLOCK_50, reset, NL, red_LED); // Instantiates the module
	
	parameter clock_period = 100;

    // toggle CLOCK_50 every half cycle
	initial begin
		CLOCK_50 <= 0;
		forever #(clock_period /2) CLOCK_50 <= ~CLOCK_50;
	end
	
	initial begin
		reset <= 1;	@(posedge CLOCK_50); // Tests the reset 
		reset <= 0;	@(posedge CLOCK_50);
		
		NL <= 1; @(posedge CLOCK_50); // Tests that the LED lights up
		NL <= 0;
		@(posedge CLOCK_50); // Tests that the LED turns off after one clock cycle. 
		@(posedge CLOCK_50);
		repeat(10) @(posedge CLOCK_50); // Tests that no random behavior happens. 
	
		
		$stop;
	end
	
endmodule
