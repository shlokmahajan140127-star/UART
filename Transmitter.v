`timescale 1ns / 1ps

module transmitor#(
    parameter DBIT = 8,
    parameter SB_TICK = 16
)(
    input clk, rst,
    input s_tick, tx_start,
    input [7:0] tx_din,
    output reg tx_done_tick,
    output wire tx
);

parameter IDLE=2'b00;
parameter START=2'b01;
parameter DATA=2'b10;
parameter STOP =2'b11;

reg[3:0] s_reg,s_next; //Tick count 0–15
reg [7:0]b_reg,b_next;//data  register 0-255
reg [2:0]n_reg,n_next;// Bit count 0–7
reg [1:0] current_state,next_state;
reg [1:0]tx_reg ,tx_next;

always@(posedge clk )
begin
    if(rst ==1'b1)
    begin
    current_state <= IDLE;
    s_reg <=0;
    b_reg <=0;
    n_reg <=0;
    tx_reg <=1'b1;
    end
    
    else
    begin
    current_state <= next_state;
    s_reg <= s_next;
    b_reg <= b_next;
    n_reg <= n_next;
    tx_reg <= tx_next;
    end
end
always@(*)
begin
next_state = current_state; 
tx_done_tick = 1'b0; 
s_next = s_reg; 
n_next = n_reg; 
b_next = b_reg; 
tx_next = tx_reg ;
 case(current_state)
       IDLE:
       begin
           tx_next=1'b1; 
           if(tx_start ==1'b1)
           next_state =START;
           s_next=1'b0;
           b_next=tx_din;
        end  
      
       START:
       begin
       tx_next=1'b0; 
           if(s_tick== 1'b1)
                 if( s_reg==15)
                     begin
                         next_state=DATA;
                         s_next=1'b0;
                         n_next=1'b0;
                     end
                 else
                    s_next =s_reg+1'b1;  
        end  
        
        DATA:
        begin
        tx_next =  b_reg[0];
            if(s_tick==1'b1)
               if(s_reg==15)
               begin
               s_next=1'b0;
               b_next =b_reg>>1;
               
                 if(n_reg==(DBIT-1))
                  next_state = STOP;
                  else
                  n_next=n_reg+1;
                  
               end
               
             else
                s_next=s_reg+1'b1;
          end
         
         STOP:
         begin
         tx_next= 1'b1;
             if(s_tick==1'b1)
               if(s_reg == SB_TICK-1)
                    begin
                    next_state = IDLE;
                    tx_done_tick=1'b1;
                    end
               else
                    s_next =s_reg+1'b1;
         end     
         default :
         next_state =IDLE;
       
  endcase

end
 assign tx = tx_reg;
endmodule
