.include "render.h.s"
.include "cpctelera.h.s"
.include "manager/player.h.s"

.globl cpct_drawSolidBox_asm
.globl cpct_getScreenPtr_asm
.globl cpct_setVideoMode_asm
.globl cpct_setPalette_asm

	;;[======================================================]
	;;| Identifier		  | Value| Identifier		  | Value|
	;;|------------------------------------------------------|
	;;| HW_BLACK			| 0x14 | HW_BLUE		  | 0x04 |
	;;| HW_BRIGHT_BLUE		| 0x15 | HW_RED			  | 0x1C |
	;;| HW_MAGENTA		  	| 0x18 | HW_MAUVE		  | 0x1D |
	;;| HW_BRIGHT_RED	 	| 0x0C | HW_PURPLE		  | 0x05 |
	;;| HW_BRIGHT_MAGENTA 	| 0x0D | HW_GREEN		  | 0x16 |
	;;| HW_CYAN			 	| 0x06 | HW_SKY_BLUE	  | 0x17 |
	;;| HW_YELLOW		   	| 0x1E | HW_WHITE		  | 0x00 |
	;;| HW_PASTEL_BLUE		| 0x1F | HW_ORANGE		  | 0x0E |
	;;| HW_PINK			 	| 0x07 | HW_PASTEL_MAGENTA| 0x0F |
	;;| HW_BRIGHT_GREEN   	| 0x12 | HW_SEA_GREEN	  | 0x02 |
	;;| HW_BRIGHT_CYAN		| 0x13 | HW_LIME		  | 0x1A |
	;;| HW_PASTEL_GREEN   	| 0x19 | HW_PASTEL_CYAN	  | 0x1B |
	;;| HW_BRIGHT_YELLOW  	| 0x0A | HW_PASTEL_YELLOW | 0x03 |
	;;| HW_BRIGHT_WHITE   	| 0x0B |						 |		
	
	;;ld		c, #0
	;;call	cpct_setVideoMode_asm

	;;ld		hl, #palette
	;;ld		de, #16
	;;call	cpct_setPalette_asm 

render_ground:
	ld		de, #0xC000
	ld		bc, #0x9000
	call	cpct_getScreenPtr_asm

	ex		de, hl
	ld		 a, #0xF0
	ld		bc, #0x0440
	call	cpct_drawSolidBox_asm

	ld		de, #0xC000
	ld		bc, #0x9040
	call	cpct_getScreenPtr_asm

	ex		de, hl
	ld		 a, #0xF0
	ld		bc, #0x0410
	call	cpct_drawSolidBox_asm

	ret

;;INPUT:	 
;;DESTROY:  
render_init::
	call	render_ground
	ret

;;Render the player entitie.
;;INPUT:   IX (#player_main)  
;;DESTROY: AF, BC, DE, HL, 
render_player_draw::
	ld		de, #0xC000
	ld		 b, player_y_coord(ix)
	ld		 c, player_x_coord(ix)
	call	cpct_getScreenPtr_asm
	ld 		player_last_screen_l(ix), l
	ld		player_last_screen_h(ix), h

	ex		de, hl
	ld		 a, #0x0F
	ld		bc, #0x0802
	call	cpct_drawSolidBox_asm

	ret
;;Erase the last player entitie.
;;INPUT:   IX (#player_main)  
;;DESTROY: AF, BC, DE, HL, 
render_player_erase::
	ld		de, #0xC000
	ld 		e, player_last_screen_l(ix)
	ld 		d, player_last_screen_h(ix)
	ld		 a, #0x00
	ld		bc, #0x0802
	call	cpct_drawSolidBox_asm

	ret
render_update::
	ld       ix, #player_main
	call	render_player_erase
	ld		a, player_y_speed(ix)
	add	 	a, player_y_coord(ix)
	call	render_player_draw
	ret