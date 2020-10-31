local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local charSelectEvent = ReplicatedStorage.Remotes:WaitForChild("CharacterSelectEvent")

local connections = require(ReplicatedStorage.Shared.Connections)

-- local configModule = require(ReplicatedStorage.Modules.CharacterScriptsConfig)

local function PromptPlayer(title, body, buttonsContent)
    --[[{
        ["Button"] = {
            ["Text"] = string
            ["OnClick"] = boolean | function
        },
        ...
    }]]
end

--[[
    data {
        {
            ["Name"] = string,
            readonly ["Id"] = ulong | nil
            ["CharacterData"] {
                ...
            }
        },
        ...
    }
]]

local function CharButtonEnter()
    return function(button, data)
        print(button, " is being hovered over")
    end
end

local function CharButtonLeave()
    return function(button, data)
        print(button, " is no longer being hovered over")
    end
end

local function CharButtonClicked()
    return function(button, data)
        print(button, " was clicked")
        
        -- Check if player has data within the clicked slot

        -- If the player has data then ask the player whether
        -- they want to spawn in with that character or not
            -- If yes, then spawn the player in using that character
            -- If no, then do nothing

        -- If the player does not have data, then
        -- ask them whether they want to create
        -- a new character within that slot or not
            -- If yes, then switch page to the race selection
            -- If no, then do nothing
        
        -- No data in slot
        if not data.Id then
            local plrChoice = PromptPlayer(--[[inputObjects, promptTitle, promptDescription]])
        else
            -- local plrChoice = PromptPlayer...
        end
    end
end

local function SetupMainMenu(data, berserkers, charGui)
    charGui = charGui or plr.PlayerGui:FindFirstChild("CharacterCustomizationGui")
    for i,v in pairs(charGui.Background.FirstFrame.Buttons:GetChildren()) do
        -- Display and format data into the character select buttons
        -- Cache data and pre-render data into the character select buttons
        -- so that when player hovers over button, theres no weird delay
        -- when the character is being added and rendered into the view port

        -- Currently I have a id property to discriminate between each character's
        -- data, but it may be better to just pre-render them. Or I could have
        -- an id property and pre-render it.
        v.Name = "CharacterSlot" .. i
        v.Text = data[i] and data[i].Name or "Character Slot " .. i
        v.CharacterId.Value = data[i].Id or -1

        -- Connect click and hover events to the character select buttons
        -- Make sure to disconnect the events once page is switched
        connections.Connect(v.Name, {
            ["MouseEnter"] = v.MouseEnter:Connect(CharButtonEnter(v, data[i])),
            ["MouseLeave"] = v.MouseLeave:Connect(CharButtonLeave(v, data[i])),
            ["MouseButton1Click"] = v.MouseButton1Click:Connect(CharButtonClicked(v, data[i]))
        })
    end
end

local function CreateCharGui(data, berserkers, subscribed)
    -- Uncomment before release
    -- local charGui = ReplicatedStorage.CharacterCustomizationGui:Clone()
    local charGui = game.StarterGui:WaitForChild("CharacterCustomizationGui"):Clone()
    charGui.Parent = plr.PlayerGui
    SetupMainMenu(data, berserkers, charGui)
end

charSelectEvent.OnClientEvent:Connect(CreateCharGui)