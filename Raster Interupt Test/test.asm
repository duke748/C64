*=$0810 ;SYS 2064


  


    JMP RESET

MAIN
    LDX RASTERCOLOUR 
    STX $d020
    CMP #$0F 
    BEQ RESET 
    INX
    STX RASTERCOLOUR
    JMP MAIN

RESET
    LDX #$00   
    STX RASTERCOLOUR
    JMP MAIN

NOCHANGE
    RTS

RASTERCOLOUR BYTE $00 ;Pointer for storing my colour

LOOP
