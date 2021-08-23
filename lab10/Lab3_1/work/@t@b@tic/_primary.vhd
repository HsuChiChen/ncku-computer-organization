library verilog;
use verilog.vl_types.all;
entity TBTic is
    generic(
        PERIOD          : integer := 10;
        PHASETIME       : vl_notype
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of PERIOD : constant is 1;
    attribute mti_svvh_generic_type of PHASETIME : constant is 3;
end TBTic;
