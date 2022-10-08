

.segment "INES"
.byte $4E,$45,$53,$1A
.byte 8 ; prg
.byte 2 ; chr
.byte $53 ; flags 6

EmptyBank =  0
SoundBank =  4
AreaBank  =  8
GameBank  = 12

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

.macro BankJSR bank, addr
      sta $103
      lda #<addr
      sta $100
      lda #>addr
      sta $101
      lda #bank
      jsr _BankJSR
.endmacro

.macro BankingCode bank
.res $FF70 - *, $FF
_BankJSR:
    sta $102
    lda #bank
    pha
    lda $102
    jsr SetPRGBank
    lda $103
    jsr @CallJSR
    pla
    jsr SetPRGBank
    rts
@CallJSR:
    jmp ($100)

VStart:
      sei
      ldx #$FF
      txs
      lda #%01000000         ; disable apu irq
      sta $4017
      lda #%10
      sta MMC5_RAMProtect1
      lda #%01
      sta MMC5_RAMProtect2
      lda #3
      sta MMC5_CHRMode       ; use 1kb chr banking
      lda #1
      sta MMC5_PRGMode       ; use 16kb prg banking
      lsr a
      sta MMC5_PRGBank3
      lda #GameBank
      jsr SetPRGBank
      lda #$44
      sta MMC5_Nametables    ; set vertical mirroring
      jmp $8000

SetPRGBank:
    clc
    ora #$80
    sta MMC5_PRGBank4+1
    adc #2
    sta MMC5_PRGBank4+3
    rts

VIRQ:
    sei
    php
    pha
    lda MMC5_SLIRQ
    lda Mirror_PPU_CTRL      ; waste some time to get to the end of the scanline
    lda Mirror_PPU_CTRL      ; waste some time to get to the end of the scanline
    lda Mirror_PPU_CTRL      ; waste some time to get to the end of the scanline
    lda Mirror_PPU_CTRL
    and #%11110110           ;mask out sprite address and nametable
    ora NameTableSelect
    sta Mirror_PPU_CTRL      ;update the register and its mirror
    sta PPU_CTRL
    lda HorizontalScroll
    sta PPU_SCROLL           ;set scroll regs for the screen under the status bar
    lda #$00
    sta PPU_SCROLL
    sta IRQAckFlag           ;indicate IRQ was acknowledged
    pla
    plp
    cli
    rti

.res $FFFA - *, $FF
.word NMIHandler
.word VStart
.word VIRQ
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

.segment "EMPTYPRG"
.scope EMPTYPRG
.org $8000
.include "emptybank.asm"
.endscope

.segment "SMBCHR"
.ifdef ANN
.incbin "NSMCHAR1.chr"
.incbin "NSMCHAR2.chr"
.else
.incbin "SM2CHAR1.chr"
.incbin "SM2CHAR2.chr"
.endif
