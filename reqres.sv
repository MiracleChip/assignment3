
module reqres  #(

parameter  NUM_FLOORS = 10 ,                  // Number of floors
parameter  FLOOR_BITS = $clog2(NUM_FLOORS)
)
(
    input wire clk,
    input wire rst,

    input wire [NUM_FLOORS-1:0] upreq,
    input wire [NUM_FLOORS-1:0] downreq,
    input wire up,
    input wire down,
    input wire open,
    output reg [FLOOR_BITS-1:0] req
);

    reg [FLOOR_BITS-1:0] curr;
    reg [FLOOR_BITS-1:0] uptarget;
    reg [FLOOR_BITS-1:0] downtarget;
    reg [31:0] timer;
    integer i;
    parameter DEBOUNCE_CYCLES = 5;

    //reg [NUM_FLOORS-1:0] served_mask;

    localparam int COUNTER_FINAL=50;
    // reg [NUM_FLOORS-1:0] upreq_internal; 
    // reg [NUM_FLOORS-1:0] downreq_internal; 

    // reg [NUM_FLOORS-1:0] prev_upreq; 
    // reg [NUM_FLOORS-1:0] prev_downreq; 

    // reg [NUM_FLOORS-1:0] upreq_internal_debounced;
    // reg [NUM_FLOORS-1:0] downreq_internal_debounced;
    // reg [FLOOR_BITS-1:0] upreq_internal_debounced_counter;
    // reg [FLOOR_BITS-1:0] downreq_internal_debounced_counter;

    //wire [NUM_FLOORS-1:0] served_mask = ~(1 << curr);

    // wire [NUM_FLOORS-1:0] upreq_masked = upreq & ~served_mask;
    // wire [NUM_FLOORS-1:0] downreq_masked = downreq & ~served_mask;
/*always @(posedge clk or negedge rst) begin
    if(!rst) begin
        prev_upreq<=0;
        prev_downreq<=0;
    end
    else begin 
        upreq_internal <= upreq ^ prev_upreq;
        downreq_internal <= downreq ^ prev_downreq;
        prev_upreq <= upreq;
        prev_downreq <= downreq;
    end
end*/
    always @(*) 
    begin
        uptarget = NUM_FLOORS;
        downtarget = NUM_FLOORS;
        // upreq_internal <= upreq ^ prev_upreq;
        // downreq_internal <= downreq ^ prev_downreq;
        
        // Find highest up request
        for (i = NUM_FLOORS-1; i >= 0; i = i - 1) 
        begin
            if (upreq[i]&&i) 
            begin
                uptarget = i;
            end
        end
        
        // Find lowest down request
        for (i = 0; i <= NUM_FLOORS-1; i = i + 1) 
        begin
            if (downreq[i] &&i) 
            begin
                downtarget = i;
            end
        end
        
        // Generate request output
        if (down && downtarget != NUM_FLOORS) 
        begin
            req = downtarget;
            //served_mask = (1 << downtarget);
        end 
        else if (up && uptarget != NUM_FLOORS) 
        begin
            req = uptarget;
            //served_mask = (1 << uptarget);
        end 
        else 
        begin
            if (uptarget < NUM_FLOORS)
            begin
                req = uptarget;
            end 
            else if (downtarget < NUM_FLOORS) 
            begin
                req = downtarget;
            end 
            else 
            begin
                req = curr;
            end
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            curr <= 'd0;
            timer <= 'd0;
            // prev_upreq<=0;
            // prev_downreq<=0;
            // upreq_internal_debounced <= 0;
            // downreq_internal_debounced <= 0;
            // upreq_internal_debounced_counter <= 0;
            // downreq_internal_debounced_counter <= 0;
            // upreq_internal <= upreq;      
            // downreq_internal <= downreq;
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
                // upreq_internal <= upreq_internal & served_mask;
                // downreq_internal <= downreq_internal & served_mask;
            end else if (open) 
            begin
                timer <= 0;
            end
            // prev_upreq <= upreq;
            // prev_downreq <= downreq;

            // if (upreq_internal !== upreq_internal_debounced) begin
            //     upreq_internal_debounced_counter <= 0;
            // end else if (upreq_internal_debounced_counter < DEBOUNCE_CYCLES - 1) begin
            //     upreq_internal_debounced_counter <= upreq_internal_debounced_counter + 1;
            // end else begin
            //     upreq_internal_debounced <= upreq_internal;
            // end
        end
    end
endmodule