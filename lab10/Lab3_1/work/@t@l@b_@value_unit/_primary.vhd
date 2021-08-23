library verilog;
use verilog.vl_types.all;
entity TLB_Value_unit is
    port(
        clk             : in     vl_logic;
        nMREQ           : in     vl_logic;
        RAddr           : in     vl_logic_vector(5 downto 0);
        WAddr           : in     vl_logic_vector(5 downto 0);
        WE              : in     vl_logic;
        WData           : in     vl_logic_vector(35 downto 0);
        RData           : out    vl_logic_vector(35 downto 0)
    );
end TLB_Value_unit;
