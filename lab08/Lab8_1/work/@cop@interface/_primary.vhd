library verilog;
use verilog.vl_types.all;
entity CopInterface is
    port(
        RESET_n         : in     vl_logic;
        CP15_WA         : out    vl_logic_vector(3 downto 0);
        CP15_WEB        : out    vl_logic;
        CP15_RA         : out    vl_logic_vector(3 downto 0);
        CP15_REB        : out    vl_logic;
        CP15_cache      : out    vl_logic;
        CP15_CFUN_wdata : out    vl_logic_vector(11 downto 0);
        CP15_TFUN_wdata : out    vl_logic_vector(4 downto 0);
        CPCLK           : in     vl_logic;
        CPID            : in     vl_logic_vector(31 downto 0);
        CPLATECANCEL    : in     vl_logic;
        nCPMREQ         : in     vl_logic;
        CPPASS          : in     vl_logic;
        CPTBIT          : in     vl_logic;
        nCPTRANS        : in     vl_logic;
        nCPWAIT         : in     vl_logic;
        CHSDE           : out    vl_logic_vector(1 downto 0);
        CHSEX           : out    vl_logic_vector(1 downto 0);
        CPEN            : out    vl_logic
    );
end CopInterface;
