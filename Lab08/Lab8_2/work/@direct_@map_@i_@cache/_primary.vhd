library verilog;
use verilog.vl_types.all;
entity Direct_Map_I_Cache is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        nWAIT           : in     vl_logic;
        Invalid_ICache  : in     vl_logic;
        Invalid_ICache_entry: in     vl_logic;
        Prefetch        : in     vl_logic;
        Entry_MVA       : in     vl_logic_vector(26 downto 0);
        TLB_Miss        : in     vl_logic;
        Data_phase_Cacheable: in     vl_logic;
        TLB_Check       : out    vl_logic;
        nMREQ           : in     vl_logic;
        MVA             : in     vl_logic_vector(31 downto 0);
        DI              : out    vl_logic_vector(31 downto 0);
        Cache_nWAIT     : out    vl_logic;
        fill            : out    vl_logic;
        Data_phase_MVA  : in     vl_logic_vector(29 downto 0);
        fill_finish     : in     vl_logic;
        TAG_WAddr       : in     vl_logic_vector(26 downto 0);
        TAG_WE          : in     vl_logic;
        Valid_WAddr     : in     vl_logic_vector(1 downto 0);
        Valid_WE        : in     vl_logic;
        Valid_WData     : in     vl_logic;
        Value_WAddr     : in     vl_logic_vector(4 downto 0);
        Value_WE        : in     vl_logic_vector(3 downto 0);
        Value_WData     : in     vl_logic_vector(31 downto 0);
        Retry           : out    vl_logic;
        Data_phase_Cache_Hit: out    vl_logic;
        Cache_operation_EN: out    vl_logic
    );
end Direct_Map_I_Cache;
