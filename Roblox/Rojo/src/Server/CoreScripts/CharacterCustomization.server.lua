local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local MessagingService = game:GetService("MessagingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local bersekers, lastUpdate, REQUEST_DELAY = {}, -1, 5 * 60
local dataModule = require(ServerScriptService.Modules.CharacterData)
local charSelectEvent = ReplicatedStorage.Remotes:WaitForChild("CharacterSelectEvent")

local function SetAllStates(humanoid, walkSpeed, jumpPower, state)
    for _,enum in pairs(Enum.HumanoidStateType:GetEnumItems()) do
        if enum ~= Enum.HumanoidStateType.None then
            humanoid:SetStateEnabled(enum, state)
        end
    end
    humanoid.WalkSpeed = walkSpeed
    humanoid.JumpPower = jumpPower
end

local function GetMemberUserId(nickname)
    local success, result = pcall(function()
        return game.Players:GetUserIdFromNameAsync(nickname)
    end)
    return success and result or nil
end

local subSuccess, _ = pcall(function()
    return MessagingService:SubscribeAsync("UpdateWhitelistEvent", function(message)
        print(message.Data["TriggehTrey"] or message.Data[1], message.Data["TriggehTrey"] or " owo")
        bersekers = message.Data
        lastUpdate = os.time()
    end)
end)

coroutine.wrap(function()
    if subSuccess or RunService:IsStudio() then
        while true do
            local delta = os.time() - lastUpdate
            if lastUpdate == -1 or delta > REQUEST_DELAY then
                local success, data = pcall(function()
                    return HttpService:RequestAsync({
                        Url = "https://discord.com/api/v6/guilds/706653106208899132/members?limit=1000",  
                        Method = "GET", 
                        Headers = {
                            ["Content-Type"] = "application/json", 
                            ["Authorization"] = "Bot NzQ1NTA2MTYyOTIwOTE1MDQ3.XzywuA.aA3VigMbfIbQfrJIjlj8KrFnVJM"
                        }
                    })
                end)
        
                if success and data.Success then
                    local members, updatedBerserkers = HttpService:JSONDecode(data.Body), {}
                    if members then
                        for _,member in pairs(members) do
                            for _,id in pairs(member.roles) do
                                if member.nick and tonumber(id) == 745309276616130641 then
                                    updatedBerserkers[member.nick] = GetMemberUserId(member.nick)
                                    print(member.nick .. (tonumber(id) == 745309276616130641 and " has the berserker role!" or " does not have the berserker role!"))
                                    break
                                end
                            end
                        end
                        bersekers = updatedBerserkers
                        updatedBerserkers = nil
        
                        pcall(function()
                            MessagingService:PublishAsync("UpdateWhitelistEvent", bersekers)
                        end)
                    end
                end
            end
            lastUpdate = os.time()
            wait(delta or REQUEST_DELAY)
        end
    end
end)()

game.Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        local data, humanoid = dataModule.GetData(plr), char:FindFirstChildWhichIsA("Humanoid")
        SetAllStates(humanoid, 0, 0, false)
        charSelectEvent:FireClient(plr, data, bersekers)
    end)
end)