module aoc_1_safe_dial_p2 (
    input clk,
    input rst_n,
    input [15:0] rotation_distance,
    input direction,                // 0 = Left (L), 1 = Right (R)
    input valid_rotation,
    output reg [15:0] zero_count,   // Total clicks that landed on 0
    output reg [6:0]  current_pos   // Dial position 0..99
);

    parameter integer DIAL_SIZE   = 100;
    parameter integer INITIAL_POS = 50;

    // Precompute quotient and remainder by 100 once (q = dist/100, r = dist%100)
    wire [15:0] q100 = rotation_distance / 16'd100;
    wire [6:0]  r100 = rotation_distance - (q100 * 16'd100);

    // Right rotation crossing count:
    // countR = q + ((current_pos + r) >= 100 ? 1 : 0)
    wire [7:0] sumR = current_pos + r100;
    wire [15:0] crossings_right = q100 + ((sumR >= 8'd100) ? 16'd1 : 16'd0);

    // Left rotation crossing count:
    // If current_pos == 0: each 100 clicks hits 0 exactly once => q
    // Else: countL = q + (r >= current_pos ? 1 : 0)
    wire [15:0] crossings_left_nonzero_cp = q100 + ((r100 >= current_pos) ? 16'd1 : 16'd0);
    wire [15:0] crossings_left = (current_pos == 7'd0) ? q100 : crossings_left_nonzero_cp;

    wire [15:0] crossings = direction ? crossings_right : crossings_left;

    // Next position after applying r (distance modulo 100)
    wire [6:0] next_pos_right = (sumR >= 8'd100) ? (sumR - 8'd100) : sumR[6:0];
    wire [6:0] next_pos_left  = (r100 <= current_pos) ? (current_pos - r100)
                                                      : (current_pos + (7'd100 - r100));
    wire [6:0] next_pos = direction ? next_pos_right : next_pos_left;

    // Process only on rising edge of valid_rotation to avoid double-counts
    reg prev_valid_rotation;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_pos <= INITIAL_POS[6:0];
            zero_count  <= 16'd0;
            prev_valid_rotation <= 1'b0;
        end else begin
            prev_valid_rotation <= valid_rotation;
            if (valid_rotation && !prev_valid_rotation) begin
                current_pos <= next_pos;
                zero_count  <= zero_count + crossings;
            end
        end
    end

endmodule
