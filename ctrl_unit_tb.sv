`timescale 1ns/1ps
module ctrl_unit_tb;
logic [7:0] req;
logic clk;
logic resetN;
logic up;
logic down;
logic open;
logic [3:0] floor;
logic [6:0] A;
//logic [3:0] floor, target_floor, current_floor;
//logic [25:0] timer;

localparam int COUNTER_FINAL=50;

ctrl_unit uut(
    .req(req),
    .clk(clk),
    .resetN(resetN),
    .up(up),
    .down(down),
    .open(open),
    .floor(floor)
);
ssd dut(
    .BCD(floor),
    .A(A)
);


localparam CLOCK_PERIOD = 20;

task DisplayHeader;
    $display("                       OUTPUTS           INPUTS             INTERNAL                       ");
    $display("                         up               down              open                          floor");
    $display("                 ==================  =============  =======================     =======================");
endtask

task AssertresetN;
    clk=1'b0;
    req=8'b00000000;
    resetN = 1'b0;                          // assert resetN
    repeat (4) @(negedge clk) ;
    #10;
    resetN = 1'b1;                          // de-assert resetN
endtask

initial begin
    clk = 0;
    #1000;
    forever #(CLOCK_PERIOD/2) clk = ~clk;
end

initial begin

    //#5
    $display("\nTest CTRL_UNIT resetN");
    $display("---------------------------------------------------------------------------");
    DisplayHeader;                       // call subroutine to print output header
    AssertresetN;

    #(CLOCK_PERIOD*COUNTER_FINAL);
    //req = 8'b01000010; //current floor 4 to 2
    req = 4'b0100; // current_floor=0, target_floor=4
    #(CLOCK_PERIOD*COUNTER_FINAL*10);

    req=4'b0010;  // from 4 go to 2nd floor
    #(CLOCK_PERIOD*COUNTER_FINAL*6);
    
    req=4'b0011 ;   //2nd to 3rd
    #(CLOCK_PERIOD*COUNTER_FINAL*4);


    req=4'b0011; //in 3rd floor
    #(CLOCK_PERIOD*COUNTER_FINAL*3);
    //req = 4'b0010;
//b00100100
//b00100011
    /*#10;
    req = 8'b00010010; // Move from floor 1 to floor 3
    #1000; // Wait for 2 seconds*/

    #20;

    $stop;
end

initial begin
    $monitor("Time: %0t | req: %b | target_floor: %d | current_floor: %d | current_state: %b | up: %b | down: %b | open: %b | SSD: %0b", uut.timer, req, uut.target_floor, uut.current_floor, uut.current_state, up, down, open, A);
end
endmodule