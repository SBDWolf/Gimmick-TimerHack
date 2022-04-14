# Gimmick-TimerHack
A TimerHack for Gimmick! Speedrunning practice.

To be assembled using xkas v14+1 (usage: xkas -o {rom path} {main.asm path}, with xkas placed in the root folder).

Features:
- Current room timer in the bottom left, previous room timer just to the right (room are defined as separated by a black screen transition).

Known issues:
- Graphical glitches:
- Static numbers below the timers (interestinly, bizhawk cuts out the portion of the screen that would show these, but they appear on a real console);
- A small flickering bar above the HUD;
- Sometimes items in your inventory get the wrong color palette;
- Sometimes the whole screen flickers.
