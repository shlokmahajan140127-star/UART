`include "transmitter.v"
`include "Receiver.v"
`include "baud_rate_generater.v"

module top_module#(
    parameter DBIT    = 8,
    parameter SB_TICK = 16
)(clk,rst,tx_s_tick, tx_start, tx_din ,tx_done_tick,tx, rx_s_tick, rx , dout,rx_done_tick);
input clk;
input rst;
//tarnsmitter
input tx_s_tick;
input wire tx_start;
input wire [7:0] tx_din;
output tx_done_tick;
output tx;

//receiver
input rx_s_tick;
input wire rx;
output [7:0] dout;
output rx_done_tick;

//baud_rate_generater
//not the s-tick in the transmitter and receiver is replaced by s_tick in tx is tx_enb and s_tick in Rx is rx_enb
wire rx_enb;
wire tx_enb;

    transmitor tx_inst(.clk(clk),
                .rst(rst),
                .tx_s_tick(tx_enb),
                .tx_start(tx_start),
                .tx_din(tx_din),
                .tx_done_tick(tx_done_tick),
                .tx(tx)
                );

    Receiver Rx_inst (.clk(clk),
                .rst(rst),
                .rx(rx),
                .rx_s_tick(rx_enb),
                .dout(dout),
                .rx_done_tick(rx_done_tick)
                );

    baud_rate_generater brg(.clk(clk),
                            .rx_enb(rx_enb),
                            .tx_enb(tx_enb)
                            );
                            
endmodule
