	processor 6502
	include "vcs.h"
	include "macro.h"

	seg code
	org $F000	;defines the origin of the ROM at F000
	


START:

    CLEAN_START     ; Macro to safely clear the memory

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Start a new frame by turning on VBLANK and VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

NextFrame:

    lda #2          ; Same as binary value %00000010
    sta VBLANK      ; turn on VBLANK

    sta VSYNC       ; turn on VSYNC


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generate the three lines of VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    sta WSYNC       ; First scan line
    sta WSYNC       ; Second scan line
    sta WSYNC       ; Third scan line

    lda #0
    sta VSYNC		; Turn off VSYNC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Let the TIA output the recommended 37 lines of VBLANK 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	ldx #37			; X = 37 (To count 37 scan lines)

LoopVBlank:
	sta WSYNC		; hit WSYNC and wait for the next scanline
	dex				; X--
	bne LoopVBlank	; Loop while X != 0

	lda #0
	sta VBLANK 		; Turn off VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Draw 192 visible scanlines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;				

	ldx #192		; X = 192 (Counter)

LoopScanLines:
	stx COLUBK		; Set the background color
	sta WSYNC		; Wait for the next scanline
	dex
	bne LoopScanLines ; Loop while X != 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Output 30 more VBLANK lines to complete the frame
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lda #2			; hit and turn on VBLANK again
	sta VBLANK

	ldx #30			; Counter for 30 scanlines

LoopOverscan:
	sta WSYNC		; Wait for the next scan line
	dex
	bne LoopOverscan	; Loops while X != 0

	jmp NextFrame


	org $FFFC	; Defines origin to $FFFC
	.word START	; Reset vector at $FFFC (Where program starts)
	.word START	; Interrupt vector at $FFFE (unused in the VCS) 
