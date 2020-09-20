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
function connections.Connect(obj, events)
    for event, connection in pairs(events) do
        connections[obj][event] = connection
    end
end

function connections.Disconnect(obj, event)
    connections[obj][event]:Disconnect()
    connections[obj][event] = nil
end

function connections.DisconnectAll(obj)
    for event, connection in pairs(connections[obj]) do
        connection:Disconnect()
        print(event .. ": " .. tostring(connections[obj][event].Connected))
        connections[obj][event] = nil
    end
    connections[obj] = nil
end

return connections
