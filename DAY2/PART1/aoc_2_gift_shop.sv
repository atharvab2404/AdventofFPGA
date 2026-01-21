module aoc_2_gift_shop (
    input clk,
    input rst_n,
    input [63:0] id_value,
    input valid_id,
    output reg [63:0] accumulated_sum,
    output wire is_invalid
);


    wire is_1d = (id_value < 64'd10);
    wire is_2d = (id_value < 64'd100);
    wire is_3d = (id_value < 64'd1000);
    wire is_4d = (id_value < 64'd10000);
    wire is_5d = (id_value < 64'd100000);
    wire is_6d = (id_value < 64'd1000000);
    wire is_7d = (id_value < 64'd10000000);
    wire is_8d = (id_value < 64'd100000000);
    wire is_9d = (id_value < 64'd1000000000);
    wire is_10d = (id_value < 64'd10000000000);
    wire is_11d = (id_value < 64'd100000000000);
    wire is_12d = (id_value < 64'd1000000000000);
    wire is_13d = (id_value < 64'd10000000000000);
    wire is_14d = (id_value < 64'd100000000000000);
    wire is_15d = (id_value < 64'd1000000000000000);
    wire is_16d = (id_value < 64'd10000000000000000);
    wire is_17d = (id_value < 64'd100000000000000000);
    wire is_18d = (id_value < 64'd1000000000000000000);
    
    wire [7:0] digit_count = is_1d ? 8'd1 :
                             is_2d ? 8'd2 :
                             is_3d ? 8'd3 :
                             is_4d ? 8'd4 :
                             is_5d ? 8'd5 :
                             is_6d ? 8'd6 :
                             is_7d ? 8'd7 :
                             is_8d ? 8'd8 :
                             is_9d ? 8'd9 :
                             is_10d ? 8'd10 :
                             is_11d ? 8'd11 :
                             is_12d ? 8'd12 :
                             is_13d ? 8'd13 :
                             is_14d ? 8'd14 :
                             is_15d ? 8'd15 :
                             is_16d ? 8'd16 :
                             is_17d ? 8'd17 :
                             is_18d ? 8'd18 :
                             8'd19;
    
    // Check if digit count is even
    wire is_even = ~digit_count[0];
    
    // Compute divisor = 10^(digit_count/2)
    wire [63:0] divisor = (digit_count == 8'd2) ? 64'd10 :
                          (digit_count == 8'd4) ? 64'd100 :
                          (digit_count == 8'd6) ? 64'd1000 :
                          (digit_count == 8'd8) ? 64'd10000 :
                          (digit_count == 8'd10) ? 64'd100000 :
                          (digit_count == 8'd12) ? 64'd1000000 :
                          (digit_count == 8'd14) ? 64'd10000000 :
                          (digit_count == 8'd16) ? 64'd100000000 :
                          (digit_count == 8'd18) ? 64'd1000000000 :
                          64'd1;
    
    // Extract halves
    wire [63:0] first_half = id_value / divisor;
    wire [63:0] second_half = id_value % divisor;
    
    // Check invalidity: even digits AND halves match
    assign is_invalid = is_even && (first_half == second_half);

    // ========================================================================
    // Sequential Logic: Accumulate sum of invalid IDs
    // ========================================================================
    reg prev_valid_id;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulated_sum <= 64'b0;
            prev_valid_id <= 1'b0;
        end else begin
            prev_valid_id <= valid_id;
            
            // Process only on rising edge of valid_id
            if (valid_id && !prev_valid_id && is_invalid) begin
                accumulated_sum <= accumulated_sum + id_value;
            end
        end
    end

endmodule
