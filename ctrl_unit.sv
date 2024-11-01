module ctrl_unit # (
    parameter int NUM_FLOORS = 16,               // Number of floors
    parameter int FLOOR_BITS = $clog2(NUM_FLOORS) // bits to represent the number of floors
)    
    (

    input logic [FLOOR_BITS-1:0] req,
    input logic clk,
    input logic resetN,
    output logic up, 
    output logic down, 
    output logic open, //open 1 if not open 0
    //output logic closed,
    output logic [FLOOR_BITS-1:0] floor // ssd output -- the reached floor 
);

//add instatiation of request_resolver (omar's part)


//timeunit 1ns/1ns;
localparam int NUM_FLOOR=10;
localparam int COUNTER_FINAL=50;

logic [31:0] counter;
logic [1:0] timer;
logic en, open_move, flag;

//define states -- 
typedef enum logic [1:0]{
    close_state =2'b00, //idle state
    open_state =2'b01,
    up_state =2'b11,
    down_state = 2'b10
} state;

state current_state, next_state;

logic [3:0] current_floor, target_floor;
//logic req_ack;

//will extract from req
//assign opcode =req[9:8];
assign target_floor = req[3:0];

//logic flag;

/// Current State Logic -- sequential logic
//state register  -- asynch reset has to be close
always_ff @(posedge clk or negedge resetN) begin
    if (!resetN) begin
        current_state <= close_state;
        
    end
    else begin
        current_state <= next_state;
        if(current_state == close_state && current_floor == target_floor) begin
            //req_ack <=1;
        end
       // else if (next_state == open_state) begin
            
       // end
        //flag<=0;
    end
end

////////////////// CURRENT FLOOR UPDATE ////////////////////////////
always @(posedge clk or negedge resetN) begin
    if (!resetN) begin
        current_floor <= 0;
        //flag<=1'b0;
        //flag<=1'b1;
        //d_stopped <=0;
        //req_ack<=0;
    end
    else begin
            // else begin
            //     current_floor<=target_floor;
            // end

            if(current_state==up_state && current_floor < target_floor && timer == 1 && counter == COUNTER_FINAL - 1) begin
                current_floor <=current_floor+1;
            end
            else if (current_state == down_state && current_floor > target_floor && timer == 1 && counter == COUNTER_FINAL - 1) begin
                current_floor <= current_floor-1;
            end
            else if(current_state==open_state && current_floor == target_floor && timer == 1 && counter == COUNTER_FINAL - 1) begin
                //flag<=0;
                current_floor<=target_floor;
                //req_ack<=1;
                //flag<=1;
                //d_stopped<=current_floor;
            end
    end
end

//logic val;

// Next State logic -- combinational logic
always_comb begin
    // Default assignments
    next_state = current_state; // Default to stay in current state
    //req_ack=1; //initialize
    case (current_state)
        close_state: begin // close
            if ((current_floor)  < target_floor) begin
                next_state = up_state;
                open_move=0;
                flag=0;
                //req_ack=1;
                //val=1;
            end 
            else if ((current_floor)  > target_floor) begin
                next_state = down_state;
                open_move=0;
                flag=0;
                //req_ack=1;
            end 
            else if ((current_floor == floor && flag==1)) begin
                next_state = open_state;
                flag=0;
            end 
        end

        open_state: begin // open 
        if(timer == 1 && counter == COUNTER_FINAL - 1) begin

               // if((current_floor)  == target_floor) begin
                    next_state=close_state;
                    open_move=0;
                    //flag=0;
                    //req_ack =0;
                    //val=req_ack;
                //req_ack=1; //it has closed
            //send
        end
        end

        up_state: begin
            //if(timer == 1 && counter == COUNTER_FINAL - 1) begin
                if ((current_floor) == target_floor) begin
                    next_state = open_state;
                    open_move=1;
                    flag=1;
                    //req_ack =1;
                end
        end

        down_state: begin
           //if(timer==2) begin
                if ((current_floor)  == target_floor) begin
                    next_state = open_state;
                    open_move=1;
                    flag=1;
                    //req_ack =1;
                end
        end

        default:  begin
            next_state = close_state;
            open_move=0;
            flag=0;
            //req_ack=0;
        end
    endcase
end


//FSM'S OUTPUT MOORE's output archiecture
always_comb begin
    case (current_state)
    close_state: {up, down, open}=3'b000; //close
    open_state: {up, down, open}=3'b001; //open
    down_state: {up, down, open}=3'b010; //down
    up_state: {up, down, open}=3'b100; //up
    endcase
end

assign floor=current_floor;


//////////////////////////////////////////////////////////
/// COUNTER for FLOORS/////////
/*always_ff @(posedge clk) begin
    if(current_state==down_state && current_floor > 0) begin
        current_floor =current_floor-1; //move down to next floor
    end
    else if(current_state==down_state) begin
        current_floor =current_floor+1; //move up to next floor
    end
end*/

//////////////////////////////////////////////////////////
/// COUNTER for TIMERS /////////
always_ff @(posedge clk or negedge resetN) begin
    if(!resetN) begin
        counter<=0;
        en<=0;
        timer<=0;
    end
    else begin
        if(((current_state==up_state &&  next_state == up_state )|| (current_state==down_state && current_state==next_state)|| current_state==open_state)) begin
        
            if (counter<COUNTER_FINAL - 1)begin
                counter<=counter+1;
                en<=0;
            end
            else if (counter == COUNTER_FINAL - 1) begin
                en<=1;
                counter<=0;
				timer<=timer+1;
                // timer=timer+1;
                // count=0;
            end
            //if(en==1) begin
                //timer<=timer+1;
                //count<=0;
              //  en<=0;
            //end
            if (timer == 1 && counter == COUNTER_FINAL - 1) begin
                timer<=0;
                //en=0;
                //count=0;
            end
		end	
    end
end

endmodule