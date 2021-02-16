/*
    Compile using kick Assembler
    This simply changes screen colours along a couple of raster line splits
*/
.label linePosStart = $00
.label linePosFinish = $a0
BasicUpstart2(init)

*=$0810
init:
    sei     // disable Interupts

rasterLine1: 
    lda linePosStart    // load line posStart into the accumulator
    cmp $D012           // has scan line reached linePosStart?
    bne rasterLine1     // Loop back if not
    inc linePosStart    // increase position of start bar
    ldx #$15            // Load Green Colour
    stx $D020           // Store in Border
    stx $D021

rasterLine2:
    lda linePosFinish
    ldx #$11
    cmp $D012           // does line position = linePosFinish
    bne rasterLine2     // loop back if not
    stx $D020           // Store Colour
    stx $D021
    dec linePosFinish   // decrease value of LinePosFinish
    jmp rasterLine1