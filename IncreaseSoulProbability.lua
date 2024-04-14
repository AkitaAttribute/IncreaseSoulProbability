--- STEAMODDED HEADER
--- MOD_NAME: IncreaseSoulProbability
--- MOD_ID: IncreaseSoulProbability
--- MOD_AUTHOR: [Akita Attribute]
--- MOD_DESCRIPTION: Increase Soul Spectral Card Probability To Spawn

----------------------------------------------
------------MOD CODE -------------------------
-- 1 is 100% chance it will spawn Soul.  Increase the value to lower the chance. 100 would be a 1 in 100 chance.
-- 1 will be a 100% chance of spectral packs having Soul.
-- Once all legendary cards are owned, they will start to spawn the default joker.  This is base game behavior.
local chanceValue = 1
-- Can be anything actually.  You can make vouchers show up in packs.
local probUppedCard = "c_soul"
-- local pack_types = {"Tarot", "Spectral", "Tarot_Planet"}
local probUppedCardPacks = {"Spectral"} -- Made it this way to allow for more inclusions if desired.

local originalFuncRef = create_card

function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
	-- Soul/BH logic
    --local original_pseudorandom = pseudorandom
    --pseudorandom = function(key)
    --    local original_result = original_pseudorandom(key)
        
		-- logToFile("Card key: " .. key)
    --    if string.find(key, 'soul_') then
	--		if math.random(chanceValue) == 1 then
	--			return 1
	--		end
    --        return 0
    --    end
        
    --    return original_result
    --end
	-- Soul/BH logic
	
	local newCardGen
	if (type_condition(probUppedCardPacks, _type)) then
		if math.random(chanceValue) == 1 then
			newCardGen = originalFuncRef(_type, area, legendary, _rarity, skip_materialize, soulable, probUppedCard, key_append)
		else
			newCardGen = originalFuncRef(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
		end
	else
		newCardGen = originalFuncRef(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
	end
    
	-- reset psuedorandom back to normal
    --pseudorandom = original_pseudorandom
    
    return newCardGen
end


function type_condition(valid_types, input_string)
	-- example valid_types input:
	-- local pack_types = {"Tarot", "Spectral", "Tarot_Planet"}
	for _, str in ipairs(valid_types) do
        if str == input_string then
            return true  -- The input string is in the list
        end
    end
    return false  -- The input string is not in the list
end


local originalSplashScreenRef = G.splash_screen

function G.splash_screen(self)
	
    local result = originalSplashScreenRef(self)
	
	forceTag("tag_ethereal")
	--forceTag("tag_charm")
	-- forceTag("tag_meteor")
	
	return result
end

function forceTag(tag_name)
	for id, data in pairs(G.P_TAGS) do
		if id ~= tag_name then
			G.P_TAGS[id].min_ante = 100
		else
			G.P_TAGS[id].min_ante = nil
		end
	end
end

function logToFile(logString)
	local file = io.open("test.txt", "a")
	file:write(logString .. "\n")
	file:close()
end

----------------------------------------------
------------MOD CODE END----------------------
