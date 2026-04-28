local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local noteGui = player:WaitForChild("PlayerGui"):WaitForChild("NoteGui")
local noteFrame = noteGui:WaitForChild("NoteFrame")
local closeButton = noteFrame:WaitForChild("CloseButton")
local openNote = ReplicatedStorage:WaitForChild("OpenNote")
local addExp = ReplicatedStorage:WaitForChild("AddExp")

openNote.OnClientEvent:Connect(function()
    noteFrame.Visible = true
end)

closeButton.MouseButton1Click:Connect(function()
    noteFrame.Visible = false
    addExp:FireServer(50)
end)
