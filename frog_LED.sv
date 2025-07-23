// Morris Huang, Hudson Wong
// 06/05/2025
// EE 271
// Lab 6 frog_LED_start

// This module represents the normal LEDs for the frogger player using an FSM
// On reset, it automatically turns off, then it allows the player to move the LED around.
// Only one LED is lit at a time. If both the green LED and red LED are lit at the same time,
// it shows a game over. 
module frog_LED (clk, reset, NL, NR, ND, NU, L, R, D, U, green_LED, red_LED, gameover);
	
	// Initializes the logic. NL represents the LED to the left, NR is the LED to the right,
	// ND is the bottom LED, and NU is the top LED. 
	// L, R, D, and U represent the player movements
	input logic clk, reset, NL, NR, ND, NU, L, R, D, U, red_LED;
	output logic green_LED, gameover;
	
	// Initializes FSM logic. 
	enum {S0, S1} ps, ns;
	
	// This is the logic for the FSM. If the adjacent LED is lit and the corresponding input
	// is true, the LED turns green. If it is lit, having the corresponding input turn on
	// will turn the LED off. 
	always_comb begin
		case (ps)
			S0: if ((NL&R&~L) || (NR&L&~R) || (NU&D&~U) || (ND&U&~D)) ns = S1;
																	else ns = S0;
			S1: if ((R & ~L & ~NL) || (L & ~R & ~NR) || (U & ~D & ~ND) || (D & ~U & ~NU)) ns = S0;
																else ns = S1;
		endcase
	end
	
	// Assigns the state of the LED
	assign green_LED = (ps == S1);
	assign gameover = (ps == S1) & red_LED;

	
	// On reset, turns off the LED. 
	always_ff @(posedge clk) begin
		if (reset)
			ps <= S0;
		else
			ps <= ns;
	end
	
endmodule
	
//   This testbench verifies the logic of the frog_LED module. 
//   It provides a clock signal and applies a synchronous reset, then
//   allows the frog_LED module to run under different conditions to test whether it lights up and turns off appropriately. 
module frog_LED_testbench();
	logic CLOCK_50, reset, NL, NR, ND, NU, L, R, D, U, green_LED, red_LED, gameover; // Initializes the logic
	
	frog_LED dut(CLOCK_50, reset, NL, NR, ND, NU, L, R, D, U, green_LED, red_LED, gameover); // Instantiates the module
	
	parameter clock_period = 100;

    // toggle CLOCK_50 every half cycle
	initial begin
		CLOCK_50 <= 0;
		forever #(clock_period /2) CLOCK_50 <= ~CLOCK_50;
	end
	
	initial begin
		reset <= 1;	@(posedge CLOCK_50); // Tests the reset 
		reset <= 0;	@(posedge CLOCK_50);
		
		NL <= 0; NR <= 0; ND <= 0; NU <= 0; L <= 0; R <= 0; D <= 0; U <= 0;red_LED <= 0; // Initializes all logic to 0. 
		
		ND <= 1; U <= 1; @(posedge CLOCK_50); // Bottom LED is lit, and the up button is pressed.
		ND <= 0; U <= 0; @(posedge CLOCK_50); // The green_LED should be lit currently. 
	
		U <= 1; D <= 1; @(posedge CLOCK_50); // Tests that LED will not turn off with conflicting buttons
		U <= 0; D <= 0; @(posedge CLOCK_50);
		R <= 1; L <= 1; @(posedge CLOCK_50); 
		R <= 0; L <= 0; @(posedge CLOCK_50);
		U <= 1; D <= 1; R <= 1; L <= 1; @(posedge CLOCK_50); 
		U <= 0; D <= 0; R <= 0; L <= 0; @(posedge CLOCK_50); 
	
		U <= 1; @(posedge CLOCK_50); // With one button press, the LED will turn off.
		U <= 0; @(posedge CLOCK_50);
		NR <= 1; L <= 1; @(posedge CLOCK_50); // turn LED back on
		NR <= 0; L <= 0; @(posedge CLOCK_50);
	
		R <= 1; @(posedge CLOCK_50); // Should turn off
		R <= 0; @(posedge CLOCK_50);
		NL <= 1; R <= 1; @(posedge CLOCK_50); // turn LED back on
		NL <= 0; R <= 0; @(posedge CLOCK_50);
	
		L <= 1; @(posedge CLOCK_50); // Should turn off
		L <= 0; @(posedge CLOCK_50);
		NU <= 1; D <= 1; @(posedge CLOCK_50); // turn LED back on
		NU <= 0; D <= 0; @(posedge CLOCK_50);
	
		D <= 1; @(posedge CLOCK_50); // Should turn off
		D <= 0; @(posedge CLOCK_50);
		ND <= 1; U <= 1; @(posedge CLOCK_50); // turn LED back on
		ND <= 0; U <= 0; @(posedge CLOCK_50);
		
		red_LED <= 1; @(posedge CLOCK_50); // Test gameover condition
		
		$stop;
	end
endmodule