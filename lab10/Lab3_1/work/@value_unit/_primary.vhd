library verilog;
use verilog.vl_types.all;
entity Value_unit is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        RAddr           : in     vl_logic_vector(4 downto 0);
        WAddr           : in     vl_logic_vector(4 downto 0);
        WE              : in     vl_logic_vector(3 downto 0);
        WData           : in     vl_logic_vector(31 downto 0);
        OE              : in     vl_logic;
        RData           : out    vl_logic_vector(31 downto 0)
    );
end Value_unit;
