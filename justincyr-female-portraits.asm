; -----------------------------------------------------------------------------
; VRAM addresses
        CHRTBL  equ     0000h   ; Pattern table
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
        .bios
	.biosvars
        .megarom ASCII8
        .start	INIT

INIT:
; Initializes stack pointer
	ld	sp, $f380

; Locate another 32 KB
        .search

; screen ,,0
	xor	a
	ld	[CLIKSW], a
; VDP: color 15,0,0
	ld	[BAKCLR], a
	ld	[BDRCLR], a
	dec	a
	ld	[FORCLR], a
; screen 3
	call	INIMLT

; Prepares background
	call	DISSCR
	call	FILVRM_FRAME

; For every chunk...
.RESTART_CHUNK_LOOP:
	xor	a
.CHUNK_LOOP:
	push	af ; (preserves chunk id)

; Prepares delay
	call	PREPARE_DELAY
; Searchs and unpacks chunk
	call	SEARCH_AND_UNPACK_CHUNK

; For every girl...
	ld	hl, unpack_buffer
	ld	b, 16
.GIRL_LOOP:
	push	bc ; (preserves counter)
; Delay
	call	EXECUTE_DELAY
; LDIRVM one girl
	call	LDIRVM_GIRL
	call	ENASCR
; Prepares delay
	call	PREPARE_DELAY
; Next girl
	pop	bc ; (restores counter)
	djnz	.GIRL_LOOP

; Next chunk
	pop	af ; (restores chunk id)
	inc	a
	cp	63
	jr	z, .RESTART_CHUNK_LOOP
	jr	.CHUNK_LOOP
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
FILVRM_FRAME:
; Frame top
	ld	hl, CHRTBL + $0034
	ld	b, 20
.FRAME_TOP_LOOP:
	push	bc
	push	hl
	ld	bc, 4
	ld	a, $ff
	call	FILVRM
	pop	hl
	ld	bc, $0008
	add	hl, bc
	pop	bc
	djnz	.FRAME_TOP_LOOP
; Frame middle
	ld	hl, CHRTBL + $0130
	call	.FRAME_SECTION
	ld	hl, CHRTBL + $0230
	call	.FRAME_SECTION
	ld	hl, CHRTBL + $0330
	call	.FRAME_SECTION
	ld	hl, CHRTBL + $0430
	call	.FRAME_SECTION
; Bottom
	ld	hl, CHRTBL + $0530
.FRAME_SECTION:
	ld	bc, 128 + 32
	ld	a, $ff
	jp	FILVRM
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
PREPARE_DELAY:
	push	af
	ld	a, [JIFFY]
	add	30
	ld	[expected_jiffy], a
	pop	af
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
EXECUTE_DELAY:
	push	hl
	ld	hl, expected_jiffy
.DELAY_LOOP:
	halt
	ld	a, [JIFFY]
	cp	[hl]
	jr	nz, .DELAY_LOOP
	pop	hl
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; LDIRVM one girl
; param hl: source data pointer
; ret hl: updated source data pointer
LDIRVM_GIRL:
; Top
	ld	de, CHRTBL + $0140
	ld	bc, 128
	call	LDIRVM
; Middle
	ex	de, hl
	ld	de, CHRTBL + $0240
	ld	bc, 128
	call	LDIRVM
	ex	de, hl
	ld	de, CHRTBL + $0340
	ld	bc, 128
	call	LDIRVM
; Bottom
	ex	de, hl
	ld	de, CHRTBL + $0440
	ld	bc, 128
	call	LDIRVM
	ex	de, hl
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; param a: chunk ID
SEARCH_AND_UNPACK_CHUNK:
; Searchs the index for the chunk
	ld	hl, INDEX
	ld	b, 0
.LOOP:
; Check index
	cp	[hl]
	jr	z, .FOUND
	inc	hl
	inc	hl
	inc	hl
; Check index
	cp	[hl]
	jr	z, .FOUND
	inc	hl
	inc	hl
	inc	hl
; Next subpage
	inc	b
	jr	.LOOP

.FOUND:
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]

; Selects subpage
	push	de ; (preserves address)
	ld	a, b
	; SELECT  a AT $6000
	SELECT  a AT $8000

; Unpacks
	pop	hl ; (restores address)
	ld	de, unpack_buffer
	; jp	UNPACK ; (falls through)
; ------VVVV----(falls through)------------------------------------------------

; -----------------------------------------------------------------------------
; Unpack to RAM routine
; param hl: packed data source address
; param de: destination buffer address
UNPACK:

; ZX0 decoder by Einar Saukas
; "Standard" version (68 bytes only)
	include	"libext/zx0/dzx0_standard.asm"
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
INDEX:
; subpage $00
	db	62
	dw	HL_62
	db	-1
	dw	$0000
; subpage $01
	db	1
	dw	HL_01
	db	19
	dw	HL_19
; subpage $02
	db	6
	dw	HL_06
	db	58
	dw	HL_58
; subpage $03
	db	2
	dw	HL_02
	db	52
	dw	HL_52
; subpage $04
	db	31
	dw	HL_31
	db	54
	dw	HL_54
; subpage $05
	db	24
	dw	HL_24
	db	38
	dw	HL_38
; subpage $06
	db	13
	dw	HL_13
	db	60
	dw	HL_60
; subpage $07
	db	16
	dw	HL_16
	db	53
	dw	HL_53
; subpage $08
	db	0
	dw	HL_00
	db	57
	dw	HL_57
; subpage $09
	db	4
	dw	HL_04
	db	56
	dw	HL_56
; subpage $0a
	db	17
	dw	HL_17
	db	18
	dw	HL_18
; subpage $0b
	db	26
	dw	HL_26
	db	37
	dw	HL_37
; subpage $0c
	db	28
	dw	HL_28
	db	39
	dw	HL_39
; subpage $0d
	db	23
	dw	HL_23
	db	20
	dw	HL_20
; subpage $0e
	db	3
	dw	HL_03
	db	5
	dw	HL_05
; subpage $0f
	db	7
	dw	HL_07
	db	8
	dw	HL_08
; subpage $10
	db	9
	dw	HL_09
	db	10
	dw	HL_10
; subpage $11
	db	11
	dw	HL_11
	db	12
	dw	HL_12
; subpage $12
	db	14
	dw	HL_14
	db	15
	dw	HL_15
; subpage $13
	db	21
	dw	HL_21
	db	22
	dw	HL_22
; subpage $14
	db	25
	dw	HL_25
	db	27
	dw	HL_27
; subpage $15
	db	29
	dw	HL_29
	db	30
	dw	HL_30
; subpage $16
	db	32
	dw	HL_32
	db	33
	dw	HL_33
; subpage $17
	db	34
	dw	HL_34
	db	35
	dw	HL_35
; subpage $18
	db	36
	dw	HL_36
	db	40
	dw	HL_40
; subpage $19
	db	41
	dw	HL_41
	db	42
	dw	HL_42
; subpage $1a
	db	43
	dw	HL_43
	db	44
	dw	HL_44
; subpage $1b
	db	45
	dw	HL_45
	db	46
	dw	HL_46
; subpage $1c
	db	47
	dw	HL_47
	db	48
	dw	HL_48
; subpage $1d
	db	49
	dw	HL_49
	db	50
	dw	HL_50
; subpage $1e
	db	51
	dw	HL_51
	db	55
	dw	HL_55
; subpage $1f
	db	59
	dw	HL_59
	db	61
	dw	HL_61
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
	defs	$5000 - $
HL_62:	.incbin	"resources/62.clr.zx0"

SUBPAGE $01 AT $8000
HL_01:	.incbin	"resources/01.clr.zx0"
HL_19:	.incbin	"resources/19.clr.zx0"	; (bigger than 4KB)

SUBPAGE $02 AT $8000
HL_06:	.incbin	"resources/06.clr.zx0"
HL_58:	.incbin	"resources/58.clr.zx0"	; (bigger than 4KB)

SUBPAGE $03 AT $8000
HL_02:	.incbin	"resources/02.clr.zx0"
HL_52:	.incbin	"resources/52.clr.zx0"	; (bigger than 4KB)

SUBPAGE $04 AT $8000
HL_31:	.incbin	"resources/31.clr.zx0"
HL_54:	.incbin	"resources/54.clr.zx0"	; (bigger than 4KB)

SUBPAGE $05 AT $8000
HL_24:	.incbin	"resources/24.clr.zx0"
HL_38:	.incbin	"resources/38.clr.zx0"	; (bigger than 4KB)

SUBPAGE $06 AT $8000
HL_13:	.incbin	"resources/13.clr.zx0"
HL_60:	.incbin	"resources/60.clr.zx0"	; (bigger than 4KB)

SUBPAGE $07 AT $8000
HL_16:	.incbin	"resources/16.clr.zx0"
HL_53:	.incbin	"resources/53.clr.zx0"	; (bigger than 4KB)

SUBPAGE $08 AT $8000
HL_00:	.incbin	"resources/00.clr.zx0"
HL_57:	.incbin	"resources/57.clr.zx0"	; (bigger than 4KB)

SUBPAGE $09 AT $8000
HL_04:	.incbin	"resources/04.clr.zx0"
HL_56:	.incbin	"resources/56.clr.zx0"	; (bigger than 4KB)

SUBPAGE $0a AT $8000
HL_17:	.incbin	"resources/17.clr.zx0"
HL_18:	.incbin	"resources/18.clr.zx0"	; (bigger than 4KB)

SUBPAGE $0b AT $8000
HL_26:	.incbin	"resources/26.clr.zx0"
HL_37:	.incbin	"resources/37.clr.zx0"	; (bigger than 4KB)

SUBPAGE $0c AT $8000
HL_28:	.incbin	"resources/28.clr.zx0"
HL_39:	.incbin	"resources/39.clr.zx0"	; (bigger than 4KB)

SUBPAGE $0d AT $8000
HL_23:	.incbin	"resources/23.clr.zx0"
HL_20:	.incbin	"resources/20.clr.zx0"	; (exactly 4KB)

SUBPAGE $0e AT $8000
HL_03:	.incbin	"resources/03.clr.zx0"
HL_05:	.incbin	"resources/05.clr.zx0"

SUBPAGE $0f AT $8000
HL_07:	.incbin	"resources/07.clr.zx0"
HL_08:	.incbin	"resources/08.clr.zx0"

SUBPAGE $10 AT $8000
HL_09:	.incbin	"resources/09.clr.zx0"
HL_10:	.incbin	"resources/10.clr.zx0"

SUBPAGE $11 AT $8000
HL_11:	.incbin	"resources/11.clr.zx0"
HL_12:	.incbin	"resources/12.clr.zx0"

SUBPAGE $12 AT $8000
HL_14:	.incbin	"resources/14.clr.zx0"
HL_15:	.incbin	"resources/15.clr.zx0"

SUBPAGE $13 AT $8000
HL_21:	.incbin	"resources/21.clr.zx0"
HL_22:	.incbin	"resources/22.clr.zx0"

SUBPAGE $14 AT $8000
HL_25:	.incbin	"resources/25.clr.zx0"
HL_27:	.incbin	"resources/27.clr.zx0"

SUBPAGE $15 AT $8000
HL_29:	.incbin	"resources/29.clr.zx0"
HL_30:	.incbin	"resources/30.clr.zx0"

SUBPAGE $16 AT $8000
HL_32:	.incbin	"resources/32.clr.zx0"
HL_33:	.incbin	"resources/33.clr.zx0"

SUBPAGE $17 AT $8000
HL_34:	.incbin	"resources/34.clr.zx0"
HL_35:	.incbin	"resources/35.clr.zx0"

SUBPAGE $18 AT $8000
HL_36:	.incbin	"resources/36.clr.zx0"
HL_40:	.incbin	"resources/40.clr.zx0"

SUBPAGE $19 AT $8000
HL_41:	.incbin	"resources/41.clr.zx0"
HL_42:	.incbin	"resources/42.clr.zx0"

SUBPAGE $1a AT $8000
HL_43:	.incbin	"resources/43.clr.zx0"
HL_44:	.incbin	"resources/44.clr.zx0"

SUBPAGE $1b AT $8000
HL_45:	.incbin	"resources/45.clr.zx0"
HL_46:	.incbin	"resources/46.clr.zx0"

SUBPAGE $1c AT $8000
HL_47:	.incbin	"resources/47.clr.zx0"
HL_48:	.incbin	"resources/48.clr.zx0"

SUBPAGE $1d AT $8000
HL_49:	.incbin	"resources/49.clr.zx0"
HL_50:	.incbin	"resources/50.clr.zx0"

SUBPAGE $1e AT $8000
HL_51:	.incbin	"resources/51.clr.zx0"
HL_55:	.incbin	"resources/55.clr.zx0"

SUBPAGE $1f AT $8000
HL_59:	.incbin	"resources/59.clr.zx0"
HL_61:	.incbin	"resources/61.clr.zx0"

; SUBPAGE $20 AT $8000
; HL_62:	.incbin	"resources/62.clr.zx0"
; -----------------------------------------------------------------------------

	.page	3

unpack_buffer:
	defs	8 * 1024
expected_jiffy:
	.byte

; EOF

