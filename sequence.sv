/* Sequence */

class my_sequence extends uvm_sequence ;
  `uvm_object_utils(my_sequence)

  // Instantiations 
  sequence_item sequence_item_in       ;

  // Construction
  function new(string name = "my_sequence");
    super.new(name);
  endfunction

  // Tasks to emulate Build Phase, Connect Phase
    // as my_sequence is an object not a component. (has no phasing).
  task pre_body;
    sequence_item_in=sequence_item::type_id::create("sequence_item_in");
  endtask

  task body; 
    // Sequence 1: Pre-Reset the DUT
    start_item(sequence_item_in)  ;
    sequence_item_in.rst_n   = 1  ;
    finish_item(sequence_item_in) ;
    #10ns                         ;

    // Sequence 2: Reset and Enable the DUT
    start_item(sequence_item_in)  ;
    sequence_item_in.rst_n   = 0  ;
    sequence_item_in.data_in = 0  ;
    sequence_item_in.addr    = 0  ;
    sequence_item_in.en 	   = 1  ;
    sequence_item_in.wr 	   = 0  ;
    finish_item(sequence_item_in) ;
    #10ns                         ;
    $display("/////// Resetting and Enabling DUT ///////")  ;
    
    // Sequence 3-35: Write in all locations of the DUT
    for(int i = 0; i < 32; i++)begin
        start_item(sequence_item_in)        ;
        sequence_item_in.rst_n   = 1        ;
        sequence_item_in.en 	   = 1        ;
        sequence_item_in.wr 	   = 1        ;
        void'(sequence_item_in.randomize()) ; // randomize Address and Input Data 
        finish_item(sequence_item_in)       ;

        // $display($time,"Writing process")   ;
      #5ns;
    end
    
    $display("/////// All Writing Sequences Ended ///////")  ;

    // Sequence 36-67: Read from all locations of the DUT
    for(int i = 0; i < 32; i++)begin
        start_item(sequence_item_in)        ;
        sequence_item_in.rst_n   = 1        ;
        sequence_item_in.en 	   = 1        ;
        sequence_item_in.wr 	   = 0        ;
        void'(sequence_item_in.randomize()) ;
        finish_item(sequence_item_in)       ;
        
        // $display ($time,"Reading process")  ;
      #5ns;
    end
    $display ("/////// All Reading Sequences Ended ///////")  ;
    #50ns;
  endtask 
  
endclass 