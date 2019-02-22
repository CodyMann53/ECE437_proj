`include "cpu_types_pkg.vh"
`include "forward_unit_if.vh"
`include "data_path_muxs_pkg.vh"

import cpu_types_pkg::*; 
import data_path_muxs_pkg::*; 
module forward_unit 
   (
     forward_unit_if.fu fuif
   );


always_comb
begin
   if(fuif.rs == fuif.reg_wr_mem) 
   begin
      fuif.porta_sel = 2'b01;
   end
   else if(fuif.rs == fuif.reg_wr_wb)
   begin
      fuif.porta_sel = 2'b10;
   end
   else
   begin
      fuif.porta_sel = 2'b00;
   end
end

always_comb
begin
<<<<<<< HEAD
   if ((fuif.rt == fuif.reg_wr_mem) & (fuif.reg_dest_ID_EX != SEL_RT) ) // and rt is not thhe result location for ID/EX register
=======
   if ((fuif.rt == fuif.reg_wr_mem) & (fuif.reg_dest_ID_EX != SEL_RT) & (fuif.opcode_ID_EX != SW) // and rt is not thhe result location for ID/EX register
>>>>>>> 759729b691775e905f2f7ab8d804be64196ba2fe
   begin
      fuif.portb_sel = 2'b01;
   end
   else if ((fuif.rt == fuif.reg_wr_wb) & (fuif.reg_dest_ID_EX != SEL_RT)) // and rt is not the result location for ID/EX register 
   begin
      fuif.portb_sel = 2'b10;
   end
   else
   begin
      fuif.portb_sel = 2'b00;
   end
end
endmodule
