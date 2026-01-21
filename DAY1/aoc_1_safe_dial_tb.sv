module aoc_1_safe_dial_tb;

    parameter CLK_PERIOD = 10;  
    parameter INPUT_FILE = "rotations.txt";
    
    reg clk;
    reg rst_n;
    reg [15:0] rotation_distance;   
    reg direction;  
    reg valid_rotation;
    wire [15:0] zero_count;
    wire [6:0] current_pos;
    
    integer file_handle;
    string line;
    integer rotation_count;
    integer distance_val;
    integer scan_status;
    byte dir_char;

    aoc_1_safe_dial dut (
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
        rst_n = 1'b0;
        valid_rotation = 1'b0;
        rotation_distance = 7'b0;
        direction = 1'b0;

        repeat(3) @(posedge clk);
        rst_n = 1'b1;
    end
    

    initial begin
      $dumpfile("dump.vcd"); $dumpvars;
        @(posedge rst_n);
        
        
        rotation_count = 0;
        
        file_handle = $fopen(INPUT_FILE, "r");
        
        if (file_handle == 0) begin
            
            $finish;
        end

        while ($fgets(line, file_handle) > 0) begin

            line = line.substr(0, line.len() - 1);  
            if (line.len() == 0) continue;
            scan_status = $sscanf(line, "%c%d", dir_char, distance_val);
            if (scan_status == 2 && distance_val >= 0) begin
                direction = (dir_char == "R") ? 1'b1 : 1'b0;
                rotation_distance = distance_val;  
                rotation_count = rotation_count + 1;
                @(posedge clk);
                valid_rotation = 1'b1;
                if (rotation_count <= 15) begin
                    $display("Rotation %5d: %c%2d | Position: %3d | Count: %d",
                        rotation_count,
                        (direction == 1) ? "R" : "L",
                        distance_val,
                        current_pos,
                        zero_count
                    );
                end 
                
                @(posedge clk);
                valid_rotation = 1'b0;
            end else begin
                if (line.len() > 0) begin
                    $display("Debug: Could not parse line: '%s'", line);
                end
            end
        end
        
        $fclose(file_handle);
        
        repeat(5) @(posedge clk);
        

        $display("Total rotations processed: %d", rotation_count);
        $display("Final dial position: %d", current_pos);
        $display("PASSWORD (Zero Count): %d", zero_count);

        $finish;
    end

endmodule
