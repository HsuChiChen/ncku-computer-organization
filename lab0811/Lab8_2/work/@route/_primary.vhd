library verilog;
use verilog.vl_types.all;
entity Route is
    port(
        Data_phase_EXT_Enable: in     vl_logic;
        EXT_DI          : in     vl_logic_vector(31 downto 0);
        Cache_DI        : in     vl_logic_vector(31 downto 0);
        DI              : out    vl_logic_vector(31 downto 0)
    );
end Route;
