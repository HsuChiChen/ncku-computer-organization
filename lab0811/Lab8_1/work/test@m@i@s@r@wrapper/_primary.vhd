library verilog;
use verilog.vl_types.all;
entity testMISRWrapper is
    generic(
        ST_NORMAL       : integer := 0;
        ST_WAIT         : integer := 1;
        ST_ERROR1       : integer := 2;
        ST_ERROR2       : integer := 3
    );
    port(
        HCLK            : in     vl_logic;
        HRESET_n        : in     vl_logic;
        HADDR           : in     vl_logic_vector(31 downto 0);
        HTRANS          : in     vl_logic_vector(1 downto 0);
        HWRITE          : in     vl_logic;
        HSIZE           : in     vl_logic_vector(2 downto 0);
        HWDATA          : in     vl_logic_vector(31 downto 0);
        HSEL_slave      : in     vl_logic;
        HREADY_in       : in     vl_logic;
        HRDATA          : out    vl_logic_vector(31 downto 0);
        HREADY_out      : out    vl_logic;
        HRESP           : out    vl_logic_vector(1 downto 0);
        IP_SEL          : out    vl_logic;
        IP_ADDR         : out    vl_logic_vector(31 downto 0);
        IP_WRITE        : out    vl_logic;
        IP_MASK         : out    vl_logic_vector(31 downto 0);
        IP_WDATA        : out    vl_logic_vector(31 downto 0);
        IP_RDATA        : in     vl_logic_vector(31 downto 0);
        IP_READY        : in     vl_logic;
        IP_ERROR        : in     vl_logic
    );
end testMISRWrapper;
