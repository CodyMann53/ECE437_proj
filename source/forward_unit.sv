`include "cpu_types_pkg.vh"
`include "forward_unit_if.vh"
`include "data_path_muxs_pkg.vh"

import cpu_types_pkg::*; 
import data_path_muxs_pkg::*; 
module forward_unit 
   (
     forward_unit_if.fu fuif
   );

// alu port a forwarding logic 
always_comb begin
   if ( (fuif.rs == fuif.reg_wr_mem) & (fuif.rs != 0) & (fuif.WEN_EX_MEM == 1)) 
   begin
      fuif.porta_sel = 2'b01;
   end
   else if( (fuif.rs == fuif.reg_wr_wb) & (fuif.rs != 0) & ( (fuif.WEN_MEM_WB == 1) | (fuif.opcode_EX_MEM == LW) ) )
   begin
      fuif.porta_sel = 2'b10;
   end
   else
   begin
      fuif.porta_sel = 2'b00;
   end
end

// alu port b forwarding logic 
always_comb begin
   if ((fuif.rt == fuif.reg_wr_mem) & (fuif.reg_dest_ID_EX != SEL_RT) & (fuif.opcode_ID_EX != SW) & (fuif.rt != 0) & (fuif.WEN_EX_MEM == 1)) // and rt is not thhe result location for ID/EX register
   begin
      fuif.portb_sel = 2'b01;
   end
   else if ((fuif.rt == fuif.reg_wr_wb) & (fuif.reg_dest_ID_EX != SEL_RT) & (fuif.opcode_ID_EX != SW) & (fuif.rt != 0) & (fuif.WEN_MEM_WB == 1)) // and rt is not the result location for ID/EX register 
   begin
      fuif.portb_sel = 2'b10;
   end
   else
   begin
      fuif.portb_sel = 2'b00;
   end
end

// mux 6 forwarding logic 
always_comb begin
   if ((fuif.rt == fuif.reg_wr_mem)  & (fuif.reg_dest_ID_EX != SEL_RT) & (fuif.rt != 0) & (fuif.WEN_EX_MEM == 1) ) // and rt is not thhe result location for ID/EX register
   begin
      fuif.mux6_sel = 2'b01;
   end
   else if ((fuif.rt == fuif.reg_wr_wb) & (fuif.reg_dest_ID_EX != SEL_RT) & (fuif.rt != 0) & ( (fuif.WEN_MEM_WB == 1) | (fuif.opcode_EX_MEM == LW) ) ) // and rt is not the result location for ID/EX register 
   begin
      fuif.mux6_sel = 2'b10;
   end
   else
   begin
      fuif.mux6_sel = 2'b00;
   end
end
endmodule
