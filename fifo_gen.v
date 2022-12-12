module fifo_gen
#(parameter D_WIDTH=8, T=20)
(
	output reg clk,reset_n,
	output reg rd,wr,
	output reg [D_WIDTH-1:0] wr_data
);

always
begin
	clk = 1;
	#(T/2);
	clk = 0;
	#(T/2);
end

initial 
begin
	initialize();
	push(4);
	push(3);
	push(2);
	push(1);
	push(0);
	repeat(4)
	begin
		pop();
	end
	pop();
	push(7);
	push_n_pop(3);
	pop();
	$stop;
end

task initialize;
begin
	rd=0;
	wr=0;
	wr_data=0;
	reset();
end
endtask

task push(input [D_WIDTH-1:0] data_in);
begin
	@(negedge clk);
	wr = 1;
	wr_data = data_in;
	@(negedge clk);
	wr = 0;
end
endtask

task pop;
begin
	@(negedge clk);
	rd=1;
	@(negedge clk);
	rd=0;
end
endtask

task push_n_pop(input [D_WIDTH-1:0] data_in);
begin
	@(negedge clk);
	rd=1;
	wr=1;
	wr_data = data_in;
	@(negedge clk);
	rd=0;
	wr=0;
end
endtask
task reset;
begin
	@(negedge clk);
	reset_n=0;
	#(T/4);
	reset_n=1;
end
endtask
endmodule