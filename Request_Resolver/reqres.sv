`include "defines.sv"

module reqres 
(
    input wire clk,
    input wire rst,

    input wire [`NUM_FLOORS-1:0] upreq,
    input wire [`NUM_FLOORS-1:0] downreq,
    input wire up,
    input wire down,
    input wire open,
    output reg [`FLOOR_BITS-1:0] req
);

    reg [`FLOOR_BITS-1:0] curr;
    reg [`FLOOR_BITS-1:0] uptarget;
    reg [`FLOOR_BITS-1:0] downtarget;
    reg [31:0] timer;
    integer i;

    localparam int COUNTER_FINAL=50;

    always @(*) 
    begin
        uptarget = `NUM_FLOORS;
        downtarget = `NUM_FLOORS;
        
        // Find highest up request
        for (i = `NUM_FLOORS-1; i >= 0; i = i - 1) 
        begin
            if (upreq[i]) 
            begin
                uptarget = i;
            end
        end
        
        // Find lowest down request
        for (i = 0; i <= `NUM_FLOORS-1; i = i + 1) 
        begin
            if (downreq[i]) 
            begin
                downtarget = i;
            end
        end
        
        // Generate request output
        if (down && downtarget != `NUM_FLOORS) 
        begin
            req = {curr, downtarget};
        end 
        else if (up && uptarget != `NUM_FLOORS) 
        begin
            req = {curr, uptarget};
        end 
        else 
        begin
            if (uptarget < `NUM_FLOORS)
            begin
                req = {curr, uptarget};
            end 
            else if (downtarget < `NUM_FLOORS) 
            begin
                req = {curr, downtarget};
            end 
            else 
            begin
                req = {curr, curr};
            end
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            curr <= 'd0;
            timer <= 'd0;
        end else begin
            timer <= timer + 1;
            if (timer == COUNTER_FINAL - 1) 
            begin
                if (up) begin
                    curr <= curr + 1;
                    timer <= 0;
                end else if (down) begin
                    curr <= curr - 1;
                    timer <= 0;
                end
            end else if (open) 
            begin
                timer <= 0;
            end
        end
    end
endmodule
