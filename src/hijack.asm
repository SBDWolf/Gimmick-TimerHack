bank 15
// Overwriting: LDY $4A | LDA #$0D | STA $8000 | LDA #$00 | STA $A000 | LDA #$0E
// org $E9CB

// LDA #$09
// STA $8000
// LDA #$06
// STA $A000
// JSR $8920
// NOP

// org $EA05

// LDA #$09
// STA $8000
// LDA #$06
// STA $A000
// JSR $8920
// NOP

org $E9ED

LDA #$09
STA $8000
LDA #$06
STA $A000
JSR $8920






