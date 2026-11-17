interface async_fifo_intf(input logic aclk_1, aclk_2, aresetn_1, aresetn_2);
  import params_pkg::*;
  logic m_tvalid;
  logic s_tready;
  logic m_tready;
  logic s_tvalid;
  logic [AF_WIDTH-1:0] rd_tdata;
  logic [AF_WIDTH-1:0] wr_tdata;


  property data_stable_if_no_handshake(aclk, aresetn, tvalid, tready, tdata);
      @(posedge aclk) disable iff (~aresetn)
      (tvalid && ~tready) |=> $stable(tdata);
  endproperty

  assert property(data_stable_if_no_handshake(aclk_1, aresetn_1, m_tvalid, m_tready, wr_tdata));
  assert property(data_stable_if_no_handshake(aclk_2, aresetn_2, s_tvalid, s_tready, rd_tdata));
  
endinterface