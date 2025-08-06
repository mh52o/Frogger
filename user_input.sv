// Morris Huang, Hudson Wong
// 06/07/2025
//  user_input

// Takes a button press that, as long as it is pressed,
// only registers once even across multiple clock cycles.
// Has parameters clk which sets the clock cycles,
// reset which sets the output to a default state,
// button which is the key input, and out which
// registers once for as long as the button is pressed.
module user_input(clk, reset, button, out);
   input logic clk, reset, button;
   output logic out;
	logic sync_button, next_button;
	 
	// A pair of flip flops for metastability. Delays the input by two cycles
	always_ff @(posedge clk) begin
		if (reset) begin
			sync_button<=1'b0;
			next_button<=1'b0;
		end else begin
			sync_button<=button;
			next_button<=sync_button;
		end
	end
	
	enum {S0, S1} ps, ns;
	
	// If the button is held down, only registers once
   always_comb begin
        case (ps)
            S0: if (next_button) ns = S1;
                        else ns = S0;
            S1: if (next_button) ns = S1;
                        else ns = S0;
        endcase
    end
    
    assign out = (ps==S0) & next_button;
        
	// Resets the output to 0
   always_ff @(posedge clk) begin
		if (reset)
			ps <= S0;
		else
			ps <= ns;
	end

endmodule

// Tests the user input module using clock cycles and inputs
module user_input_testbench();
	logic CLOCK_50; // 50MHz clock
	logic reset, button, out;
		
	user_input dut(CLOCK_50, reset, button, out);
	parameter clock_period = 100;
		
		
	initial begin
		CLOCK_50 <= 0;
		forever #(clock_period /2) CLOCK_50 <= ~CLOCK_50;
					
	end //initial
	
	initial begin
		reset <= 1; button<=0; @(posedge CLOCK_50); 
		reset <= 0;  @(posedge CLOCK_50); 
		button<=1;   @(posedge CLOCK_50); 
						 @(posedge CLOCK_50); 
						 @(posedge CLOCK_50); 
						 @(posedge CLOCK_50); 
		button<=0;	 @(posedge CLOCK_50); // Tests whether out only registers once
		button<=1;	 @(posedge CLOCK_50); 
		button<=0;	 @(posedge CLOCK_50); 
						 @(posedge CLOCK_50); 
						 @(posedge CLOCK_50); 
						 @(posedge CLOCK_50); 
		button<=1;	 @(posedge CLOCK_50); // Tests whether multiple buttons counts as one press
		button<=1;	 @(posedge CLOCK_50);
		button<=1;	 @(posedge CLOCK_50);
		button<=1;	 @(posedge CLOCK_50);
		button<=1;	 @(posedge CLOCK_50);
		button<=0;	 @(posedge CLOCK_50);	
		button<=1;	 @(posedge CLOCK_50);
		button<=1;	 @(posedge CLOCK_50);
		button<=1;	 @(posedge CLOCK_50);
		button<=1;	 @(posedge CLOCK_50);
		button<=1;	 @(posedge CLOCK_50);	
		$stop;		
		end //initial
endmodule	
	
			