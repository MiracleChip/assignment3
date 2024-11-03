
module reqres  #(

parameter  NUM_FLOORS =  10,                  // Number of floors
parameter  FLOOR_BITS = $clog2(NUM_FLOORS)
)
(
    input logic clk,
    input logic resetN,

    input logic [NUM_FLOORS-1:0] upreq,
    input logic [NUM_FLOORS-1:0] downreq,
    input logic up,
    input logic down,
    input logic open,
    output logic [FLOOR_BITS-1:0] req
);

logic [FLOOR_BITS-1:0] initial_floor;
// logic [FLOOR_BITS-1:0] current;
integer i;

logic flag;

typedef enum logic[1:0] { 
    IDLE_state=2'b00,
    MOVEUP_state=2'b10,
    MOVEDOWN_state=2'b01
    // WAIT_state=2'b11
 } state;

state current_state, next_state;

logic [FLOOR_BITS-1:0] next_req;
logic newreq;

// logic [NUM_FLOORS-1:0] upreq_wire;
// logic [NUM_FLOORS-1:0] downreq_wire;

always_ff@(posedge clk or resetN) begin
    if(!resetN) begin
        current_state<=IDLE_state;
        req<=0;
        // upreq_wire<=0;
        // downreq_wire<=0;
    end
    else begin
        current_state<=next_state;
        // downreq_wire<=downreq;
        //if(current_state==MOVEUP_state ||current_state==MOVEDOWN_state) begin
           req<=next_req; 
        //end
    end
end
    
always_comb begin
    next_state=current_state;
    flag=0;
    initial_floor=0;
    next_req=initial_floor;
    i=0;
    newreq=0;
    if(newreq==1 || newreq==0) begin
        case(current_state) 
            IDLE_state: begin
                if(initial_floor==0) begin
                    next_state=MOVEUP_state;
                end 
            end

            MOVEUP_state: begin
                for(i=0; i<NUM_FLOORS; i++) begin
                    if(upreq[i]==1) begin
                        next_req=i;
                        next_state=MOVEUP_state;
                        // flag=1;
                    end
                    if(i==NUM_FLOORS-1 && upreq[i]==0) begin
                            next_state=MOVEDOWN_state;
                    end
                    else begin 
                            next_state=MOVEUP_state;
                    end
                    end
                end

            MOVEDOWN_state: begin
                for(i=NUM_FLOORS; i>=0; i--) begin
                    if(downreq[i]==1) begin
                        next_req=i;
                        next_state=MOVEDOWN_state;
                        // flag=1;
                    end

                    if(i==0 && downreq[i]==0) begin
                        next_state=IDLE_state;
                        newreq=1;
                    end
                    end
                end

        endcase
    end

end



    
    
endmodule