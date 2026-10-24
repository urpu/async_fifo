class af_test_base extends uvm_test;

    `uvm_component_utils(af_test_base)

    af_env env;

    af_top_sequence sqce;

    function new(string name = "af_test_base", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = af_env::type_id::create("env", this);
        sqce = af_top_sequence::type_id::create("sqce", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        sqce.start(env.agent.af_sequencer);
        phase.drop_objection(this);
    endtask

endclass