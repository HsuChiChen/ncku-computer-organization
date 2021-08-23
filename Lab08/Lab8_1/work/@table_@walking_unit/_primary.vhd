library verilog;
use verilog.vl_types.all;
entity Table_Walking_unit is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        nWAIT           : in     vl_logic;
        TTB             : in     vl_logic_vector(17 downto 0);
        MVA             : in     vl_logic_vector(21 downto 0);
        fill            : in     vl_logic;
        fill_finish     : out    vl_logic;
        TAG_WAddr       : out    vl_logic_vector(21 downto 0);
        TAG_WE          : out    vl_logic;
        Valid_WAddr     : out    vl_logic_vector(5 downto 0);
        Valid_WE        : out    vl_logic;
        Valid_WData     : out    vl_logic;
        Value_WAddr     : out    vl_logic_vector(5 downto 0);
        Value_WE        : out    vl_logic;
        Value_WData     : out    vl_logic_vector(35 downto 0);
        Translation_fault: out    vl_logic_vector(1 downto 0);
        Translation_fault_Domain: out    vl_logic_vector(3 downto 0);
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
end Table_Walking_unit;
