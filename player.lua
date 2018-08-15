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

local ExamFields = {}
-- calculate the field areas in blocks
for _,pos in ipairs(entrance.ExamPositions) do
	-- vector alignment to the block center
	local xpos = (math.floor(pos.x / 16) * 16) + 8
	local ypos = (math.floor(pos.y / 16) * 16) + 8
	local zpos = (math.floor(pos.z / 16) * 16) + 8
	ExamFields[#ExamFields + 1] = {
		start = pos,
		pos1 = {x=xpos-24, y=ypos-72, z=zpos-24},
		pos2 = {x=xpos+23, y=ypos+23, z=zpos+23},
		name = "",
	}
end

local function set_player_privs(player_name, list)
	local privs = {}
	for _,priv in ipairs(list) do
		privs[priv] = true
	end
	minetest.set_player_privs(player_name, privs)
end

-- Place the player in the exam field
local function place_player(pos, player_name)
	local player = minetest.get_player_by_name(player_name)
	if player then
		local spos = minetest.pos_to_string(player:get_pos())
		player:set_attribute("entrance_start_pos", spos)
		player:set_attribute("entrance_last_known_pos", spos)
		player:set_pos(pos)
	end
end	

-- Place the player back to the start point
local function return_player(player_name)
	local player = minetest.get_player_by_name(player_name)
	if player then
		local spos = player:get_attribute("entrance_start_pos")
		local pos = minetest.string_to_pos(spos)
		if pos then
			player:set_pos(pos)
		end
		player:set_attribute("entrance_start_pos", nil)
		player:set_attribute("entrance_last_known_pos", nil)
	end
end	

local function book_field(player_name)
	for _,item in ipairs(ExamFields) do
		if item.name == "" then
			item.name = player_name
			return item
		end
	end
	return nil
end

local function free_field(player_name)
	for _,item in ipairs(ExamFields) do
		if item.name == player_name then
			item.name = ""
			return item
		end
	end
	return nil
end

local function field_index(player_name)
	for idx,item in ipairs(ExamFields) do
		if item.name == player_name then
			return idx
		end
	end
	return nil
end

local function place_marker(pos)
	minetest.set_node(pos, {name="wool:yellow"})
	pos.y = pos.y + 1
	minetest.set_node(pos, {name="wool:yellow"})
	pos.y = pos.y + 1
	minetest.set_node(pos, {name="wool:yellow"})
	pos.y = pos.y + 1
	minetest.set_node(pos, {name="wool:yellow"})
	pos.y = pos.y + 1
	minetest.set_node(pos, {name="wool:yellow"})
	pos.y = pos.y + 1
	minetest.set_node(pos, {name="wool:yellow"})
end

local function place_markers(start, pos1, pos2)
	place_marker({x=pos1.x, y=start.y, z=pos1.z})
	place_marker({x=pos2.x, y=start.y, z=pos2.z})
	place_marker({x=pos2.x, y=start.y, z=pos1.z})
	place_marker({x=pos1.x, y=start.y, z=pos2.z})
end

local function clear_player_inventory(player_name)
	local inv = minetest.get_inventory({type="player", name=player_name})
	local list = inv:get_list("main")
	for _,stack in ipairs(list) do
		stack:clear()
	end
	inv:set_list("main", list)
end

local function fill_player_inventory(player_name, items)
	local inv = minetest.get_inventory({type="player", name=player_name})
	for _,item in ipairs(items) do
		inv:add_item("main", item)
	end
end


local function control_player(pos1, pos2, player_name)
	local player = minetest.get_player_by_name(player_name)
	if player then
		if minetest.check_player_privs(player_name, "entrant") then
			-- check if outside of the exam field
			local correction = false
			local pl_pos = player:getpos()
			if pl_pos then
				if pl_pos.x < pos1.x then pl_pos.x = pos1.x; correction = true end
				if pl_pos.x > pos2.x then pl_pos.x = pos2.x; correction = true end
				if pl_pos.y < pos1.y then pl_pos.y = pos1.y; correction = true end
				if pl_pos.y > pos2.y then pl_pos.y = pos2.y; correction = true end
				if pl_pos.z < pos1.z then pl_pos.z = pos1.z; correction = true end
				if pl_pos.z > pos2.z then pl_pos.z = pos2.z; correction = true end
				-- check if a protected area is violated
				if correction == true then
					local spos = player:get_attribute("entrance_last_known_pos")
					local last_pos = minetest.string_to_pos(spos)
					if last_pos then
						player:set_pos(last_pos)	
					end
				else  -- store last known correct position
					local spos = minetest.pos_to_string(pl_pos)
					player:set_attribute("entrance_last_known_pos", spos)
				end
				minetest.after(1, control_player, pos1, pos2, player_name)
			end
		end
	end
end	

local function formspec_help(offs)
	return "size[13,8]"..
		default.gui_bg..
		default.gui_bg_img..
		default.gui_slots..
		"field[0,0;0,0;_type_;;help]"..
		"image[7.5,0;5,3;entrance_altar.png]"..
		"label[0,"..(3-offs/50)..";"..entrance.ExamHelp.."]"..
		--"label[0.2,0;test]"..
		"scrollbar[12,0;0.5,8;vertical;sb_help;"..offs.."]"
end

local function start_test(player_name)
	local item = book_field(player_name)
	if item then
		set_player_privs(player_name, entrance.PlayerExamPrivs)
		fill_player_inventory(player_name, entrance.ExamStartItems)
		place_player(item.start, player_name)
		minetest.delete_area(item.pos1, item.pos2)
		minetest.after(5, place_markers, item.start, item.pos1, item.pos2)
		minetest.after(1, control_player, item.pos1, item.pos2, player_name)
		minetest.show_formspec(player_name, "entrance:exam_help", formspec_help(1))
		return true
	end
	return false
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local evt = minetest.explode_scrollbar_event(fields.sb_help)
	if evt.type == "CHG" then
		minetest.show_formspec(player:get_player_name(), 
				"entrance:exam_help", 
				formspec_help(evt.value))
	end
end)

local function cancel_test(player_name)
	local item = free_field(player_name)
	if item then
		-- no privs anymore
		minetest.set_player_privs(player_name, {})
		clear_player_inventory(player_name)
		return_player(player_name)
		return true
	end
	return false
end

local congratulations = "size[8,4]"..
	default.gui_bg..
	default.gui_bg_img..
	default.gui_slots..
	"image[6,0;2,2;entrance_cup.png]"..
	"label[0,0;"..
	S("Congratulations!!\n\nYou successfully passed\nthe entrance exam.\n\n"..
	  "Achieve your dreams but stick to the rules").."]"

function entrance.test_finished(player_name)
	if cancel_test(player_name) then
		set_player_privs(player_name, entrance.PlayerStandardPrivs)
		fill_player_inventory(player_name, entrance.ExamFinishedItems)
		minetest.show_formspec(player_name, "entrance:congratulations", congratulations)
		minetest.chat_send_player(player_name, S("You successfully passed the entrance exam"))
		minetest.chat_send_all(player_name..S(" successfully passed the entrance exam"))
		minetest.log("action", player_name.." passed the entrance exam")
	end
end


minetest.register_privilege("entrant", 
	{description = S("Player who is currently in the entrance exam"), 
	give_to_singleplayer = false})

minetest.register_chatcommand("start_exam", {
	description = S("Start the entrance exam to get interact privs"),
	func = function(name)
		if not minetest.check_player_privs(name, "interact") then
			if start_test(name) then
				minetest.log("action", name.." started the entrance exam")
				return true, S("Let's start the exam")
			else
				return false, S("All exam fields are full!")
			end
		else
			return false, S("You already have interact privs")
		end
	end,
})

minetest.register_chatcommand("cancel_exam", {
	param = "<Player>",	
	description = S("Cancel the entrance exam for the given player"),
	func = function(name, params)
		if minetest.check_player_privs(name, "server") then
			local player_name = params:match('^(%S+)$')
			if minetest.check_player_privs(player_name, "entrant") then
				cancel_test(player_name)
				minetest.chat_send_player(player_name, S("Your exam was canceled"))
				minetest.log("action", player_name.." canceled the entrance exam")
				return true, S("Exam canceled")
			else
				return false, S("Player is not in the entrance exam")
			end
		end
		return false, S("You don't have server privs")
	end,
})

minetest.register_chatcommand("place_exam_markers", {
	description = S("Place all exam markers"),
	func = function(name, params)
		if minetest.check_player_privs(name, "server") then
			for _,item in ipairs(ExamFields) do
				place_markers(item.start, item.pos1, item.pos2)
			end
			return true, S("Exam markers placed")
		end
		return false, S("You don't have server privs")
	end,
})

minetest.register_chatcommand("exam_help", {
	description = S("Output help to the exam"),
	func = function(name)
		minetest.show_formspec(name, "entrance:exam_help", formspec_help(1))
		return true, ""
	end,
})


-- reserve field for 4 ticks
minetest.register_on_leaveplayer(function(player, timed_out)
	local player_name = player:get_player_name()
	if not minetest.check_player_privs(player_name, "server") and
			minetest.check_player_privs(player_name, "entrant") then
		local idx = field_index(player_name)
		if idx then
			ExamFields[idx].timeout = 4
			minetest.log("action", "Entrant "..player_name.." left the game")
		end
	end
end)

-- cancel exam when the timeout is up 
minetest.register_on_joinplayer(function(player)
	local player_name = player:get_player_name()
	if not minetest.check_player_privs(player_name, "server") and
			minetest.check_player_privs(player_name, "entrant") then
		local idx = field_index(player_name)
		if idx == nil then
			minetest.set_player_privs(player_name, {})
			clear_player_inventory(player_name)
			return_player(player_name)
		end
	else
		minetest.log("action", "Entrant "..player_name.." joined the game")
	end
	if not minetest.check_player_privs(player_name, "interact") then
		minetest.chat_send_player(player_name, entrance.WelcomeInfo)
	end
end)

-- cancel exam
minetest.register_on_dieplayer(function(player)
	local player_name = player:get_player_name()
	if not minetest.check_player_privs(player_name, "server") and
			minetest.check_player_privs(player_name, "entrant") then
		minetest.set_player_privs(player_name, {})
		clear_player_inventory(player_name)
	end
end)


local function maintenance()
	-- output welcome text
	for _,player in ipairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		if not minetest.check_player_privs(name, "interact") then
			minetest.chat_send_player(name, entrance.WelcomeInfo)
		end
	end
	-- free up booked but deserted exam fields
	for idx,item in ipairs(ExamFields) do
		if item.timeout then
			item.timeout = item.timeout - 1
			if item.timeout <= 0 then
				minetest.log("action", "Entrant "..item.name.." gave up (timeout)")
				item.timeout = nil
				item.name = ""
			end
		end
	end
	minetest.after(5*60, maintenance)
end

minetest.after(30, maintenance)
