library verilog;
use verilog.vl_types.all;
entity TLB_Controller is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        nWAIT           : in     vl_logic;
        TLB_EN          : in     vl_logic;
        TLB_nWAIT       : out    vl_logic;
        Invalid_TLB     : in     vl_logic;
        Invalid_TLB_MVA : in     vl_logic;
        TLB_Hit         : in     vl_logic;
        TLB_operation_EN: out    vl_logic;
        Invalid         : out    vl_logic;
        Invalid_Valid_WE: out    vl_logic;
        Invalid_Valid_WData: out    vl_logic;
        fill            : out    vl_logic;
        fill_finish     : in     vl_logic;
        Retry           : out    vl_logic
    );
end TLB_Controller;
