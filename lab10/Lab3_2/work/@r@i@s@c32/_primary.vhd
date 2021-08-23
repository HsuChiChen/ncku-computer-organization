library verilog;
use verilog.vl_types.all;
entity RISC32 is
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        HRDATAM         : in     vl_logic_vector(31 downto 0);
        HREADYM         : in     vl_logic;
        HRESPM          : in     vl_logic_vector(1 downto 0);
        HGRANTM         : in     vl_logic;
        HADDRM          : out    vl_logic_vector(31 downto 0);
        HTRANSM         : out    vl_logic_vector(1 downto 0);
        HWRITEM         : out    vl_logic;
        HSIZEM          : out    vl_logic_vector(2 downto 0);
        HBURSTM         : out    vl_logic_vector(2 downto 0);
        HPROTM          : out    vl_logic_vector(3 downto 0);
        HWDATAM         : out    vl_logic_vector(31 downto 0);
        HBUSREQM        : out    vl_logic;
        HLOCKM          : out    vl_logic;
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
        RISCNIRQ        : in     vl_logic;
        RISCNFIQ        : in     vl_logic
    );
end RISC32;
