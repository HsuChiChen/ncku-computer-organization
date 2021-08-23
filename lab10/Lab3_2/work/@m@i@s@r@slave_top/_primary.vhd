library verilog;
use verilog.vl_types.all;
entity MISRSlave_top is
    port(
        nWAIT           : in     vl_logic;
        HCLK            : in     vl_logic;
        HRESET_n        : in     vl_logic;
        HADDRS          : in     vl_logic_vector(31 downto 0);
        HTRANSS         : in     vl_logic_vector(1 downto 0);
        HWRITES         : in     vl_logic;
        HSIZES          : in     vl_logic_vector(2 downto 0);
        HWDATAS         : in     vl_logic_vector(31 downto 0);
        HSELS           : in     vl_logic;
        HREADYS         : in     vl_logic;
        HRDATAS         : out    vl_logic_vector(31 downto 0);
        HREADYOUTS      : out    vl_logic;
        HRESPS          : out    vl_logic_vector(1 downto 0);
        core_out        : in     vl_logic_vector(189 downto 0)
    );
end MISRSlave_top;
