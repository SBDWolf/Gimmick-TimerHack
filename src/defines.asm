// NES PPU registers
define PPU_CTRL $2000
define PPU_ADDR $2006
define PPU_DATA $2007

// $E2 is 0x0 on intro screen, 0x1 on title screen, 0x36 on map screen, and 0x8 during gameplay
define game_state $E2

// This RAM address is non-zero during screen transition
define in_transition $29

define pause_flag $601
define curr_level $1B
define end_of_game_flag $EB


// Timer variables
define curr_timer_s $770
define curr_timer_f $771
define prev_timer_s $772
define prev_timer_f $773
define level_timer_s $774
define level_timer_f $775

define timer_cap_flag $776
define already_transferred_room_time $777
define already_drawn_static_timers $778

// this variable is used to know when to reset the level timer
define prev_level $779

// this variable is used to know when to set the level timer to 255.59.
// this is because the overflow flag on the NES gets set after a value exceeds 127, so using that CPU flag is not an option...
define prev_level_timer_s $77A


// defining some ROM addresses of MY OWN CODE here and using them as variables, because labels seem broken when using the jmp instruction...
define hundreds_digits $8B08
define tens_digits $8C08
define ones_digits $8D08
define done_offset $8AF0

