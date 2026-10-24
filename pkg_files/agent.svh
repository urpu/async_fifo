class af_agent extends uvm_agent;
    `uvm_component_utils(af_agent)

    uvm_sequencer #(af_sequence_item) af_sequencer;

    af_driver  af_drv;
    af_monitor af_mon;
    uvm_analysis_export #(af_analysis_sequence_item) af_agent_exp;

    function new(string name = "af_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        af_drv = af_driver::type_id::create("af_drv", this);
        af_mon = af_monitor::type_id::create("af_mon", this);
        af_sequencer = new("af_sequencer", this);
        af_agent_exp = new("af_agent exp", this);
    endfunction

    virtual function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        af_drv.seq_item_port.connect(af_sequencer.seq_item_export);
        af_mon.mon_ap.connect(af_agent_exp);
    endfunction
endclass