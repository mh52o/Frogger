// Morris Huang, Hudson Wong
// 06/07/025
// EE 271
// Lab 6 comparator

// Comparator takes in two inputs inputA and inputB and returns whether A is greater than B.
// If it is less than or equal to B, returns 0, otherwise returns 1. 
module comparator(inputA, inputB, A_greater_B, clk, reset);
	input logic [9:0] inputA, inputB;
	input logic clk, reset;
	output logic A_greater_B;
	
	// Sequential logic to set A_greater_B
	always_ff @(posedge clk) begin
		if (reset) 
			A_greater_B <= 1'b0;
		else 
			A_greater_B <= (inputA > inputB);
	end
endmodule

// This module tests the comparator by instantiating several test cases to make
// sure that it correctly outputs when A is greater than B. 
module comparator_testbench();

	logic [9:0] inputA, inputB;
	logic CLOCK_50, reset, A_greater_B;
	
	// Calls comparator
	comparator dut(inputA, inputB, A_greater_B, CLOCK_50, reset);
	
	parameter clock_period = 100;

    // toggle CLOCK_50 every half cycle
	initial begin
		CLOCK_50 <= 0;
		forever #(clock_period /2) CLOCK_50 <= ~CLOCK_50;
	end
	
	initial begin
	    // Apply reset for one clock cycle
		reset <= 1;	@(posedge CLOCK_50);
		reset <= 0;	@(posedge CLOCK_50);
		
		inputA <= 1000000000; inputB <= 0100000000; @(posedge CLOCK_50); // Test A > B 
		@(posedge CLOCK_50);
		inputA <= 0100000000; inputB <= 0100000000; @(posedge CLOCK_50); // Test A = B
		@(posedge CLOCK_50);
		inputA <= 0100000000; inputB <= 1000000000; @(posedge CLOCK_50); // Test A < B
		inputA <= 0000000000; inputB <= 0000000000; @(posedge CLOCK_50); // Test edge cases
		inputA <= 1111111111; inputB <= 1111111111; @(posedge CLOCK_50);
		inputA <= 0000000000; inputB <= 1111111111; @(posedge CLOCK_50); 
		inputA <= 1111111111; inputB <= 0000000000; @(posedge CLOCK_50); // Test A < B
		
		inputA <= 0100001111; inputB <= 1000001100; @(posedge CLOCK_50); // Test random values
		inputA <= 1100010100; inputB <= 100101000; @(posedge CLOCK_50); 
		inputA <= 0100011110; inputB <= 1001111100; @(posedge CLOCK_50); 
		inputA <= 0100101111; inputB <= 1010101100; @(posedge CLOCK_50); 
		inputA <= 0101010110; inputB <= 0101010110; @(posedge CLOCK_50); 
		inputA <= 0100101100; inputB <= 0010100000; @(posedge CLOCK_50); 
		inputA <= 0100101100; inputB <= 0100001111; @(posedge CLOCK_50); 
		inputA <= 1100011000; inputB <= 1000100110; @(posedge CLOCK_50); 
		inputA <= 1111000000; inputB <= 1000000010; @(posedge CLOCK_50); 
		inputA <= 0100000000; inputB <= 1010110010; @(posedge CLOCK_50); 
		inputA <= 0101011100; inputB <= 0101100101; @(posedge CLOCK_50); 
		inputA <= 1100111000; inputB <= 1111111100; @(posedge CLOCK_50); 
		inputA <= 0100110000; inputB <= 1000110000; @(posedge CLOCK_50); 
		
						
		$stop;
	end
endmodule
	
	