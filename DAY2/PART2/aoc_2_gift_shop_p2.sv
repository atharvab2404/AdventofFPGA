module aoc_2_gift_shop_p2 (
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


    // Pattern length 1 
    wire [63:0] pattern_1 = id_value % 64'd10;
    wire [63:0] reconstructed_1 = 
        (digit_count == 8'd2) ? (pattern_1 * 11) :
        (digit_count == 8'd3) ? (pattern_1 * 111) :
        (digit_count == 8'd4) ? (pattern_1 * 1111) :
        (digit_count == 8'd5) ? (pattern_1 * 11111) :
        (digit_count == 8'd6) ? (pattern_1 * 111111) :
        (digit_count == 8'd7) ? (pattern_1 * 1111111) :
        (digit_count == 8'd8) ? (pattern_1 * 11111111) :
        (digit_count == 8'd9) ? (pattern_1 * 111111111) :
        (digit_count == 8'd10) ? (pattern_1 * 1111111111) :
        (digit_count == 8'd11) ? (pattern_1 * 11111111111) :
        (digit_count == 8'd12) ? (pattern_1 * 111111111111) :
        (digit_count == 8'd13) ? (pattern_1 * 1111111111111) :
        (digit_count == 8'd14) ? (pattern_1 * 11111111111111) :
        (digit_count == 8'd15) ? (pattern_1 * 111111111111111) :
        (digit_count == 8'd16) ? (pattern_1 * 1111111111111111) :
        64'd0;
    wire check_1 = (reconstructed_1 == id_value) && (digit_count >= 8'd2 && digit_count <= 8'd16);

    // Pattern length 2:
    wire [63:0] pattern_2 = id_value % 64'd100;
    wire [63:0] seg2_1 = (id_value / 64'd100) % 64'd100;
    wire [63:0] seg2_2 = (id_value / 64'd10000) % 64'd100;
    wire [63:0] seg2_3 = (id_value / 64'd1000000) % 64'd100;
    wire [63:0] seg2_4 = (id_value / 64'd100000000) % 64'd100;
    wire [63:0] seg2_5 = (id_value / 64'd10000000000) % 64'd100;
    wire [63:0] seg2_6 = (id_value / 64'd1000000000000) % 64'd100;
    wire [63:0] seg2_7 = (id_value / 64'd100000000000000) % 64'd100;
    wire [63:0] seg2_8 = (id_value / 64'd10000000000000000) % 64'd100;
    wire [63:0] seg2_9 = (id_value / 64'd1000000000000000000) % 64'd100;
    wire check_2 = ((digit_count == 8'd4) && (seg2_1 == pattern_2)) ||
                   ((digit_count == 8'd6) && (seg2_1 == pattern_2) && (seg2_2 == pattern_2)) ||
                   ((digit_count == 8'd8) && (seg2_1 == pattern_2) && (seg2_2 == pattern_2) && (seg2_3 == pattern_2)) ||
                   ((digit_count == 8'd10) && (seg2_1 == pattern_2) && (seg2_2 == pattern_2) && (seg2_3 == pattern_2) && (seg2_4 == pattern_2)) ||
                   ((digit_count == 8'd12) && (seg2_1 == pattern_2) && (seg2_2 == pattern_2) && (seg2_3 == pattern_2) && (seg2_4 == pattern_2) && (seg2_5 == pattern_2)) ||
                   ((digit_count == 8'd14) && (seg2_1 == pattern_2) && (seg2_2 == pattern_2) && (seg2_3 == pattern_2) && (seg2_4 == pattern_2) && (seg2_5 == pattern_2) && (seg2_6 == pattern_2)) ||
                   ((digit_count == 8'd16) && (seg2_1 == pattern_2) && (seg2_2 == pattern_2) && (seg2_3 == pattern_2) && (seg2_4 == pattern_2) && (seg2_5 == pattern_2) && (seg2_6 == pattern_2) && (seg2_7 == pattern_2)) ||
                   ((digit_count == 8'd18) && (seg2_1 == pattern_2) && (seg2_2 == pattern_2) && (seg2_3 == pattern_2) && (seg2_4 == pattern_2) && (seg2_5 == pattern_2) && (seg2_6 == pattern_2) && (seg2_7 == pattern_2) && (seg2_8 == pattern_2) && (seg2_9 == pattern_2));

    // Pattern length 3
    wire [63:0] pattern_3 = id_value % 64'd1000;
    wire [63:0] seg3_1 = (id_value / 64'd1000) % 64'd1000;
    wire [63:0] seg3_2 = (id_value / 64'd1000000) % 64'd1000;
    wire [63:0] seg3_3 = (id_value / 64'd1000000000) % 64'd1000;
    wire [63:0] seg3_4 = (id_value / 64'd1000000000000) % 64'd1000;
    wire [63:0] seg3_5 = (id_value / 64'd1000000000000000) % 64'd1000;
    wire check_3 = ((digit_count == 8'd6) && (seg3_1 == pattern_3)) ||
                   ((digit_count == 8'd9) && (seg3_1 == pattern_3) && (seg3_2 == pattern_3)) ||
                   ((digit_count == 8'd12) && (seg3_1 == pattern_3) && (seg3_2 == pattern_3) && (seg3_3 == pattern_3)) ||
                   ((digit_count == 8'd15) && (seg3_1 == pattern_3) && (seg3_2 == pattern_3) && (seg3_3 == pattern_3) && (seg3_4 == pattern_3)) ||
                   ((digit_count == 8'd18) && (seg3_1 == pattern_3) && (seg3_2 == pattern_3) && (seg3_3 == pattern_3) && (seg3_4 == pattern_3) && (seg3_5 == pattern_3));

    // Pattern length 4
    wire [63:0] pattern_4 = id_value % 64'd10000;
    wire [63:0] seg4_1 = (id_value / 64'd10000) % 64'd10000;
    wire [63:0] seg4_2 = (id_value / 64'd100000000) % 64'd10000;
    wire [63:0] seg4_3 = (id_value / 64'd1000000000000) % 64'd10000;
    wire [63:0] seg4_4 = (id_value / 64'd10000000000000000) % 64'd10000;
    wire check_4 = ((digit_count == 8'd8) && (seg4_1 == pattern_4)) ||
                   ((digit_count == 8'd12) && (seg4_1 == pattern_4) && (seg4_2 == pattern_4) && (seg4_3 == pattern_4)) ||
                   ((digit_count == 8'd16) && (seg4_1 == pattern_4) && (seg4_2 == pattern_4) && (seg4_3 == pattern_4) && (seg4_4 == pattern_4));

    // Pattern length 5
    wire [63:0] pattern_5 = id_value % 64'd100000;
    wire [63:0] seg5_1 = (id_value / 64'd100000) % 64'd100000;
    wire [63:0] seg5_2 = (id_value / 64'd10000000000) % 64'd100000;
    wire check_5 = ((digit_count == 8'd10) && (seg5_1 == pattern_5)) ||
                   ((digit_count == 8'd15) && (seg5_1 == pattern_5) && (seg5_2 == pattern_5));

    // Pattern length 6
    wire [63:0] pattern_6 = id_value % 64'd1000000;
    wire [63:0] seg6_1 = (id_value / 64'd1000000) % 64'd1000000;
    wire [63:0] seg6_2 = (id_value / 64'd1000000000000) % 64'd1000000;
    wire check_6 = ((digit_count == 8'd12) && (seg6_1 == pattern_6)) ||
                   ((digit_count == 8'd18) && (seg6_1 == pattern_6) && (seg6_2 == pattern_6));

    // Pattern length 7
    wire [63:0] pattern_7 = id_value % 64'd10000000;
    wire [63:0] seg7_1 = (id_value / 64'd10000000) % 64'd10000000;
    wire check_7 = (digit_count == 8'd14) && (seg7_1 == pattern_7);

    // Pattern length 8
    wire [63:0] pattern_8 = id_value % 64'd100000000;
    wire [63:0] seg8_1 = (id_value / 64'd100000000) % 64'd100000000;
    wire check_8 = (digit_count == 8'd16) && (seg8_1 == pattern_8);

    // Pattern length 9
    wire [63:0] pattern_9 = id_value % 64'd1000000000;
    wire [63:0] seg9_1 = (id_value / 64'd1000000000) % 64'd1000000000;
    wire check_9 = (digit_count == 8'd18) && (seg9_1 == pattern_9);

    // OR all pattern checks
    assign is_invalid = check_1 || check_2 || check_3 || check_4 || check_5 || check_6 || check_7 || check_8 || check_9;


    reg prev_valid_id;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulated_sum <= 64'b0;
            prev_valid_id <= 1'b0;
        end else begin
            prev_valid_id <= valid_id;

            if (valid_id && !prev_valid_id && is_invalid) begin
                accumulated_sum <= accumulated_sum + id_value;
            end
        end
    end

endmodule
