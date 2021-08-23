library verilog;
use verilog.vl_types.all;
entity TLB_Comparison is
    port(
        Hit             : in     vl_logic;
        Valid           : in     vl_logic;
        TLB_Hit         : out    vl_logic
    );
end TLB_Comparison;
