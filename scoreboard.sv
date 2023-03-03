/* Scoreboard */

class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  // Instantiations
  sequence_item sequence_item_in                              ;

  uvm_tlm_analysis_fifo #(sequence_item) my_tlm_analysis_fifo ; 
  uvm_analysis_export #(sequence_item) my_analysis_export     ;  

  logic [31:0] wr_data [0:31]                                 ;
  logic [31:0] addr                                           ; 

  // Construction
  function new(string name = "scoreboard", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  // Build Phase
  function void build_phase (uvm_phase phase);
    super.build_phase(phase)           ;

    my_tlm_analysis_fifo = new("uvm_tlm_fifo",this)       ;
    my_analysis_export   = new("my_analysis_export",this) ;

    $display("scoreboard_build_phase") ;
  endfunction

  // Connect Phase
  function void connect_phase (uvm_phase phase);
    super.connect_phase(phase)           ;

    // Connect FIFO Export Port to Scoreboard's Export Port
      // that eventually connects to Agent's Analysis Port at env.sv
    my_analysis_export.connect(my_tlm_analysis_fifo.analysis_export) ;

    $display("scoreboard_connect_phase") ;
  endfunction

  // Run Phase
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    forever begin         
      my_tlm_analysis_fifo.get(sequence_item_in);

      // Writing Case
      if ((sequence_item_in.rst_n == 1) & (sequence_item_in.en == 1) & (sequence_item_in.wr == 1)) begin
        wr_data[sequence_item_in.addr] = sequence_item_in.data_in ;
      end // Reading Case
      else if ((sequence_item_in.rst_n == 1) & (sequence_item_in.en == 1) & (sequence_item_in.valid_out == 1'b1)) begin
        if(sequence_item_in.data_out == wr_data[addr]) begin
          $display("TEST PASSED: data_out = %d, ref_data = %d.", sequence_item_in.data_out, wr_data[addr]);
        end
        else begin
          $display("TEST FAILED: data_out = %d, ref_data = %d.", sequence_item_in.data_out, wr_data[addr]);
        end
      end
      else if ((sequence_item_in.rst_n == 0)) begin
        for (int i = 0; i < $size(wr_data); i++) begin
          wr_data [i] = 0;
        end
      end
      addr = sequence_item_in.addr;
    end
    $display("scoreboard_run_phase");
  endtask

endclass 