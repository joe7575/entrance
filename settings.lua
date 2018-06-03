--[[

	Entrance Settings
	=================

	Copyright (C) 2018 Joachim Stolberg

	LGPLv2.1+
	See LICENSE.txt for more information
	
	Adapt this file to your own needs
	
]]--


-- list of positions of "green areas" for the exams
entrance.ExamPositions = {
    {x=-112, y=11, z=633},
    {x=-225, y=10, z=811},
}

-- what the player gets to start the exam
entrance.ExamStartItems = {
	"default:tree 4", 
	"default:sapling 8", 
	"farming:seed_wheat 10", 
	"default:torch 4", 
	"default:water_source",
}

-- what has to be in the offering bowl to finish the exam
entrance.RequiredItems = {
	"default:torch",
	"farming:wheat 4", 
	"default:apple 2"
}

-- what the player gets after he finished the exam
entrance.ExamFinishedItems = {
	"default:tree 4", 
	"default:sapling 8", 
	"farming:seed_wheat 10", 
	"default:torch 4", 
	"default:water_source",
}

-- player privs during the exam (don't remove the entrant privs)
entrance.PlayerExamPrivs = {"interact", "shout", "entrant"}

-- player privs after he has finished the exam
entrance.PlayerStandardPrivs = {"interact", "shout", "spawn", "home", "settime"}


-- message will be shown to new players cyclically
entrance.WelcomeInfo = [[
Welcome here on the Server!
You don't have any privs/rights to build or craft anything. 
Before you get the privs, you have to make the entrance exam. 
This exam is not difficult but needs about 20 min or more depending on your skills.
Start the exam with the command '/start_exam'
]]

-- player without interact privs will be teleported to this point when punched
entrance.SpawnPoint = {x=-13, y=22, z=591}
