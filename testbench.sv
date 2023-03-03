/* Testbench */

import uvm_pkg ::*         ;
`include "uvm_macros.svh"  ;

`include "interface.sv"    ;
`include "uvm_classes.sv"  ;

module tb_top ;
  // Instantiate Interface to DUT
  intf1 intf_in () ;

  // Instantiate DUT
  memory   mem_16_32 
  (
    .clk(intf_in.clk),
    .rst_n(intf_in.rst_n),
    .en(intf_in.en),
    .wr(intf_in.wr),
    .addr(intf_in.addr),
    .data_in(intf_in.data_in),
    .data_out(intf_in.data_out),
    .valid_out(intf_in.valid_out)
  );
  
  initial begin 
    intf_in.clk = 0         ;
    // Connect Virtual Interface to Driver and Monitor
    uvm_config_db #(virtual intf1)::set(null,"uvm_test_top","vif",intf_in);

    // Run UVM Environment
    run_test("test");
  end 

  // Clock Generation
  always #5 intf_in.clk=~intf_in.clk;
endmodule 