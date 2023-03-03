/* Test */

class test extends uvm_test ;
  `uvm_component_utils(test)

  // Instantiations
  env           test_env       ;
  my_sequence   my_sequence_in ;

  virtual intf1 config_virtual ;
  virtual intf1 local_virtual  ;

  // Construction
  function new(string name = "test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  // Build Phase
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    // Creation
    test_env       = env::type_id::create("test_env",this)          ;
    my_sequence_in = my_sequence::type_id::create("my_sequence_in") ;

    // Receiving Virtual Interface
    if(!uvm_config_db#(virtual intf1)::get(this,"","vif",config_virtual))
          `uvm_fatal(get_full_name(),"Error!")
    
    // Connecting Virtual Interface
    local_virtual=config_virtual ;
    uvm_config_db #(virtual intf1)::set(this,"test_env","vif",local_virtual);

    $display("test_build_phase");
  endfunction

  // Connect Phase
  function void connect_phase (uvm_phase phase);
    super.connect_phase(phase)     ;
    $display("test_connect_phase") ;
  endfunction

  // Run Phase
  task run_phase (uvm_phase phase);
    super.run_phase(phase)      ;
    $display("test_run_phase")  ;

    phase.raise_objection(this) ;
    my_sequence_in.start(test_env.agent_i.sequencer_i) ;
    phase.drop_objection(this)  ;

  endtask
endclass 