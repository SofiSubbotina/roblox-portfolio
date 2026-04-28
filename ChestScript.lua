local chest = script.Parent
local proximityPrompt = chest.Union.ProximityPrompt
local openNote = game.ReplicatedStorage.OpenNote
local usedPlayers = {}

proximityPrompt.Triggered:Connect(function(player)
    if usedPlayers[player.UserId] then
        return
    end
    usedPlayers[player.UserId] = true
    openNote:FireClient(player)
end)
