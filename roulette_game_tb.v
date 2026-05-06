`timescale 1ns / 1ps

module roulette_game_tb;
    reg clk;
    reg rst;
    reg [15:0] seed;
    reg start_round;
    reg [5:0] bet_pos;
    reg [7:0] bet_amount;
    reg place_bet;
    wire [15:0] total_money;
    wire [15:0] round_winnings;
    wire round_done;

  
    roulette_game uut (
        .clk(clk),
        .rst(rst),
        .seed(seed),
        .start_round(start_round),
        .bet_pos(bet_pos),
        .bet_amount(bet_amount),
        .place_bet(place_bet),
        .total_money(total_money),
        .round_winnings(round_winnings),
        .round_done(round_done)
    );

  
    always #5 clk = ~clk;

    initial begin
   
        clk = 0;
        rst = 1;
        seed = 16'hACE5; // Change this to generate another number
        start_round = 0;
        bet_pos = 6'd0;
        bet_amount = 8'd0;
        place_bet = 0;

       
        #10;
        rst = 0;

        
        #10;

       
        bet_pos = 6'd5;       // Change to set position
        bet_amount = 8'd10;   // Change to set bet amount
        place_bet = 1;
        #10;
        place_bet = 0;

       
        start_round = 1;
        #10;
        start_round = 0;

        // Wait for round to complete
        wait (round_done);

    $display("-------------------------------------------------");
	$display("Your bet:        Position %d with $%d", bet_pos, bet_amount);
	$display("Winning number:  %d", uut.winning_num);  

	if (bet_pos == uut.winning_num) begin
    	$display("Result:          YOU WON! You receive $%d", round_winnings);
	end else begin
      $display("Result:          You lost. :(");
	end

	$display("Money left:      $%d", total_money);
	$display("-------------------------------------------------");


        // Wait a bit before finishing
        #20;
        $finish;
    end

endmodule
