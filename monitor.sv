/* Monitor */

class monitor extends uvm_monitor ;
  `uvm_component_utils(monitor)

  // Instantiations 
  sequence_item seq_item_in     ;
  sequence_item seq_item_buff   ;

  virtual intf1 monitor_virtual ;
  
  uvm_analysis_port #(sequence_item) my_analysis_port ; 
  
  // Construction
  function new(string name = "monitor", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  // Build Phase
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    // Creation
    seq_item_in   = sequence_item::type_id::create("seq_item_in")   ;
    seq_item_buff = sequence_item::type_id::create("seq_item_buff") ;

    if(!(uvm_config_db #(virtual intf1)::get(this,"","vif",monitor_virtual)))
      `uvm_fatal(get_full_name(),"Error!")

    // Create TLM Port to to be used in Agent, and then connect to Env, 
    // and eventually both the Scoreboard and the Subscriber
    my_analysis_port = new("my_analysis_port",this)                 ;

    $display("monitor_build_phase");
  endfunction
  
  // Connect Phase
  function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    $display("monitor_connect_phase");
  endfunction

  // Run Phase
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    $display("monitor_run_phase");
    
    forever begin
      @(posedge(monitor_virtual.clk))  
        seq_item_in.data_in <= monitor_virtual.data_in ;   
        seq_item_in.addr    <= monitor_virtual.addr    ;
        seq_item_in.rst_n   <= monitor_virtual.rst_n   ;
        seq_item_in.en      <= monitor_virtual.en      ;
        seq_item_in.wr      <= monitor_virtual.wr      ;

        if(monitor_virtual.valid_out)begin
          // $display("beginning of monitoring: ")        ;

          seq_item_in.data_out  <= monitor_virtual.data_out  ;
          seq_item_in.valid_out <= monitor_virtual.valid_out ;
          
          // $display("end of monitoring: ")       ;
          // $display("monitored output before casting: data_out = %d, valid_out=%d", monitor_virtual.data_out, monitor_virtual.valid_out);
        end

      // Buffering monitored output in case there is change in sequence item
      #1 $cast(seq_item_buff,seq_item_in);
      // $display("monitored output after casting: data_out = %d, valid_out = %d", seq_item_buff.data_out, seq_item_buff.valid_out);
      
      // Writing in port connected to Agent, then Scoreboard
      my_analysis_port.write(seq_item_buff);
    end
  endtask
  
endclass 