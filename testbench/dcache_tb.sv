/*
  Cody Mann
  mann53@purdue.edu

  data cache testbench
*/

// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module dcache_tb;

  // parameter definitions 
  parameter PERIOD = 10; 

  logic CLK = 0, nRST;

  // clock generation block 
  always #(PERIOD/2) CLK++;

  // interfaces
  datapath_cache_if dcif();
 
  // coherence interface
  caches_if                 cif0();

  // cif1 will not be used, but ccif expects it as an input
  caches_if                cif1();
  cache_control_if #(.CPUS(1))   ccif (cif0, cif1);
  cpu_ram_if ramif();

  // DUT
  `ifndef MAPPED
    dcache DUT(CLK, nRST, dcif, cif0);
    memory_control DUT_MEMORY_CONTROL(ccif);
    ram RAM(CLK, nRST, ramif);
  `else
    dcache DUT(
      .\dcif.dhit (dcif.dhit), 
      .\dcif.dmemREN(dcif.dmemREN), 
      .\dcif.dmemWEN (dcif.dmemWEN), 
      .\dcif.dmemstore(dcif.dmemstore), 
      .\dcif.dmemaddr (dcif.dmemaddr), 
      .\dcif.dmemload (dcif.dmemload),
      .\cif.dwait (cif.dwait), 
      .\cif.dload (cif.dload), 
      .\cif.dREN (cif.dREN), 
      .\cif.dWEN (cif.dWEN), 
      .\cif.daddr (cif.daddr), 
      .\cif.dstore (cif.dstore),  
      .\nRST (nRST),
      .\CLK (CLK) 
      ); 
    memory_control MEMORY_CONTROL(
      .\ccif.iREN (ccif.iREN),
      .\ccif.dREN (ccif.dREN),
      .\ccif.dWEN (ccif.dWEN),
      .\ccif.dstore (ccif.dstore),
      .\ccif.iaddr (ccif.iaddr),
      .\ccif.daddr (ccif.daddr),
      .\ccif.ramload (ccif.ramload),
      .\ccif.ramstate (ccif.ramstate),
      .\ccif.ccwrite (ccif.ccwrite),
      .\ccif.cctrans (ccif.cctrans),
      .\ccif.iwait (ccif.iwait),
      .\ccif.dwait (ccif.dwait),
      .\ccif.iload (ccif.iload),
      .\ccif.dload (ccif.dload),
      .\ccif.ramstore (ccif.ramstore),
      .\ccif.ramaddr (ccif.ramaddr),
      .\ccif.ramWEN (ccif.ramWEN),
      .\ccif.ramREN (ccif.ramREN),
      .\ccif.ccwait (ccif.ccwait),
      .\ccif.ccinv (ccif.ccinv),
      .\ccif.ccsnoopaddr (ccif.ccsnoopaddr)
    );
    ram RAM(
    .\CLK (CLK),
    .\nRST (nRST),
    .\ramif.ramaddr (ramif.ramaddr),
    .\ramif.ramstore (ramif.ramstore),
    .\ramif.ramREN (ramif.ramREN),
    .\ramif.ramWEN (ramif.ramWEN),
    .\ramif.ramstate (ramif.ramstate),
    .\ramif.ramload (ramif.ramload)
    );
  `endif

/*******************  CONNECTIONS ********************/

  // assign statements memory control -> ram
  assign ramif.ramaddr = ccif.ramaddr;
  assign ramif.ramREN = ccif.ramREN;
  assign ramif.ramWEN = ccif.ramWEN;
  assign ramif.ramstore = ccif.ramstore;

  // assign statements ram -> memory control
  assign ccif.ramload = ramif.ramload;
  assign ccif.ramstate = ramif.ramstate;

  // assign dcache -> memory control 
  assign ccif.dREN = cif0.dREN; 
  assign ccif.dWEN = cif0.dWEN; 
  assign ccif.daddr = cif0.daddr; 
  assign ccif.dstore = cif0.dstore; 

  // assign memory control -> dcache 
  assign cif0.dwait = ccif.dwait; 
  assign cif0.dload = ccif.dload; 

  // test program
  test PROG ( 
    .CLK(CLK),
    .nRST(nRST),
    dcif
    ); 

endmodule

/******************* TEST PROGRAM ********************/
program test(
  input logic CLK,
  output logic nRST, 
  datapath_cache_if dcif
  ); 

  // import statements 
  import cpu_types_pkg::*; 

/******************* TEST VARIABLE DECLARATIONS ********************/
  int test_case_num = 0; 
  string test_description = "Initializing"; 

  // data variables 
  dcachef_t [31:0] byte_address;
  word_t [31:0] data;  

  // parameter definitions  
  parameter PERIOD = 10;

/******************* TEST VECTORS ********************/

/******************* TEST TASK DEFINITIONS ********************/

  // task to read or write data from the cache
  task access_cache;
    input logic wren; 
    input dcachef_t byte_address; 
    input word_t data; 
    input word_t exp_read_data; 
    begin
      // check whether a read or write
      if (wren == 1'b1) begin 
        // get away from the negative edge of clock 
        @(negedge ClK); 
        // apply propper inputs to cache for a write
        dcif.halt = 1'b0; 
        dcif.dmemREN = 1'b0; 
        dcif.dmemWEN = 1'b1; 
        dcif.dmemstore = data; 
        dcif.dmemaddr = byte_address; 

        // wait a little to allow inputs to settle 
        #(10)
        // wait unitl dcache gives back a dhit 
        while(dcif.dhit == 0); 

        // get away from the negative edge of clock cycle
        @(negedge CLK); 
        dcif.halt = 1'b0; 
        dcif.dmemREN = 1'b0; 
        dcif.dmemWEN = 1'b0; 
        dcif.dmemstore = 32'd0; 
        dcif.dmemaddr = 32'd0; 
      end 
      // else it is a read 
      else begin  
        // get away from the negative edge of clock 
        @(negedge ClK); 

        // apply propper inputs to cache for a write
        dcif.halt = 1'b0; 
        dcif.dmemREN = 1'b1; 
        dcif.dmemWEN = 1'b0; 
        dcif.dmemstore = 32'd0; 
        dcif.dmemaddr = byte_address; 

        // wait a little to allow inputs to settle 
        #(10)

        // wait unitl dcache gives back a dhit 
        while(dcif.dhit == 0);
        #(10)
        // check the read data 
        check_read_data(exp_read_data, byte_address); 

        // get away from the negative edge of clock cycle
        @(negedge CLK); 
        dcif.halt = 1'b0; 
        dcif.dmemREN = 1'b0; 
        dcif.dmemWEN = 1'b0; 
        dcif.dmemstore = 32'd0; 
        dcif.dmemaddr = 32'd0; 
      end 
    end 
  endtask

  task check_read_data; 
    input word_t exp_data; 
    input dcachef_t addr; 
    begin 
      // check to see if the data load from cache is waht is expected.
      if (dcif.dmemload != exp_data) begin 
        $display("Time: %00gns Incorrect data from cache when requesting address 0x%f0h.")
      end 
    end 
  endtask

  // resets the whole system 
  task reset_dut; 
    begin 

      // get away from posedge of clock 
      @(negedge CLK); 

      // bring nRST low 
      nRST = 1'b0; 

      // wait for a period 
      #(PERIOD)

      // get away from posedge of clock 
      @(negedge CLK); 

      // bring nRST back high 
      nRST = 1'b1; 
    end 
  endtask

  // dumps the meory from ram at end of testbench
  task automatic dump_memory();
    string filename = "memcpu.hex";
    int memfd;

    cif0.daddr = 0;
    cif0.dREN = 0;
    cif0.dWEN = 0;

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;



      cif0.daddr = i << 2;
      cif0.dREN = 1;
      repeat (4) @(posedge CLK);
      if (cif0.dload === 0)
        continue;
      values = {8'h04,16'(i),8'h00,cif0.dload};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),cif0.dload,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin

      cif0.dREN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask

/******************* TEST INITIAL BLOCK ********************/
  initial begin

    /******************* TEST CASES CREATION ********************/

    /******************* START RUNNING THROUGH TEST CASES ********************/
    // initialize all inputs 
    dcif.halt = 1'b0; 
    dcif.dmemREN = 1'b0; 
    dcif.dmemWEN = 1'b0; 
    dcif.dmemstore = 32'b0;
    dcif.dmemaddr = 32'd0; 

    /************************************
    *
    *       Test case 1: testing toggle coverage on dcache table
    *
    ************************************/
    test_description = "Testing toggle coverage on Dcache table.";
    reset_dut(); 

    // dump the memory into memcpu.hex after testbench is finished 
    dump_memory(); 
  end 
endprogram
