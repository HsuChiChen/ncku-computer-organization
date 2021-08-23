library verilog;
use verilog.vl_types.all;
entity ValidRAM is
    port(
        rst_n           : in     vl_logic;
        clk             : in     vl_logic;
        RA              : in     vl_logic_vector(1 downto 0);
        WA              : in     vl_logic_vector(1 downto 0);
        DI              : in     vl_logic_vector(0 downto 0);
        DO              : out    vl_logic_vector(0 downto 0);
        CSn             : in     vl_logic;
        WEn             : in     vl_logic;
        OEn             : in     vl_logic
    );
end ValidRAM;
