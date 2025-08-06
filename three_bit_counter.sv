// Morris Huang, Hudson Wong
// 05/22/2025
// three_bit_counter

// Three_bit_counter increments a counter by 1 every time an input is true.
// It starts at 0 and goes to 7 using binary numbers and a finite state machine.
// It takes in parameters clk, reset, in, and out.
// clk represents the clock cycles,
// reset sets the counter back to zero,
// in increments the number by one,
// and out represents the current count
module three_bit_counter (clk, reset, in, out);
	input logic clk, reset, in;
	output logic [2:0] out;
	
	// Sets the eight states 0-7
	enum {S0, S1, S2, S3, S4, S5, S6, S7} ps, ns; // Present state, next state
	
	// Sets the finite state machine for the counter. If the input is true,
	// goes to the next state. Otherwise, stays on the same state. 
	always_comb begin
		case(ps)
			S0: if (in) ns = S1;
					else ns = S0;
			S1: if (in) ns = S2;
					else ns = S1;
			S2: if (in) ns = S3;
					else ns = S2;
			S3: if (in) ns = S4;
					else ns = S3;
			S4: if (in) ns = S5;
					else ns = S4;
			S5: if (in) ns = S6;
					else ns = S5;
			S6: if (in) ns = S7;
					else ns = S6;
			S7: ns = S7;
		endcase
	end
	
	// Sets the output to whatever state it corresponds to from 0-7
	always_comb begin
        case (ps)
            S0: out = 3'b000;
            S1: out = 3'b001;
            S2: out = 3'b010;
            S3: out = 3'b011;
			S4: out = 3'b100;
			S5: out = 3'b101;
			S6: out = 3'b110;
			S7: out = 3'b111;
        endcase
    end
	
	// Resets the present state to the first state, going back to 0
	always_ff @(posedge clk) begin
		if (reset)
			ps <= S0;
		else
			ps <= ns;
	end
endmodule
	
// This module tests the three bit counter, ensuring that it only increments
// when in is true, and that out represents the correct output
module three_bit_counter_testbench();
	
	// Instantiates the logic
    logic CLOCK_50; // 50MHz clock
    logic reset, in;
    logic [2:0] out;
	
	// Calls the module
	three_bit_counter dut(CLOCK_50, reset, in, out);
	
	parameter clock_period = 100;
		
	// Runs every 100/2 picoseconds for each clock cycle
	initial begin
		CLOCK_50 <= 0;
		forever #(clock_period /2) CLOCK_50 <= ~CLOCK_50;
					
	end //initial
	
	initial begin
			reset <= 1; 				@(posedge CLOCK_50); // assert reset
			reset <= 0; 				@(posedge CLOCK_50); // release reset
			in<=1;   					@(posedge CLOCK_50); // Ensures that the out increments by 1
										@(posedge CLOCK_50); // Also ensures that it maxes out at 7 without causing errors
										@(posedge CLOCK_50); 
										@(posedge CLOCK_50); 
										@(posedge CLOCK_50); 
										@(posedge CLOCK_50); 
										@(posedge CLOCK_50); 
										@(posedge CLOCK_50); 
										@(posedge CLOCK_50); 
										@(posedge CLOCK_50); 
										@(posedge CLOCK_50); 
			in<=0;						@(posedge CLOCK_50); 
			reset<=1;					@(posedge CLOCK_50); 
			reset<=0;					@(posedge CLOCK_50); 
										@(posedge CLOCK_50); 
			in<=1;						@(posedge CLOCK_50); 
			in<=0;						@(posedge CLOCK_50); // Ensures that there are no false increments
			in<=1;						@(posedge CLOCK_50); 
			in<=0;						@(posedge CLOCK_50); 
			in<=1;						@(posedge CLOCK_50); 
			in<=0;						@(posedge CLOCK_50); 
			in<=1;						@(posedge CLOCK_50); 
			in<=0;						@(posedge CLOCK_50); 
			in<=1;						@(posedge CLOCK_50); 
			in<=0;						@(posedge CLOCK_50); 
			in<=1;						@(posedge CLOCK_50); 
			in<=0;						@(posedge CLOCK_50); 
			in<=1;						@(posedge CLOCK_50); 
			in<=0;						@(posedge CLOCK_50); 
					 
		$stop;		
		end //initial
endmodule	