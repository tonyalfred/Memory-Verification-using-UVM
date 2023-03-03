/* Sequence Item */

class sequence_item extends uvm_sequence_item ;
    `uvm_object_utils(sequence_item)
  
  // Construction
  function new(string name = "sequence_item");
    super.new(name);
  endfunction
  
  // Variables
  parameter   ADDR_WIDTH        = 32      ;
  parameter   DATA_WIDTH        = 32      ;

  logic                         clk       ;
  logic                         rst_n     ;

  logic                         en        ;
  logic                         wr        ;

  randc logic [DATA_WIDTH-1:0]  addr      ;
  randc logic [ADDR_WIDTH-1:0]  data_in   ;

  logic       [DATA_WIDTH-1:0]  data_out  ;
  logic                         valid_out ;

  // Randomization Constraints
  constraint addr_constrains {addr inside{[0:31]};}    ;
  constraint data_constrains {data_in inside{[0:31]};} ;

endclass 