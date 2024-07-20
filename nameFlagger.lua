nameFlagger = nameFlagger or {}
nameFlagger.savedVariables = ZO_SavedVars:New("TGC_SavedVariables", 1, nil, { players = {} })

local function Initialize()
    -- Ensure savedVariables.players is initialized
    nameFlagger.savedVariables.players = nameFlagger.savedVariables.players or {}
end

local function daysBetween(d1, d2)
    return os.difftime(os.time(d1), os.time(d2)) / (24 * 60 * 60)
end

local function PrintTable(t, indent)
    if type(t) ~= "table" then
        d("Provided value is not a table")
        return
    else
        d("Provided value is a table")
    end

    if not indent then indent = 0 end
    local formatting = string.rep("  ", indent)
    for k, v in pairs(t) do
        if type(v) == "table" then
            d(formatting .. tostring(k) .. ":")
            PrintTable(v, indent + 1)
        else
            d(formatting .. tostring(k) .. ": " .. tostring(v))
        end
    end
end

local function OnChatMessage(eventCode, messageType, fromName, text, isCustomerService, fromDisplayName)
    if messageType == CHAT_CHANNEL_ZONE or messageType == CHAT_CHANNEL_SAY then
        d("OnChatMessage triggered")
        PrintTable(nameFlagger.savedVariables.players)
        
        local playerData = nameFlagger.savedVariables.players[fromDisplayName]
        
        if playerData then
            local currentDate = os.date("*t")
            local addedDate = {
                year = tonumber(string.sub(playerData.AddedDate, 1, 4)),
                month = tonumber(string.sub(playerData.AddedDate, 6, 7)),
                day = tonumber(string.sub(playerData.AddedDate, 9, 10))
            }
            local daysSinceAdded = math.floor(daysBetween(currentDate, addedDate))

            if playerData.Banned then
                d(string.format("Banned: %s (%d days ago)", fromName, daysSinceAdded))
            end

            if playerData.NI then
                d(string.format("Not Interested: %s (%d days ago)", fromName, daysSinceAdded))
            end
        else
            d("No player data found for " .. fromDisplayName)
        end
    end
end

EVENT_MANAGER:RegisterForEvent("nameFlagger", EVENT_CHAT_MESSAGE_CHANNEL, OnChatMessage)

local function OnAddonLoaded(event, addonName)
    if addonName == "nameFlagger" then
        Initialize()
        EVENT_MANAGER:UnregisterForEvent("nameFlagger", EVENT_ADD_ON_LOADED)
        d("nameFlagger initialized.")
    end
end

EVENT_MANAGER:RegisterForEvent("nameFlagger", EVENT_ADD_ON_LOADED, OnAddonLoaded)

-- Example of how to use the PrintTable function after initialization
EVENT_MANAGER:RegisterForEvent("nameFlagger", EVENT_ADD_ON_LOADED, function(event, addonName)
    if addonName == "nameFlagger" then
        Initialize()
        PrintTable(nameFlagger.savedVariables.players)
    end
end)
