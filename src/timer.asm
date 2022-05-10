bank 3

org $C920

// Execute part of the hijacked instructions here
// For some reason, it's important to do these here instead of at the end to prevent some graphics from glitching out.

LDA #$0D
STA $8000
LDA #$81
STA $A000


// Various checks
LDA {game_state}
CMP #$08
BEQ check_transition
JMP {done_offset}

check_transition:
LDA {in_transition}
CMP #$00
BNE transfer_room_time

check_pause_flag:
LDA {pause_flag}
CMP #$FF
BNE check_timer_cap
JMP {done_offset}



check_timer_cap:
LDA #$00
STA {already_transferred_room_time}
LDA {timer_cap_flag}
// Keep in mind that this number notation without the $ sign means decimal!
CMP #100
BNE increment_timer
JMP {done_offset}


transfer_room_time:
LDA #$00
STA {already_drawn_static_timers}
LDA {already_transferred_room_time}
CMP #$01
BEQ go_to_done

LDA {level_timer_s}
STA {prev_level_timer_s}

LDA {curr_timer_f}
STA {prev_timer_f}

CLC
ADC {level_timer_f}
CMP #60
BCC dont_increment_seconds
INC {level_timer_s}
SEC
SBC #60
dont_increment_seconds:
STA {level_timer_f}

LDA {curr_timer_s}
STA {prev_timer_s}

CLC
ADC {level_timer_s}
STA {level_timer_s}
CMP {prev_level_timer_s}
BCS level_timer_not_overflown

LDA #255
STA {level_timer_s}
LDA #59
STA {level_timer_f}

level_timer_not_overflown:
LDA #$00
STA {curr_timer_f}
STA {curr_timer_s}
STA {timer_cap_flag}

LDA #$01
STA {already_transferred_room_time}


go_to_done:
JMP {done_offset}



increment_timer:
INC {curr_timer_f}
LDA {curr_timer_f}
CMP #60
BNE draw_timer
LDA #$00
STA {curr_timer_f}
INC {curr_timer_s}
LDA {curr_timer_s}
CMP #100
BNE draw_timer
STA {timer_cap_flag}
LDA #99
STA {curr_timer_s}
LDA #59
STA {curr_timer_f}

draw_timer:
// This method of drawing is just how you draw stuff on video on the NES.
// Consult this for more information: https://www.nesdev.org/wiki/PPU_registers
// I'm not sure what this write to PPU_CTRL does exactly, but I've seen similar stuff to it in other NES hacks.
// I think this write to PPU_CTRL seems to help prevent other graphics from glitching out.
// I think this page from nesdev has some related information: https://www.nesdev.org/wiki/Errata
LDA #$F8
STA {PPU_CTRL}
LDA #$23
STA {PPU_ADDR}
LDA #$85
STA {PPU_ADDR}
LDX {curr_timer_s}
LDA {tens_digits}, x
STA {PPU_DATA}
LDA {ones_digits}, x
STA {PPU_DATA}

LDA #$23
STA {PPU_ADDR}
LDA #$88
STA {PPU_ADDR}
LDX {curr_timer_f}
LDA {tens_digits}, x
STA {PPU_DATA}
LDA {ones_digits}, x
STA {PPU_DATA}


// This flag makes it so that the previous room time only gets drawn once at the start of every room.
// This reduces execution time and should help prevent screen flickering (?)
LDA {already_drawn_static_timers}
CMP #$01
BNE draw_static_timers
JMP {done_offset}


draw_static_timers:
// previous room time
LDA #$23
STA {PPU_ADDR}
LDA #$90
STA {PPU_ADDR}
LDX {prev_timer_s}
LDA {tens_digits}, x
STA {PPU_DATA}
LDA {ones_digits}, x
STA {PPU_DATA}

LDA #$23
STA {PPU_ADDR}
LDA #$93
STA {PPU_ADDR}
LDX {prev_timer_f}
LDA {tens_digits}, x
STA {PPU_DATA}
LDA {ones_digits}, x
STA {PPU_DATA}

// level time
LDA #$23
STA {PPU_ADDR}
LDA #$99
STA {PPU_ADDR}
LDX {level_timer_s}
LDA {hundreds_digits}, x
STA {PPU_DATA}
LDA {tens_digits}, x
STA {PPU_DATA}
LDA {ones_digits}, x
STA {PPU_DATA}

LDA #$23
STA {PPU_ADDR}
LDA #$9D
STA {PPU_ADDR}
LDX {level_timer_f}
LDA {tens_digits}, x
STA {PPU_DATA}
LDA {ones_digits}, x
STA {PPU_DATA}

LDA {curr_level}
CMP {prev_level}
BEQ still_the_same_level

STA {prev_level}
LDA #$00
STA {level_timer_s}
STA {level_timer_f}


still_the_same_level:
INC {already_drawn_static_timers}
JMP {done_offset}




// Execute final instructions out of the ones that have been hijacked, then return to hijacked loop
org {done_offset}
.done:
LDA $EAE4, y
RTS






// Lookup tables for quick hex to dec conversion. This saves CPU time at the expense of ROM space.
org {tens_digits}
.tens_digits_table:
db $0,$0,$0,$0,$0,$0,$0,$0,$0,$0 // 0
db $1,$1,$1,$1,$1,$1,$1,$1,$1,$1 // 10
db $2,$2,$2,$2,$2,$2,$2,$2,$2,$2 // 20
db $3,$3,$3,$3,$3,$3,$3,$3,$3,$3 // 30
db $4,$4,$4,$4,$4,$4,$4,$4,$4,$4 // 40
db $5,$5,$5,$5,$5,$5,$5,$5,$5,$5 // 50
db $6,$6,$6,$6,$6,$6,$6,$6,$6,$6 // 60
db $7,$7,$7,$7,$7,$7,$7,$7,$7,$7 // 70
db $8,$8,$8,$8,$8,$8,$8,$8,$8,$8 // 80
db $9,$9,$9,$9,$9,$9,$9,$9,$9,$9 // 90
db $0,$0,$0,$0,$0,$0,$0,$0,$0,$0 // 100
db $1,$1,$1,$1,$1,$1,$1,$1,$1,$1 // 110
db $2,$2,$2,$2,$2,$2,$2,$2,$2,$2 // 120
db $3,$3,$3,$3,$3,$3,$3,$3,$3,$3 // 130
db $4,$4,$4,$4,$4,$4,$4,$4,$4,$4 // 140
db $5,$5,$5,$5,$5,$5,$5,$5,$5,$5 // 150
db $6,$6,$6,$6,$6,$6,$6,$6,$6,$6 // 160
db $7,$7,$7,$7,$7,$7,$7,$7,$7,$7 // 170
db $8,$8,$8,$8,$8,$8,$8,$8,$8,$8 // 180
db $9,$9,$9,$9,$9,$9,$9,$9,$9,$9 // 190
db $0,$0,$0,$0,$0,$0,$0,$0,$0,$0 // 200
db $1,$1,$1,$1,$1,$1,$1,$1,$1,$1 // 210
db $2,$2,$2,$2,$2,$2,$2,$2,$2,$2 // 220
db $3,$3,$3,$3,$3,$3,$3,$3,$3,$3 // 230
db $4,$4,$4,$4,$4,$4,$4,$4,$4,$4 // 240
db $5,$5,$5,$5,$5,$5 // 250
org {ones_digits}
.ones_digits_table:
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 0
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 10
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 20
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 30
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 40
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 50
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 60
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 70
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 80
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 90
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 100
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 110
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 120
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 130
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 140
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 150
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 160
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 170
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 180
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 190
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 200
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 210
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 220
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 230
db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 240
db $0,$1,$2,$3,$4,$5 // 250

org {hundreds_digits}
db $0,$0,$0,$0,$0,$0,$0,$0,$0,$0 // 0
db $0,$0,$0,$0,$0,$0,$0,$0,$0,$0 // 10
db $0,$0,$0,$0,$0,$0,$0,$0,$0,$0 // 20
db $0,$0,$0,$0,$0,$0,$0,$0,$0,$0 // 30
db $0,$0,$0,$0,$0,$0,$0,$0,$0,$0 // 40
db $0,$0,$0,$0,$0,$0,$0,$0,$0,$0 // 50
db $0,$0,$0,$0,$0,$0,$0,$0,$0,$0 // 60
db $0,$0,$0,$0,$0,$0,$0,$0,$0,$0 // 70
db $0,$0,$0,$0,$0,$0,$0,$0,$0,$0 // 80
db $0,$0,$0,$0,$0,$0,$0,$0,$0,$0 // 90
db $1,$1,$1,$1,$1,$1,$1,$1,$1,$1 // 100
db $1,$1,$1,$1,$1,$1,$1,$1,$1,$1 // 110
db $1,$1,$1,$1,$1,$1,$1,$1,$1,$1 // 120
db $1,$1,$1,$1,$1,$1,$1,$1,$1,$1 // 130
db $1,$1,$1,$1,$1,$1,$1,$1,$1,$1 // 140
db $1,$1,$1,$1,$1,$1,$1,$1,$1,$1 // 150
db $1,$1,$1,$1,$1,$1,$1,$1,$1,$1 // 160
db $1,$1,$1,$1,$1,$1,$1,$1,$1,$1 // 170
db $1,$1,$1,$1,$1,$1,$1,$1,$1,$1 // 180
db $1,$1,$1,$1,$1,$1,$1,$1,$1,$1 // 190
db $2,$2,$2,$2,$2,$2,$2,$2,$2,$2 // 200
db $2,$2,$2,$2,$2,$2,$2,$2,$2,$2 // 210
db $2,$2,$2,$2,$2,$2,$2,$2,$2,$2 // 220
db $2,$2,$2,$2,$2,$2,$2,$2,$2,$2 // 230
db $2,$2,$2,$2,$2,$2,$2,$2,$2,$2 // 240
db $2,$2,$2,$2,$2,$2 // 250
