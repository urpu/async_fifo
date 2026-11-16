class af_m_rand_subsequence extends uvm_sequence;

    `uvm_object_utils(af_m_rand_subsequence)

    function new(string name = "af_m_rand_subsequence");
        super.new(name);
    endfunction
    
    rand int tvalid_one_freq;
    rand int tvalid_zero_freq;
    //rand int tready_one_freq;
    //rand int tready_zero_freq;

    constraint tvalid_one_freq_range     {tvalid_one_freq  inside {1, 4, 16};}
    constraint tvalid_zero_freq_range    {tvalid_zero_freq inside {1, 4, 16};}
    //constraint s_tready_one_freq_range   {tready_one_freq  inside {1, 4, 16};}
    //constraint s_tready_zero_freq_range  {tready_zero_freq inside {1, 4, 16};}
    constraint no_excess_values         {(tvalid_one_freq  == 4)  -> (tvalid_zero_freq == 1);
                                         (tvalid_zero_freq == 4)  -> (tvalid_one_freq  == 1);
                                         (tvalid_one_freq  == 16) -> (tvalid_zero_freq == 1);
                                         (tvalid_zero_freq == 16) -> (tvalid_one_freq  == 1);
                                         //(tready_one_freq  == 4)  -> (tready_zero_freq == 1);
                                         //(tready_zero_freq == 4)  -> (tready_one_freq  == 1);
                                         //(tready_one_freq  == 16) -> (tready_zero_freq == 1);
                                         //(tready_zero_freq == 16) -> (tready_one_freq  == 1);
    }

    af_m_sequence_item af_item = af_s_sequence_item::type_id::create("af_item");

    virtual task body();

        af_item.tvalid_one_freq  = this.tvalid_one_freq;
        af_item.tvalid_zero_freq = this.tvalid_zero_freq;
        af_item.tready_one_freq  = this.tready_one_freq;
        af_item.tready_zero_freq = this.tready_zero_freq;

        repeat(1024) begin
            start_item(af_item);
            if (!af_item.randomize()) begin
                `uvm_fatal("body","Can't randomize, fix your constraints")
            end
            $display("--------------------");
            $display("VALID/READY FREQUENCY OF VALUES %t", $time());
            $display("m_tvalid 1/0 - %d/%d", af_seq.tvalid_one_freq, af_seq.tvalid_zero_freq);
            $display("s_tready 1/0 - %d/%d", af_seq.tready_one_freq, af_seq.tready_zero_freq);
            $display("");
            finish_item(af_item);
        end
        
    endtask

endclass


class af_overload_and_clear_subsequence extends uvm_sequence;

    `uvm_object_utils(af_overload_subsequence)

    function new(string name = "af_overload_subsequence");
        super.new(name);
    endfunction

    af_sequence_item af_item = af_sequence_item::type_id::create("af_item");

    virtual task body();
        
        af_item.m_tvalid_freq.constraint_mode(0);
        af_item.s_tready_freq.constraint_mode(0);

        af_item.m_tvalid = 1;
        af_item.s_tready = 0;

        repeat(1024) begin
            start_item(af_item);
            if (!af_item.randomize()) begin
                `uvm_fatal("body","Can't randomize, fix your constraints")
            end
            finish_item(af_item);
        end

        af_item.m_tvalid = 0;
        af_item.s_tready = 1;

        repeat(AF_DEPTH * 4) begin
            start_item(af_item);
            if (!af_item.randomize()) begin
                `uvm_fatal("body","Can't randomize, fix your constraints")
            end
            finish_item(af_item);
        end
        
    endtask

endclass