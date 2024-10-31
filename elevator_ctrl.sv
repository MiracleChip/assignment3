`include "defines.sv"

module elevator_ctrl(

    input logic clk,
    input logic rst,
    input logic [`NUM_FLOORS-1:0] upreq,
    input logic [`NUM_FLOORS-1:0] downreq,
    //input logic up_button,
    //input logic down_button,
    //input logic open_req,
    output logic open_move,
    output logic down_move,
    output logic up_move,
    output logic [`FLOOR_BITS-1:0] floor,
    output logic [6:0] A

);

logic [`FLOOR_BITS-1:0] req;

reqres request_resolver (
    .clk(clk),
    .rst(rst),
    .upreq(upreq),
    .downreq(downreq),
    .up(up_move),
    .down(down_move),
    .open(up_move),
    .req(req)

);

ctrl_unit CU ( 
    .req(req),
    .clk(clk),
    .resetN(rst),
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