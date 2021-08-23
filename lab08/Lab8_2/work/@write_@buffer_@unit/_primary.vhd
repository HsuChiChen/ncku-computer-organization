library verilog;
use verilog.vl_types.all;
entity Write_Buffer_Unit is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        nWAIT           : in     vl_logic;
        Drain_WB        : in     vl_logic;
        Write_Back      : in     vl_logic;
        Write_Back_Addr : in     vl_logic_vector(27 downto 0);
        Write_Back_Data : in     vl_logic_vector(127 downto 0);
        Write_Back_nWAIT: out    vl_logic;
        Write_Buffer_Enable: in     vl_logic;
        Data_phase_PA   : in     vl_logic_vector(31 downto 0);
        Data_phase_nTRANS: in     vl_logic;
        Data_phase_MAS  : in     vl_logic_vector(1 downto 0);
        WB_nWAIT        : out    vl_logic;
        DO              : in     vl_logic_vector(31 downto 0);
        WB_HRDATAM      : in     vl_logic_vector(31 downto 0);
        WB_HREADYM      : in     vl_logic;
        WB_HADDRM       : out    vl_logic_vector(31 downto 0);
        WB_HTRANSM      : out    vl_logic_vector(1 downto 0);
        WB_HWRITEM      : out    vl_logic;
        WB_HSIZEM       : out    vl_logic_vector(2 downto 0);
        WB_HBURSTM      : out    vl_logic_vector(2 downto 0);
        WB_HPROTM       : out    vl_logic_vector(3 downto 0);
        WB_HWDATAM      : out    vl_logic_vector(31 downto 0);
        WB_HBUSREQM     : out    vl_logic;
        WB_HLOCKM       : out    vl_logic
    );
end Write_Buffer_Unit;
