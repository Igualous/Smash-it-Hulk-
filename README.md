# Smash it, HULK!

## Description
"Smash it, HULK!" is a retro-style, fast-paced action-puzzle game inspired by the mechanics of Fix-It Felix Jr. from the movie Wreck-It Ralph, but reimagined within the Marvel Cinematic Universe (MCU). The game is entirely coded in Assembly RISC-V, offering a minimalist yet challenging experience that pays homage to classic arcade games while celebrating the Avengers' legacy.

## Features
- Graphical interface (Bitmap Display, 320×240, 8 bits/pixel);
- Keyboard interface (Keyboard and Display MMIO simulator);
- MIDI audio interface (ecalls 31, 32, 33);
- 2 levels with different layouts;
- Character animation and movement;
- Collision with enemies and projectiles (loss of life);
- Implementation of 2 enemies, each with distinct behaviors;
- Character attack mechanics and invencibility upon collecting special pellets;
- HUD (heads-up display) with information on lifes, score and power-ups;
- Music and sound effects

## Prerequisites
To run the game, you need:
- A compatible RISC-V CPU or emulator. ([FPGARS](https://leoriether.github.io/FPGRARS/) is included with the game)
- A configured RISC-V Assembly development environment.

## How to play

To run the game, open the folder `GAME` and symply drag the file `main.asm` over the executable `fpgrars-x86_64-pc-windows-msvc--unb.exe`.
````
[ W ], [ A ], [ S ], [ D ] - player move
[ E ], [ I ] - player actions
[ 1 ], [ 2 ] - menu interactions

Cheat codes: 

[ Z ] - second phase                 
[ X ] - game over screen          
[ C ] - game complete screen 
[ T ] - power up                          
````
## License
This project is licensed under the [MIT License](https://opensource.org/licenses/MIT) - see the [LICENSE](LICENSE) file for more details.

## Authors
- Guilherme Silva Cavalcante
- Igor Rodrigues
- João Paulo Silva Mendes
