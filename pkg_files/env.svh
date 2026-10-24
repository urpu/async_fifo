class af_env extends uvm_env;

    `uvm_component_utils(af_env)

    af_agent agent;
    af_scoreboard scr;

    function new(string name = "af_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = af_agent::type_id::create("agent", this);
        scr   = af_scoreboard::type_id::create("scr", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.af_agent_exp.connect(scr.af_scr_imp);
    endfunction
endclass