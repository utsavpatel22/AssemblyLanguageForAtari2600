	processor 6502
	
	seg code
	org $F000       ; defines the code origin at $F000

Start:
	sei             ; disables interrupts
	cld             ; disable the BCD decimal mathe mode
	ldx #$FF	; loads the X register with #$FF
	txs		; transfer X register to S(stack) register

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Clear the Zero Page region ($00 to $FF)
; Meaning the entire TIA register space and also RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	lda #0		; A = 0
	ldx #$FF	; X = #$FF
	sta $FF 	; make sure $FF is zeroed before the loop starts
MemLoop:
	dex			; x--
	sta $0,X	; store zero at address $0 + X
	bne MemLoop	; loop until X == 0 (z-flag set)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;File ROM size to exactly 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	org $FFFC
	.word Start
	.word Start
