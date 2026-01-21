module aoc_2_gift_shop_tb;

    parameter CLK_PERIOD = 10;  // 100MHz
    parameter INPUT_FILE = "aoc2_ranges.txt";

    reg clk;
    reg rst_n;
    reg [63:0] id_value;
    reg valid_id;
    wire [63:0] accumulated_sum;
    wire is_invalid;

    integer file_handle;
    string line;
    integer scan_status;
    longint start_id, end_id;
    longint id_idx;
    integer range_count = 0;
    integer total_invalid_count = 0;

    aoc_2_gift_shop dut (
        .clk(clk),
        .rst_n(rst_n),
        .id_value(id_value),
        .valid_id(valid_id),
        .accumulated_sum(accumulated_sum),
        .is_invalid(is_invalid)
    );

    // Clock generation
    initial begin
        clk = 1'b0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Reset
    initial begin
        rst_n = 1'b0;
        valid_id = 1'b0;
        id_value = 64'b0;
        repeat(3) @(posedge clk);
        rst_n = 1'b1;
    end

    // Main stimulus: read ranges and check all IDs
    initial begin
        @(posedge rst_n);


        file_handle = $fopen(INPUT_FILE, "r");
        if (file_handle == 0) begin
            $display("ERROR: Could not open file '%s'", INPUT_FILE);
            $display("Expected format: start-end (one range per line)");
            $finish;
        end

        // Read ranges from file
        while ($fgets(line, file_handle) > 0) begin
            // Trim line
            line = line.substr(0, line.len() - 1);
            if (line.len() == 0) continue;

            // Parse: start-end
            scan_status = $sscanf(line, "%d-%d", start_id, end_id);
            if (scan_status == 2) begin
                range_count = range_count + 1;
                
                $display("Processing range %0d: %0d to %0d", range_count, start_id, end_id);

                // Check each ID in this range
                for (id_idx = start_id; id_idx <= end_id; id_idx = id_idx + 1) begin
                    id_value = id_idx[63:0];
                    
                    @(posedge clk);
                    valid_id = 1'b1;
                    
                    // Wait one cycle for combinational result
                    @(posedge clk);
                    
                    if (is_invalid) begin
                        total_invalid_count = total_invalid_count + 1;
                        if (total_invalid_count <= 20) begin
                            $display("  Found invalid ID: %0d", id_idx);
                        end
                    end
                    
                    valid_id = 1'b0;
                end
            end else begin
                if (line.len() > 0) begin
                    $display("Debug: Could not parse line: '%s'", line);
                end
            end
        end

        $fclose(file_handle);
        
        // Wait for final accumulation
        repeat(5) @(posedge clk);


        $display("Total ranges processed: %0d", range_count);
        $display("Total invalid IDs found: %0d", total_invalid_count);
        $display("SUM OF ALL INVALID IDs: %0d", accumulated_sum);

        $finish;
    end

endmodule
