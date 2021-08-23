library verilog;
use verilog.vl_types.all;
entity IRCntl is
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        HSELT           : in     vl_logic;
        HADDR           : in     vl_logic_vector(31 downto 0);
        HWRITE          : in     vl_logic;
        HIRQSource      : in     vl_logic_vector(15 downto 0);
        HIRQAck         : out    vl_logic_vector(15 downto 0);
        HWDATA          : in     vl_logic_vector(31 downto 0);
        HRDATA          : out    vl_logic_vector(31 downto 0);
        nIRQ            : out    vl_logic
    );
end IRCntl;
