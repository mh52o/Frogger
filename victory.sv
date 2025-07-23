// Morris Huang, Hudson Wong
// 06/04/2025
// EE 271
// Victory Module

// This module determines when the player wins by reaching the top of the field or 
// loses when it collides with a car. In either case, it resets the playfield. 
module victory (clk, reset, UpKey,DownKey, win, lose, reset_playfield, gameover, TopLED, difficulty);
    input logic clk, reset, UpKey, DownKey, gameover, TopLED;
    output logic win, lose;
    output logic reset_playfield;
	 output logic [2:0] difficulty;
    
    assign win = (TopLED & UpKey & ~DownKey);
    assign lose = gameover;
	 three_bit_counter counter(.clk(clk), .reset(reset), .in(win), .out(difficulty));

	// Manage reset_playfield signal. If the player wins or loses or if the reset switch is toggled,
	// it resets the field to its default state. 
    always_ff @(posedge clk) begin
        if (reset)
            reset_playfield <= 1;
        else if (win || lose)
            reset_playfield <= 1;
        else
            reset_playfield <= 0;
    end
endmodule
	
//   This testbench verifies the logic of the victory module
//   It provides a clock signal and the inputs and tests whether it 
// correctly displays the win and lose conditions as well as increment the difficulty. 
module victory_testbench();
    
    logic clk, reset, UpKey, DownKey, gameover, TopLED, win, lose, reset_playfield;
    logic [2:0] difficulty;
    
    // Instantuate Device under test
    victory dut(clk, reset, UpKey,DownKey, win, lose, reset_playfield, gameover, TopLED, difficulty);
    
     parameter clock_period = 100;
		
		// Runs every 100/2 picoseconds for each clock cycle
		initial begin
			clk <= 0;
			forever #(clock_period /2) clk <= ~clk;
		
		end
		
		initial begin
		
		reset <= 1; UpKey <= 0; DownKey <= 0; TopLED <= 0;gameover <= 0; @(posedge clk);
		reset <= 0; @(posedge clk);
		
		// Test winning conditions and difficulty logic
		UpKey <= 1; DownKey <= 0; TopLED <= 1; @(posedge clk);
											TopLED <= 0;				@(posedge clk);
					
		UpKey <= 1; DownKey <= 0; TopLED <= 1; @(posedge clk);
											TopLED <= 0;				@(posedge clk);
		UpKey <= 1; DownKey <= 0; TopLED <= 1; @(posedge clk);
											TopLED <= 0;				@(posedge clk);
											@(posedge clk);
		
		
		// Test losing conditions
		UpKey <= 1; DownKey <= 0; gameover<=1; @(posedge clk);
		
		
		// Test regular in game condition
		UpKey <= 0; DownKey <= 0; TopLED <= 1; gameover<=0; @(posedge clk);
		UpKey <= 0; DownKey <= 0; TopLED <= 0; gameover<=0;  @(posedge clk);
		
		end 
		
	endmodule
    




