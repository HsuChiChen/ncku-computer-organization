library verilog;
use verilog.vl_types.all;
entity Master01 is
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
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
        HBUSREQM        : out    vl_logic
    );
end Master01;
