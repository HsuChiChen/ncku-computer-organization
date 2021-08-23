library verilog;
use verilog.vl_types.all;
entity Data_phase_Dirty_MUX is
    port(
        fill            : in     vl_logic;
        Cache_operation_EN: in     vl_logic;
        Controller_Dirty_WAddr: in     vl_logic_vector(1 downto 0);
        Controller_Dirty_WE: in     vl_logic_vector(1 downto 0);
        Controller_Dirty_WData: in     vl_logic_vector(1 downto 0);
        Index           : in     vl_logic_vector(1 downto 0);
        Dirty_WAddr     : in     vl_logic_vector(1 downto 0);
        Dirty_WE        : in     vl_logic_vector(1 downto 0);
        Dirty_WData     : in     vl_logic_vector(1 downto 0);
        Data_phase_Dirty_RAddr: out    vl_logic_vector(1 downto 0);
        Data_phase_Dirty_WAddr: out    vl_logic_vector(1 downto 0);
        Data_phase_Dirty_WE: out    vl_logic_vector(1 downto 0);
        Data_phase_Dirty_WData: out    vl_logic_vector(1 downto 0)
    );
end Data_phase_Dirty_MUX;
