`timescale 1ns / 1ps

module Receiver
#( parameter DBIT = 8,
    parameter SB_TICK = 16
    )
(
    input clk,
    input rst,
    input rx,
    input s_tick,
    output wire [7:0] dout,
    output reg rx_done_tick
    );
 
 parameter IDLE=2'b00;
 parameter START =2'b01;
 parameter DATA =2'b10;
 parameter STOP =2'b11;
 
 reg [3:0]s_reg ,s_next;//Tick count 0-15
 reg [2:0] n_reg ,n_next;// Bit count 0-7
 reg [7:0] b_reg ,b_next; //data  register 0-255
 reg [1:0] rx_reg ,rx_next;
 reg [1:0] current_state ,next_state;
 
 always@(posedge clk)
 begin
    if(rst==1'b1)
    begin
    current_state <=IDLE;
    s_reg <=0;
    n_reg <=0;
    b_reg <=0;
    end
    
    else
    begin
    current_state <= next_state;
    s_reg <= s_next;
    n_reg <= n_next;
    b_reg <= b_next;
    end
 end
 
 always@(*)
 begin
    next_state =current_state;
    s_next= s_reg;
    n_next= n_reg;
    b_next =b_reg; 
    rx_done_tick = 1'b0;
    case(current_state)
          IDLE:  
            if(rx==1'b0)
            begin
               next_state =START;
               s_next=0;   
            end
            
            else
               next_state = IDLE;
             
             
             
            START:  
            if(s_tick==1'b1)
              if(s_reg ==7)
              begin
                next_state =DATA;
                s_next =0;
                n_next =0;
              end
                       
        
                 
            DATA:  
            if(s_tick==1'b1)
            begin
              if(s_reg ==15)
                begin
                s_next=0;
                b_next={rx,b_reg[7:1]};
                  
                      if(n_reg == (DBIT -1))
                       begin
                       next_state =STOP;
                       end
                       
                      else
                      begin
                      n_next= n_reg+1;
                      end
                      
                 
                end
               else
               s_next=s_reg+1;
            end
            
            STOP:
            if(s_tick==1'b1)
            begin
                if(s_reg ==SB_TICK -1)
                    begin
                    rx_done_tick=1'b1;
                    next_state =IDLE;
                    end
                else
                   s_next =s_reg+1;
            end
            
            else
            next_state =STOP;
            
            default:
            next_state= IDLE;
      endcase
end
assign dout = b_reg; 
endmodule
