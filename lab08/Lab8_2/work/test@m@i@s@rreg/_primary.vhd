library verilog;
use verilog.vl_types.all;
entity testMISRreg is
    port(
        nWAIT           : in     vl_logic;
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        reg_num         : in     vl_logic_vector(2 downto 0);
        write_data      : in     vl_logic_vector(31 downto 0);
        write_mask      : in     vl_logic_vector(31 downto 0);
        write_enable    : in     vl_logic;
        read_data       : out    vl_logic_vector(31 downto 0);
        core_out        : in     vl_logic_vector(189 downto 0)
    );
end testMISRreg;
