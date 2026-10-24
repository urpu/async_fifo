class af_sequence_item extends uvm_sequence_item;

    `uvm_object_utils(af_sequence_item)

    function new (string name = "af_sequence_item");
        super.new(name);
    endfunction

    int tvalid_one_freq  = 1;
    int tvalid_zero_freq = 1;
    int tready_one_freq  = 1;
    int tready_zero_freq = 1;


    rand bit m_tvalid;
    rand bit s_tready;
    rand bit [WIDTH-1:0] wr_tdata;

    constraint m_tvalid_freq {m_tvalid dist {1 := tvalid_one_freq, 0 := tvalid_zero_freq};}
    constraint s_tready_freq {s_tready dist {1 := tready_one_freq, 0 := tready_zero_freq};}

endclass


class af_analysis_sequence_item extends uvm_sequence_item;

    `uvm_object_utils(af_analysis_sequence_item)

    function new(string name = "af_analysis_sequence_item");
        super.new(name);
    endfunction

    bit [WIDTH-1:0] wr_tdata, rd_tdata;
    
endclass