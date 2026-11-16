class af_m_sequence_item extends uvm_sequence_item;

    `uvm_object_utils(af_m_sequence_item)

    function new (string name = "af_m_sequence_item");
        super.new(name);
    endfunction

    rand int tvalid_one_freq;
    rand int tvalid_zero_freq;


    rand bit m_tvalid;
    rand bit [AF_WIDTH-1:0] wr_tdata;

    constraint m_tvalid_freq {m_tvalid dist {1 := tvalid_one_freq, 0 := tvalid_zero_freq};}
    constraint s_tready_freq {s_tready dist {1 := tready_one_freq, 0 := tready_zero_freq};}

endclass


class af_s_sequence_item extends uvm_sequence_item;

    `uvm_object_utils(af_s_sequence_item)

    function new (string name = "af_s_sequence_item");
        super.new(name);
    endfunction

    rand int tready_one_freq;
    rand int tready_zero_freq;

    rand bit s_tready;


    constraint m_tvalid_freq {m_tvalid dist {1 := tvalid_one_freq, 0 := tvalid_zero_freq};}
    constraint s_tready_freq {s_tready dist {1 := tready_one_freq, 0 := tready_zero_freq};}

endclass


class af_analysis_sequence_item extends uvm_sequence_item;

    `uvm_object_utils(af_analysis_sequence_item)

    function new(string name = "af_analysis_sequence_item");
        super.new(name);
    endfunction

    bit [AF_WIDTH-1:0] wr_tdata, rd_tdata;
    
endclass