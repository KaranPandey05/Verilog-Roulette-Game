# Verilog-Roulette-Game
A fun little roulette game to help me gamble without going broke :)

## How It Works

### Random Number Generation — `lfsr_rng`

The LFSR module generates a pseudo-random 6-bit number each clock cycle using a 16-bit shift register with feedback taps at bits 15, 13, 12, and 10. The output is constrained to 0–37 using modulo 38, mapping to the 38 positions on a standard roulette wheel (0, 00, and 1–36).

The LFSR is seeded on reset, meaning the same seed will always produce the same sequence of numbers. Changing the seed changes the outcome.

**Feedback polynomial:**
```
lfsr[n+1] = {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]}
rand_num  = lfsr[5:0] % 38
```

### Game Logic — `roulette_game`

The top-level module manages:

- **Bet placement** — accepts a position (0–37) and an amount per clock cycle when `place_bet` is asserted, provided the player has enough money and no round is in progress
- **Round execution** — on `start_round`, samples the current LFSR output as the winning number, computes a 36x payout on the winning position, deducts all stakes, and clears bets
- **Money tracking** — starts at $100 and updates each round: `total_money = total_money - total_bet + (bet_on_winner * 36)`
- **Round signaling** — asserts `round_done` for one cycle when results are ready

All state updates are synchronous on the positive clock edge, with an active-high reset.

---

## Testbench

The testbench (`roulette_game_tb`) runs a single round with a fixed seed (`16'hACE5`) to produce a deterministic result. It:

1. Resets the system
2. Places a $10 bet on position 5
3. Starts a round and waits for `round_done`
4. Prints the result, winning number, and remaining balance

To change the bet or outcome, modify `bet_pos`, `bet_amount`, or `seed` in the testbench.

**Example output:**
```
-------------------------------------------------
Your bet:        Position  5 with $ 10
Winning number:  11
Result:          You lost. :(
Money left:      $   90
-------------------------------------------------
```

---

## Notes

- The LFSR is not cryptographically secure — it is a pseudo-random sequence suitable for simulation purposes only
- The 36x payout (rather than the standard 35:1) is a simplification; in real roulette the house keeps one unit, giving the casino its edge
- Bets cannot be placed once a round is in progress, and the system prevents betting more than the current balance
