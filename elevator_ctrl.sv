module elevator_ctrl #(

parameter  NUM_FLOORS = 10 ,                  // Number of floors
parameter  FLOOR_BITS = $clog2(NUM_FLOORS)
)(
   

    input logic clk,
    input logic resetN,
    input logic [NUM_FLOORS-1:0] upreq,
    input logic [NUM_FLOORS-1:0] downreq,
    output logic [6:0] A

);
logic [FLOOR_BITS-1:0] floor;
logic [FLOOR_BITS-1:0] req;
logic open_move;
logic down_move;
logic up_move;

reqres request_resolver (
    .clk(clk),
    .resetN(resetN),
    .upreq(upreq),
    .downreq(downreq),
    .up(up_move),
    .down(down_move),
    .open(open_move),
    .req(req)

);

ctrl_unit CU ( 
    .req(req),
    .clk(clk),
    .resetN(resetN),
    .up(up_move),
    .down(down_move),
    .open(open_move),
    .floor(floor)
);



ssd dut(
    .BCD(floor),
    .A(A)
);





endmodule