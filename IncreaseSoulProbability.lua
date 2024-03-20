--- STEAMODDED HEADER
--- MOD_NAME: IncreaseSoulProbability
--- MOD_ID: IncreaseSoulProbability
--- MOD_AUTHOR: [Akita Attribute]
--- MOD_DESCRIPTION: Increase Soul Spectral Card Probability To Spawn

----------------------------------------------
------------MOD CODE -------------------------
-- 1 is 100% chance it will spawn Black Hole and Soul.  Increase the value to lower the chance. 100 would be a 1 in 100 chance.
-- 1 will be a 100% chance of spectral packs having both of these.  Planet packs will contain a black hole 100%, and Tarot packs will 100% contain a Soul.  
-- Oddly, it only marginally increases the chance of Black Hole appearing inside of Tarot packs.
-- I did very basic work here without complete understanding of the impacts.
-- Once all legendary cards are owned, they will start to spawn the default joker.  This is base game behavior.
local chanceValue = 1 

local originalFuncRef = create_card

function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    local original_pseudorandom = pseudorandom
    pseudorandom = function(key)
        local original_result = original_pseudorandom(key)
        
		-- logToFile("Card key: " .. key)
        if string.find(key, 'soul_') then
			if math.random(chanceValue) == 1 then
				return 1
			end
            return 0
        end
        
        return original_result
    end
    
    local newCardGen = originalFuncRef(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    
    pseudorandom = original_pseudorandom
    
    return newCardGen
end




local originalSplashScreenRef = G.splash_screen

function G.splash_screen(self)
	
    local result = originalSplashScreenRef(self)
	
	-- forceTag("tag_ethereal")
	-- forceTag("tag_charm")
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