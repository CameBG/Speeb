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

.globl keyboard_update
.globl keyboard_check_space_just_pressed
.globl keyboard_check_enter_just_pressed
.globl keyboard_check_a_just_pressed
.globl keyboard_check_d_just_pressed
.globl keyboard_check_a_pressed
.globl keyboard_check_d_pressed
.globl keyboard_check_a_not_pressed
.globl keyboard_check_d_not_pressed
.globl keyboard_check_a_just_released
.globl keyboard_check_d_just_released

.globl cpct_isKeyPressed_asm

keyboard_not_pressed_state = 0x00
keyboard_pressed_state = 0x01
keyboard_just_pressed_state = 0x02
keyboard_just_released_state = 0x04

keyboard_space  = 0x8005
keyboard_enter  = 0x0402
keyboard_a      = 0x2008
keyboard_d      = 0x2007

keyboard_left   = 0x0409
keyboard_right  = 0x0809
keyboard_shoot1 = 0x1009

;;INPUT:
;;  _KEY:   adress to the key state direction, can be **
;;  _VALUE: value to check, can be *, a, b, c, d, e, h, l, (hl), (ix+*), (iy+*)
;;RETURNS:
;;  z if _KEY is set at _VALUE, nz otherwise
;;DESTROYS: AF
.macro keyboard_check_key_value _KEY, _VALUE
    ld a, (_KEY)
    cp _VALUE
.endm

;;INPUT:
;;  HL:         key code
;;  _OUTPUT:    state byte for the key/set of keys, can be **
;;DESTROYS: AF, BC, DE, HL
.macro keyboard_update_state _OUTPUT, _KEY_CODE_1, _KEY_CODE_2
    call    cpct_scanKeyboard_asm

    ld hl, _KEY_CODE_1
    call    cpct_isKeyPressed_asm
    jr      nz,  .+2 +3+3+2 +3+2+2 +3+2+2 +2+3+2 +2+3+2        ;; (jr was key 'pressed'?)

    ld hl, _KEY_CODE_2
    call    cpct_isKeyPressed_asm
    jr      nz,  .+2 +3+2+2 +3+2+2 +2+3+2 +2+3+2        ;; (jr was key 'pressed'?)



    ;; was key 'pressed' before?
    ld  a,  (_OUTPUT)                           ;;  3 bytes
    cp  #keyboard_pressed_state             ;;  2 bytes
    jr  z,  .+2 +3+2+2 +2+3+2                   ;;  2 bytes (jr just pressed)

    ld  a,  (_OUTPUT)                           ;;  3 bytes
    cp  #keyboard_just_pressed_state           ;;  2 bytes
    jr  z,  .+2 +2+3+2                          ;;  2 bytes (jr just pressed)

    ;;  not_pressed
        ld  a,  #keyboard_not_pressed_state         ;;  2 bytes
        ld  (_OUTPUT), a                        ;;  3 bytes
        jr  .+2 +3+2+2 +2+3+2 +3+2+2 +2+3+2 +2+3;;  2 bytes (jr continue)

    ;;  released
        ld  a,  #keyboard_just_released_state    ;;  2 bytes
        ld  (_OUTPUT), a                        ;;  3 bytes
        jr  .+2 +3+2+2 +3+2+2 +2+3+2 +2+3       ;;  2 bytes (jr continue)

    ;; was key 'not pressed' before?
    ld  a,  (_OUTPUT)                           ;;  3 bytes
    cp  #keyboard_not_pressed_state                 ;;  2 bytes
    jr  z,  .+2 +3+2+2 +2+3+2                   ;;  2 bytes (jr released)

    ld  a,  (_OUTPUT)                           ;;  3 bytes
    cp  #keyboard_just_released_state            ;;  2 bytes
    jr  z,  .+2 +2+3+2                          ;;  2 bytes (jr released)

    ;;  pressed
        ld  a,  #keyboard_pressed_state     ;;  2 bytes
        ld  (_OUTPUT), a                        ;;  3 bytes
        jr  .+2 +2+3                            ;;  2 bytes (jr continue)

    ;; just_pressed
        ld  a,  #keyboard_just_pressed_state   ;;  2 bytes
        ld  (_OUTPUT), a                        ;;  3 bytes

    ;;  continue:
.endm