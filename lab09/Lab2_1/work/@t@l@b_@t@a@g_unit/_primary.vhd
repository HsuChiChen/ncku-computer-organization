library verilog;
use verilog.vl_types.all;
entity TLB_TAG_unit is
    port(
        clk             : in     vl_logic;
        nMREQ           : in     vl_logic;
        RAddr           : in     vl_logic_vector(21 downto 0);
        WAddr           : in     vl_logic_vector(21 downto 0);
        WE              : in     vl_logic;
        Hit             : out    vl_logic
    );
end TLB_TAG_unit;
