
class af_vseq_base extends uvm_sequence;
    `uvm_object_utils(af_vseq_base)
    `uvm_declare_p_sequencer(af_vsequencer)

    af_m_sequencer af_m_seqer;
    af_s_sequencer af_s_seqer;

    function new(string name = "af_vseq_base");
        super.new(name);
    endfunction

    virtual task body();
        af_m_seqer = p_sequencer.af_m_seqer;
        af_s_seqer = p_sequencer.af_s_seqer;
    endtask
    
endclass

class af_vseq_1 extends af_vseq_base;
    `uvm_object_utils(af_vseq_1)

    function new(string name = "af_vseq_1");
        super.new(name);
    endfunction

    af_m_rand_subsequence af_m_rand_seq = af_m_rand_subsequence::type_id::create("af_m_rand_seq");
    af_s_rand_subsequence af_s_rand_seq = af_s_rand_subsequence::type_id::create("af_s_rand_seq");
    af_m_bottleneck_subsequence af_m_btl_seq = af_m_bottleneck_subsequence::type_id::create("af_m_btl_seq");

    virtual task body();
        super.body();
        fork
            af_m_btl_seq.start(af_m_seqer);
            begin
                if (!af_s_rand_seq.randomize() with {af_s_rand_seq.tready_one_freq == 4;}) begin
                    `uvm_fatal("body","Can't randomize, fix your constraints")
                end
                af_s_rand_seq.start(af_s_seqer);
            end
        join

        repeat(256) begin
            rand_test();
        end
    endtask

    virtual task rand_test();
        fork
            begin
                if (!af_s_rand_seq.randomize()) begin
                    `uvm_fatal("body","Can't randomize, fix your constraints")
                end
                af_s_rand_seq.start(af_s_seqer);
            end
            begin
                if (!af_m_rand_seq.randomize()) begin
                    `uvm_fatal("body","Can't randomize, fix your constraints")
                end
                af_m_rand_seq.start(af_m_seqer);
            end
        join
    endtask


endclass

