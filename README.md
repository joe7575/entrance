# Entrance

Entrance examination for new players to get standard (interact,...) privs.

Browse on: ![GitHub](https://github.com/joe7575/entrance)

Download: ![GitHub](https://github.com/joe7575/entrance/archive/master.zip)

To keep griefers away from the server all new players don't get interact privs.
They have to go through this entrance exam to get the necessary privs.

Goal of the exam is to build an altar with an offering bowl.
After offering the defined items (see settings.lua) the player has passed the exam.
He will be teleported to the starting position. The exam area will be prepared for the next exam.


After installation, adapt the file settings.lua to your needs:
- Add green flat exam areas to the list entrance.ExamPositions.    
  The area should be large enough for the 32x32 exam field and should be near see level (y-pos)
  so that the player has not go to deep to find ores.    
  And the areas should be far away from any settlement (no help from other players possible)
- Optionally adapt the item lists in ExamStartItems, RequiredItems, and ExamFinishedItems,
- New players should not have any privs. Therefore, adapt minetest.conf: "default_privs = "- 
- Add the normal player privs to PlayerStandardPrivs
- Adapt WelcomeInfo and/or ExamHelp to your needs
- 
![Entrance](https://github.com/joe7575/entrance/blob/master/screenshot.png)

## How it works
- A new spawned player has no interact and no shout privs. He can only walk around and see everything.
  But he gets cyclically a page faded in, where there is an indication that he has to do an entrance exam 
  before he will get normal rights.
- If he agrees, he will be beamed into a green 32x32 area very far out, which he can not leave but has to do the exam.
- The goal is to build an altar and place a sacrificial bowl there and fill it with the required things.
- When the goal is reached, the player gets standard rights and is teleported back to his starting point.
- If the player leaves the game for more than 15 min, the exam is canceled. But the player can start a new test at any time.
- In both cases, the area is cleared again so that the next one finds the same starting conditions.
- Since the player can not leave this field, he has to come to terms with what he finds or can do there.
- The player can always call up a help page with tips and the expected test result.


## Dependencies
default, wool  
Optional: intllib

# License
Copyright (C) 2018 Joachim Stolberg  
Code: Licensed under the GNU LGPL version 2.1 or later. See LICENSE.txt and http://www.gnu.org/licenses/lgpl-2.1.txt  
Textures: CC0

