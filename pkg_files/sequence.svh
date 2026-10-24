class af_top_sequence extends uvm_sequence;

    `uvm_object_utils(af_top_sequence)

    function new(string name = "af_top_sequence");
        super.new(name);
    endfunction

    af_rand_subsequence af_seq = af_rand_subsequence::type_id::create("af_seq");

    virtual task body;

        repeat(32) begin
            if (!af_seq.randomize()) begin
                `uvm_fatal("body","Can't randomize, fix your constraints")
            end
            $display("--------------------");
            $display("VALID/READY FREQUENCY OF VALUES %t", $time());
            $display("m_tvalid 1/0 - %d/%d", af_seq.tvalid_one_freq, af_seq.tvalid_zero_freq);
            $display("s_tready 1/0 - %d/%d", af_seq.tready_one_freq, af_seq.tready_zero_freq);
            $display("");
            af_seq.start(m_sequencer);
        end

    endtask

endclass