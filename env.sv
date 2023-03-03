/* Environment */

class env extends uvm_env ;
  `uvm_component_utils(env)

  // Instantiations
  agent      agent_i           ;
  subscriber subscriber_i      ;
  scoreboard scoreboard_i      ;

  virtual intf1 config_virtual ;
  virtual intf1 local_virtual  ;

  // Construction
  function new(string name = "env",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  // Build Phase
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    // Creation
    agent_i      = agent::type_id::create("agent_i",this)           ;
    subscriber_i = subscriber::type_id::create("subscriber_i",this) ;
    scoreboard_i = scoreboard::type_id::create("scoreboard_i",this) ;

    // Receiving Virtual Interface
    if(!(uvm_config_db #(virtual intf1)::get(this,"","vif",config_virtual)))
    `uvm_fatal(get_full_name(),"Error!")

    // Connecting Virtual Interface
    local_virtual=config_virtual;
    uvm_config_db #(virtual intf1)::set(this,"agent_i","vif",local_virtual);

    $display("env_build_phase");
  endfunction
  
  // Connect Phase
  function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);

    // Connect Agent to both Subscriber and Scoreboard
    agent_i.my_analysis_port.connect(scoreboard_i.my_analysis_export) ;
    agent_i.my_analysis_port.connect(subscriber_i.analysis_export)    ;

    $display("env_connect_phase");
  endfunction
endclass 