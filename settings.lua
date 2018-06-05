--[[

	Entrance Settings
	=================

	Copyright (C) 2018 Joachim Stolberg

	LGPLv2.1+
	See LICENSE.txt for more information
	
	Adapt this file to your own needs
	
]]--

-- Load support for intllib.
local MP = minetest.get_modpath("entrance")
local S, NS = dofile(MP.."/intllib.lua")


-- list of positions of "green areas" for the exams
entrance.ExamPositions = {
    {x=-112, y=11, z=633},
    {x=-225, y=10, z=811},
}

-- what the player gets to start the exam
entrance.ExamStartItems = {
	"default:tree 5", 
	"farming:seed_wheat 12", 
	"default:torch 8", 
	"default:water_source",
}

-- what has to be in the offering bowl to finish the exam
entrance.RequiredItems = {
	"default:sword_steel",
	"farming:bread 2", 
}

-- what the player gets after he finished the exam
entrance.ExamFinishedItems = {
	"default:torch 20", 
	"default:tree 20", 
	"default:sapling 10", 
	"farming:seed_wheat 20", 
	"farming:bread 20,"
}

-- player privs during the exam (don't remove the entrant privs)
entrance.PlayerExamPrivs = {"interact", "shout", "entrant"}

-- player privs after he has finished the exam
entrance.PlayerStandardPrivs = {"interact", "shout", "home"}


-- message will be shown to new players cyclically
entrance.WelcomeInfo = S([[Welcome here on the Server!
You don't have any privs/rights to build or craft anything. 
Before you get the privs, you have to make the entrance exam. 
This exam is not difficult but needs about 45 min. or more time depending on your skills.
Start the exam with the command '/start_exam'
More info about the exam with '/exam_help'
]])


entrance.ExamHelp = S([[Your task: 
Build an altar and sacrifice bread 
and a sword for the gods.

You can open again this help page 
by means of the command /exam_help

In detail:
- Remove one dirt and place 
  the water in the hole.
- Craft a Wooden Hoe and prepare the 
  soil around the water for the seed.
  For the recipes use the Crafting Guide.
- Place the seed on the soil.
- Craft a Wooden Pickaxe and go mining.
- Replace the Wooden Pickaxe by means 
  of a Stone Pickaxe.
- Collect Cobblestone, Iron Lump, Coal Lump
  and so on.
- Craft a Furnace and smelt the Iron Lumps
  to Steel Ingots.
- Craft the Offering Bowl.
- Build the altar (5x5x5 blocks large) 
  by means of 125 Cobblestone.
- Place 16 Torches on the altar.
- Place the Offering Bowl in the middle.
- Craft the Steel Sword.
- Harvest the Wheat when it is ripe.
  (has to be as high as a normal block)
- Craft the 2 Flour from 8 Wheat.
- Cook the Bread in the Furnace.
- Sacrifice the 2 Breads and the Sword.

That's it. Simple, or?  :)
]])