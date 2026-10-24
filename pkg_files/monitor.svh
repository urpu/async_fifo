class af_monitor extends uvm_monitor;

    `uvm_component_utils(af_monitor)

    virtual async_fifo_intf af_if;

    af_sequence_item af_item;

    af_analysis_sequence_item af_an_item;

    typedef bit [15:0] tdata;

    mailbox #(tdata) m_mbx;
    mailbox #(tdata) s_mbx;

    uvm_analysis_port #(af_analysis_sequence_item) mon_ap;

    function new(string name = "af_monitor", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_resource_db#(virtual async_fifo_intf)::read_by_name(get_full_name(), "af_if", af_if, this)) begin
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name, ".vif" });
        end
        mon_ap = new("mon_ap", this);
        m_mbx = new();
        s_mbx = new();
    endfunction


    virtual task run_phase(uvm_phase phase);
        fork
            mon_manager();
            mon_subordinate();
            in_analysis_port();
        join
    endtask


    virtual task mon_manager();
        tdata tdat;
        forever begin
            wait(af_if.aresetn_1);
            fork
                forever begin
                    @(posedge af_if.aclk_1);
                    if (af_if.m_tvalid && af_if.m_tready) begin
                        tdat = af_if.wr_tdata;
                        m_mbx.put(tdat);
                    end
                end
            join_none
            wait(~af_if.aresetn_1);
            disable fork;
            while(m_mbx.try_get(tdat));
        end          
    endtask

    virtual task mon_subordinate();
        tdata tdat;
        forever begin
            wait(af_if.aresetn_2);
            fork
                forever begin
                    @(posedge af_if.aclk_2);
                    if (af_if.s_tvalid && af_if.s_tready) begin
                        tdat = af_if.rd_tdata;
                        s_mbx.put(tdat);
                    end
                end
            join_none
            wait(~af_if.aresetn_2);
            disable fork;
            while(s_mbx.try_get(tdat));
        end
    endtask


    virtual task in_analysis_port();
        tdata wr_tdata;
        tdata rd_tdata;
        forever begin
            af_an_item = new();
            @(posedge af_if.aclk_2);
            if (af_if.s_tvalid && af_if.s_tready) begin
                m_mbx.get(wr_tdata);
                s_mbx.get(rd_tdata);
                af_an_item.wr_tdata = wr_tdata;
                af_an_item.rd_tdata = rd_tdata;
                mon_ap.write(af_an_item);
            end
        end
    endtask


endclass