module async_fifo
#(parameter WIDTH = 16,
  parameter DEPTH = 8)

  (input  logic aclk_1, aclk_2, aresetn_1, aresetn_2,

   input  logic m_tvalid,
   output logic m_tready,
   input  logic [WIDTH - 1:0] wr_tdata,   
   output logic s_tvalid,
   input  logic s_tready,
   output logic [WIDTH - 1:0] rd_tdata);

   //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
   localparam PTR_DEPTH = $clog2(DEPTH);


   // write and read pointers
   logic [PTR_DEPTH:0] wr_pnter, rd_pnter;
   // pointers converted to gray code
   logic [PTR_DEPTH:0] gr_wr_pnter, gr_rd_pnter;
   // synchronized pointers
   logic [PTR_DEPTH:0] wq_rd_pnter, rq_wr_pnter;
   // double flip-flops to synchronize pointers
   logic [PTR_DEPTH:0] sync_wr_pnter [1:0];
   logic [PTR_DEPTH:0] sync_rd_pnter [1:0];

   logic pop, push, full, empty;
   logic [WIDTH - 1:0] data [DEPTH - 1:0];

   //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
   // write pointer
   always_ff @(posedge aclk_1)
       if (~aresetn_1)
           wr_pnter <= '0;
       else if (push) begin
           if (wr_pnter[PTR_DEPTH - 1:0] == DEPTH-1) begin
               wr_pnter <= {~wr_pnter[PTR_DEPTH], {(PTR_DEPTH){1'b0}}};
           end
           else
               wr_pnter <= wr_pnter + 1'b1;
       end

    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    // read pointer
    always_ff @(posedge aclk_2)
        if (~aresetn_2)
            rd_pnter <= '0;
        else if (pop) begin
            if (rd_pnter[PTR_DEPTH- 1:0] == DEPTH - 1)
                rd_pnter <= {~rd_pnter[PTR_DEPTH], {(PTR_DEPTH){1'b0}}};
            else
                rd_pnter <= rd_pnter + 1'b1;
        end
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    // write/read data
    always_ff @(posedge aclk_1)
        if (push)
            data[wr_pnter[PTR_DEPTH-1:0]] <= wr_tdata;

    assign rd_tdata = data[rd_pnter[PTR_DEPTH-1:0]];

    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    // convert to gray code
    assign gr_wr_pnter = (wr_pnter >> 1) ^ wr_pnter;
    assign gr_rd_pnter = (rd_pnter >> 1) ^ rd_pnter;

    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    // synchronizers
    always_ff @(posedge aclk_1)
        if (~aresetn_1)
            {sync_rd_pnter[1], sync_rd_pnter[0]} <= '0;
        else
            {sync_rd_pnter[1], sync_rd_pnter[0]} <= {sync_rd_pnter[0], gr_rd_pnter};

    always_ff @(posedge aclk_2)
        if (~aresetn_2)
            {sync_wr_pnter[1], sync_wr_pnter[0]} <= '0;
        else
            {sync_wr_pnter[1], sync_wr_pnter[0]} <= {sync_wr_pnter[0], gr_wr_pnter};

    assign wq_rd_pnter = sync_rd_pnter[1];
    assign rq_wr_pnter = sync_wr_pnter[1];

    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    // full/empty signals
    assign full  = (gr_wr_pnter == {~wq_rd_pnter[PTR_DEPTH : PTR_DEPTH-1], wq_rd_pnter[PTR_DEPTH-2:0]});
    assign empty = (gr_rd_pnter == rq_wr_pnter);

    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    // pop/push valid/ready signals
    assign push  = ~full && m_tvalid;
    assign m_tready = ~full;

    assign pop   = ~empty && s_tready;
    assign s_tvalid = ~empty;
    


                
endmodule