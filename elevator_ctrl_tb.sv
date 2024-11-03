module elevator_ctrl_tb();

parameter  NUM_FLOORS = 10 ;                   // Number of floors
parameter  FLOOR_BITS = $clog2(NUM_FLOORS);


logic clk;
logic resetN;
logic [NUM_FLOORS-1:0] upreq;
logic [NUM_FLOORS-1:0] downreq;
logic [6:0] A;

localparam CLOCK_PERIOD = 20;
localparam int COUNTER_FINAL=50;

elevator_ctrl ctrl(
    .clk(clk),
    .resetN(resetN),
    .upreq(upreq),
    .downreq(downreq),
    .A(A)
);


task DisplayHeader;
    $display("                       OUTPUTS           INPUTS             INTERNAL                       ");
    $display("                         up               down              open                          floor");
    $display("                 ==================  =============  =======================     =======================");
endtask

initial begin
    clk = 0;
    forever #(CLOCK_PERIOD/2) clk = ~clk; // 20ns period, 50MHz clock
end


initial begin
    $display("\n |||||| T O P ||||||");
    $display("---------------------------------------------------------------------------");
    DisplayHeader;                       // call subroutine to print output header
    // AssertresetN;

    clk = 0;
    resetN = 0;
    upreq = 'b0;
    downreq ='b0;

    // Reset sequence
    #5 resetN = 1;
    #50 resetN = 0; // Assert reset for a short duration
    #50 resetN = 1;

    #(CLOCK_PERIOD*COUNTER_FINAL*4);
    // Test case 1: Set an upward request at floor 3, and move up
    upreq[1] = 1; // Request to go up from floor 3
    //up_button = 1; // Elevator starts moving up
    #(CLOCK_PERIOD*COUNTER_FINAL*8);
    upreq[4] = 1;
     // Wait some time
    //up_button = 0;
    

    ///#(CLOCK_PERIOD*COUNTER_FINAL*8);  
    //upreq[3] = 0; 
    //upreq[4] = 0;
    #100;

    $stop; 

end

endmodule