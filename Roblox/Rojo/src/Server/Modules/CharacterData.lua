local charData = {}
charData.CachedData = {}

local charStore = game:GetService("DataStoreService"):GetDataStore("CharacterStore")

function charData.SaveData(plr, data)
    local success, err = pcall(function()
        charData:UpdateAsync(plr.UserId .. "-char_data", function(_)
            charData.CachedData[plr.UserId] = data
            return data
        end)
    end)

    if not success then
        warn("Error when saving data for " .. plr.Name .. ": " .. err)
    end
end

function charData.GetData(plr)
    if not charData.CachedData[plr.UserId] then
        local _, result = pcall(function()
            return charStore:GetAsync(plr.UserId .. "-char_data") or {}
        end)
        
        charData.CachedData[plr.UserId] = result
        return result
    end
    return charData.CachedData[plr.UserId]
end

return game:GetService("RunService"):IsServer() and charData