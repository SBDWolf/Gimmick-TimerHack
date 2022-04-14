bank 15

// This is inside of NMI
org $E9ED
// Overwriting: LDA #$0D | STA $8000 | LDA #$81 | STA $A000 | LDA $EAE4, y
// This code switches bank to one that hasw a lot more free space available.
// Each mapper has a different way of switching banks, this is how you do it Gimmick! (mapper 69)
// https://www.nesdev.org/wiki/Sunsoft_FME-7
LDA #$09
STA $8000
LDA #$06
STA $A000
JSR $8920






