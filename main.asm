

.segment "INES"
.byte $4E,$45,$53,$1A
.byte 4 ; prg
.byte 2 ; chr
.byte $43 ; flags 6

SoundBank =  0
AreaBank  =  2
GameBank  =  4

; convert ascii to smb1 charset
; space
.charmap    $20,   $00
; !
.charmap    $21,   $1F
; -
.charmap    $2D,   $28
; x to cross
.charmap    $78,   $29
; $ to coin
.charmap    $24,   $2e
; c to copyright
.charmap    $62,   $CF
; m to mushroom
.charmap    $6D,   $CE
; / to chain
.charmap    $2F,   $7F
; .
.charmap    $2E,   $AF

; 0
.charmap $30+00,   $00
; 1
.charmap $30+01,   $01
; 2
.charmap $30+02,   $02
; 3
.charmap $30+03,   $03
; 4
.charmap $30+04,   $04
; 5
.charmap $30+05,   $05
; 6
.charmap $30+06,   $06
; 7
.charmap $30+07,   $07
; 8
.charmap $30+08,   $08
; 9
.charmap $30+09,   $09

; A
.charmap $41+00, $18
; B
.charmap $41+01, $A+01
; C
.charmap $41+02, $A+02
; D
.charmap $41+03, $3c
; E
.charmap $41+04, $A+04
; F
.charmap $41+05, $A+05
; G
.charmap $41+06, $3e
; H
.charmap $41+07, $16
; I
.charmap $41+08, $1d
; K
.charmap $41+10, $1c
; L
.charmap $41+11, $A+10
; M
.charmap $41+12, $19
; N
.charmap $41+13, $1a
; O
.charmap $41+14, $15
; P
.charmap $41+15, $A+14
; R
.charmap $41+17, $1b
; S
.charmap $41+18, $A+16
; T
.charmap $41+19, $14
; U
.charmap $41+20, $17
; W
.charmap $41+22, $A+19
; Y
.charmap $41+24, $1e
; Z
.charmap $41+25, $A+21

; allow line continuation feature
.linecont +
.autoimport

; wastes close to the amount of cycles passed :)
.macro WasteCycles yvalue

.if yvalue = 0 || yvalue = 1
.elseif yvalue = 2
    nop
.elseif yvalue = 3
    ldy $0
.elseif yvalue = 4
    nop
    nop
.elseif yvalue = 5
    ldy $0
    nop
.elseif yvalue = 6
    nop
    nop
    nop
.elseif yvalue = 7
    ldy $0
    nop
    nop
.elseif yvalue = 8
    nop
    nop
    nop
    nop
.else
    ldy #((yvalue-3) / 4)  ; 3 cycles
:   dey                    ; 2 cycles 
    bne :-                 ; 2 cycles
.if yvalue = 9
    ldy $0
.elseif (yvalue-3) .mod 4 = 3
    ldy $0
.elseif (yvalue-3) .mod 4 = 2
    nop
.endif
.endif


.endmacro


.macro MakeBankCall bank, wide, routine
    lda #%110
    sta MMC3_BankSelect
    lda #bank
    sta MMC3_BankData
.if wide = 1
    lda #%111
    sta MMC3_BankSelect
    lda #bank+1
    sta MMC3_BankData
.endif
    jsr routine
    lda #%110
    sta MMC3_BankSelect
    lda #GameBank
    sta MMC3_BankData
.if wide = 1
    lda #%111
    sta MMC3_BankSelect
    lda #GameBank+1
    sta MMC3_BankData
.endif
    rts
.endmacro

.segment "SMBPRG"
.scope SMBPRG
.org $8000
.include "sm2main.asm"
.endscope

.segment "SNDPRG"
.scope SNDPRG
.org $8000
.include "soundengine.asm"
.endscope

.segment "AREAPRG"
.scope AREAPRG
.org $8000
.include "areas.asm"
.endscope

.segment "SMBCHR"
.ifdef ANN
.incbin "NSMCHAR1.chr"
.incbin "NSMCHAR2.chr"
.else
.incbin "SM2CHAR1.chr"
.incbin "SM2CHAR2.chr"
.endif
