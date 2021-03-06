;; Speeb
;; Copyright (C) 2020  University of Alicante
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

.include "render.h.s"
.include "cpctelera.h.s"
.include "manager/entity.h.s"
.include "img/screens/screenbackground_z.h.s"
.include "manager/grassfield.h.s"

;;DESTROYS: AF, BC, DE, HL
render_clean:
	render_draw_solid_box_at #0x00, #0x00, #0x00, #0x40, #0xC8
	render_draw_solid_box_at #0x40, #0x00, #0x00, #0x10, #0xC8
	ret

;;DESTROY: AF, BC, DE, HL
render_init::
	

	;(2B DE) dest_end	Ending (latest) byte of the destination (decompressed) array
	;(2B HL) source_end	Ending (latest) byte of the source (compressed) array
	;Assembly call (Input parameters on registers)
	ld 		hl, #_screenbackground_z_end
	ld		de, #0xFFFF
    call cpct_zx7b_decrunch_s_asm
	ret

;;INPUT
;; IX:	Grass
render_redraw_grass:
	;;doesnt erase new grass
	xor a
	ld d, grass_last_screen_h(ix)
	ld e, grass_last_screen_l(ix)
	cp d
	jr nz, render_redraw_grass_not_new
	cp e
	jr nz, render_redraw_grass_not_new
	jr render_redraw_grass_new
	;;erase
	render_redraw_grass_not_new:
	render_draw_solid_box #0xF3, #2, #2 
	;;test
	
	render_redraw_grass_new:

	;;only draw if not dead
	xor a
	cp grass_is_dead(ix)
	ret nz
	
	render_get_screen_pointer grass_x_coord(ix), grass_y_coord(ix)
	ld grass_last_screen_h(ix), h
	ld grass_last_screen_l(ix), l
	ex de, hl
	ld hl, #_grass
	ld b, #2
	ld c, #2
	call cpct_drawSprite_asm
;;F3 light green
;;0F dark green
;; X 0x50 -> 0x00
;; Y 0xA2 -> 0xC8

	ret

render_entity_redraw_xor_low::
	call_render_for_type render_entity_redraw_xor, #render_type_xor_low

render_entity_redraw_xor_high::
	call_render_for_type render_entity_redraw_xor, #render_type_xor_high

;;Render the entity.
;;INPUT:   IX (entity) 
;;DESTROY: AF, BC, DE, HL 
render_entity_redraw_xor::
    ;; doesn't draw non moved entities
	render_get_screen_pointer_from_entity
	ld  a, l
	cp  entity_last_screen_l(ix)
	jr  nz, render_entity_redraw_xor_moved
	ld  a, h
	cp entity_last_screen_h(ix)
	jr  nz, render_entity_redraw_xor_moved
	;;but needs to erase them if they dead!
	xor a
	cp  entity_is_dead(ix)
	ret z

	render_entity_redraw_xor_moved:
	xor a
	cp  entity_last_screen_l(ix)
	jr  nz, render_entity_redraw_xor_not_new
	cp entity_last_screen_h(ix)
	jr  z, render_entity_redraw_xor_no_erase
	;;NO REDIBUJAR LA MISMA NI BORRAR NUEVAS

	render_entity_redraw_xor_not_new:
	push	hl
	;;erase
	ld 		e, entity_last_screen_l(ix)
	ld 		d, entity_last_screen_h(ix)

	ld		l, entity_sprite_l(ix)
	ld		h, entity_sprite_h(ix)

	ld		b, entity_sprite_width(ix)
	ld		c, entity_sprite_height(ix)
	call	cpct_drawSpriteBlended_asm

	pop		hl
    
	render_entity_redraw_xor_no_erase:

	xor a
	cp  entity_is_dead(ix)
	ret nz ;;doesn't draw dead entities

	;; draw
	ld 		entity_last_screen_l(ix), l
	ld		entity_last_screen_h(ix), h
	ex		de, hl
	ld		l, entity_sprite_l(ix)
	ld		h, entity_sprite_h(ix)
	ld		b, entity_sprite_width(ix)
	ld		c, entity_sprite_height(ix)
	call	cpct_drawSpriteBlended_asm

	;;Allows you to see the bounding box of things
	;;At the cost of weird trails of unfathomable madness
    .if render_see_bounding_box
		;;if bounding box
		render_get_screen_pointer entity_x_coord(ix), entity_y_coord(ix)
		ex de, hl
		render_draw_solid_box #0xC0, entity_width(ix), entity_height(ix)
	.endif
	ret

;; Not use direcly, render_message makes it more readable
;;INPUT:
;;	A:	Y
;;	B:	X
;;	H:	BACKGROUND COLOR
;;	L:	FONT COLOR
;;	IY:	STRING
;; DESTROYS: AF, BC, DE, HL, IY
render_draw_text_at::
    ld (render_draw_text_at_y), a
	ld a, b
    ld (render_draw_text_at_x), a

	call cpct_setDrawCharM0_asm

	ld		de, #render_vid_mem_start
	render_draw_text_at_y = .+1
	ld		b, #0xAA
	render_draw_text_at_x = .+1 
	ld		c, #0xAA
	call	cpct_getScreenPtr_asm

	call cpct_drawStringM0_asm

	ret

.globl	cpct_waitVSYNC_asm

;;DESTROYS: AF, BC, DE, HL, IX
render_update::

    call     cpct_waitVSYNC_asm

	ld hl, #render_entity_redraw_xor_high
	call entity_for_all_enemies

	ld hl, #render_entity_redraw_xor_low 
	call entity_for_all_enemies




	ld      ix, #entity_end
	call	render_entity_redraw_xor


	;render_draw_solid_box_at #0x00, #0x00, #0xC0, #4, #0xC8
	;render_draw_solid_box_at #76, #0x00, #0xC0, #4, #0xC8


	ld      ix, #entity_main_player
	call	render_entity_redraw_xor


	;ld ix, #grassfield_grass
	;call render_redraw_grass

	ld hl, #render_redraw_grass
	call grassfield_for_all_grass

	;;STOP, it goes way too fast
	call cpct_waitVSYNC_asm
	halt
	halt


	ret
	