class af_top_sequence extends uvm_sequence;

    `uvm_object_utils(af_top_sequence)

    function new(string name = "af_top_sequence");
        super.new(name);
    endfunction

    af_rand_subsequence af_rand_seq = af_rand_subsequence::type_id::create("af_rand_seq");

    af_overload_and_clear_subsequence af_ov_cl_seq = af_overload_and_clear_subsequence::type_id::create("af_ov_cl_seq");

    virtual task body;

        af_ov_cl_seq.start(m_sequencer);

        repeat(32) begin
            if (!af_rand_seq.randomize()) begin
                `uvm_fatal("body","Can't randomize, fix your constraints")
            end
            af_seq.start(m_sequencer);
        end

    endtask

endclass


class vseq_base extends uvm_sequence;
    `uvm_object_utils(vseq_base)
    `uvm_declare_p_sequencer(af_vsequencer)

    af_m_sequencer af_m_sqncer;
    af_s_sequencer af_s_sqncer;

    function new(string name = "vseq_base");
        super.new(name);
    endfunction

    virtual task body();
        af_m_sqncer = p_sequencer.af_m_sqncer;
        af_s_sqncer = p_sequencer.af_s_sqncer;
    endtask
    
endclass
