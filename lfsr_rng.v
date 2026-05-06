module lfsr_rng (
    input wire clk,
    input wire rst,
    input wire [15:0] seed,
    output reg [5:0] rand_num
);
    reg [15:0] lfsr;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr <= seed;
            rand_num <= 6'd0;
        end else begin
            lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]};
            rand_num <= lfsr[5:0] % 6'd38; 
        end
    end
endmodule