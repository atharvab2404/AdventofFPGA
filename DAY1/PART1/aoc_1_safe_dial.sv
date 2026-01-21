module aoc_1_safe_dial (
    input clk,
    input rst_n,
    input [15:0] rotation_distance,  
    input direction,                
    input valid_rotation,          
    output reg [15:0] zero_count,  
    output reg [6:0] current_pos   
);

    parameter DIAL_SIZE = 100;
    parameter INITIAL_POS = 50;

    wire signed [15:0] temp_pos_signed;
    wire [6:0] normalized_distance;
    wire [6:0] next_pos;

    assign normalized_distance = rotation_distance % 100;

    assign temp_pos_signed = direction ? (current_pos + normalized_distance) : (current_pos - normalized_distance);  
    
    assign next_pos = (temp_pos_signed < 0) ? 
                      (temp_pos_signed + 100) :
                      ((temp_pos_signed >= 100) ? 
                       (temp_pos_signed - 100) : 
                       temp_pos_signed[6:0]);
    
    wire is_zero = (next_pos == 7'b0000000);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_pos <= INITIAL_POS;  
            zero_count <= 16'b0;
        end else if (valid_rotation) begin
            current_pos <= next_pos;
            zero_count <= zero_count + (is_zero ? 16'b1 : 16'b0);
        end
    end

endmodule
