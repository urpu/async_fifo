class af_rand_subsequence extends uvm_sequence;

    `uvm_object_utils(af_rand_subsequence)

    function new(string name = "af_rand_subsequence");
        super.new(name);
    endfunction
    
    rand int tvalid_one_freq;
    rand int tvalid_zero_freq;
    rand int tready_one_freq;
    rand int tready_zero_freq;

    constraint tvalid_one_freq_range     {tvalid_one_freq  inside {1, 4, 16};}
    constraint tvalid_zero_freq_range    {tvalid_zero_freq inside {1, 4, 16};}
    constraint s_tready_one_freq_range   {tready_one_freq  inside {1, 4, 16};}
    constraint s_tready_zero_freq_range  {tready_zero_freq inside {1, 4, 16};}
    constraint no_excess_values         {(tvalid_one_freq  == 4)  -> (tvalid_zero_freq == 1);
                                         (tvalid_zero_freq == 4)  -> (tvalid_one_freq  == 1);
                                         (tvalid_one_freq  == 16) -> (tvalid_zero_freq == 1);
                                         (tvalid_zero_freq == 16) -> (tvalid_one_freq  == 1);
                                         (tready_one_freq  == 4)  -> (tready_zero_freq == 1);
                                         (tready_zero_freq == 4)  -> (tready_one_freq  == 1);
                                         (tready_one_freq  == 16) -> (tready_zero_freq == 1);
                                         (tready_zero_freq == 16) -> (tready_one_freq  == 1);}

    af_sequence_item af_item = af_sequence_item::type_id::create("af_item");

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
            finish_item(af_item);
        end
        
    endtask

endclass