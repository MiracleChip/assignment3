`include "defines.sv"

module tb_reqres;
    //localparam int NUM_FLOORS = 10,               // Number of floors
    //localparam int FLOOR_BITS = $clog2(NUM_FLOORS) // bits to represent the number of floors

    // Testbench signals
    reg clk;
    reg rst;
    reg [`NUM_FLOORS-1:0] upreq;
    reg [`NUM_FLOORS-1:0] downreq;
    reg up;
    reg down;
    reg open;
    wire [`FLOOR_BITS-1:0] req;


    // Instantiate the reqres module
    reqres uut
    (
        .clk(clk),
        .rst(rst),
        .upreq(upreq),
        .downreq(downreq),
        .up(up),
        .down(down),
        .open(open),
        .req(req)
    );

    // Clock generation
    always #10 clk = ~clk; // 20ns period, 50MHz clock

    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        upreq = 'b0;
        downreq ='b0;
        up = 0;
        down = 0;
        open = 0;
        
        // Reset sequence
        #5 rst = 1;
        #50 rst = 0; // Assert reset for a short duration
        #50 rst = 1;
        
        // Test case 1: Set an upward request at floor 3, and move up
        #50 upreq[3] = 1; // Request to go up from floor 3
        up = 1; // Elevator starts moving up
        #1000; // Wait some time
        up = 0;
        upreq[3] = 0;
        
        // Test case 2: Set a downward request at floor 7, move down
        #50 downreq[7] = 1; // Request to go down from floor 7
        down = 1; // Elevator starts moving down
        #1000; // Wait some time
        down = 0;
        downreq[7] = 0;

        // Test case 3: Open door while idle
        #50 open = 1; // Open doors while idle
        #50 open = 0;

        // Test case 4: Set both up and down requests
        #50 upreq[5] = 1; // Request to go up from floor 5
        downreq[2] = 1; // Request to go down from floor 2
        up = 1; // Move up first
        #1000;
        up = 0;
        down = 1; // Move down after reaching target
        #1000;
        down = 0;
        upreq[5] = 0;
        downreq[2] = 0;
        
        // Test case 5: Reset during operation
        #50 upreq[6] = 1;
        up = 1;
        #100 rst = 0; // Assert reset in the middle of movement
        #50 rst = 1;
        
        // End simulation after running all tests
        #2000;
        $stop;
    end

    // Self-checking block
    always @(posedge clk) begin
        if (upreq[3] && up && req != {'d0, 'd3}) begin
            $display("Test failed: Incorrect request for upward direction at time %t", $time);
        end else if (downreq[7] && down && req != {'d0, 'd7}) begin
            $display("Test failed: Incorrect request for downward direction at time %t", $time);
        end else if (open && req != {'d0, 'd0}) begin
            $display("Test failed: Incorrect request when door is open at time %t", $time);
        end else begin
            $display("Test passed at time %t %0b", $time, req);
        end
    end

endmodule
