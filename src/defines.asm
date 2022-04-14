// NES PPU registers
define PPU_ADDR $2006
define PPU_DATA $2007

// $E2 is 0x0 on intro screen, 0x1 on title screen, 0x36 on map screen, and 0x8 during gameplay
define game_state $E2

// This RAM address is non-zero during screen transition
define in_transition $29


// Timer variables
define curr_timer_s $770
define curr_timer_f $771
define prev_timer_s $772
define prev_timer_f $773

define timer_cap_flag $774
define already_transferred_room_time $775


// defining some ROM addresses of MY OWN CODE here and using them as variables, because labels seem oddly broken when using the jmp instruction...
define tens_digits $89F5
define ones_digits $8A5A
define done_offset $89E6

