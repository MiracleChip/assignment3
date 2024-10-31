`include "defines.sv"
module elevator_ctrl_tb();

logic clk;
logic rst;
logic [`NUM_FLOORS-1:0] upreq;
logic [`NUM_FLOORS-1:0] downreq;
logic open_move;
logic down_move;
logic up_move;
logic [`FLOOR_BITS-1:0] floor;
logic [6:0] A;

localparam CLOCK_PERIOD = 20;
localparam int COUNTER_FINAL=50;


task DisplayHeader;
    $display("                       OUTPUTS           INPUTS             INTERNAL                       ");
    $display("                         up               down              open                          floor");
    $display("                 ==================  =============  =======================     =======================");
endtask

initial begin
    clk = 0;
    #1000;
    forever #(CLOCK_PERIOD/2) clk = ~clk; // 20ns period, 50MHz clock
end

initial begin
    $display("\n |||||| T O P ||||||");
    $display("---------------------------------------------------------------------------");
    DisplayHeader;                       // call subroutine to print output header
    // AssertresetN;

    clk = 0;
    rst = 0;
    upreq = 'b0;
    downreq ='b0;

    // Reset sequence
    #5 rst = 1;
    #50 rst = 0; // Assert reset for a short duration
    #50 rst = 1;

    #(CLOCK_PERIOD*COUNTER_FINAL);
    // Test case 1: Set an upward request at floor 3, and move up
    upreq[3] = 1; // Request to go up from floor 3
    //up_button = 1; // Elevator starts moving up
    #(CLOCK_PERIOD*COUNTER_FINAL*8); // Wait some time
    //up_button = 0;
    upreq[3] = 0;

    #(CLOCK_PERIOD*COUNTER_FINAL);    

end

endmodule