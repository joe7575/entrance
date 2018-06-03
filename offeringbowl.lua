--[[

	Entrance
	========

	Copyright (C) 2018 Joachim Stolberg

	LGPLv2.1+
	See LICENSE.txt for more information
	
]]--

-- Load support for intllib.
local MP = minetest.get_modpath("entrance")
local S, NS = dofile(MP.."/intllib.lua")


local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	return stack:get_count()
end

local function allow_metadata_inventory_take(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	return stack:get_count()
end

local function formspec()
	return "size[8,7.5]"..
	default.gui_bg..
	default.gui_bg_img..
	default.gui_slots..
	"list[context;main;0,0;8,4;]"..
	"list[current_player;main;0,3.5;8,4;]"..
	"listring[context;main]"..
	"listring[current_player;main]"
end

-- determine the number of cobble and torch nodes
local function check_altar(pos)
	local pos1 = {x=pos.x-2, y=pos.y-6, z=pos.z-2}
	local pos2 = {x=pos.x+2, y=pos.y-1, z=pos.z+2}
	local nodes = minetest.find_nodes_in_area(pos1, pos2, "default:cobble")
	local num_cobble = #nodes
	pos1 = {x=pos.x-2, y=pos.y, z=pos.z-2}
	pos2 = {x=pos.x+2, y=pos.y, z=pos.z+2}
	nodes = minetest.find_nodes_in_area(pos1, pos2, "default:torch")
	local num_torch = #nodes
	return num_cobble == 125 and num_torch >= 16
end

local function check_inventory(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local content = {}
	for _,stack in ipairs(inv:get_list("main")) do
		if not stack:is_empty() then
			local name = stack:get_name()
			if content[name] then
				content[name] = content[name] + stack:get_count()
			else
				content[name] = stack:get_count()
			end
		end
	end
	for _,item in pairs(entrance.RequiredItems) do
		local parts = string.split(item, " ")
		local count
		if #parts == 1 then 
			count = 1
		else
			count = tonumber(parts[2])
		end
		local name = parts[1]
		if not content[name] or content[name] < count then
			return false
		end
	end
	return true
end

local function check_results(pos, player)
	if check_altar(pos) and check_inventory(pos) then
		entrance.test_finished(player:get_player_name())
	end
end


minetest.register_node("entrance:offeringbowl", {
	description = S("Offering Bowl"),
	tiles = {
		-- up, down, right, left, back, front
		'entrance_offeringbowl_top.png',
		'entrance_offeringbowl_top.png',
		'entrance_offeringbowl.png',
	},

	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-8/16, -8/16, -8/16,  8/16,  6/16,  8/16},
			{-8/16, -8/16, -8/16,  8/16,  8/16, -6/16},
			{ 6/16, -8/16, -8/16,  8/16,  8/16,  8/16},
			{-8/16, -8/16, -8/16, -6/16,  8/16,  8/16},
			{-8/16, -8/16,  6/16,  8/16,  8/16,  8/16},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {-8/16, -8/16, -8/16,   8/16, 8/16, 8/16},
	},

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size('main', 24)
	end,
	
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", formspec())
	end,

	on_rotate = screwdriver.disallow,
		
	can_dig = function(pos,player)
		if minetest.is_protected(pos, player:get_player_name()) then
			return false
		end
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,

	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_take = allow_metadata_inventory_take,

	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		check_results(pos, player)
	end,
	
	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	groups = {cracky=2},
	is_ground_content = false,
	sounds = default.node_sound_metal_defaults(),
})


minetest.register_craft({
	output = "entrance:offeringbowl",
	recipe = {
		{"default:steel_ingot", "", "default:steel_ingot"},
		{"default:steel_ingot", "default:coal_lump", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
	},
})

