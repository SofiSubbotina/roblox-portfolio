local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BestStatsStore = DataStoreService:GetDataStore("BestStats")
local saving = {}

local function loadStats(userId)
	local ok, data = pcall(function()
		return BestStatsStore:GetAsync(userId)
	end)
	if ok and data then return data end
	return { BestCoins = 0, BestDistance = 0, BestTime = 0 }
end

local function saveStats(userId, payload)
	if saving[userId] then return end -- prevent frequent saves
	saving[userId] = true
	pcall(function()
		BestStatsStore:SetAsync(userId, payload)
	end)
	task.wait(1)
	saving[userId] = nil
end

Players.PlayerAdded:Connect(function(player)
	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	ls.Parent = player

	local bestCoins = Instance.new("IntValue")
	bestCoins.Name = "BestCoins"
	bestCoins.Parent = ls

	local bestDistance = Instance.new("IntValue")
	bestDistance.Name = "BestDistance"
	bestDistance.Parent = ls

	local bestTime = Instance.new("IntValue")
	bestTime.Name = "BestTime"
	bestTime.Parent = ls

	local saved = loadStats(player.UserId)
	bestCoins.Value = saved.BestCoins or 0
	bestDistance.Value = saved.BestDistance or 0
	bestTime.Value = saved.BestTime or 0

	local valuesFolder = ReplicatedStorage:FindFirstChild("Values")
	if valuesFolder then
		local coinsValue = valuesFolder:FindFirstChild("Coins")
		local highscoreValue = valuesFolder:FindFirstChild("Highscore")

		if coinsValue then
			coinsValue:GetPropertyChangedSignal("Value"):Connect(function()
				if coinsValue.Value > bestCoins.Value then
					bestCoins.Value = coinsValue.Value
				end
			end)
		end

		if highscoreValue then
			highscoreValue:GetPropertyChangedSignal("Value"):Connect(function()
				if highscoreValue.Value > bestDistance.Value then
					bestDistance.Value = highscoreValue.Value
				end
			end)
		end
	end
end)

Players.PlayerRemoving:Connect(function(player)
	local ls = player:FindFirstChild("leaderstats")
	if ls then
		saveStats(player.UserId, {
			BestCoins = ls.BestCoins.Value,
			BestDistance = ls.BestDistance.Value,
			BestTime = ls.BestTime.Value,
		})
	end
end)

game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		local ls = player:FindFirstChild("leaderstats")
		if ls then
			saveStats(player.UserId, {
				BestCoins = ls.BestCoins.Value,
				BestDistance = ls.BestDistance.Value,
				BestTime = ls.BestTime.Value,
			})
		end
	end
	task.wait(2)
end)
