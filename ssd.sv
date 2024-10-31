module ssd (
    input logic [3:0] BCD,  
    output logic [6:0] A
);

    always @(*)
	 begin
        case (BCD)
            4'b0000: A = 7'b1000000;
            4'b0001: A = 7'b1111001;
            4'b0010: A = 7'b0100100;
            4'b0011: A = 7'b0110000;
            4'b0100: A = 7'b0011001;
            4'b0101: A = 7'b0010010;
            4'b0110: A = 7'b0000010;
            4'b0111: A = 7'b1111000;
            4'b1000: A = 7'b1111111;
            4'b1001: A = 7'b0010000;
            default: A = 7'b0000000;
        endcase
    end

endmodule
