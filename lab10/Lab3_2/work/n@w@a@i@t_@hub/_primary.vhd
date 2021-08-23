library verilog;
use verilog.vl_types.all;
entity nWAIT_Hub is
    port(
        WFI_nWAIT       : in     vl_logic;
        IMMU_nWAIT      : in     vl_logic;
        DMMU_nWAIT      : in     vl_logic;
        IEXT_nWAIT      : in     vl_logic;
        DEXT_nWAIT      : in     vl_logic;
        ICache_nWAIT    : in     vl_logic;
        DCache_nWAIT    : in     vl_logic;
        WB_nWAIT        : in     vl_logic;
        nWAIT           : out    vl_logic
    );
end nWAIT_Hub;
