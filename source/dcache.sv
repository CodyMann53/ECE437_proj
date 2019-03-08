`include "datapath_cache_if.vh"
`include "caches_if.vh"
`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

module dcache (
   input logic CLK, nRST,
   datapath_cache_if.dcache dcif, 
   caches_if.dcache cif
);

typedef struct packed {
   logic [24:0] left_tag, right_tag;
   word_t left_dat0, right_dat0;
   word_t left_dat1, right_dat1;
   logic left_dirty, right_dirty;
   logic left_valid, right_valid;
} dcache_block_t;

typedef enum logic[3:0] {
   IDLE = 4'd0;
   WB1 = 4'd1;
   WB2 = 4'd2;
   READ1 = 4'd3;
   READ2 = 4'd4;
   HALT = 4'd5;
   FLUSH1 = 4'd6;
   FLUSH2 = 4'd7;
   DIRTY = 4'd8;
   COUNT = 4'd9;
} state_t;

logic [25:0] tag;
assign tag = dcif.dmemaddr[31:6];

logic [2:0] cache_index;
assign cache_index = dcif.dmemaddr[5:3];

logic [2:0] data_index;
assign data_index = dcif.dmemaddr[2:0];

logic hit;
logic[7:0] last_used, next_last_used;
word_t hit_count, next_hit_count;

integer i;

dcache_block_t dbl[7:0];

logic[25:0] next_left_tag, next_right_tag;
word_t next_left_dat0, next_left_dat1, next_right_dat0, next_right_dat1;
logic next_left_dirty, next_left_valid, next_right_dirty, next_right_valid;

state_t state, next_state;

logic[3:0] cache_row, next_cache_row, old_cache_row, next_old_cache_row;

always_ff @(posedge CLK or negedge nRST)
begin
   if(nRST == 0)
   begin
      for(i = 0; i < 8; i++)
      begin
         dbl[i].left_tag <= 0;
         dbl[i].right_tag <= 0;
         dbl[i].left_dat0 <= 0;
         dbl[i].right_dat0 <= 0;
         dbl[i].left_dat1 <= 0;
         dbl[i].right_dat1 <= 0;
         dbl[i].left_dirty <= 0;
         dbl[i].right_dirty <= 0;
         dbl[i].left_valid <= 0;
         dbl[i].right_valid <= 0;
      end
   else
   begin
      dbl[cache_index].left_tag <= next_left_tag;
      dbl[cache_index].right_tag <= next_right_tag;      
      dbl[cache_index].left_dat0 <= next_left_dat0;
      dbl[cache_index].right_dat0 <= next_right_dat0;
      dbl[cache_index].left_dat1 <= next_left_dat1;
      dbl[cache_index].right_dat1 <= next_right_dat1;
      dbl[cache_index].left_dirty <= next_left_dirty;
      dbl[cache_index].right_dirty <= next_right_dirty;
      dbl[cache_index].left_valid <= next_left_valid;
      dbl[cache_index].right_valid <= next_right_valid;
   end
end

always_ff @(posedge CLK or negedge nRST)
begin
   if(nRST == 0)
   begin
      for(i = 0; i < 8; i++)
      begin
         last_used[i] <= 0;
      end
      state <= IDLE;
      hit_count <= 0;
      cache_row <= 0;
      old_cache_row <= 0;
   end
   else
   begin
      for(i = 0; i < 8; i++)
      begin
         last_used[i] <= next_last_used;
      end
      state <= next_state;
      hit_count <= next_hit_count;
      cache_row <= next_cache_row;
      old_cache_row <= next_old_cache_row;
   end
end

always_comb
begin
   next_state = state;
   casez(state)
      IDLE :
      begin
         if(dcif.halt == 1)
         begin
            next_state = DIRTY;
         end
         else if(hit == 0)
         begin
            if(last_used[cache_index] == 0)
            begin
               if(cbl[cache_index].right_dirty == 1)
               begin
                  next_state = WB1;
               end
               else
               begin
                  next_state = READ1;
               end
            end
            else
            begin
               if(cbl[cache_index].left_dirty == 1)
               begin
                  next_state = WB1;
               end
               else
               begin
                  next_state = READ1;
               end
            end
         end
      end
      WB1 :
      begin
         if(cif.dwait == 0)
         begin
            next_state = WB2;
         end
      end
      WB2 :
      begin
         if(cif.dwait == 0)
         begin
            next_state = READ1;
         end
      end
      READ1 :
      begin
         if(cif.dwait == 0)
         begin
            next_state = READ2;
         end
      end
      READ2 :
      begin
         if(cif.dwait == 0)
         begin
            next_state = IDLE;
         end
      end
      FLUSH1 :
      begin
         if(cif.dwait == 0)
         begin
            next_state = FLUSH2;
         end
      end
      FLUSH2 :
      begin
         if(cif.dwait == 0)
         begin
            next_state = DIRTY;
         end
      end
      DIRTY :
      begin
         if(cache_row < 8)
         begin
            if(cbl[cache_row].left_dirty == 1)
            begin
               next_state = FLUSH1;
            end
         else if(cache_row < 16)
         begin
            if(cbl[cache_row - 8].right_dirty == 1)
            begin
               next_state = FLUSH1;
            end
         end
         else
         begin
            next_state = COUNT;
         end      
         next_old_cache_row = cache_row;
         next_cache_row = cache_row + 1;
      end
      COUNT :
      begin
         if(cif.dwait == 0)
         begin
            next_state = HALT;
         end
      end
   endcase
end

always_comb
begin
   cif.dREN = 0;
   cif.dWEN = 0;
   cif.daddr = 0;
   cif.dstore = 0;

   next_left_tag = dbl[cache_index].left_tag;
   next_right_tag = dbl[cache_index].right_tag;      
   next_left_dat0 = dbl[cache_index].left_dat0;
   next_right_dat0 = dbl[cache_index].right_dat0;
   next_left_dat1 = dbl[cache_index].left_dat1;
   next_right_dat1 = dbl[cache_index].right_dat1;
   next_left_dirty = dbl[cache_index].left_dirty;
   next_right_dirty = dbl[cache_index].right_dirty;
   next_left_valid = dbl[cache_index].left_valid;
   next_right_valid = dbl[cache_index].right_valid;

   dcif.dhit = 0;
   dcif.dmemload = 0;
   dcif.flushed = 0;
   
   next_hit_count = hit_count;
   for(i = 0; i < 8; i++)
   begin
      next_last_used[i] = last_used[i];
   end
   hit = 0;

   casez(state)
      IDLE :
      begin
         if(dcif.dmemREN)
         begin
            if((tag == cbl[cache_index].left_tag) && cbl[cache_index].left_valid)
            begin
               dcif.dhit = 1;
               hit = 1;
               next_last_used = 0;
               next_hit_count = hit_count + 1;
               if(data_index[2] == 0)
               begin
                  dcif.dmemload = cbl[cache_index].left_dat0;
               end
               else
               begin
                  dcif.dmemload = cbl[cache_index].left_dat1;
               end
            end
            else if((tag == cbl[cache_index].right_tag) && cbl[cache_index].right_valid)
            begin
               dcif.dhit = 1;
               hit = 1;
               next_last_used = 1;
               next_hit_count = hit_count + 1;
               if(data_index[2] == 0)
               begin
                  dcif.dmemload = cbl[cache_index].right_dat0;
               end
               else
               begin
                  dcif.dmemload = cbl[cache_index].right_dat1;
               end
            end
            else
            begin
               next_hit_count = hit_count - 1;
            end
         end
         else if(dcif.dmemWEN == 1)
         begin
            if(tag == cbl[cache_index].left_tag)
            begin
               dcif.dhit = 1;
               hit = 1;
               next_left_dirty = 1;
               next_last_used = 0;
               next_hit_count = hit_count + 1;
               if(data_index[2] == 0)
               begin
                  next_left_dat0 = dcif.dmemstore;
               end
               else
               begin
                  next_left_dat1 = dcif.dmemstore;
               end
            end
            else if(tag == cbl[cache_index].right_tag)
            begin
               dcif.dhit = 1;
               hit = 1;
               next_right_dirty = 1;
               next_last_used = 1;
               next_hit_count = hit_count + 1;
               if(data_index[2] == 0)
               begin
                  next_right_dat0 = dcif.dmemstore;
               end
               else
               begin
                  next_right_dat1 = dcif.dmemstore;
               end
            end
            else
            begin
               next_hit_count = hit_count - 1;
            end            
         end
      end
      WB1 :
      begin
         if(last_used[cache_index] == 0)
         begin
            cif.daddr = {cbl[cache_index].right_tag, cache_index, 3'b000};
            cif.dstore = cbl[cache_index].right_dat0;
         end
         else
         begin
            cif.daddr = {cbl[cache_index].left_tag, cache_index, 3'b000};
            cif.dstore = cbl[cache_index].left_dat0;
         end
         cif.dWEN = 1;
      end
      WB2 :
      begin
         if(last_used[cache_index] == 0)
         begin
            cif.daddr = {cbl[cache_index].right_tag, cache_index, 3'b100};
            cif.dstore = cbl[cache_index].right_dat1;
         end
         else
         begin
            cif.daddr = {cbl[cache_index].left_tag, cache_index, 3'b100};
            cif.dstore = cbl[cache_index].left_dat1;
         end
         cif.dWEN = 1;
      end
      READ1 :
      begin
         if(last_used[cache_index] == 0)
         begin
            next_right_dat0 = cif.dload;
         end
         else
         begin
            next_left_dat0 = cif.dload;
         end
         cif.dREN = 1;
         cif.daddr = {tag, cache_index, 3'b000};
      end
      READ2 :
      begin
         if(last_used[cache_index] == 0)
         begin
            next_right_dat1 = cif.dload;
            next_right_dirty = 0;
            next_right_valid = 1;
            next_right_tag = tag;
         end
         else
         begin
            next_left_dirty = 0;
            next_left_valid = 1;
            next_left_tag = tag;
         end
         cif.dREN = 1;
         cif.daddr = {tag, cache_index, 3'b100};
      end
      FLUSH1 :
      begin
         if(old_cache_row < 8)
         begin
            cif.daddr = {cbl[old_cache_row].left_tag, old_cache_row, 3'b000};
            cif.dstore = cbl[old_cache_row].left_dat0;
         end
         else
         begin
            cif.daddr = {cbl[old_cache_row - 8].right_tag, old_cache_row - 8, 3'b000};
            cif.dstore = cbl[old_cache_row - 8].right_dat0;
         end
      end
      FLUSH2 :
      begin
         if(old_cache_row < 8)
         begin
            cif.daddr = {cbl[old_cache_row].left_tag, old_cache_row, 3'b100};
            cif.dstore = cbl[old_cache_row].left_dat1;
         end
         else
         begin
            cif.daddr = {cbl[old_cache_row - 8].right_tag, old_cache_row - 8, 3'b100};
            cif.dstore = cbl[old_cache_row - 8].right_dat1;
         end
      end
      COUNT :
      begin
         cif.daddr = 32'h00003100;  
         cif.dWEN = 1;
         cif.dstore = hit_count;
      end
   endcase      
end







































