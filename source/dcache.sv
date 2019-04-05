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
   logic [25:0] left_tag, right_tag;
   word_t left_dat0, right_dat0;
   word_t left_dat1, right_dat1;
   logic left_dirty, right_dirty;
   logic left_valid, right_valid;
} dcache_block_t;

typedef enum logic[3:0] {
   IDLE, WB1, WB2, READ1, READ2, HALT, FLUSH1, FLUSH2, DIRTY, COUNT, SNOOP, WB1_SNOOP, WB2_SNOOP, NO_WB
} state_t;

logic [25:0] tag;
assign tag = dcif.dmemaddr[31:6];

logic [25:0] tag_snoop;
assign tag_snoop = cif.ccsnoopaddr[31:6];

logic [2:0] cache_index;
assign cache_index = dcif.dmemaddr[5:3];

logic [2:0] cache_index_snoop;
assign cache_index_snoop = cif.ccsnoopaddr[5:3];

logic [2:0] data_index;
assign data_index = dcif.dmemaddr[2:0];

logic [31:0] last_daddr, next_last_daddr;

logic hit;
logic[7:0] last_used, next_last_used;

integer i;

dcache_block_t cbl[7:0];

logic[25:0] next_left_tag, next_right_tag;
word_t next_left_dat0, next_left_dat1, next_right_dat0, next_right_dat1;
logic next_left_dirty, next_left_valid, next_right_dirty, next_right_valid;

state_t state, next_state, prev_state, next_prev_state;

logic[4:0] cache_row, next_cache_row, old_cache_row, next_old_cache_row, temp_old_row;

logic next_dmemWEN, dmemWEN;
logic next_dmemREN, dmemREN;
logic ccinv;
word_t ccsnoopaddr, next_last_address;  


always_ff @(posedge CLK or negedge nRST)
begin
   if(nRST == 0)
   begin
      for(i = 0; i < 8; i++)
      begin
         cbl[i].left_tag <= 0;
         cbl[i].right_tag <= 0;
         cbl[i].left_dat0 <= 0;
         cbl[i].right_dat0 <= 0;
         cbl[i].left_dat1 <= 0;
         cbl[i].right_dat1 <= 0;
         cbl[i].left_dirty <= 0;
         cbl[i].right_dirty <= 0;
         cbl[i].left_valid <= 0;
         cbl[i].right_valid <= 0;
      end
      last_daddr <= 0;
      dmemWEN <= 0; 
      dmemREN <= 0; 
      ccinv <= 1'b0; 
      ccsnoopaddr <= 32'd0; 
   end
   else
   begin
      cbl[cache_index].left_tag <= next_left_tag;
      cbl[cache_index].right_tag <= next_right_tag;
      cbl[cache_index].left_dat0 <= next_left_dat0;
      cbl[cache_index].right_dat0 <= next_right_dat0;
      cbl[cache_index].left_dat1 <= next_left_dat1;
      cbl[cache_index].right_dat1 <= next_right_dat1;
      cbl[cache_index].left_dirty <= next_left_dirty;
      cbl[cache_index].right_dirty <= next_right_dirty;
      cbl[cache_index].left_valid <= next_left_valid;
      cbl[cache_index].right_valid <= next_right_valid;
      last_daddr <= next_last_daddr;
      dmemWEN <= next_dmemWEN; 
      ccinv <= cif.ccinv; 
      ccsnoopaddr <= cif.ccsnoopaddr; 
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
      prev_state <= IDLE;
      cache_row <= 0;
      old_cache_row <= 0;
   end
   else
   begin
      last_used[cache_index] <= next_last_used[cache_index];
      state <= next_state;
      prev_state <= next_prev_state;
      cache_row <= next_cache_row;
      old_cache_row <= next_old_cache_row;
   end
end

always_comb
begin
   // default values 
   next_state = state;
   next_prev_state = state;
   next_cache_row = cache_row;
   next_old_cache_row = old_cache_row;
   next_last_address = last_daddr; 
   next_dmemWEN = dmemWEN; 

   casez(state)
      IDLE :
      begin
         // if being snooped
         if (cif.ccwait == 1) begin
            next_state = SNOOP; 
         end 
         // if processor is halting
         else if(dcif.halt == 1)
         begin
            next_cache_row = 0;
            next_state = DIRTY;
         end
         // if a miss and actually trying to read or write 
         else if(hit == 0 && (dcif.dmemREN == 1 || dcif.dmemWEN == 1))
         begin
            // If right block in current set was the last recently used 
            if(last_used[cache_index] == 0)
            begin
               // if the right block is dirty and valid
               if((cbl[cache_index].right_dirty) == 1 && (cbl[cache_index].right_valid == 1))
               begin
                  // start write back process to send it back to ram 
                  next_state = WB1;
               end
               else
               begin
                  // else start reading in the requested memory block
                  next_state = READ1;
               end
            end
            // the left block in current set was the last recently used
            else
            begin
               // If the left block is dirty and valid
               if((cbl[cache_index].left_dirty) == 1 && (cbl[cache_index].left_valid == 1))
               begin
                  // Begin the process of writing to memory
                  next_state = WB1;
               end
               // the block is not dirty
               else
               begin
                  // Start process of reading block from memory 
                  next_state = READ1;
               end
            end
         end

         // latch inputs
         next_last_daddr = dcif.dmemaddr; 
         next_dmemWEN = dcif.dmemWEN; 
      end
      WB1 :
      begin
         // if being snooped
         if (cif.ccwait == 1) begin 
            next_state = SNOOP; 
         end
         else if(cif.dwait == 0)
         begin
            next_state = WB2;
         end
      end
      WB2 :
      begin
         if (cif.ccwait == 1) begin 
            next_state = SNOOP; 
         end
         else if(cif.dwait == 0)
         begin
            next_state = READ1;
         end
      end
      READ1 :
      begin
         // if being snooped 
         if (cif.ccwait == 1) begin 
            next_state = SNOOP; 
         end 
         else if(cif.dwait == 0)
         begin
            next_state = READ2;
         end
      end
      READ2 :
      begin
         // if being snooped 
         if (cif.ccwait == 1) begin 
            next_state = SNOOP; 
         end 
         else if(cif.dwait == 0)
         begin
            next_state = IDLE;
         end
      end
      FLUSH1 :
      begin
         // if being snooped 
         if (cif.ccwait == 1) begin 
            next_state = SNOOP; 
         end 
         else if(cif.dwait == 0)
         begin
            next_state = FLUSH2;
         end
      end
      FLUSH2 :
      begin
         // if being snooped 
         if (cif.ccwait == 1) begin 
            next_state = SNOOP; 
         end 
         else if(cif.dwait == 0)
         begin
            next_state = DIRTY;
         end
      end
      DIRTY :
      begin
         // if being snooped 
         if (cif.ccwait == 1) begin 
            next_state = SNOOP; 
         end 
         // of checking the left block
         else if(cache_row < 8)
         begin
            // if left block is dirty and valid
            if(cbl[cache_row].left_dirty == 1 && cbl[cache_row].left_valid == 1)
            begin
               // flush it
               next_state = FLUSH1;
            end
         end
         // else if checking the right block
         else if(cache_row < 16)
         begin
            // if the right block is dirty and valid 
            if(cbl[cache_row - 8].right_dirty == 1 && cbl[cache_row - 8].right_valid == 1)
            begin
               // flush it 
               next_state = FLUSH1;
            end
         end
         // else cache has been flushed so done
         else
         begin
            next_state = HALT;
         end
         // move to next row in dcache
         next_old_cache_row = cache_row;
         next_cache_row = cache_row + 1;
      end
      HALT: next_state = HALT; 
      SNOOP:
      begin
         // if the left tag matches, left block is valid
         if ((tag_snoop == cbl[cache_index_snoop].left_tag) && (cbl[cache_index_snoop].left_valid == 1)) begin 
            // if the block is dirty
            if (cbl[cache_index_snoop].left_dirty == 1) begin 
               // start the write back
               next_state = WB1_SNOOP;
            end
            // else tell memory controller to go to ram 
            else begin 
               next_state = NO_WB; 
            end
         end 
         // else if the right tag matches, right block is valid
         else if ((tag_snoop == cbl[cache_index].right_tag) && (cbl[cache_index].right_valid == 1)) begin 
            // if the block is dirty
            if (cbl[cache_index_snoop].right_dirty == 1) begin 
               // start the write back
               next_state = WB1_SNOOP;
            end
            // else tell memory controller to go to ram 
            else begin 
               next_state = NO_WB; 
            end
         end 
         // else tell memory controller to go to ram for data 
         else begin 
            next_state = NO_WB; 
         end
      end 
      WB1_SNOOP: 
      begin 
         // if memory controller says ram is valid 
         if (cif.dwait == 0) begin 
            // move to next word to write 
            next_state = WB2_SNOOP;
         end  
      end 
      WB2_SNOOP:
      begin 
         // if memory controller says ram is valid 
         if (cif.dwait == 0) begin 
            // Finished providing data so go back to idle  
            next_state = IDLE;
         end 
      end 
      NO_WB: 
      begin 
         // Not supllying the data, so go back to idle
         next_state = IDLE; 
      end
      default : 
      begin 
         next_state = state;
         next_cache_row = cache_row;
      end
   endcase
end

integer j;

always_comb
begin
   cif.dREN = 0;
   cif.dWEN = 0;
   cif.daddr = 0;
   cif.dstore = 0;
   cif.ccwrite = 0;
   cif.cctrans = 0;

   next_left_tag = cbl[cache_index].left_tag;
   next_right_tag = cbl[cache_index].right_tag;
   next_left_dat0 = cbl[cache_index].left_dat0;
   next_right_dat0 = cbl[cache_index].right_dat0;
   next_left_dat1 = cbl[cache_index].left_dat1;
   next_right_dat1 = cbl[cache_index].right_dat1;
   next_left_dirty = cbl[cache_index].left_dirty;
   next_right_dirty = cbl[cache_index].right_dirty;
   next_left_valid = cbl[cache_index].left_valid;
   next_right_valid = cbl[cache_index].right_valid;

   dcif.dhit = 0;
   dcif.dmemload = 0;
   dcif.flushed = 0;

   next_last_used = last_used;
   temp_old_row = next_cache_row;
   hit = 0;

   casez(state)
      IDLE :
      begin
         // if a processor read
         if(dcif.dmemREN == 1)
         begin
            // if the left tag matches and block is valid
            if((tag == cbl[cache_index].left_tag) && (cbl[cache_index].left_valid == 1))
            begin
               // give back a dhit 
               dcif.dhit = 1;
               // set the internal hit signal
               hit = 1;
               // Set the left block as last recently used
               next_last_used[cache_index] = 0;
               // If processor requesting the first word in the block
               if(data_index[2] == 0)
               begin
                  // set word0 on dmemload line
                  dcif.dmemload = cbl[cache_index].left_dat0;
               end
               // else processor is requesting the second word in the block 
               else
               begin
                  // set word1 on dmemload line
                  dcif.dmemload = cbl[cache_index].left_dat1;
               end
            end
            // if the right tag matches and block is valid
            else if((tag == cbl[cache_index].right_tag) && cbl[cache_index].right_valid == 1)
            begin
               // give back a dhit to the processor
               dcif.dhit = 1;
               // set the internal hit signal
               hit = 1;
               // sed the right block as last recently used
               next_last_used[cache_index] = 1;
               // if the processor was requesting word0
               if(data_index[2] == 0)
               begin
                  // put word 0 on the data line
                  dcif.dmemload = cbl[cache_index].right_dat0;
               end
               // else the processor was requesting word1
               else
               begin
                  // put word1 on the data line
                  dcif.dmemload = cbl[cache_index].right_dat1;
               end
            end
            // A miss
            else begin 
               dcif.dhit = 1'b0; 
               hit = 1'b0; 
            end 
         end
         // If a processor write is occuring
         else if(dcif.dmemWEN == 1)
         begin
            // If left tag matches, left block is valid, and left block is dirty (Writing to a shared block should produce a miss in order to go and invalidate the other caches)
            if(tag == cbl[cache_index].left_tag && cbl[cache_index].left_valid == 1)
            begin
               // give back a dhit to processor
               dcif.dhit = 1;
               // set internal hit signal
               hit = 1;
               // set the left block to dirty 
               next_left_dirty = 1;
               // set the right block as the last used
               next_last_used[cache_index] = 0;
               // if writing to word0
               if(data_index[2] == 0)
               begin
                  // set the word0 data to dmemstore line
                  next_left_dat0 = dcif.dmemstore;
               end
               // writing to word1
               else
               begin
                  // set the word1 data to dmemstore line
                  next_left_dat1 = dcif.dmemstore;
               end
               // Tell bus that writing to a block address
               cif.ccwrite = 1'b1; 
               cif.ccsnoopaddr = dcif.dmemaddr; 
            end
            // if right tag matches, right block is valid, and right block is dirty (Writing to a shared block should produce a miss in order to go and invalidate the other caches)
            else if(tag == cbl[cache_index].right_tag && cbl[cache_index].right_valid == 1)
            begin
               // give back a dhit to the processor
               dcif.dhit = 1;
               // set internal hit signal 
               hit = 1;
               // set right block to dirty
               next_right_dirty = 1;
               // Update the last recently used to the left block
               next_last_used[cache_index] = 1;
               // if writing word0
               if(data_index[2] == 0)
               begin
                  // set word0 data to dmemstore line
                  next_right_dat0 = dcif.dmemstore;
               end
               // writing to word1
               else
               begin
                  // set word1 data to dmemstore line
                  next_right_dat1 = dcif.dmemstore;
               end
               // Tell bus that writing to a block address
               cif.ccwrite = 1'b1; 
               cif.ccsnoopaddr = dcif.dmemaddr;
            end
            // A miss
            else begin 
               dcif.dhit = 1'b0; 
               hit = 1'b0; 
            end 
         end
      end
      WB1 :
      begin
         // If the right block was the last recently used
         if(last_used[cache_index] == 0)
         begin
            // Write righ block back to memory
            cif.daddr = {cbl[cache_index].right_tag, cache_index, 3'b000};
            cif.dstore = cbl[cache_index].right_dat0;
         end
         // else left block was last recently used 
         else
         begin
            // write left block back to memory
            cif.daddr = {cbl[cache_index].left_tag, cache_index, 3'b000};
            cif.dstore = cbl[cache_index].left_dat0;
         end
         // Let memory controller know that dcache wants to write to memory
         cif.dWEN = 1;
      end
      WB2 :
      begin
         // if the right block was last recently used
         if(last_used[cache_index] == 0)
         begin
            // write the right block back
            cif.daddr = {cbl[cache_index].right_tag, cache_index, 3'b100};
            cif.dstore = cbl[cache_index].right_dat1;
            // Set right block to not dirty 
            next_right_dirty = 1'b0; 
         end
         // left block was last recently used
         else
         begin
            // write the left block back
            cif.daddr = {cbl[cache_index].left_tag, cache_index, 3'b100};
            cif.dstore = cbl[cache_index].left_dat1;
            // set left block to not dirty
            next_left_dirty = 1'b0; 
         end
         // tell memory controller that dcache wants to write to memroy
         cif.dWEN = 1;
      end
      READ1 :
      begin
         // if right block was the last recently used
         if(last_used[cache_index] == 0)
         begin
            // read data into word0 or right block
            next_right_dat0 = cif.dload;
         end
         // else left block was the last recently used
         else
         begin
            // read data into word0 of left block
            next_left_dat0 = cif.dload;
         end
         // let memory controller know that it is requesting a read from memory
         cif.dREN = 1;
         // set the daddr
         cif.daddr = {tag, cache_index, 3'b000}; 
         // set the ccwrite if there was a processor write request (Dcache telling other memory that they need to invalidate their blocks)
         cif.ccwrite = dmemWEN; 
      end
      READ2 :
      begin
         // if right block was the last recently used 
         if(last_used[cache_index] == 0)
         begin
            // read in word1
            next_right_dat1 = cif.dload;
            // Set the right block as valid
            next_right_valid = 1;
            if(cif.dwait == 0)
            begin
               next_right_tag = tag;
               // set the left block as the last recently used 
               next_last_used[cache_index] = 1;
            end
         end
         // else left block was the last recently used 
         else
         begin
            // read in word1
            next_left_dat1 = cif.dload;
            // set the left block to valid
            next_left_valid = 1;
            if(cif.dwait == 0)
            begin
               next_left_tag = tag;
               next_last_used[cache_index] = 0;
            end
         end
         // let memory controller know that it is requesting a read from memory
         cif.dREN = 1;
         // set the daddr
         cif.daddr = {tag, cache_index, 3'b100};
         // set the ccwrite if there was a processor write request (Dcache telling other memory that they need to invalidate their blocks)
         cif.ccwrite = dmemWEN; 
      end
      FLUSH1 :
      begin
         // if still flushing left blocks
         if(old_cache_row < 8)
         begin
            cif.dWEN = 1'b1;
            cif.daddr = {cbl[old_cache_row].left_tag, old_cache_row[2:0], 3'b000};
            cif.dstore = cbl[old_cache_row].left_dat0;
         end
         // else flushing right blocks now
         else
         begin
            temp_old_row = old_cache_row - 8;
            cif.dWEN = 1'b1;
            cif.daddr = {cbl[old_cache_row - 8].right_tag, temp_old_row[2:0], 3'b000};
            cif.dstore = cbl[old_cache_row - 8].right_dat0;
         end
      end
      FLUSH2 :
      begin
         // if still flushing left blocks
         if(old_cache_row < 8)
         begin
            cif.dWEN = 1'b1;
            cif.daddr = {cbl[old_cache_row].left_tag, old_cache_row[2:0], 3'b100};
            cif.dstore = cbl[old_cache_row].left_dat1;
            next_left_dirty = 1'b0; 
         end
         // flushing right blocks now 
         else
         begin
            temp_old_row = old_cache_row - 8;
            cif.dWEN = 1'b1;
            cif.daddr = {cbl[old_cache_row - 8].right_tag, temp_old_row[2:0], 3'b100};
            cif.dstore = cbl[old_cache_row - 8].right_dat1;
            next_right_dirty = 1'b0; 
         end
      end
      HALT:
      begin 
         // set flushed signal to signify that no dirty values are left in the cache 
         dcif.flushed = 1'b1;
         // set trans high to allow snoopers to progress
         cif.cctrans = 1'b1; 
      end 
      SNOOP:
      begin
         // if the left tag matches, left block is valid
         if ((tag_snoop == cbl[cache_index_snoop].left_tag) && (cbl[cache_index_snoop].left_valid == 1)) begin
            // invalidate block if needed
            if (cif.ccinv == 1) begin 
               // set the left block to invalid
               next_left_valid = 1'b0; 
               next_left_dirty = 1'b0; 
            end 
         end 
         // else if the right tag matches, right block is valid
         else if ((tag_snoop == cbl[cache_index].right_tag) && (cbl[cache_index].right_valid == 1)) begin 
            // invalidate block if needed
            if (cif.ccinv == 1) begin 
               // set the right block to invalid
               next_right_valid = 1'b0; 
               next_right_dirty = 1'b0; 
            end 
         end 
      end
      WB1_SNOOP:
      begin 
         // Signal to memory controller that dcache wants to do a write back and also that it is done transitioning
         cif.cctrans = 1'b1; 
         cif.ccwrite = 1'b1; 

         // if data in left block
         if (tag_snoop == cbl[cache_index_snoop].left_tag) begin 
            // set data address of left block
            cif.daddr = {cbl[cache_index_snoop].left_tag, cache_index_snoop, 3'b000};
            cif.dstore = cbl[cache_index_snoop].left_dat0;
         end 
         // else in the right block
         else begin
            // set data address of right block
            cif.daddr = {cbl[cache_index_snoop].right_tag, cache_index_snoop, 3'b000};
            cif.dstore = cbl[cache_index_snoop].right_dat0;
         end 
      end 
      WB2_SNOOP: 
      begin 
         // if data in left block
         if (tag_snoop == cbl[cache_index_snoop].left_tag) begin 
            // set data address of left block
            cif.daddr = {cbl[cache_index_snoop].left_tag, cache_index_snoop, 3'b100};
            cif.dstore = cbl[cache_index_snoop].left_dat1;
         end 
         // else in the right block
         else begin
            // set data address of right block
            cif.daddr = {cbl[cache_index_snoop].right_tag, cache_index_snoop, 3'b100};
            cif.dstore = cbl[cache_index_snoop].right_dat1;
         end 
      end 
      NO_WB: 
      begin 
         // Signal to memory controller that it should just go to ram 
         cif.cctrans = 1'b1; 
         cif.ccwrite = 1'b0; 
      end
   endcase
end
endmodule





































