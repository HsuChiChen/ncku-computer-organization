library verilog;
use verilog.vl_types.all;
entity EXT is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        nWAIT           : in     vl_logic;
        nInsData        : in     vl_logic;
        Data_phase_EXT_Enable: in     vl_logic;
        Data_phase_PA   : in     vl_logic_vector(31 downto 0);
        Data_phase_nTRANS: in     vl_logic;
        Data_phase_LOCK : in     vl_logic;
        Data_phase_MAS  : in     vl_logic_vector(1 downto 0);
        Data_phase_nRW  : in     vl_logic;
        DI              : out    vl_logic_vector(31 downto 0);
        EXT_nWAIT       : out    vl_logic;
        EXT_ABORT       : out    vl_logic;
        DO              : in     vl_logic_vector(31 downto 0);
        HRDATAM         : in     vl_logic_vector(31 downto 0);
        HREADYM         : in     vl_logic;
        HRESPM          : in     vl_logic_vector(1 downto 0);
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
end EXT;
