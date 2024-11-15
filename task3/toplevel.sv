//toplevel.sv
module toplevel #(
    parameter   D_WIDTH = 8
)(
    //interface signals
    input   logic               clk,    //clock
    input   logic               rst,    //reset
    input   logic               en,     //enable
    input   logic [15:0]        N,   //increment for addr counter
    output  logic [D_WIDTH-1:0] dout    //output data
);

    logic   tick;   //interconnect wire

clktick clockTick(
    .clk (clk),
    .rst (rst),
    .en (en),
    .N (N),
    .tick (tick)
);

f1_fsm f1Fsm(
    .clk (clk),
    .rst (rst),
    .en (tick),
    .data_out (dout)
);

endmodule
