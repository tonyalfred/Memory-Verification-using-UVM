/* Agent */

class agent extends uvm_agent ;
  `uvm_component_utils(agent)
   
  // Instantiations 
  driver        driver_i       ;
  monitor       monitor_i      ;
  sequencer     sequencer_i    ;
  
  virtual intf1 config_virtual ;
  virtual intf1 local_virtual  ;
  
  uvm_analysis_port #(sequence_item) my_analysis_port ; 
  
  // Construction
  function new(string name = "agent", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  // Build Phase
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    // Creation
    driver_i    = driver::type_id::create("driver_i",this)       ;
    monitor_i   = monitor::type_id::create("monitor_i",this)     ;
    sequencer_i = sequencer::type_id::create("sequencer_i",this) ;

    // Receiving Virtual Interface
    if(!(uvm_config_db #(virtual intf1)::get(this,"","vif",config_virtual)))
    `uvm_fatal(get_full_name(),"Error!")
    
    // Connecting Virtual Interface
    local_virtual = config_virtual ;
    uvm_config_db #(virtual intf1)::set(this,"driver_i","vif",local_virtual)  ;
    uvm_config_db #(virtual intf1)::set(this,"monitor_i","vif",local_virtual) ;
        
    // Create TLM Port to connect with Env, and eventually Scoreboard 
    my_analysis_port = new ("my_analysis_port",this)             ;

    $display("agent_build_phase");
    endfunction
    
  // Connect Phase
  function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    
    // Connect Sequencer to Driver & Monitor to Env
    monitor_i.my_analysis_port.connect(my_analysis_port)        ;
    driver_i.seq_item_port.connect(sequencer_i.seq_item_export) ;
    
    $display("agent_connect_phase");
  endfunction

endclass 