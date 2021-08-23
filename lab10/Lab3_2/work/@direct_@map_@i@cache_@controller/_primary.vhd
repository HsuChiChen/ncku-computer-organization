library verilog;
use verilog.vl_types.all;
entity Direct_Map_ICache_Controller is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        nWAIT           : in     vl_logic;
        TLB_Miss        : in     vl_logic;
        Data_phase_Cacheable: in     vl_logic;
        TLB_Check       : out    vl_logic;
        Cache_nWAIT     : out    vl_logic;
        Invalid_ICache  : in     vl_logic;
        Invalid_ICache_entry: in     vl_logic;
        Prefetch        : in     vl_logic;
        Entry_MVA       : in     vl_logic_vector(2 downto 0);
        Data_phase_MVA  : in     vl_logic_vector(2 downto 0);
        Data_phase_Cache_Hit: in     vl_logic;
        Cache_operation_EN: out    vl_logic;
        Invalid         : out    vl_logic;
        Data_phase_OE   : out    vl_logic;
        Invalid_Valid_WE: out    vl_logic;
        Invalid_Valid_WData: out    vl_logic;
        fill            : out    vl_logic;
        fill_finish     : in     vl_logic;
        Retry           : out    vl_logic
    );
end Direct_Map_ICache_Controller;
