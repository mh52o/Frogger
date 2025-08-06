// Morris Huang, Hudson Wong
// 06/05/2025
// DE1_SoC

// This module simulates a game of frogger, where the player attempts to cross a 
// road full of crossing cars. The game is simulated on an LED matrix, and if the player
// runs into the car, they lose. If they reach the end, they win, and the cars spawn and move faster.
// There are eight difficulties in total, and reset will reset the difficulty to 0. 
module DE1_SoC (CLOCK_50,HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, GPIO_1, SW);

	input logic CLOCK_50;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [35:0] GPIO_1;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	logic [31:0] clk;
	
	// Initializes two clock parameters. The whichClock controls the player movements,
	// while crossyClock controls the car movements. This makes it so that the player can move
	// faster than the cars. 
	parameter whichClock = 4;
	parameter crossyClock =25;
	
	
	// Initializes the clock divider and the LED matrix 
	clock_divider cdiv (CLOCK_50, clk);
	logic [15:0][15:0] RedPixels; // 16x16 array of red LEDs
   logic [15:0][15:0] GrnPixels;
	
	// Cycles through the LED matrix to light up each pixel 
	LEDDriver(.GPIO_1(GPIO_1), .RedPixels(RedPixels), .GrnPixels(GrnPixels), .EnableCount(1'b1), .CLK(clk[5]), .RST(SW[0]));

	logic reset_playfield, reset, L, R, U, D;  // configure reset, the player moves, and the gameover logic
	logic [35:0] gameover; // Initializes gameover as a 36 bit array to take in the inputs from all of the LEDs in the 6x6 block
	logic [2:0] difficulty;
	assign reset = SW[9]; // Reset when SW[9] is toggled
	
	
	// Sends the input to a user input module to make sure that a long button
	// press only registers as one input. Also implements a pair of flip flops
	// for metastability. 
	// Key 0 corresponds to the right movement, key 1 to up, key 2 to down, and key 3 to left. 
	user_input right(.clk(clk[whichClock]), .reset(reset), .button(~KEY[0]), .out(R));
	user_input left(.clk(clk[whichClock]), .reset(reset), .button(~KEY[3]), .out(L));
	user_input down(.clk(clk[whichClock]), .reset(reset), .button(~KEY[2]), .out(D));
	user_input up(.clk(clk[whichClock]), .reset(reset), .button(~KEY[1]), .out(U));
	
	// Initializes a 6x6 playing field where the player can move freely. 
	// Whenever the player moves right after reaching the rightmost edge, transfers
	// them to the leftmost edge, and same for the left side. They cannot move down
	// after reaching the bottom, but the frogger disappears after reaching the top and pressing up
	frog_LED f1010(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[10][11]), .NR(GrnPixels[10][15]), .ND(GrnPixels[11][10]), .NU(1'b0), .L(L), .R(R), .D(D), .U(U),  .green_LED(GrnPixels[10][10]), .red_LED(RedPixels[10][10]), .gameover(gameover[0]));
	frog_LED f1011(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[10][12]), .NR(GrnPixels[10][10]), .ND(GrnPixels[11][11]), .NU(1'b0), .L(L), .R(R), .D(D), .U(U),  .green_LED(GrnPixels[10][11]), .red_LED(RedPixels[10][11]), .gameover(gameover[1]));
	frog_LED f1012(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[10][13]), .NR(GrnPixels[10][11]), .ND(GrnPixels[11][12]), .NU(1'b0), .L(L), .R(R), .D(D), .U(U),  .green_LED(GrnPixels[10][12]), .red_LED(RedPixels[10][12]), .gameover(gameover[2]));
	frog_LED f1013(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[10][14]), .NR(GrnPixels[10][12]), .ND(GrnPixels[11][13]), .NU(1'b0), .L(L), .R(R), .D(D), .U(U),  .green_LED(GrnPixels[10][13]), .red_LED(RedPixels[10][13]), .gameover(gameover[3]));
	frog_LED f1014(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[10][15]), .NR(GrnPixels[10][13]), .ND(GrnPixels[11][14]), .NU(1'b0), .L(L), .R(R), .D(D), .U(U),  .green_LED(GrnPixels[10][14]), .red_LED(RedPixels[10][14]), .gameover(gameover[4]));
	frog_LED f1015(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[10][10]), .NR(GrnPixels[10][14]), .ND(GrnPixels[11][15]), .NU(1'b0), .L(L), .R(R), .D(D), .U(U),  .green_LED(GrnPixels[10][15]), .red_LED(RedPixels[10][15]), .gameover(gameover[5]));
 
	frog_LED f1110(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[11][11]), .NR(GrnPixels[11][15]), .ND(GrnPixels[12][10]), .NU(GrnPixels[10][10]), .L(L), .R(R), .D(D), .U(U),  .green_LED(GrnPixels[11][10]), .red_LED(RedPixels[11][10]), .gameover(gameover[6]));
	frog_LED f1111(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[11][12]), .NR(GrnPixels[11][10]), .ND(GrnPixels[12][11]), .NU(GrnPixels[10][11]), .L(L), .R(R), .D(D), .U(U),  .green_LED(GrnPixels[11][11]), .red_LED(RedPixels[11][11]), .gameover(gameover[7]));
	frog_LED f1112(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[11][13]), .NR(GrnPixels[11][11]), .ND(GrnPixels[12][12]), .NU(GrnPixels[10][12]), .L(L), .R(R), .D(D), .U(U),  .green_LED(GrnPixels[11][12]), .red_LED(RedPixels[11][12]), .gameover(gameover[8]));
	frog_LED f1113(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[11][14]), .NR(GrnPixels[11][12]), .ND(GrnPixels[12][13]), .NU(GrnPixels[10][13]), .L(L), .R(R), .D(D), .U(U),  .green_LED(GrnPixels[11][13]), .red_LED(RedPixels[11][13]), .gameover(gameover[9]));
	frog_LED f1114(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[11][15]), .NR(GrnPixels[11][13]), .ND(GrnPixels[12][14]), .NU(GrnPixels[10][14]), .L(L), .R(R), .D(D), .U(U),  .green_LED(GrnPixels[11][14]), .red_LED(RedPixels[11][14]), .gameover(gameover[10]));
	frog_LED f1115(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[11][10]), .NR(GrnPixels[11][14]), .ND(GrnPixels[12][15]), .NU(GrnPixels[10][15]), .L(L), .R(R), .D(D), .U(U),  .green_LED(GrnPixels[11][15]), .red_LED(RedPixels[11][15]), .gameover(gameover[11]));

	frog_LED_start f1515(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[15][10]), .NR(GrnPixels[15][14]), .ND(1'b0), .NU(GrnPixels[14][15] || GrnPixels[15][15]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[15][15]), .red_LED(RedPixels[15][15]), .gameover(gameover[12]));
	frog_LED f1514(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[15][15]), .NR(GrnPixels[15][13]), .ND(1'b0), .NU(GrnPixels[14][14] || GrnPixels[15][14]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[15][14]), .red_LED(RedPixels[15][14]), .gameover(gameover[13]));
	frog_LED f1513(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[15][14]), .NR(GrnPixels[15][12]), .ND(1'b0), .NU(GrnPixels[14][13] || GrnPixels[15][13]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[15][13]), .red_LED(RedPixels[15][13]), .gameover(gameover[14]));
	frog_LED f1512(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[15][13]), .NR(GrnPixels[15][11]), .ND(1'b0), .NU(GrnPixels[14][12] || GrnPixels[15][12]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[15][12]), .red_LED(RedPixels[15][12]), .gameover(gameover[15]));
	frog_LED f1511(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[15][12]), .NR(GrnPixels[15][10]), .ND(1'b0), .NU(GrnPixels[14][11] || GrnPixels[15][11]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[15][11]), .red_LED(RedPixels[15][11]), .gameover(gameover[16]));
	frog_LED f1510(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[15][11]), .NR(GrnPixels[15][15]), .ND(1'b0), .NU(GrnPixels[14][10] || GrnPixels[15][10]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[15][10]), .red_LED(RedPixels[15][10]), .gameover(gameover[17]));
    
	frog_LED f1415(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[14][10]), .NR(GrnPixels[14][14]), .ND(GrnPixels[15][15]), .NU(GrnPixels[13][15]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[14][15]), .red_LED(RedPixels[14][15]), .gameover(gameover[18]));
	frog_LED f1414(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[14][15]), .NR(GrnPixels[14][13]), .ND(GrnPixels[15][14]), .NU(GrnPixels[13][14]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[14][14]), .red_LED(RedPixels[14][14]), .gameover(gameover[19]));
	frog_LED f1413(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[14][14]), .NR(GrnPixels[14][12]), .ND(GrnPixels[15][13]), .NU(GrnPixels[13][13]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[14][13]), .red_LED(RedPixels[14][13]), .gameover(gameover[20]));
	frog_LED f1412(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[14][13]), .NR(GrnPixels[14][11]), .ND(GrnPixels[15][12]), .NU(GrnPixels[13][12]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[14][12]), .red_LED(RedPixels[14][12]), .gameover(gameover[21]));
   frog_LED f1411(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[14][12]), .NR(GrnPixels[14][10]), .ND(GrnPixels[15][11]), .NU(GrnPixels[13][11]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[14][11]), .red_LED(RedPixels[14][11]), .gameover(gameover[22]));
   frog_LED f1410(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[14][11]), .NR(GrnPixels[14][15]), .ND(GrnPixels[15][10]), .NU(GrnPixels[13][10]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[14][10]), .red_LED(RedPixels[14][10]), .gameover(gameover[23]));
    
	frog_LED f1315(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[13][10]), .NR(GrnPixels[13][14]), .ND(GrnPixels[14][15]), .NU(GrnPixels[12][15]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[13][15]), .red_LED(RedPixels[13][15]), .gameover(gameover[24])); 
	frog_LED f1314(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[13][15]), .NR(GrnPixels[13][13]), .ND(GrnPixels[14][14]), .NU(GrnPixels[12][14]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[13][14]), .red_LED(RedPixels[13][14]), .gameover(gameover[25]));
	frog_LED f1313(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[13][14]), .NR(GrnPixels[13][12]), .ND(GrnPixels[14][13]), .NU(GrnPixels[12][13]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[13][13]), .red_LED(RedPixels[13][13]), .gameover(gameover[26])); 
	frog_LED f1312(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[13][13]), .NR(GrnPixels[13][11]), .ND(GrnPixels[14][12]), .NU(GrnPixels[12][12]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[13][12]), .red_LED(RedPixels[13][12]), .gameover(gameover[27]));
	frog_LED f1311(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[13][12]), .NR(GrnPixels[13][10]), .ND(GrnPixels[14][11]), .NU(GrnPixels[12][11]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[13][11]), .red_LED(RedPixels[13][11]), .gameover(gameover[28]));
	frog_LED f1310(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[13][11]), .NR(GrnPixels[13][15]), .ND(GrnPixels[14][10]), .NU(GrnPixels[12][10]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[13][10]), .red_LED(RedPixels[13][10]), .gameover(gameover[29]));

	frog_LED f1215(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[12][10]), .NR(GrnPixels[12][14]), .ND(GrnPixels[13][15]), .NU(GrnPixels[11][15]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[12][15]), .red_LED(RedPixels[12][15]), .gameover(gameover[30]));
	frog_LED f1214(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[12][15]), .NR(GrnPixels[12][13]), .ND(GrnPixels[13][14]), .NU(GrnPixels[11][14]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[12][14]), .red_LED(RedPixels[12][14]), .gameover(gameover[31]));
	frog_LED f1213(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[12][14]), .NR(GrnPixels[12][12]), .ND(GrnPixels[13][13]), .NU(GrnPixels[11][13]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[12][13]), .red_LED(RedPixels[12][13]), .gameover(gameover[32]));
	frog_LED f1212(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[12][13]), .NR(GrnPixels[12][11]), .ND(GrnPixels[13][12]), .NU(GrnPixels[11][12]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[12][12]), .red_LED(RedPixels[12][12]), .gameover(gameover[33]));
	frog_LED f1211(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[12][12]), .NR(GrnPixels[12][10]), .ND(GrnPixels[13][11]), .NU(GrnPixels[11][11]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[12][11]), .red_LED(RedPixels[12][11]), .gameover(gameover[34]));
	frog_LED f1210(.clk(clk[whichClock]), .reset(reset_playfield), .NL(GrnPixels[12][11]), .NR(GrnPixels[12][15]), .ND(GrnPixels[13][10]), .NU(GrnPixels[11][10]), .L(L), .R(R), .D(D), .U(U), .green_LED(GrnPixels[12][10]), .red_LED(RedPixels[12][10]), .gameover(gameover[35]));
	
	// Initializes the logic to randomize the car movement
	logic random1, random2, random3, frogger_car1, frogger_car2, frogger_car3;
	logic [9:0] random_cross1, random_cross2, random_cross3;
	
	// Uses a seeded_LFSR to ensure that the cars spawn randomly
	seeded_LFSR random_move1(.clk(clk[crossyClock - difficulty]), .reset(reset), .out(random_cross1), .seed(10'b0000000000)); 
	seeded_LFSR random_move2(.clk(clk[crossyClock - difficulty]), .reset(reset), .out(random_cross2), .seed(10'b0000011111)); 
	seeded_LFSR random_move3(.clk(clk[crossyClock - difficulty]), .reset(reset), .out(random_cross3), .seed(10'b0101010101)); 
	
	// Uses a comparator to turn the 10 bit number from the LFSR into a singular output
	comparator rand1(.inputA(random_cross1), .inputB(10'b0111111111), .A_greater_B(random1), .clk(clk[crossyClock - difficulty]), .reset(reset));
	comparator rand2(.inputA(random_cross2), .inputB(10'b0111111111), .A_greater_B(random2), .clk(clk[crossyClock - difficulty]), .reset(reset));
	comparator rand3(.inputA(random_cross3), .inputB(10'b0111111111), .A_greater_B(random3), .clk(clk[crossyClock - difficulty]), .reset(reset));
	
	// Ensures that the car only spawns once if the output from comparator is true for multiple clock cycles
	user_input car_move1(.clk(clk[crossyClock - difficulty]), .reset(reset), .button(random1), .out(frogger_car1));
	user_input car_move2(.clk(clk[crossyClock - difficulty]), .reset(reset), .button(random2), .out(frogger_car2));
	user_input car_move3(.clk(clk[crossyClock - difficulty]), .reset(reset), .button(random3), .out(frogger_car3));
	
	// Initializes the logic for the cars. Each car moves to the right every clock cycle until
	// it reaches the edge and disappears. Uses the LFSR to randomly determine when the 
	// cars spawn. The cars are represented by red LEDs. They spawn on the 2nd, 4th, and 5th row
	crossy_road c1415(.clk(clk[crossyClock - difficulty]), .reset(reset_playfield), .NL(frogger_car1), .red_LED(RedPixels[14][15]));
	crossy_road c1414(.clk(clk[crossyClock - difficulty]), .reset(reset_playfield), .NL(RedPixels[14][15]), .red_LED(RedPixels[14][14]));
	crossy_road c1413(.clk(clk[crossyClock - difficulty]), .reset(reset_playfield), .NL(RedPixels[14][14]), .red_LED(RedPixels[14][13]));
	crossy_road c1412(.clk(clk[crossyClock - difficulty]), .reset(reset_playfield), .NL(RedPixels[14][13]), .red_LED(RedPixels[14][12]));
	crossy_road c1411(.clk(clk[crossyClock - difficulty]), .reset(reset_playfield), .NL(RedPixels[14][12]), .red_LED(RedPixels[14][11]));
	crossy_road c1410(.clk(clk[crossyClock - difficulty]), .reset(reset_playfield), .NL(RedPixels[14][11]), .red_LED(RedPixels[14][10]));
	
	
	crossy_road c1215(.clk(clk[crossyClock - difficulty]), .reset(reset_playfield), .NL(frogger_car2), .red_LED(RedPixels[12][15]));
	crossy_road c1214(.clk(clk[crossyClock - difficulty]), .reset(reset_playfield), .NL(RedPixels[12][15]), .red_LED(RedPixels[12][14]));
	crossy_road c1213(.clk(clk[crossyClock - difficulty]), .reset(reset_playfield), .NL(RedPixels[12][14]), .red_LED(RedPixels[12][13]));
	crossy_road c1212(.clk(clk[crossyClock - difficulty]), .reset(reset_playfield), .NL(RedPixels[12][13]), .red_LED(RedPixels[12][12]));
	crossy_road c1211(.clk(clk[crossyClock - difficulty]), .reset(reset_playfield), .NL(RedPixels[12][12]), .red_LED(RedPixels[12][11]));
	crossy_road c1210(.clk(clk[crossyClock - difficulty]), .reset(reset_playfield), .NL(RedPixels[12][11]), .red_LED(RedPixels[12][10]));
	
	
	crossy_road c1015(.clk(clk[crossyClock - difficulty]), .reset(reset_playfield), .NL(frogger_car3), .red_LED(RedPixels[10][15]));
	crossy_road c1014(.clk(clk[crossyClock - difficulty]), .reset(reset_playfield), .NL(RedPixels[10][15]), .red_LED(RedPixels[10][14]));
	crossy_road c1013(.clk(clk[crossyClock - difficulty]), .reset(reset_playfield), .NL(RedPixels[10][14]), .red_LED(RedPixels[10][13]));
	crossy_road c1012(.clk(clk[crossyClock - difficulty]), .reset(reset_playfield), .NL(RedPixels[10][13]), .red_LED(RedPixels[10][12]));
	crossy_road c1011(.clk(clk[crossyClock - difficulty]), .reset(reset_playfield), .NL(RedPixels[10][12]), .red_LED(RedPixels[10][11]));
	crossy_road c1010(.clk(clk[crossyClock - difficulty]), .reset(reset_playfield), .NL(RedPixels[10][11]), .red_LED(RedPixels[10][10]));
	
	
						
	victory v0(.clk(clk[whichClock]), .reset(reset),.TopLED(GrnPixels[10][10] || GrnPixels[10][11] || GrnPixels[10][12] || GrnPixels[10][13] || GrnPixels[10][14] || GrnPixels[10][15]), .UpKey(U), .DownKey(D), .gameover(|gameover), .win(win), .lose(lose), .reset_playfield(reset_playfield), .difficulty(difficulty));

endmodule

// This testbench verifies the behavior of the DE1_SoC module, ensuring that the 
// module instantiates a board that can run a game of Frogger, randomize the car movement, and so on. 
// The parameters whichClock and crossyClock must be set to zero for this testbench to function, and the LED
// Driver must not be initialized. 
module DE1_SoC_testbench();
   logic CLOCK_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [35:0] GPIO_1;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	
	DE1_SoC dut(CLOCK_50,HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, GPIO_1, SW);

	
	parameter clock_period = 100;

    // toggle CLOCK_50 every half cycle
	initial begin
		CLOCK_50 <= 0;
		forever #(clock_period /2) CLOCK_50 <= ~CLOCK_50;
	end
	
	
	initial begin
    	KEY[0] <= 0; KEY[1] <= 0; KEY[2] <= 0; KEY[3] <= 0; SW[9] <= 0; @(posedge CLOCK_50); // Sets all relevant variables to 0.
    	
    	SW[9] <= 1; @(posedge CLOCK_50);
    	SW[9] <= 0; @(posedge CLOCK_50); //Toggle reset
    	
    	repeat(20) @(posedge CLOCK_50); //Tests the car functionality
		KEY[2] <= 1; KEY[1] <= 1; repeat(10) @(posedge CLOCK_50); // Tests that opposite keys do not move the frog
		KEY[2] <= 0; KEY[1] <= 0; repeat(10) @(posedge CLOCK_50);
		KEY[0] <= 1; KEY[3] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[0] <= 0; KEY[3] <= 0; repeat(10) @(posedge CLOCK_50);
    
    	
    	KEY[0] <= 1; repeat(10) @(posedge CLOCK_50); // Tests that each of the movement keys works
    	KEY[0] <= 0; repeat(10)@(posedge CLOCK_50);
    	KEY[1] <= 1; repeat(10)@(posedge CLOCK_50);
    	KEY[1] <= 0; repeat(10)@(posedge CLOCK_50);
    	KEY[2] <= 1; repeat(10)@(posedge CLOCK_50);
    	KEY[2] <= 0; repeat(10)@(posedge CLOCK_50);
    	KEY[3] <= 1; repeat(10)@(posedge CLOCK_50);
    	KEY[3] <= 0; repeat(10)@(posedge CLOCK_50);
    	
    	KEY[3] <= 1; repeat(10)@(posedge CLOCK_50); // Frog moves and wins
    	KEY[3] <= 0; repeat(10)@(posedge CLOCK_50);
    	KEY[3] <= 1; repeat(10)@(posedge CLOCK_50);
    	KEY[3] <= 0; repeat(10)@(posedge CLOCK_50);
    	KEY[2] <= 1; repeat(10)@(posedge CLOCK_50); 
    	KEY[2] <= 0; repeat(10)@(posedge CLOCK_50);
    	KEY[2] <= 1; repeat(10)@(posedge CLOCK_50); 
    	KEY[2] <= 0; repeat(10)@(posedge CLOCK_50);
    	KEY[2] <= 1; repeat(10)@(posedge CLOCK_50); 
    	KEY[2] <= 0; repeat(10)@(posedge CLOCK_50);
    	KEY[2] <= 1; repeat(10)@(posedge CLOCK_50); 
    	KEY[2] <= 0; repeat(10)@(posedge CLOCK_50);
    	KEY[2] <= 1; repeat(10)@(posedge CLOCK_50); 
    	KEY[2] <= 0; repeat(10)@(posedge CLOCK_50);
    	KEY[2] <= 1; repeat(10)@(posedge CLOCK_50); 
    	KEY[2] <= 0; repeat(10)@(posedge CLOCK_50);
		
		// Random moves to ensure everything works
		KEY[2] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[0] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[3] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[3] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[1] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[1] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[0] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[2] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[3] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[3] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[1] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[1] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[2] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[0] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[1] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[1] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[3] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[3] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[0] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[2] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[1] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[1] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[3] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[3] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[1] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[1] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[0] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[2] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[3] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[3] <= 0; repeat(10) @(posedge CLOCK_50);
		
		KEY[2] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[0] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[3] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[3] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[1] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[1] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[0] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[2] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[3] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[3] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[1] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[1] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[2] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[0] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[1] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[1] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[3] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[3] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[0] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[2] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[1] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[1] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[3] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[3] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[1] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[1] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[0] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[2] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[3] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[3] <= 0; repeat(10) @(posedge CLOCK_50);

		KEY[3] <= 1; repeat(10) @(posedge CLOCK_50);
		KEY[3] <= 0; repeat(10) @(posedge CLOCK_50);
    	
    	SW[9] <= 1; repeat(10)@(posedge CLOCK_50); // Toggle reset
    	SW[9] <= 0; @(posedge CLOCK_50);
    	
    	KEY[2] <= 1; repeat(10)@(posedge CLOCK_50); // Frog runs into a car and resets
    	KEY[2] <= 0; repeat(10)@(posedge CLOCK_50);
    	repeat(20)   @(posedge CLOCK_50); 
    	
    $stop;
    end
endmodule
