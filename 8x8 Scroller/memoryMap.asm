;===============================================================================
; $00-$FF  PAGE ZERO (256 bytes)
 
                ; $00-$01   Reserved for IO

                ; $03-$8F   Reserved for BASIC

                ; $90-$FA   Reserved for Kernal

screenMemoryLowByte           = $03     ; 00
screenMemoryHighByte          = $04     ; 04
currentCharacter              = $05     ; Current character i.e. 'A'
currentBitPosition            = $06     ; current bit position     
currentCharacterByte          = $07     ; Current byte of char i.e. $18 top row
currentByteXPosition          = $08     ; x position in char
currentByteYPosition          = $09     ; y position in char
charByte0                     = $0a
charByte1                     = $0b
charByte2                     = $0c
charByte3                     = $0d
charByte4                     = $0e
charByte5                     = $0f
charByte6                     = $10
charByte7                     = $11
scrollOffset                  = $12     ; pointer for horizontal scroll offset
currentScrollCharLowByte      = $13     ; low byte for current character
currentScrollCharHighByte     = $14     ; high byte for current character
currentOffset                 = $18     ; current offset for zero page bytes
;screenMemoryLowByte           = $fb
;screenMemoryHighByte          = $fc
;currentCharacter              = $fd
;currentBitPosition            = $fe          

          
          

                ; $FF       Reserved for Kernal

;===============================================================================
; $0100-$01FF  STACK (256 bytes)


;===============================================================================
; $0200-$9FFF  RAM (40K)
screenLocationLargeScroll     = $0630
row14                         = $0630
row15                         = $0658
row16                         = $0680
row17                         = $06a8
row18                         = $06d0
row19                         = $06f8
row20                         = $0720
row21                         = $0748
row22                         = $0770
SCREENRAM                     = $0400
currentCharsetCharacter       = $37c7          


; $0801
; Game code is placed here by using the *=$0801 directive 
; in gameMain.asm 


* = $3800
        incbin characters.bin; Custom character set

;===============================================================================
; $A000-$BFFF  BASIC ROM (8K)


;===============================================================================
; $C000-$CFFF  RAM (4K)


;===============================================================================
; $D000-$DFFF  IO (4K)

; These are some of the C64 registers that are mapped into
; IO memory space
; Names taken from 'Mapping the Commodore 64' book

SP0X            = $D000
SP0Y            = $D001
MSIGX           = $D010
RASTER          = $D012
SPENA           = $D015
SCROLX          = $D016
VMCSB           = $D018
SPBGPR          = $D01B
SPMC            = $D01C
SPSPCL          = $D01E
EXTCOL          = $D020
BGCOL0          = $D021
BGCOL1          = $D022
BGCOL2          = $D023
BGCOL3          = $D024
SPMC0           = $D025
SPMC1           = $D026
SP0COL          = $D027
FRELO1          = $D400 ;(54272)
FREHI1          = $D401 ;(54273)
PWLO1           = $D402 ;(54274)
PWHI1           = $D403 ;(54275)
VCREG1          = $D404 ;(54276)
ATDCY1          = $D405 ;(54277)
SUREL1          = $D406 ;(54278)
FRELO2          = $D407 ;(54279)
FREHI2          = $D408 ;(54280)
PWLO2           = $D409 ;(54281)
PWHI2           = $D40A ;(54282)
VCREG2          = $D40B ;(54283)
ATDCY2          = $D40C ;(54284)
SUREL2          = $D40D ;(54285)
FRELO3          = $D40E ;(54286)
FREHI3          = $D40F ;(54287)
PWLO3           = $D410 ;(54288)
PWHI3           = $D411 ;(54289)
VCREG3          = $D412 ;(54290)
ATDCY3          = $D413 ;(54291)
SUREL3          = $D414 ;(54292)
SIGVOL          = $D418 ;(54296)      
COLORRAM        = $D800
CIAPRA          = $DC00
CIAPRB          = $DC01

;===============================================================================
; $E000-$FFFF  KERNAL ROM (8K) 


;===============================================================================
