bank 3

org $C920

LDA {game_state}
CMP #$08
BEQ check_transition
JMP {done_offset}

check_transition:
LDA {in_transition}
CMP #$00
BEQ check_timer_cap
BNE transfer_room_time



check_timer_cap:
LDA #$00
STA {already_transferred_room_time}
LDA {timer_cap_flag}
// Keep in mind that this number notation without the $ sign means decimal!
CMP #100
BNE increment_timer
JMP {done_offset}


transfer_room_time:
LDA {already_transferred_room_time}
CMP #$01
BEQ go_to_done
LDA {curr_timer_f}
STA {prev_timer_f}
LDA {curr_timer_s}
STA {prev_timer_s}
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


// This method of drawing is just how you draw stuff on video on the NES. Consult the PPU Registers page on nesdev for more information.
draw_timer:
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



LDA #$23
STA {PPU_ADDR}
LDA #$8F
STA {PPU_ADDR}
LDX {prev_timer_s}
LDA {tens_digits}, x
STA {PPU_DATA}
LDA {ones_digits}, x
STA {PPU_DATA}

LDA #$23
STA {PPU_ADDR}
LDA #$92
STA {PPU_ADDR}
LDX {prev_timer_f}
LDA {tens_digits}, x
STA {PPU_DATA}
LDA {ones_digits}, x
STA {PPU_DATA}




// Execute Hijacked instructions, then return to hijacked loop
.done:


LDY $4A
LDA #$0D
STA $8000
LDA #$00
STA $A000
LDA #$0E
RTS



// Lookup tables for quick hex to dec conversion. This saves CPU time at the expense of ROM space.
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
db $F // 100

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
db $C // 100
