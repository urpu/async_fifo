`include "uvm_macros.svh"
`include "test_pkg.sv"
module testbench;
    import uvm_pkg::*;
    import test_pkg::*;
    import params_pkg::*;

    bit aclk_1, aclk_2;
    bit aresetn_1, aresetn_2;

    async_fifo_intf af_if 
                   (.aclk_1(aclk_1), .aclk_2(aclk_2),
                    .aresetn_1(aresetn_1), .aresetn_2(aresetn_2));


    async_fifo #(.WIDTH(WIDTH), .DEPTH(DEPTH))
               as_fifo 
               (.aclk_1   (aclk_1),
                .aclk_2   (aclk_2),
                .aresetn_1(aresetn_1),
                .aresetn_2(aresetn_2),
                .m_tready (af_if.m_tready),
                .m_tvalid (af_if.m_tvalid),
                .s_tready (af_if.s_tready),
                .s_tvalid (af_if.s_tvalid),
                .rd_tdata (af_if.rd_tdata),
                .wr_tdata (af_if.wr_tdata));


    initial begin
        aclk_1 = 0;
        forever begin
            #5;
            aclk_1 = ~aclk_1;
        end
    end

    initial begin
        aclk_2 = 0;
        #2;
        forever begin
            #5;
            aclk_2 = ~aclk_2;
        end
    end


    initial begin
        repeat(100) @(posedge aclk_1);
        aresetn_1 <= 0;
        repeat (4)  @(posedge aclk_1);
        aresetn_1 <= 1;
    end

    initial begin
        repeat(100) @(posedge aclk_2);
        aresetn_2 <= 0;
        repeat (4)  @(posedge aclk_2);
        aresetn_2 <= 1;
    end


    initial begin
        repeat(100000) @(posedge aclk_1);
        $display("Timeout!");
        $stop();
    end

    initial begin
        uvm_resource_db#(virtual async_fifo_intf)::set("*", "af_if", af_if);
        run_test("af_test_base");
    end

endmodule