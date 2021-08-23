library verilog;
use verilog.vl_types.all;
entity Write_Buffer_StatusRAM is
    port(
        clk             : in     vl_logic;
        RA              : in     vl_logic_vector(1 downto 0);
        WA              : in     vl_logic_vector(1 downto 0);
        DI              : in     vl_logic_vector(3 downto 0);
        DO              : out    vl_logic_vector(3 downto 0);
        CSn             : in     vl_logic;
        WEn             : in     vl_logic;
        OEn             : in     vl_logic
    );
end Write_Buffer_StatusRAM;
