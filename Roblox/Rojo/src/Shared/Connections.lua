--[[
connections = {
    [obj: Instance] = events: Dictionary,
    ...
}
]]
local connections = {}

--[[
events = {
    [event: String] = connection: RbxScriptConnection,
    ...
}
]]
function connections.Connect(id, events)
    if not connections[id] then
        connections[id] = {}
    end

    for event, connection in pairs(events) do
        connections[id][event] = connection
    end
end

function connections.Disconnect(id, event)
    if connections[id] and connections[id][event] then
        connections[id][event]:Disconnect()
        connections[id][event] = nil
    end
end

function connections.DisconnectAll(id)
    if connections[id] then
        for event, connection in pairs(connections[id]) do
            -- TEST: Do these hold references to the dictionary?
            connection:Disconnect()
            print(event .. ": " .. tostring(connections[obj][events].Connected))
            event = nil
            print(connections[id]["PlayerAdded"])
        end
        connections[id] = nil
    end
end

return connections