# Sokoban RISCV User Guide
                                                                                    
                                                                                    
  .--.--.                   ,-.                                                     
 /  /    '.             ,--/ /|            ,---,                                    
|  :  /`. /    ,---.  ,--. :/ |   ,---.  ,---.'|                      ,---,         
;  |  |--`    '   ,'\ :  : ' /   '   ,'\ |   | :                  ,-+-. /  |        
|  :  ;_     /   /   ||  '  /   /   /   |:   : :      ,--.--.    ,--.'|'   |        
 \  \    `. .   ; ,. :'  |  :  .   ; ,. ::     |,-.  /       \  |   |  ,"' |        
  `----.   \'   | |: :|  |   \ '   | |: :|   : '  | .--.  .-. | |   | /  | |        
  __ \  \  |'   | .; :'  : |. \'   | .; :|   |  / :  \__\/: . . |   | |  | |        
 /  /`--'  /|   :    ||  | ' \ \   :    |'   : |: |  ," .--.; | |   | |  |/         
'--'.     /  \   \  / '  : |--' \   \  / |   | '/ : /  /  ,.  | |   | |--'          
  `--'---'    `----'  ;  |,'     `----'  |   :    |;  :   .'   \|   |/              
                      '--'               /    \  / |  ,     .-./'---'               
                                         `-'----'   `--`---'                        
                                                                                    

## Overview

This guide will walk you through the steps required to load and play the game on the CPUlator emulator. You’ll also fnd detailed descriptions of how to interact with the game, customize the gameboard size, and understand the key features such as movement, error handling for invalid moves, and restarting.

## Getting Started

1. Download the Game File

• First, download the game fle provided to you.

2. Open CPUlator Emulator

• Go to https://cpulator.01xz.ne/7sys=rv32-sp∈.


![](https://web-api.textin.com/ocr_image/external/18420e8f935239f2.jpg)

Figure 1: CPUlator RISCV main page.

## 3. Load the Game File

• Click on the File menu at the top of the page, and select Open.

• Choose the game fle you downloaded.


![](https://web-api.textin.com/ocr_image/external/cb366fc2dd14facf.jpg)

Figure 2: On click, this will open fle explorer.


![](https://web-api.textin.com/ocr_image/external/9190b930db2c1b19.jpg)

Figure 3: Navigate to ’downloads’ and load the .s fle.

## 4. Compile and Load the Game

• After selecting the fle, press the F5 key to compile and load the code.

## 5. Run the Game

• If the game doesn’t start automatically, press F3 to begin running the code.


![](https://web-api.textin.com/ocr_image/external/5b4b9a2de87c45a1.jpg)

Figure 4: Ensure to click on the terminal, so it records all input.

## Game Controls

• WASD keys: Use the W, A, S, and D keys to move your character around the game board when prompted.

• R key: Press the R key to restart the game at any time or when prompted after solving a puzzle.

## How to Play

In this version of Sokoban, your objective is to push a single box onto the designated storage location on the game board. By default, the player is repre sented by ’!’, boxes are shown as ’#’, targets as ’O’, and walls are depicted as ’+’. Further info regarding this is documented at the top of the .s fle.

Use the movement controls (W, A, S, D) to move your character around the board. To move the box, simply walk into it in the direction you want to push.The box can only be pushed (not pulled), and you cannot push it into walls or outside the boundaries of the game board.

## Objective

• Win the game by pushing the box onto the storage location, which is clearly marked on the board.

## Key Gameplay Rules

• You can only push: The box can only be pushed from behind; pulling it is not possible.

• One box: Since there is only one box, plan your moves carefully to avoid getting it stuck in corners or against walls.

• Walls block movement: Be mindful of walls as you push the box; once the box is stuck against a wall, it cannot be moved.

## Gameplay Features

• Walls and Movement: The game board includes walls that block your movement. When you try to move into a wall or out of bounds, the game will display a clear error message indicating that the move is invalid.

• Restarting the Game: After each move, the program will prompt you with an option to restart the game at any time by pressing the R key.

• Winning the Game: When you successfully solve the puzzle, the game will celebrate your success with a congratulatory message. Afterward, you will be prompted to restart if you wish to play again.


![](https://web-api.textin.com/ocr_image/external/d64273050dfd9477.jpg)

Figure 5: Code has exited and requires a diferent restart.


![](https://web-api.textin.com/ocr_image/external/fa59f14d61831ea2.jpg)

Figure 6: Player is attempting to move into the wall.

## Customization Options

Press CTRL + E to open the editor. Navigate to the .data section at the top.Under the #customizable tag, you will fnd all customizable options. Ensure to recompile the game and run it after any changes, using the same instructions mentioned earlier.

### 1. Change Gameboard Size

You can change the gameboard size to your liking, making navigation more tedious or easy. X-Y Dimensions can both be altered, just make sure to not go below the minimum measurements.

### 2. Change Player Skin

You can also customize the appearance of your character by selecting diferent ”skins” or symbols to represent the player on the gameboard.This can be modifed through the same .data section in the editor.


![](https://web-api.textin.com/ocr_image/external/0f1c33f8d24003a2.jpg)


|  |  |
| -- | -- |


Figure 7: Any boundaries will be stated beside the variable.

## Troubleshooting

• Game not loading: Make sure you’ve pressed F5 to compile the code.If the game doesn’t start, try pressing F3 to run it.

• Invalid Moves: If your character cannot move in a direction, a message will inform you that the move is not possible. Double-check your input and ensure you are not blocked by a wall or edge.

• Adjusting Controls: Ensure your keyboard input is working correctly,and you are using the appropriate keys (W, A, S, D for movement and R for restarting).

## Tips for New Players

• Plan your moves: Since walls block your path, plan your navigation to avoid unnecessary backtracking.

• Restart if stuck: If you feel like you’ve made a mistake or are stuck,press R to restart the game instantly.

• Experiment with settings: Adjust the grid size and player skin to suit your preferences or to increase the game’s difculty.

## Enjoy the Game!

Customize your experience and challenge yourself to solve the puzzle. Have fun!



