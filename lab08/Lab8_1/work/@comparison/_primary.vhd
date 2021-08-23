library verilog;
use verilog.vl_types.all;
entity Comparison is
    port(
        Data_phase_Hit  : in     vl_logic;
        Data_phase_Valid: in     vl_logic;
        Data_phase_Cache_Hit: out    vl_logic
    );
end Comparison;
