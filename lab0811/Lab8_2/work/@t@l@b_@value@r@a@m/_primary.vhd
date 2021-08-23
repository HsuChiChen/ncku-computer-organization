library verilog;
use verilog.vl_types.all;
entity TLB_ValueRAM is
    port(
        clk             : in     vl_logic;
        RA              : in     vl_logic_vector(5 downto 0);
        WA              : in     vl_logic_vector(5 downto 0);
        DI              : in     vl_logic_vector(35 downto 0);
        DO              : out    vl_logic_vector(35 downto 0);
        CSn             : in     vl_logic;
        WEn             : in     vl_logic;
        OEn             : in     vl_logic
    );
end TLB_ValueRAM;
