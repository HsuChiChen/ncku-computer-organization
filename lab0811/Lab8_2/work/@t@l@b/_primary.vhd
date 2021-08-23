library verilog;
use verilog.vl_types.all;
entity TLB is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        nWAIT           : in     vl_logic;
        Invalidat_TLB   : in     vl_logic;
        Invalidat_TLB_MVA: in     vl_logic;
        TLB_Entry_MVA   : in     vl_logic_vector(21 downto 0);
        TLB_EN          : in     vl_logic;
        nMREQ           : in     vl_logic;
        MVA             : in     vl_logic_vector(31 downto 0);
        Descriptor      : out    vl_logic_vector(31 downto 0);
        Domain          : out    vl_logic_vector(3 downto 0);
        TLB_nWAIT       : out    vl_logic;
        fill            : out    vl_logic;
        fill_finish     : in     vl_logic;
        TAG_WAddr       : in     vl_logic_vector(21 downto 0);
        TAG_WE          : in     vl_logic;
        Valid_WAddr     : in     vl_logic_vector(5 downto 0);
        Valid_WE        : in     vl_logic;
        Valid_WData     : in     vl_logic;
        Value_WAddr     : in     vl_logic_vector(5 downto 0);
        Value_WE        : in     vl_logic;
        Value_WData     : in     vl_logic_vector(35 downto 0);
        Retry           : out    vl_logic;
        TLB_Hit         : out    vl_logic;
        TLB_operation_EN: out    vl_logic
    );
end TLB;
