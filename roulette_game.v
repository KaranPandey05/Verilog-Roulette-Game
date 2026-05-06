module roulette_game (
    input wire clk,
    input wire rst,
    input wire [15:0] seed,
    input wire start_round,
    input wire [5:0] bet_pos,
    input wire [7:0] bet_amount,
    input wire place_bet,
    output reg [15:0] total_money,
    output reg [15:0] round_winnings,
    output reg [5:0] winning_num,
    output reg round_done
);
    reg [7:0] bets [0:37];
    reg [15:0] total_bet;
    reg [15:0] winnings_temp;
    reg round_in_progress;
    wire [5:0] rand_num;
    
    lfsr_rng rng (
        .clk(clk),
        .rst(rst),
        .seed(seed),
        .rand_num(rand_num)
    );

    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin

            total_money <= 16'd100; 
            round_winnings <= 16'd0;
            total_bet <= 16'd0;
            winnings_temp <= 16'd0;
            round_done <= 1'b0;
            round_in_progress <= 1'b0;
            winning_num <= 6'd0;

            for (i = 0; i < 38; i = i + 1)
                bets[i] <= 8'd0;
        end else begin
            if (place_bet && !round_in_progress && total_money >= total_bet + bet_amount) begin
                bets[bet_pos] <= bets[bet_pos] + bet_amount;
                total_bet <= total_bet + bet_amount;
            end

            if (start_round && !round_in_progress) begin

                round_in_progress <= 1'b1;
                round_done <= 1'b0;
                winning_num <= rand_num;
                winnings_temp <= bets[rand_num] * 16'd36;
                round_winnings <= bets[rand_num] * 16'd36;
                total_money <= total_money - total_bet + (bets[rand_num] * 16'd36);
                
                for (i = 0; i < 38; i = i + 1)
                    bets[i] <= 8'd0;

                total_bet <= 16'd0;
                round_done <= 1'b1;
                round_in_progress <= 1'b0;
            end
        end
    end
endmodule