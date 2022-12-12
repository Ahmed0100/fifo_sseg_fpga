module fifo_test
(
	input clk,reset_n,
	input rd,wr,
	output [3:0] sel,
	output [7:0] sseg
);

wire rd_db,wr_db;
wire [7:0] rd_data;
wire [3:0] bcd[3:0];

db_fsm db_fsm_inst
(
	.clk(clk),
	.reset_n(reset_n),
	.sw(!rd),
	.db(rd_db)
);

db_fsm db_fsm_inst_2
(
	.clk(clk),
	.reset_n(reset_n),
	.sw(~wr),
	.db(wr_db)
);

fifo fifo_inst
(
	.clk(clk), .reset_n(reset_n),
	.wr(wr_db),.rd(rd_db),
	.wr_data(8'd15), .rd_data(rd_data)
);

bin2bcd bin2bcd_inst
(
   .clk(clk), .reset_n(reset_n),
   .start(1),
   .bin({6'b0,rd_data}),
	.bcd3(bcd[3]), .bcd2(bcd[2]), 
	.bcd1(bcd[1]), .bcd0(bcd[0])
);

disp_hex_mux disp_unit
(.clk(clk), .reset_n(reset_n), .active(1), .mesg(0), .dp_in(4'b1111),
     .hex3(0), .hex2(0), .hex1(0), .hex0(rd_data),
     .an(sel), .sseg(sseg));

endmodule