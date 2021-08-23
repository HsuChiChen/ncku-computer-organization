library verilog;
use verilog.vl_types.all;
entity testMISRWrapper is
    generic(
        ST_NORMAL       : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        ST_WAIT         : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        ST_ERROR1       : vl_logic_vector(0 to 1) := (Hi1, Hi0);
        ST_ERROR2       : vl_logic_vector(0 to 1) := (Hi1, Hi1)
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
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ST_NORMAL : constant is 1;
    attribute mti_svvh_generic_type of ST_WAIT : constant is 1;
    attribute mti_svvh_generic_type of ST_ERROR1 : constant is 1;
    attribute mti_svvh_generic_type of ST_ERROR2 : constant is 1;
end testMISRWrapper;
