class af_agent extends uvm_agent;
    `uvm_component_utils(af_agent)

    af_m_sequencer af_m_sqncer;
    af_s_sequencer af_s_sqncer;

    af_m_driver  af_m_drv;
    af_s_driver  af_s_drv;
    af_monitor af_mon;
    uvm_analysis_export #(af_analysis_sequence_item) af_agent_exp;

    function new(string name = "af_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        af_m_drv = af_m_driver::type_id::create("af_m_drv", this);
        af_s_drv = af_s_driver::type_id::create("af_s_drv", this);
        af_mon = af_monitor::type_id::create("af_mon", this);
        af_m_sqncer = af_m_sequencer::type_id::create("af_m_sqncer", this);
        af_s_sqncer = af_s_sequencer::type_id::create("af_s_sqncer", this);
        af_agent_exp = new("af_agent exp", this);
    endfunction

    virtual function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        af_m_drv.seq_item_port.connect(af_m_sqncer.seq_item_export);
        af_s_drv.seq_item_port.connect(af_s_sqncer.seq_item_export);
        af_mon.mon_ap.connect(af_agent_exp);
    endfunction
endclass