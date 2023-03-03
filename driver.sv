/* Driver */

class driver extends uvm_driver #(sequence_item) ;
  `uvm_component_utils(driver)

  sequence_item  seq_item_in    ;

  virtual intf1  driver_virtual ;
  
  // Construction
  function new(string name = "driver", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  // Build Phase
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    
    if(!(uvm_config_db #(virtual intf1)::get(this,"","vif",driver_virtual)))
      `uvm_fatal(get_full_name(),"Error!")
    
    seq_item_in = sequence_item::type_id::create("seq_item_in"); 
    
    $display("driver_build_phase");   
  endfunction

  // Connect Phase
  function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    $display("driver_connect_phase");
  endfunction

  // Run Phase
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    $display("driver_run_phase");

    forever begin
      seq_item_port.get_next_item(seq_item_in)    ;
      
      // $display("After get_next_item @ DRIVER:")   ;

      // Mapping between Sequence Item & Virtual Interface
      @(posedge driver_virtual.clk)
      driver_virtual.rst_n   <= seq_item_in.rst_n   ;
      driver_virtual.en      <= seq_item_in.en      ;
      driver_virtual.wr      <= seq_item_in.wr      ;
      driver_virtual.addr    <= seq_item_in.addr    ;
      driver_virtual.data_in <= seq_item_in.data_in ;

      // $display("Before item_done @ DRIVER:")      ;
      // $display($time  , "%p",seq_item_in)         ;

      seq_item_port.item_done()                   ;
    end
  endtask

endclass 