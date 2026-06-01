`timescale 1ns / 1ps

module baud_rate_generater (clk ,rx_enb,tx_enb);
input clk;
output rx_enb;
output tx_enb;

reg [12:0]tx_counter;
reg [10:0] rx_counter;

always@(posedge clk )
    begin
     if(tx_counter ==5208)
     begin
     tx_counter= 12'b000000000000;
     end
     
     else
     begin
     tx_counter=tx_counter+1;
     end
   end
   
 always@(posedge clk)   
   begin
     if(rx_counter ==325)
     begin
     tx_counter= 10'b0000000000;
     end
     
     else
     begin
     rx_counter=rx_counter+1;
     end
   end
    
   assign tx_enb =(tx_counter==0)?1'b1 :1'b0;
   assign rx_enb =(rx_counter==0)?1'b1 :1'b0;
   
endmodule
