; 10 SYS (2064)

*=$0801

        BYTE    $0E, $08, $0A, $00, $9E, $20, $28,  $32, $30, $36, $34, $29, $00, $00, $00


*=$0810
          sei                                       ; turn off Interupts
          
          ; Set the memory location of the custom character set
          lda            $D018     
          and            #%11110000               ; keep higher 4 bits
          ora            #$0E                     ; maps to  $3800 memory address
          sta            $D018     
          
          jsr            initialiseScrollText     ; Initialise self-mod code 
          jsr            read_next_char

waitForRasterline 
          ;wait for wanted rasterline at screenline 164
          lda            $d012     
          cmp            #162  
          bne            waitForRasterline  

          ;Do the scroll routine if screen is at 232 
          lda            scrollOffset    
          sta            $d016                    ; Scroll the screen
          sta            $0400
          inc            $0403     

waitForRasterline2 
          lda            $d012                    ; read current rasterline
          cmp            #$0                      ; Is it 0
          bne            waitForRasterline2     

          ;switch mode back to 40 columns for top portion of screen
          lda            #08       
          sta            $d016     

          jsr            loop      
          ;jsr            scroll 
          inc            $0404 
          
          jmp            waitForRasterline  
          
scroll 
          lda            scrollOffset             ; load the current scroll Offset
          sta            $0401                    ; Store in position 2 of screen for debug
          sec                                     ; Set Carry 
          sbc            #$01                     ; Sub with Carry the accumulator - Speed of scroll 
          and            #%00000111               ; And the bits we need
          sta            scrollOffset             ; Update the scroll offset
          ;bcs            scroll                  ; Branch if carry set to endscroll
          ldx            #$00      

move_line ; Move each character on the line one to the left
          lda            row14+1,x                ; read screepos+1
          sta            row14,x                  ; Move it one to the left
          lda            row15+1,x                ; read screepos+1
          sta            row15,x                  ; Move it one to the left
          lda            row16+1,x                ; read screepos+1
          sta            row16,x                  ; Move it one to the left
          lda            row17+1,x                ; read screepos+1
          sta            row17,x                  ; Move it one to the left
          lda            row18+1,x                ; read screepos+1
          sta            row18,x                  ; Move it one to the left
          lda            row19+1,x                ; read screepos+1
          sta            row19,x                  ; Move it one to the left
          lda            row20+1,x                ; read screepos+1
          sta            row20,x                  ; Move it one to the left
          lda            row21+1,x                ; read screepos+1
          sta            row21,x                  ; Move it one to the left
          lda            row22+1,x                ; read screepos+1
          sta            row22,x                  ; Move it one to the left
          
          inx                                     ; Increment X register
          cpx            #$27                     ; has it done full line i.e. 40 chars?
          bne            move_line ; Loop back round if not finished
          
          inc            currentBitPosition       ; Increase current bit position
          jsr            resetScreenLocation
          ldx            #$00      
          stx            loop_counter; reset loop counter back to 0

          jmp            waitForRasterline
          
read_next_char ; Self-mod code
          lda            scroll_text              ; Load current character
          sta            currentCharacter         ; stores in $05
          cmp            #$ff                     ; Is value 255?
          beq            jump_initialiseScrollText
          bne            no_jump_initialiseScrollText
jump_initialiseScrollText
          jsr            initialiseScrollText
no_jump_initialiseScrollText
          jsr            resetCharacterPointer    ; *** Reset Character pointer back to $0700
          
          clc                                     ; Clear Carry
          sbc            #$3f                     ; Subtract 63 to get current charcter offset
          
          sta            currentScrollCharLowByte ; Store in lowBye of the next character pointer
          
          ; Set screen position pointers to $0657 {on right hand side of screen}
          jsr            resetScreenLocation
          
          jsr            timesCharacterByEight; ** Times by 8 to hit correct point in memory 
          ldy            #$0       
          ldx            #$00      
store_in_zeroPage      
          lda            (currentScrollCharLowByte,y)
          sta            charByte0,x; store in zero page
          inx
          iny
          cpx            #$08      
          bne            store_in_zeroPage
          ldx            #$00                     ; Set 0
          stx            currentBitPosition       ; in current bit position i.e. left to right
          stx            loop_counter             ; in current Loop
          stx            currentByteXPosition     ; reset x position
          stx            currentByteYPosition     ; reset y position
          inc            read_next_char+1         ; inc self-mode code lower byte location
          ;jmp            loop      
          rts




scroll1
          ;do scroll
          dec            screenMemoryLowByte; 
          ldx            #$00
          stx            loop_counter
shift_zeroPage           
          ; Shifts the zero page memory to the next byte
          asl            charByte0,x              ; store in zero page
          inx
          cpx            #$08      
          bne            shift_zeroPage
          jsr            scroll    
          ;jsr            loop      
          
          inc            read_next_char+1
          jmp            read_next_char
          
          
loop
          ldx            currentBitPosition
          cpx            #$07      
          beq            read_next_char
          ldx            loop_counter             ; load current loop into x
          cpx            #$8                      ; Is it 8?
          beq            scroll1                  ; read next character if it is
          inc            loop_counter             ; Increase the loop counter
          
          ldx            currentOffset            ; reload current byte position
          lda            charByte0,x
          sta            currentCharacterByte     ; store in zero page $07
          inc            currentOffset
          
          lda            #%10000000               ; Create bit mask to determine if bit 1 is set
          bit            currentCharacterByte; bit comparison of leftmost bit
          
          beq            plot_blank               ; If 0 jump to plot_blank Routine
          bne            plot_char                ; If 1 jump to plot_char routine
          
plot_char          
          ldy            y_offset                 ; Load the y offset i.e. how many characters to move along on each line
          lda            circle                   ; load the char for a circle

          sta            (screenMemoryLowByte,y)  ; Store in screen memory via indirect index
          jsr            addLine                  ; increase the screen position by one line ( 40 characters)
          ;inc            loop_counter             ; Increment the counter pointer ( number of loops)
          ;inc            currentBitPosition       ; Increment the currentBitPosition
          jmp            loop      
          
plot_blank          
          ldy            y_offset                 ; Load the y offset i.e. how many characters to move along on each line
          lda            #$20                     ; load the char for a circle
          sta            (screenMemoryLowByte,y)  ; Store in screen memory via indirect index
          jsr            addLine                  ; increase the screen position by one line ( 40 characters)
          rts
          ;jmp            loop     
          ;jmp            waitForRasterline
          
                    
END
          rts
          

addLine ; Adds 40 to the current screen position
          clc
          lda            screenMemoryLowByte      ; load low byte of screen memory pointer
          adc            newline                  ; Add with carry low byte of how how many characters to add to screen memory low byte
          sta            screenMemoryLowByte      ; store result back in low byte of screen memory pointer
          lda            screenMemoryHighByte     ; load high byte of screen memory pointer     
          adc            newline+1                ; Add with carry high byte of how how many characters to add to screen memory high byte
          sta            screenMemoryHighByte     ; store result back in high byte of screen memory pointer  
          rts
          
selectNextCharacter                         ; Adds 8 to the current character set memory to read
          clc
          lda            currentCharsetCharacter+1           ; load low byte of current character in video memory to read 
          adc            #$08                               ; Add with carry low byte of how how many characters to add to screen memory low byte
          sta            currentCharsetCharacter           ; store result back in low byte of screen memory pointer
          ;sta            selectNextCharacter+1              ; store result back in low byte of screen memory pointer
          lda            #>currentCharsetCharacter          ; load high byte of screen memory pointer     
          adc            #$08                               ; Add with carry high byte of how how many characters to add to screen memory high byte
          sta            currentScrollCharHighByte          ; store result back in high byte of screen memory pointer
          sta            >currentCharsetCharacter
          rts

resetScreenLocation
          ldx            #$57; sets scroll position at right hand side of screen      
          ldy            #$06;     
          stx            screenMemoryLowByte
          sty            screenMemoryHighByte
          ldx            #$0       
          stx            currentOffset
          rts
          
timesCharacterByEight         ; As $0700 as basis times that number by 8 to point to correct character
          lda            currentScrollCharLowByte    
          asl            currentScrollCharLowByte       
          rol            currentScrollCharHighByte
          asl            currentScrollCharLowByte       
          rol            currentScrollCharHighByte   
          asl            currentScrollCharLowByte       
          rol            currentScrollCharHighByte
          rts


initialiseScrollText
          lda            #<scroll_text            ; Reload low byte of scroll_text
          sta            read_next_char+1         ; store low byte of scroll_text in self-mod code
          lda            #>scroll_text            ; Reload high byte of scroll_text
          sta            read_next_char+2         ; store high byte of scroll_text in self-mod code
          lda            #$01      
          sta            currentOffset
          lda            #$c7
          sta            selectNextCharacter+1    
          lda            #$37    
          sta            selectNextCharacter+2 
          rts


resetCharacterPointer         ; Resets the character pointer back to $0700
          ldx            #$00      
          ldy            #$07      
          stx            currentScrollCharLowByte
          sty            currentScrollCharHighByte
          rts




xcounter
          byte           0
          


          
          
newline
          byte           $28,$00 ; newline as a 16 bit number - Needed to add to screen

scrollPosition
          byte           $0
          
loop_counter
          byte           $0
          
circle
          byte           $42  ; circle character
          
          
y_offset
          byte           $0
          
scroll_text
          text           "abcdefghijklmnopqrstuvwxyz1234"
          text           " shout out to my wgc chums  "
          byte           $ff; Ends scroller
         
;*=$00c0  ; want to place this in zero page memory
screenMemory 
          word           $0400
          



          