.include "cpctelera.h.s"
.include "manager/player.h.s"
.include "system/render.h.s"
.include "system/physics.h.s"

.area _DATA
.area _CODE

.globl cpct_disableFirmware_asm
.globl cpct_waitVSYNC_asm

_main::
   call     cpct_disableFirmware_asm
   
   call     player_init
   call     render_init
   
loop:
   call     physics_update
   call     render_update
   

   .rept 5
      halt
      halt
      call     cpct_waitVSYNC_asm
   .endm
   
   jr       loop