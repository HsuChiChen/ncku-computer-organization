library verilog;
use verilog.vl_types.all;
entity Arbiter is
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        HTRANS          : in     vl_logic_vector(1 downto 0);
        HBURST          : in     vl_logic_vector(2 downto 0);
        HREADY          : in     vl_logic;
        HRESP           : in     vl_logic_vector(1 downto 0);
        HSPLIT          : in     vl_logic_vector(4 downto 0);
        HBUSREQ0        : in     vl_logic;
        HBUSREQ1        : in     vl_logic;
        HBUSREQ2        : in     vl_logic;
        HBUSREQ3        : in     vl_logic;
        HBUSREQ4        : in     vl_logic;
        HLOCK0          : in     vl_logic;
        HLOCK1          : in     vl_logic;
        HLOCK2          : in     vl_logic;
        HLOCK3          : in     vl_logic;
        HLOCK4          : in     vl_logic;
        HGRANT0         : out    vl_logic;
        HGRANT1         : out    vl_logic;
        HGRANT2         : out    vl_logic;
        HGRANT3         : out    vl_logic;
        HGRANT4         : out    vl_logic;
        HMASTER         : out    vl_logic_vector(4 downto 0);
        HMASTLOCK       : out    vl_logic
    );
end Arbiter;
