module aoc_1_safe_dial_p2_tb;

    parameter CLK_PERIOD = 10;  
    parameter INPUT_FILE = "rotations.txt";

    reg clk;
    reg rst_n;
    reg [15:0] rotation_distance;
    reg direction;        // 0=L, 1=R
    reg valid_rotation;
    wire [15:0] zero_count;
    wire [6:0]  current_pos;

    integer file_handle;
    string line;
    integer rotation_count;
    integer distance_val;
    integer scan_status;
    byte dir_char;

    aoc_1_safe_dial_p2 dut (
        .clk(clk),
        .rst_n(rst_n),
        .rotation_distance(rotation_distance),
        .direction(direction),
        .valid_rotation(valid_rotation),
        .zero_count(zero_count),
        .current_pos(current_pos)
    );


    initial begin
        clk = 1'b0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    initial begin
      $dumpfile("dump.vcd"); $dumpvars;
        rst_n = 1'b0;
        valid_rotation = 1'b0;
        rotation_distance = 16'd0;
        direction = 1'b0;
        repeat(3) @(posedge clk);
        rst_n = 1'b1;
    end

    initial begin
        @(posedge rst_n);

        rotation_count = 0;
        file_handle = $fopen(INPUT_FILE, "r");


        while ($fgets(line, file_handle) > 0) begin
            line = line.substr(0, line.len() - 1);
            if (line.len() == 0) continue;

            scan_status = $sscanf(line, "%c%d", dir_char, distance_val);
            if (scan_status == 2 && distance_val >= 0) begin
                direction = (dir_char == "R") ? 1'b1 : 1'b0;
                rotation_distance = distance_val[15:0];
                rotation_count = rotation_count + 1;

                @(posedge clk);
                valid_rotation = 1'b1;
                @(posedge clk);
                valid_rotation = 1'b0;

                if (rotation_count <= 15) begin
                    $display("Rot %5d: %s%0d  -> pos=%3d  count=%0d",
                             rotation_count,
                             (direction?"R":"L"), distance_val,
                             current_pos, zero_count);
                end else if (rotation_count == 16) begin
                    $display("  ... processing ...");
                end
            end else begin
                if (line.len() > 0) begin
                    $display("Debug: Could not parse line: '%s'", line);
                end
            end
        end

        $fclose(file_handle);
        repeat(5) @(posedge clk);


        $display("Total rotations processed: %0d", rotation_count);
        $display("Final dial position: %0d", current_pos);
        $display("PASSWORD (Zero Count): %0d", zero_count);


        $finish;
    end

endmodule
