class af_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(af_scoreboard)

    uvm_analysis_imp #(af_analysis_sequence_item, af_scoreboard) af_scr_imp;

    function new(string name = "af_scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        af_scr_imp = new("af_scr_imp", this);
    endfunction

    virtual function void write(af_analysis_sequence_item af_an_item);
        if (af_an_item.wr_tdata != af_an_item.rd_tdata) begin
            `uvm_error("scoreboard", $sformatf("error, expected: %h, actual: %h", af_an_item.rd_tdata, af_an_item.wr_tdata))
        end
    endfunction


endclass