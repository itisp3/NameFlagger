-- Define the path to the SavedVariables file
local savedVarsPath = "TGC_SavedVariables.lua"

-- Function to load saved variables from file
local function LoadSavedVariables()
    local savedVars = {}
    local chunk = loadfile(savedVarsPath)
    if chunk then
        savedVars = chunk() or {}
    else
        d("Could not load saved variables file.")
    end
    return savedVars
end

-- Function to calculate the number of days between two dates
local function daysBetween(d1, d2)
    return os.difftime(os.time(d1), os.time(d2)) / (24 * 60 * 60)
end

-- Event handler for chat messages
local function OnChatMessage(eventCode, messageType, fromName, text, isCustomerService, fromDisplayName)
    if messageType == CHAT_CHANNEL_ZONE or messageType == CHAT_CHANNEL_SAY then
        local savedVars = LoadSavedVariables()
        local playerData = savedVars.players[fromDisplayName]
        
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
        end
    end
end

-- Register the event handler for chat messages
EVENT_MANAGER:RegisterForEvent("MyAddon", EVENT_CHAT_MESSAGE_CHANNEL, OnChatMessage)
