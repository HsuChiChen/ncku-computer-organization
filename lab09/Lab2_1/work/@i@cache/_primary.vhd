library verilog;
use verilog.vl_types.all;
entity ICache is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        nWAIT           : in     vl_logic;
        Cache_Enable    : in     vl_logic;
        Round_Robin     : in     vl_logic;
        Invalid_ICache  : in     vl_logic;
        Invalid_ICache_entry: in     vl_logic;
        Prefetch        : in     vl_logic;
        Entry_MVA       : in     vl_logic_vector(26 downto 0);
        TLB_Miss        : in     vl_logic;
        Data_phase_PA   : in     vl_logic_vector(26 downto 0);
        Data_phase_Cacheable: in     vl_logic;
        TLB_Check       : out    vl_logic;
        Data_phase_nTRANS: in     vl_logic;
        nMREQ           : in     vl_logic;
        MVA             : in     vl_logic_vector(31 downto 0);
        DI              : out    vl_logic_vector(31 downto 0);
        Cache_nWAIT     : out    vl_logic;
        HRDATAM         : in     vl_logic_vector(31 downto 0);
        HREADYM         : in     vl_logic;
        HADDRM          : out    vl_logic_vector(31 downto 0);
        HTRANSM         : out    vl_logic_vector(1 downto 0);
        HWRITEM         : out    vl_logic;
        HSIZEM          : out    vl_logic_vector(2 downto 0);
        HBURSTM         : out    vl_logic_vector(2 downto 0);
        HPROTM          : out    vl_logic_vector(3 downto 0);
        HWDATAM         : out    vl_logic_vector(31 downto 0);
        HBUSREQM        : out    vl_logic;
        HLOCKM          : out    vl_logic
    );
end ICache;
