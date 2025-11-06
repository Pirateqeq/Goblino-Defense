# Goblino Defense!

#### Video Demo:  <URL HERE>

#### Description:
---
A tower defense game where goblins take the path to reach the other end of the screen to steal meat from you. Use towers (The Archer, The Knight and, The Pawn) to defend your food before they steal all of it! As the game progresses the number of goblins increase. Gain gold from defending during waves to increase the number of your towers to ward them off as long as you can!


#### [**Main.lua**](/main.lua):
---
Starting off with the most important file of them all the main file which will take all the seperate lua files and libraries then integrate them together. Using three main Love2d functions `love.load() love.update() love.draw()`. Load on startup takes all the tables from the other lua files and sets the variables up for the game to use. Update runs the code inside of its function every frame of the game based on what is in the other update functions. The draw function will draw onto the game every frame based on what is in the other draw functions. Here is where we will include the libraries which we will use. [Tiled](https://www.mapeditor.org/) a map editor that uses sprite sheets and allows the user to create their own map. I decided to use the [Tiny Swords](https://pixelfrog-assets.itch.io/tiny-swords) sprite pack to illustrate the game.

#### Base Map
![basemap](/assets/map.jpg)
<sup>Map without any elements.</sup>


#### [Grid.lua](/grid.lua)
---
In this lua file we will create the grid for the towers and to mark the enemy path. The sprite sizes are all going to be 64x64px so we will be using a 30x17 grid of 64x64px cells with each index of the grid containing 0, 1, 2 indicating (0) invalid, (1) valid cell, (2) tower. We will be using the grid number to control the placement of towers, the pathway of the enemies and positioning of elements. Originally we were going to use this grid only as a way to indicate wehter a tower is placed but later learned how easy it would be to use it as a cordinate system for positioning elements.

![mapGrid](/assets/mapGrid.jpg)
<sup>Grid Cell containing R (row), C (collum) and the grid number in the center.</sup>


#### [Counter.lua](/counters.lua)
---
This lua file will be used to create and keep track of the playeys current health and gold and have their animations aswel. Gold will be starting off with 100 gold and increasing by each enemy killed by 25 gold. Health will also start at 100 hp and drop 10 points each time a enemy reaches the end. At 0 the players will lose the the game and will have to start over. As for the animation they will be idle, once the wave starts they begin and stop once its over. We will use this file to help with the player losing the game and the progression of the player. The load function will declare and initialize 4 tables and set the games font it will load all of the place ments for the counters and setup their animations aswel. Inside the update function we will have the statement to change the animation of the gold and health to be still otherwise active. Inside the draw function it will contain the statements to setup the font and print out the gold, health, wave, and score for the game.

![Gold](/assets/gold/goldSpawn.png)
<sup>Gold animation</sup>

![Health](/assets/meat/meatFlip.png)
<sup>Health animation</sup>


#### [Enemies.lua](/enemies.lua)
---
This lua file will be used for the enemies of the player (Goblins). They will follow the path on the map in a zig zag, untill they reach the end of the map in which the player will lose a single point of hp. There will be only a single type of enemy (Can be expanded upon) which will be all one hit with increasing size per wave and increasing speeds. They will also have a walking animation but it will be just playing as the enemy walks over the path. There will be a function here to spawn enemies on the call of the function. They will be placed individually into a table which will be drawn all together. 

![Goblin](/assets/goblin/goblinidle.png)
<sup>Goblin unit</sup>

#### [Buttons.lua](/buttons.lua)
---
This file will be used to setup the buttons used to place the towers, there will be 4 buttons in total, 3 tower buttons and one play button. The towers will each have a button image, a button image for when pressed, a animation of said tower, and a price tag of how much the tower will cost. When the button is pressed a idle image of the tower will be following the players mouse to place towers onto the grid. The function for actually spawning the tower itself will reside in their respective lua file. This file will have 3 other functions to assist with its functions `buttons:hovering( x, y )` , `buttons:onClick( x, y )` and `buttons:onRelease()`. Hovering will allow us to check if he players mouse is placed onto the specefic button and return which button it is hovering. The onClick function will be called anytime the player clicks, this will be inconjunction with the hovering function to change the button to its pressed version and select said tower; if the function is not hovering anything it resets all selected values to false. The onRelease function will reset all button images to their non-pressed version. Once a tower is selected the tower with its range is drawn onto the mouse to be placed. There will also be a function to sell towers by selecting a tower using the grid and then clicking onto the sell button that appears.

![Buttons](/assets/mapButtons.jpg)
<sup>Map with buttons</sup>

#### [Archer.lua](/archer.lua)
---
This file will be used to control the Archer tower's function, placement and, it's values. Its load function will load two tables the table containing the archer itself and the arrows that will shot by the archers. The Archer tower will have the longest range out of the three towers (6 blocks) it will cost 100 gold and will shoot a arrow every 3 seconds. Inside the update function there will be two statements one controlling the archer and the arrow. The arrow will have it its own spawn function spawning itself based on the archer that calls the function ( `archers:spawn( x , y )` ). Once an arrow is spawned (using `archers:shootArrow( archerX, archerY, targetX, targetY)` ) it will target the first enemy in its table and get close to the target untill they colide in which the enemy will be despawned ( `table.remove( enemies.table, 1)` ) and then the arrow will also be despawned ( `table.remove( self.arrows, 1)` ). Can be edited to create different variations of archers and or arrows. This tower will have a flag called `archer.inRange` which will indicate whether a enemy is inside the range of this tower. If true the cooldown of said tower will be continued otherwise paused. When the cooldown reachers 2.5s the animation is swtiched to its attack animation `archer.anim = archer.animations.attack`. When its cooldown reaches 2.9s or greater the cooldown is reset to 0s and a arrow is spawned, then the animation is swtiched to its idle animation `archer.anim = archer.animation.idle`. Once the round is over the table for arrows is emptied and its cooldown is reset to the default value and their inRange flags are set to false in case of the round ending with enemies in range. In this statement there is a line `goto doNotAttack end` this line is used to avoid the file trying to index into the first enemies table when its not initialized at the start of the game. Inside its draw function it will have 3 statements one to draw the archer and its animation.

![Archer](/assets/archer/Archer_Still.png)
<sup>Archer while idle</sup>

#### [Knight.lua](/knight.lua)
---
This file will be used to control the Knight tower's function, placement and its values. Its load function will contrain the table for the knight itself.This tower will be used to rapidly attack enemies in a short range. It will cost 100 gold and attack every 2 seconds. The knight will have a range of 3 blocks. This file will include a function to spawn kights `function knights:spawn( x , y )`. Can be edited to spawn in different variation of knights.Inside the update function will be the statements for controlling the knights cooldown and animation (Similaryly to The Archer tower). This tower will also have a flag called `knight.inRange` which will function exactly like the flag in [Archer.lua](/archers.lua). Its cooldown will function simlarly to The Archer tower at 1.5s the animation will swtich to its attack animation and then at 1.9s revert its cooldown back to 0s and remove the first index'd enemy. Then switch its animation abck to idle. Afterward the file checks if the round is over if it is the knights animation will be switched to its idle animation `knight.anim = knight.animations.idle` and its cooldown reset to its default value (1.3s).

![Knight](/assets/knight/Knight_Still.png)
<sup>Knight while idle</sup>

#### [Pawn.lua](/pawns.lua)
---
This file will be used to control the Pawn tower's function, placement, and its values. This file is very simarly to the Knight tower execpt for the animation used, the range, the cooldown of its attack, and the ammount of enemies that the tower attacks (2 enemies instead of 1).

![Pawn](/assets/pawn/Pawn_Still.png)
<sup>Pawn while idle</sup>

#### [gameState.lua](/gameState.lua)
---
This file will handle the waves and score ribbons for the game. It contains the fonts and the flag used to let the game know when the player has lost. When the player loses (health drops below 0) the flag will be set to true and all the buttons become unselectable and a ribbon with GAME OVER appears over the map. With a score and wave counters displayed as well a reset button to restart the program.

![GameOver](/assets/mapGameOver.JPG)
<sup>Game Over screen after player loses</sup>