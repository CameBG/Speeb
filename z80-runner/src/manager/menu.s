.module menu

.include "menu.h.s"
.include "system/render.h.s"
.include "utility/keyboard.h.s"

menu_title_message_1: .asciz "RUNNING GAME";
menu_title_message_1_x = 0x08
menu_title_message_1_y = 0x85
menu_title_message_1_text_color = 2

menu_title_message_2: .asciz "[Press SPACE to PLAY]";
menu_title_message_2_x = 0x08
menu_title_message_2_y = 0xA0
menu_title_message_2_text_color = 1

menu_show_title_screen:
   render_draw_text_at #menu_title_message_1_x, #menu_title_message_1_y, #0, #menu_title_message_1_text_color, #menu_title_message_1
   render_draw_text_at #menu_title_message_2_x, #menu_title_message_2_y, #0, #menu_title_message_2_text_color, #menu_title_message_2

   ;; Wait for player to press space
   menu_show_title_screen_loop:
      call  keyboard_update
      call	keyboard_check_space_just_pressed
      jr    nz,   menu_show_title_screen_loop

   ret

menu_init::
    call menu_show_title_screen
    call render_clean
    ret