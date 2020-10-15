local mod_name = "aoe_tools"
local max_digtime_mult = 2

local wield_scale = { x = 1, y = 1, z = 1 }

local alog = function(...)
	local arg = {...}
	local str = ""
		for _,s in ipairs(arg) do
			str = str .. tostring(s) .. "\t"
		end
	minetest.log("action", str)
end
local wlog = function(...)
	local arg = {...}
	local str = ""
		for _,s in ipairs(arg) do
			str = str .. tostring(s) .. "\t"
		end
	minetest.log("warning", str)
end



local function dig_aoe(itemstack, user, node, digparams, pointed_thing)
	if not pointed_thing or pointed_thing.type ~= "node" then 
		return
	end
	--minetest.log("action", "digp: " .. dump(digparams))
	--itemstack:add_wear(digparams.wear)
	
	local m_digtime
	if digparams.diggable then
		m_digtime = digparams.time
	else
		--the node was dug, so it must be diggable by the hand.
		m_digtime = minetest.get_dig_params(
			minetest.registered_nodes[node.name].groups,
			ItemStack(nil):get_tool_capabilities()).time
	end
		
		
	
	local initial_tool = itemstack:get_name()
	
	for i=1, -1, -1 do
		for j = 1, -1, -1 do
			--don't mine the central node again
			--if i == 0 and j == 0 then
			--	goto continue --why are we using lua, again?
			--end
			
			local pos = table.copy(pointed_thing.under)
			
			if pointed_thing.under.x ~= pointed_thing.above.x then
				pos.y = pos.y + i
				pos.z = pos.z + j
			elseif pointed_thing.under.y ~= pointed_thing.above.y then
				pos.x = pos.x + i
				pos.z = pos.z + j
			elseif pointed_thing.under.z ~= pointed_thing.above.z then
				pos.y = pos.y + i
				pos.x = pos.x + j
			else
				wlog("Invalid pointed_thing: all coordinates match.")
				return
			end
			
			
			--minetest.log("action", "diggin " .. dump(pos))
			local current_node = minetest.get_node(pos)
			--minetest.log("action", "node at " ..i .. ", " .. j ..": " .. 
			--dump(current_node))
			--minetest.log("action", "is name: " .. dump(itemstack:get_name()))
			
			minetest.node_dig(pos, minetest.get_node(pos), user)
			itemstack:add_wear(minetest.get_dig_params(
				minetest.registered_nodes[current_node.name].groups,
				itemstack:get_tool_capabilities()).wear)
			--did the tool already break?
			if itemstack:get_name() ~= initial_tool then
				--minetest.log("action", "tool broke in between")
				return itemstack
			end
			
			::continue::
		end
	end
		
	return itemstack
end


------------------------------------------------------
-- tool regisrations
------------------------------------------------------

minetest.register_tool(mod_name .. ":hammer_wood", {
	description = "Wooden Hammer",
	inventory_image = "hammer_wood.png",
	tool_capabilities = {
		full_punch_interval = 1.6,
		max_drop_level=0,
		groupcaps={	--2.15
			 cracky = {times={[3]=6.0}, uses=16, maxlevel=1},
		},
		damage_groups = {fleshy=3},
		punch_attack_uses = 30,
	},
	groups = { tool=1, hammer=1},
	sound = { breaks = "default_tool_breaks" },
	after_use = dig_aoe,
})

minetest.register_tool(mod_name .. ":hammer_stone", {
	description = "Stone Hammer",
	inventory_image = "hammer_stone.png",
	tool_capabilities = {
		full_punch_interval = 1.6,
		max_drop_level=0,
		groupcaps={
			 cracky = {times={[2]=2.5, [3]=1.80}, uses=32, maxlevel=1},
		},
		damage_groups = {fleshy=4},
		punch_attack_uses = 35,
	},
	groups = { tool=1, hammer=1},
	sound = { breaks = "default_tool_breaks" },
	after_use = dig_aoe,
})

minetest.register_tool(mod_name .. ":hammer_bronze", {
	description = "Bronze Hammer",
	inventory_image = "hammer_bronze.png",
	tool_capabilities = {
		full_punch_interval = 1.55,
		max_drop_level=1,
		groupcaps={
			 cracky = {times={[1]=6.0, [2]=2.3, [3]=1.3}, uses=36, maxlevel=2},
		},
		damage_groups = {fleshy=5},
		punch_attack_uses = 40,
	},
	groups = { tool=1, hammer=1},
	sound = { breaks = "default_tool_breaks" },
	after_use = dig_aoe,
})

minetest.register_tool(mod_name .. ":hammer_steel", {
	description = "Steel Hammer",
	inventory_image = "hammer_steel.png",
	tool_capabilities = {
		full_punch_interval = 1.5,
		max_drop_level=1,
		groupcaps={
			 cracky = {times={[1]=5.0, [2]=2.0, [3]=1.0}, uses=42, maxlevel=2},
		},
		damage_groups = {fleshy=5},
		punch_attack_uses = 45,
	},
	groups = { tool=1, hammer=1},
	sound = { breaks = "default_tool_breaks" },
	after_use = dig_aoe,
})

minetest.register_tool(mod_name .. ":hammer_mese", {
	description = "Mese Hammer",
	inventory_image = "hammer_mese.png",
	tool_capabilities = {
		full_punch_interval = 1.5,
		max_drop_level=3,
		groupcaps={
			 cracky = {times={[1]=3.8, [2]=1.8, [3]=0.85}, uses=42, maxlevel=3},
		},
		damage_groups = {fleshy=6},
		punch_attack_uses = 50,
	},
	groups = { tool=1, hammer=1},
	sound = { breaks = "default_tool_breaks" },
	after_use = dig_aoe,
})

minetest.register_tool(mod_name .. ":hammer_diamond", {
	description = "Diamond Hammer",
	inventory_image = "hammer_diamond.png",
	tool_capabilities = {
		full_punch_interval = 1.45,
		max_drop_level=3,
		groupcaps={
			 cracky = {times={[1]=3.2, [2]=1.5, [3]=0.7}, uses=48, maxlevel=3},
		},
		damage_groups = {fleshy=6},
		punch_attack_uses = 55,
	},
	groups = { tool=1, hammer=1},
	sound = { breaks = "default_tool_breaks" },
	after_use = dig_aoe,
})


------------------------------------------------------
-- recipe regisrations. code ~stolen~ borrowed from MTG.
------------------------------------------------------

local craft_ingreds = {
	wood = "group:wood",
	stone = "group:stone",
	steel = "default:steel_ingot",
	bronze = "default:bronze_ingot",
	mese = "default:mese_crystal",
	diamond = "default:diamond"
}

for name, mat in pairs(craft_ingreds) do
	minetest.register_craft({
		output = "aoe_tools:hammer_".. name,
		recipe = {
			{mat, mat, mat},
			{mat, "group:stick", mat},
			{"", "group:stick", ""}
		}
	})
end