# Smash Simon
<img src="https://github.com/L-S-2020/smash-simon/blob/main/readme_pictures/gameplay.png?raw=true" alt="the console" width="700"/> 

A 2d (local) multiplayer fighting game, build as present for the 18th birthday of a friend ([@Shiggy5](https://github.com/Shiggy5)). This game was developed to be played on the [GG55, a self-made game console](https://github.com/L-S-2020/gg55).

All the characters, animations, maps and healthbars are handmade (or handpixeld ;) ) by Moritz, Johannes, Jan and Martin, I was responsible for the code and the final game design in Godot Engine.

![Godot Engine Badge](https://img.shields.io/badge/Made_using_Godot%20Engine-478CBF?logo=godotengine&logoColor=fff&style=for-the-badge)

## Gameplay
The game itself is inspired from the Super Smash Bros series, with the guys from our friend group as characters. To play, up to four players (as of now, only local connected controllers are supported) choose a character to play, select a map and fight against each other, until only one is still alive. 

<img src="https://github.com/L-S-2020/smash-simon/blob/main/readme_pictures/player_select.png?raw=true" alt="the console" width="230"/> <img src="https://github.com/L-S-2020/smash-simon/blob/main/readme_pictures/map_select.png?raw=true" alt="the console" width="600"/> 

Every character can run (left/right), jump, beat and block, all with animations.

<img src="https://github.com/L-S-2020/smash-simon/blob/main/readme_pictures/animationen.png?raw=true" alt="the console" width="700"/> 

### The characters:


|<img src="https://github.com/L-S-2020/smash-simon/blob/main/readme_pictures/johannes.png?raw=true" alt="the console" width="200"/>| <img src="https://github.com/L-S-2020/smash-simon/blob/main/readme_pictures/jan.png?raw=true" alt="the console" width="200"/>  |<img src="https://github.com/L-S-2020/smash-simon/blob/main/readme_pictures/moritz.png?raw=true" alt="the console" width="200"/> | <img src="https://github.com/L-S-2020/smash-simon/blob/main/readme_pictures/martin.png?raw=true" alt="the console" width="200"/> |<img src="https://github.com/L-S-2020/smash-simon/blob/main/readme_pictures/simon.png?raw=true" alt="the console" width="200"/> | <img src="https://github.com/L-S-2020/smash-simon/blob/main/readme_pictures/leonard.png?raw=true" alt="the console" width="200"/> |
|--|--|--|--|--|--|
| Johannes | Jan | Moritz | Martin | Simon | Leonard

### The maps
|<img src="https://github.com/L-S-2020/smash-simon/blob/main/readme_pictures/classroom.png?raw=true" alt="the console" width="300"/> | <img src="https://github.com/L-S-2020/smash-simon/blob/main/readme_pictures/5.png?raw=true" alt="the console" width="300"/>  |
|--|--|
| GSG (Inspired by our school) | 5 (inspired by Simons favourite number) |



## Making the game
The game itself was made using godot engine, for the graphics, piskel editor was used.

<img src="https://github.com/L-S-2020/smash-simon/blob/main/readme_pictures/godot_editor.png?raw=true" alt="the console" width="700"/> 

From a systemdesign standpoint, the game is based on a "main" scene, which receives the player choices from a global variable. This scene then initates the selected map, the players and the healthbars as child scenes and keeps track of the remaining players and their healthbars. 
For detecting hits between players and applying the damage, I've used the health_hithbox_hurtbox addon, which lets you create so called hurtboxes for players and hitboxes for hits and detecs the collision of the two. So everytime the hit button is pressed, a temporary hitbox is spawned for 0.1 seconds in front of the player. If it collides with the hurtbox of another player, the game subtracts 10 points from the players health. 


## Future roadmap / ideas
- online multiplayer
- more maps/ characters
- PvE levels (fight against computer enemies)
