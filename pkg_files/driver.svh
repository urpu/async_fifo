class af_driver extends uvm_driver#(af_sequence_item);
    `uvm_component_utils(af_driver)

    virtual async_fifo_intf af_if;

    af_sequence_item af_item;

    function new(string name = "af_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_resource_db#(virtual async_fifo_intf)::read_by_name(get_full_name(), "af_if", af_if, this)) begin
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name, ".vif" });
        end
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        fork
            drive_manager();
            drive_subordinate();
        join
    endtask

    virtual task drive_manager();
        forever begin
            wait(af_if.aresetn_1);
            fork
                forever begin
                    @(posedge af_if.aclk_1);
                    if (af_if.m_tvalid && ~af_if.m_tready) begin
                    end
                    else begin
                        seq_item_port.get_next_item(af_item);
                        af_if.m_tvalid <= af_item.m_tvalid;
                        af_if.wr_tdata <= af_item.wr_tdata;
                        seq_item_port.item_done();
                    end
                end
            join_none
            wait(~af_if.aresetn_1);
            disable fork;
        end
    endtask

    virtual task drive_subordinate();
        forever begin
            wait(af_if.aresetn_2);
            fork
                forever begin
                    @(posedge af_if.aclk_2);
                    seq_item_port.get_next_item(af_item);
                    af_if.s_tready <= af_item.s_tready;
                    seq_item_port.item_done();
                end
            join_none
            wait(~af_if.aresetn_2);
            disable fork;
        end
    endtask

endclass