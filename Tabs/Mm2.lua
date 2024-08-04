-- Find Player
local playerData = {}

local function findMurderer()
	for _, player in ipairs(game.Players:GetPlayers()) do
		if player.Backpack:FindFirstChild("Knife") then
			return player
		end

		if player.Character then
			if player.Character:FindFirstChild("Knife") then
				return player
			end
		end
	end

	if playerData then
		for playerName, data in pairs(playerData) do
			if data.Role == "Murderer" then
				local targetPlayer = game.Players:FindFirstChild(playerName)
				if targetPlayer then
					return targetPlayer
				end
			end
		end
	end
	return nil
end

local function findSheriff()
	for _, player in ipairs(game.Players:GetPlayers()) do
		if player.Backpack:FindFirstChild("Gun") then
			return player
		end

		if player.Character then
			if player.Character:FindFirstChild("Gun") then
				return player
			end
		end
	end

	if playerData then
		for playerName, data in pairs(playerData) do
			if data.Role == "Sheriff" then
				local targetPlayer = game.Players:FindFirstChild(playerName)
				if targetPlayer then
					return targetPlayer
				end
			end
		end
	end
	return nil
end

-- ShootOffset
local function getPredictedPosition(player, shootOffset)
	pcall(function()
		if not player.Character then
			OrionLib:MakeNotification({
	Name = "AimOffset",
	Content = "No murderer to predict position.",
	Image = "rbxassetid://4483345998",
	Time = 3
})
			return Vector3.new(0, 0, 0)
		end
	end)

	local playerHRP = player.Character:FindFirstChild("UpperTorso")
	local playerHum = player.Character:FindFirstChild("Humanoid")

	if not playerHRP or not playerHum then
		return Vector3.new(0, 0, 0), "Could not find the player's HumanoidRootPart."
	end

	local playerPosition = playerHRP.Position
	local velocity = playerHRP.AssemblyLinearVelocity
	local playerMoveDirection = playerHum.MoveDirection
	local playerLookVec = playerHRP.CFrame.LookVector
	local yVelFactor = (velocity.Y > 0 and -1) or 0.5

	local predictedPosition = playerHRP.Position + ((velocity * Vector3.new(0, 0.5, 0))) * (shootOffset / 15) + playerMoveDirection * shootOffset

	return predictedPosition
end

function isLocalPlayerSheriff()
	local localPlayer = game.Players.LocalPlayer
	local sheriff = findSheriff()

	return localPlayer == sheriff
end

local shootOffset = 2.8 --Default

-- AimShot
local function shoot()
	if not isLocalPlayerSheriff() then
		OrionLib:MakeNotification({
	Name = "AimBot",
	Content = "You're not sheriff/hero.",
	Image = "rbxassetid://4483345998",
	Time = 3
})
		return
	end

	local murderer = findMurderer()
	if not murderer then
		OrionLib:MakeNotification({
	Name = "AimBot",
	Content = "No Murder to Shoot",
	Image = "rbxassetid://4483345998",
	Time = 3
})

		return
	end

	if not game.Players.LocalPlayer.Character:FindFirstChild("Gun") then
		local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
		if game.Players.LocalPlayer.Backpack:FindFirstChild("Gun") then
			hum:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild("Gun"))
		else
			OrionLib:MakeNotification({
	Name = "AimBot",
	Content = " Chill out pal",
	Image = "rbxassetid://4483345998",
	Time = 3
})
			return
		end
	end

	local murdererHRP = murderer.Character:FindFirstChild("HumanoidRootPart")

	if not murdererHRP then
		OrionLib:MakeNotification({
	Name = "Aimbot",
	Content = "Could not find the murderer's",
	Image = "rbxassetid://4483345998",
	Time = 5})
		return
	end

	local predictedPosition = getPredictedPosition(murderer, shootOffset)

	local args = {
		[1] = 1,
		[2] = predictedPosition,
		[3] = "AH2"
	}
	game.Players.LocalPlayer.Character.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))
end
-- Create Button
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CrosshairGui"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 60)
frame.Position = UDim2.new(0.5, -75, 0.5, -30)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(0, 0, 255)
frame.BackgroundTransparency = 0.8
frame.Parent = screenGui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame
local innerFrame = Instance.new("Frame")
innerFrame.Size = UDim2.new(1, -4, 1, -4) 
innerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
innerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
innerFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) 
innerFrame.BackgroundTransparency = 0.8
innerFrame.Parent = frame
local innerCorner = Instance.new("UICorner")
innerCorner.CornerRadius = UDim.new(0, 10)
innerCorner.Parent = innerFrame
local imageLabel = Instance.new("ImageLabel")
imageLabel.Size = UDim2.new(0, 50, 0, 50)
imageLabel.Image = "rbxassetid://7733765307"
imageLabel.BackgroundTransparency = 1
imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
imageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
imageLabel.Parent = innerFrame
local button = Instance.new("ImageButton")
button.Size = UDim2.new(1, 0, 1, 0)
button.Position = UDim2.new(0, 0, 0, 0)
button.AnchorPoint = Vector2.new(0, 0)
button.BackgroundTransparency = 1
button.Parent = innerFrame

-- Drag Ui
local dragging
local dragInput
local dragStart
local startPos
local enabled = true
local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if not enabled then return end
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)

local function toggleButton(state)
    enabled = state
    frame.Visible = state
end

toggleButton(false)
button.Activated:Connect(function()
    shoot()
end)

-- Esp 
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local highlight = Instance.new("Highlight")
highlight.Name = "Highlight"
local highlightEnabled = true 

local function addHighlight(character, color)
    if highlightEnabled and character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart and not humanoidRootPart:FindFirstChild("Highlight") then
            local highlightClone = highlight:Clone()
            highlightClone.Adornee = character
            highlightClone.Parent = humanoidRootPart
            highlightClone.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlightClone.FillColor = color
            highlightClone.Name = "Highlight"
        end
    end
end

local function removeHighlight(character)
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local highlightInstance = humanoidRootPart:FindFirstChild("Highlight")
            if highlightInstance then
                highlightInstance:Destroy()
            end
        end
    end
end

local function setupCharacter(character, color)
    removeHighlight(character)
    addHighlight(character, color)
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Died:Connect(function()
            removeHighlight(character)
        end)
    end
end

local function findRole(player)
    if player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife") then
        return "Murderer"
    elseif player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun") then
        return "Sheriff"
    elseif playerData and playerData[player.Name] and playerData[player.Name].Role then
        return playerData[player.Name].Role
    else
        return "Innocent"
    end
end

while true do
    if highlightEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local character = player.Character
                local role = findRole(player)
                if role == "Murderer" then
                    setupCharacter(character, Color3.fromRGB(255, 0, 0))
                elseif role == "Sheriff" then
                    setupCharacter(character, Color3.fromRGB(0, 150, 255))
                else
                    setupCharacter(character, Color3.fromRGB(0, 255, 0))
                end
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                removeHighlight(player.Character)
            end
        end
    end
    wait(1)
end

-- [[Mm2]] --
    local TabM = Window:MakeTab({
    Name = "Murder Mystery 2",
    Icon = "rbxassetid://7733799795",
    PremiumOnly = false,
})

local AimUiToggle = TabM:AddToggle({
    Name = "Shoot Ui",
    Default = false,
    Callback = function(value)
        toggleButton(value) 
    end
})

local AimKeybind = TabM:AddBind({
	Name = "Shoot Keybind",
	Default = Enum.KeyCode.Q,
	Hold = false,
	Callback = function()
		shoot()
	end    
})

local AimOffset = TabM:AddTextbox({
    Name = "Aim Offset",
    Default = "2.8",
    TextDisappear = true
,
    Callback = function(text)
        if not tonumber(text) then
            OrionLib:MakeNotification({
	Name = "AimBot",
	Content = "Not a valid number.",
	Image = "rbxassetid://4483345998",
	Time = 3
})
            return
        end
        
        local offset = tonumber(text)
        
        if offset > 5 then
            OrionLib:MakeNotification({
	Name = "AimBot",
	Content = "An offset with a multiplier of 5 might not at all shoot the murderer!",
	Image = "rbxassetid://4483345998",
	Time = 3
})
        elseif offset < 0 then
OrionLib:MakeNotification({
	Name = "AimBot",
	Content = "An offset with a negative multiplier will make a shot BEHIND the murderer's walk direction.",
	Image = "rbxassetid://4483345998",
	Time = 3
})
        else
            shootOffset = offset
OrionLib:MakeNotification({
	Name = "AimBot",
	Content = "Offset has been set to " .. offset,
	Image = "rbxassetid://4483345998",
	Time = 3
})
        end
    end
})

local SectionM = TabM:AddSection({
	Name = "Esp"
})

TabM:AddToggle({
	Name = "Esp",
	Default = false,
	Callback = function(Value)
		highlightEnabled = Value
	end    
})
