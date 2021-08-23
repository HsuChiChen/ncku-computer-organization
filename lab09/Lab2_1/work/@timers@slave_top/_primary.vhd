library verilog;
use verilog.vl_types.all;
entity TimersSlave_top is
    port(
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
        IRQ             : out    vl_logic;
        ACK             : in     vl_logic
    );
end TimersSlave_top;
