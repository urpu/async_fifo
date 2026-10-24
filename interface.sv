interface async_fifo_intf(input logic aclk_1, aclk_2, aresetn_1, aresetn_2);
  import params_pkg::*;
  logic m_tvalid;
  logic s_tready;
  logic m_tready;
  logic s_tvalid;
  logic [WIDTH-1:0] rd_tdata;
  logic [WIDTH-1:0] wr_tdata;
endinterface