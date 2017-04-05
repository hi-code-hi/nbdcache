`define     M_XRD        5'b00000
`define     M_XWR        5'b00001
`define     M_PFR        5'b00010
`define     M_PFW        5'b00011
`define     M_XA_SWAP    5'b00100
`define     M_NOP        5'b00101
`define     M_XLR        5'b00110
`define     M_XSC        5'b00111
`define     M_XA_ADD     5'b01000
`define     M_XA_XOR     5'b01001
`define     M_XA_OR      5'b01010
`define     M_XA_AND     5'b01011
`define     M_XA_MIN     5'b01100
`define     M_XA_MAX     5'b01101
`define     M_XA_MINU    5'b01110
`define     M_XA_MAXU    5'b01111
`define     M_FLUSH      5'b10000
`define     M_PRODUCE    5'b10001
`define     M_CLEAN      5'b10011

`define     clientInvalid           2'h0
`define     clientShared            2'h1
`define     clientExclusiveClean    2'h2
`define     clientExclusiveDirty    2'h3

`define         MT_B   3'h0
`define         MT_H   3'h1
`define         MT_W   3'h2
`define         MT_D   3'h3
`define         MT_BU  3'h4
`define         MT_HU  3'h5
`define         MT_WU  3'h6
`define         MT_Q   3'h7

`define     lrscCycles   6'h20