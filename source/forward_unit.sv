`include "cpu_types_pkg.vh"
`include "forward_unit_if.vh"

import cpu_types_pkg::*; 
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
   if(fuif.rt == fuif.reg_wr_mem)
   begin
      fuif.portb_sel = 2'b01;
   end
   else if(fuif.rt == fuif.reg_wr_wb)
   begin
      fuif.portb_sel = 2'b10;
   end
   else
   begin
      fuif.portb_sel = 2'b00;
   end
end
endmodule
