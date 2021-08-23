library verilog;
use verilog.vl_types.all;
entity DValue_unit is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        RAddr           : in     vl_logic_vector(4 downto 0);
        WAddr           : in     vl_logic_vector(4 downto 0);
        WE              : in     vl_logic_vector(3 downto 0);
        WData           : in     vl_logic_vector(31 downto 0);
        Write_Back_OE   : in     vl_logic_vector(1 downto 0);
        OE              : in     vl_logic;
        Write_Back_Data : out    vl_logic_vector(127 downto 0);
        RData           : out    vl_logic_vector(31 downto 0)
    );
end DValue_unit;
