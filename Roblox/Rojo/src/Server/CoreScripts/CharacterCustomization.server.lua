local ServerScriptService = game:GetService("ServerScriptService")
local dataModule = require(ServerScriptService.Modules.CharacterData)
local whitelistModule = require(ServerScriptService.Modules.Whitelist)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local charSelectEvent = ReplicatedStorage.Remotes:WaitForChild("CharacterSelectEvent")

local function SetAllStates(humanoid, walkSpeed, jumpPower, state)
    for _,enum in pairs(Enum.HumanoidStateType:GetEnumItems()) do
        if enum ~= Enum.HumanoidStateType.None then
            humanoid:SetState(enum, state)
        end
    end
    humanoid.WalkSpeed = walkSpeed
    humanoid.JumpPower = jumpPower
end

game.Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        local data = dataModule.GetData(plr)
        local humanoid = char:FindFirstChildWhichIsA("Humanoid")
        -- SetAllStates(humanoid, 0, 0, false)
        charSelectEvent:FireClient(plr, data, whitelistModule.Berserker[plr.Name], whitelistModule.Nitro[plr.Name])
        -- Figure out better way to access whitelist
    end)
end)