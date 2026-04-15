local folder = workspace:WaitForChild("MovingParts")
local RunService = game:GetService("RunService")

local platformData = {}
local totalTime = 0

for _, part in ipairs(folder:GetChildren()) do
	if part:IsA("BasePart") then
		table.insert(platformData, {
			part = part,
			startPos = part.Position,
			amplitude = math.random(3, 6),
			speed = math.random() * 2 + 1,
			offset = math.random() * math.pi * 2,
			active = true,
			falling = false
		})

		part.Touched:Connect(function(hit)
			local humanoid = hit:FindFirstAncestorOfClass("Model")
				and hit:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid")
			if not humanoid then return end

			local data
			for _, d in ipairs(platformData) do
				if d.part == part then data = d break end
			end
			if not data or not data.active then return end

			data.active = false
			task.wait(1.2)

			-- check if player is still standing on platform
			local stillTouching = false
			for _, touching in ipairs(part:GetTouchingParts()) do
				if touching:IsDescendantOf(humanoid.Parent) then
					stillTouching = true break
				end
			end

			if stillTouching then
				data.falling = true
				part.Anchored = false
				task.wait(1.5)
				part.Anchored = true
				part.AssemblyLinearVelocity = Vector3.zero
				part.AssemblyAngularVelocity = Vector3.zero

				-- smooth return to start position
				local fallPos, duration, elapsed = part.Position, 1, 0
				while elapsed < duration do
					elapsed += RunService.Heartbeat:Wait()
					part.Position = fallPos:Lerp(data.startPos, elapsed / duration)
				end
				part.Position = data.startPos
				data.falling = false
			end

			data.active = true
		end)
	end
end

RunService.Heartbeat:Connect(function(dt)
	totalTime += dt
	for _, data in ipairs(platformData) do
		if data.active and not data.falling then
			local y = data.startPos.Y + math.sin(totalTime * data.speed + data.offset) * data.amplitude
			data.part.CFrame = CFrame.new(data.startPos.X, y, data.startPos.Z)
				* CFrame.Angles(0, math.rad(data.part.Orientation.Y), 0)
		end
	end
end)
