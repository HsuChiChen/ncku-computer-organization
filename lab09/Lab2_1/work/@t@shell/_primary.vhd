library verilog;
use verilog.vl_types.all;
entity TShell is
    port(
        HCLK            : in     vl_logic;
        RESET_n         : in     vl_logic;
        HRESET_Core     : out    vl_logic;
        HGRANT          : in     vl_logic;
        READY           : in     vl_logic;
        HRDATA          : in     vl_logic_vector(31 downto 0);
        ADDR            : in     vl_logic_vector(31 downto 0);
        HBUSREQ_Core    : in     vl_logic;
        HWRITE          : in     vl_logic;
        HPROT_Core      : in     vl_logic_vector(3 downto 0);
        FIQN            : in     vl_logic;
        IRQN            : in     vl_logic;
        HRDATA_Core     : out    vl_logic_vector(31 downto 0);
        NFIQ_Core       : out    vl_logic;
        NIRQ_Core       : out    vl_logic;
        HADDR_Core      : out    vl_logic_vector(31 downto 0);
        nWAIT           : in     vl_logic;
        CP15protect     : out    vl_logic
    );
end TShell;
