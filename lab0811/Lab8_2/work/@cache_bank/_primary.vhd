library verilog;
use verilog.vl_types.all;
entity Cache_bank is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        RAddr           : in     vl_logic_vector(1 downto 0);
        WAddr           : in     vl_logic_vector(1 downto 0);
        WE              : in     vl_logic_vector(3 downto 0);
        OE              : in     vl_logic;
        WData           : in     vl_logic_vector(31 downto 0);
        RData           : out    vl_logic_vector(31 downto 0)
    );
end Cache_bank;
