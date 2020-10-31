local connections = require(game.ReplicatedStorage.Shared.Connections)

local function PlayerAdded(player)
    print(player.Name)
    connections.Disconnect("Player", "PlayerAdded")
    print("works", connections.Player.PlayerAdded.Connected)
end

connections.Connect("Player", {
    ["PlayerAdded"] = game.Players.PlayerAdded:Connect(PlayerAdded)
})
