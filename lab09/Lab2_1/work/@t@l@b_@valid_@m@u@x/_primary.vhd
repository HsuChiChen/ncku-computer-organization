library verilog;
use verilog.vl_types.all;
entity TLB_Valid_MUX is
    port(
        TLB_operation_EN: in     vl_logic;
        Invalid_Valid_WE: in     vl_logic;
        Invalid_Valid_WData: in     vl_logic;
        Valid_WAddr     : in     vl_logic_vector(5 downto 0);
        Valid_WE        : in     vl_logic;
        Valid_WData     : in     vl_logic;
        TLB_Entry_MVA   : in     vl_logic_vector(5 downto 0);
        TLB_Valid_WAddr : out    vl_logic_vector(5 downto 0);
        TLB_Valid_WE    : out    vl_logic;
        TLB_Valid_WData : out    vl_logic
    );
end TLB_Valid_MUX;
