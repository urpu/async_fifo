class af_m_sequencer extends uvm_sequencer#(af_m_sequence_item);
    `uvm_component_utils(af_m_sequencer)

    function new(string name = "af_m_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction
endclass


class af_s_sequencer extends uvm_sequencer#(af_s_sequence_item);
    `uvm_component_utils(af_s_sequencer)

    function new(string name = "af_s_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction
endclass



class af_vsequencer extends uvm_sequencer;
    `uvm_component_utils(af_vsequencer)

    af_m_sequencer af_m_sqncer;
    af_s_sequencer af_s_sqncer;

    function new(string name = "af_vsequencer", uvm_component parent);
        super.new(name, parent);
    endfunction

endclass