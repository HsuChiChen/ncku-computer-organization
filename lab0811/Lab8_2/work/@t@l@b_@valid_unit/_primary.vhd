library verilog;
use verilog.vl_types.all;
entity TLB_Valid_unit is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        nMREQ           : in     vl_logic;
        RAddr           : in     vl_logic_vector(5 downto 0);
        WAddr           : in     vl_logic_vector(5 downto 0);
        WE              : in     vl_logic;
        WData           : in     vl_logic;
        TLB_operation_EN: in     vl_logic;
        Valid           : out    vl_logic
    );
end TLB_Valid_unit;
