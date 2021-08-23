library verilog;
use verilog.vl_types.all;
entity PA_TAG_unit is
    port(
        clk             : in     vl_logic;
        RAddr           : in     vl_logic_vector(1 downto 0);
        WAddr           : in     vl_logic_vector(1 downto 0);
        WE              : in     vl_logic;
        WData           : in     vl_logic_vector(25 downto 0);
        OE              : in     vl_logic;
        RData           : out    vl_logic_vector(25 downto 0)
    );
end PA_TAG_unit;
