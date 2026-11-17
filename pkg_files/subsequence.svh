class af_m_rand_subsequence extends uvm_sequence;

    `uvm_object_utils(af_m_rand_subsequence)

    function new(string name = "af_m_rand_subsequence");
        super.new(name);
    endfunction
    
    rand int tvalid_one_freq;
    rand int tvalid_zero_freq;


    constraint tvalid_one_freq_range     {tvalid_one_freq  inside {1, 4, 16};}
    constraint tvalid_zero_freq_range    {tvalid_zero_freq inside {1, 4, 16};}

    constraint no_excess_values         {(tvalid_one_freq  == 4)  -> (tvalid_zero_freq == 1);
                                         (tvalid_zero_freq == 4)  -> (tvalid_one_freq  == 1);
                                         (tvalid_one_freq  == 16) -> (tvalid_zero_freq == 1);
                                         (tvalid_zero_freq == 16) -> (tvalid_one_freq  == 1);
    }

    af_m_sequence_item af_m_item = af_m_sequence_item::type_id::create("af_m_item");

    virtual task body();

        af_m_item.tvalid_one_freq  = this.tvalid_one_freq;
        af_m_item.tvalid_zero_freq = this.tvalid_zero_freq;

        $display("--------------------");
        $display("VALID FREQUENCY  %0t", $time());
        $display("m_tvalid  1/0  -  %0d/%0d", tvalid_one_freq, tvalid_zero_freq);
        $display("");


        repeat(1023) begin
            start_item(af_m_item);
            if (!af_m_item.randomize()) begin
                `uvm_fatal("body","Can't randomize, fix your constraints")
            end
            finish_item(af_m_item);
        end

        start_item(af_m_item);
        if (!af_m_item.randomize() with {af_m_item.m_tvalid == 0;}) begin
                `uvm_fatal("body","Can't randomize, fix your constraints")
        end
        finish_item(af_m_item);
        
    endtask

endclass


class af_m_bottleneck_subsequence extends uvm_sequence;

    `uvm_object_utils(af_m_bottleneck_subsequence)

    function new(string name = "af_m_bottleneck_subsequence");
        super.new(name);
    endfunction

    af_m_sequence_item af_m_item = af_m_sequence_item::type_id::create("af_m_item");

    virtual task body();
        
        af_m_item.m_tvalid_freq.constraint_mode(0);

    
        repeat(1024) begin
            start_item(af_m_item);
            if (!af_m_item.randomize() with {af_m_item.m_tvalid == 1;}) begin
                `uvm_fatal("body","Can't randomize, fix your constraints")
            end
            finish_item(af_m_item);
        end

        repeat(AF_DEPTH * 2) begin
            start_item(af_m_item);
            if (!af_m_item.randomize() with {af_m_item.m_tvalid == 0;}) begin
                `uvm_fatal("body","Can't randomize, fix your constraints")
            end
            finish_item(af_m_item);
        end
        
    endtask

endclass



class af_s_rand_subsequence extends uvm_sequence;

    `uvm_object_utils(af_s_rand_subsequence)

    function new(string name = "af_s_rand_subsequence");
        super.new(name);
    endfunction
    

    rand int tready_one_freq;
    rand int tready_zero_freq;

    constraint s_tready_one_freq_range   {tready_one_freq  inside {1, 4, 16};}
    constraint s_tready_zero_freq_range  {tready_zero_freq inside {1, 4, 16};}
    constraint no_excess_values         {(tready_one_freq  == 4)  -> (tready_zero_freq == 1);
                                         (tready_zero_freq == 4)  -> (tready_one_freq  == 1);
                                         (tready_one_freq  == 16) -> (tready_zero_freq == 1);
                                         (tready_zero_freq == 16) -> (tready_one_freq  == 1);
    }

    af_s_sequence_item af_s_item = af_s_sequence_item::type_id::create("af_s_item");

    virtual task body();

        af_s_item.tready_one_freq  = this.tready_one_freq;
        af_s_item.tready_zero_freq = this.tready_zero_freq;

        $display("--------------------");
        $display("READY FREQUENCY  %0t", $time());
        $display("s_tready  1/0  -  %0d/%0d", tready_one_freq, tready_zero_freq);
        $display("");

        repeat(1023) begin
            start_item(af_s_item);
            if (!af_s_item.randomize()) begin
                `uvm_fatal("body","Can't randomize, fix your constraints")
            end
            finish_item(af_s_item);
        end

        start_item(af_s_item);
        if (!af_s_item.randomize() with {af_s_item.s_tready == 1;}) begin
            `uvm_fatal("body","Can't randomize, fix your constraints")
        end
        finish_item(af_s_item);
        
    endtask

endclass