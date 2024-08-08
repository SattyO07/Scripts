-- Services
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- Variables
local gunDropESP = false
local EspPlayer = false
local shootOffset = 2.8
local gunDropCache = {}
local TimeGUI = false

-- Functions
local function GetMurderer()
    local playerData = ReplicatedStorage.Remotes.Extras.GetPlayerData:InvokeServer()
    for playerName, playerInfo in pairs(playerData) do
        if playerInfo.Role == "Murderer" then
            return playerName
        end
    end
    return nil
end

local function GetSheriff()
    local playerData = ReplicatedStorage.Remotes.Extras.GetPlayerData:InvokeServer()
    for playerName, playerInfo in pairs(playerData) do
        if playerInfo.Role == "Sheriff" then
            return playerName
        end
    end
    return nil
end

local function GetHero()
    local playerData = ReplicatedStorage.Remotes.Extras.GetPlayerData:InvokeServer()
    for playerName, playerInfo in pairs(playerData) do
        if playerInfo.Role == "Hero" then
            return playerName
        end
    end
    return nil
end

local function getPredictedPosition(player, shootOffset)
    if not player.Character then
        warn("No character found for player")
        return Vector3.new(0, 0, 0)
    end

    local character = player.Character
    local playerHRP = character:FindFirstChild("HumanoidRootPart")
    local playerHum = character:FindFirstChild("Humanoid")

    if not playerHRP or not playerHum then
        warn("Could not find the player's HumanoidRootPart or Humanoid")
        return Vector3.new(0, 0, 0)
    end

    local playerPosition = playerHRP.Position
    local velocity = playerHRP.AssemblyLinearVelocity
    local playerMoveDirection = playerHum.MoveDirection

    local predictedPosition = playerHRP.Position + ((velocity * Vector3.new(0, 0.5, 0))) * (shootOffset / 15) + playerMoveDirection * shootOffset

    return predictedPosition
end

-- Shoot
local function shoot()
    local localPlayer = Players.LocalPlayer

    if GetSheriff() ~= localPlayer.Name and GetHero() ~= localPlayer.Name then
        OrionLib:MakeNotification({Name = "AimBot",Content = "You are Not Sheriff/Hero!",Image = "rbxassetid://7733771628",Time = 5})
        return
    end

    local murderer = GetMurderer()
    if not murderer then
        OrionLib:MakeNotification({Name = "AimBot",Content = "No Murder to shoot!",Image = "rbxassetid://7733771628",Time = 5})
        return
    end

    if not localPlayer.Character or not localPlayer.Character:FindFirstChild("Humanoid") then
        warn("Character or Humanoid not found.")
        return
    end

    if not localPlayer.Character:FindFirstChild("Gun") then
        local hum = localPlayer.Character:FindFirstChild("Humanoid")
        if localPlayer.Backpack:FindFirstChild("Gun") then
            hum:EquipTool(localPlayer.Backpack:FindFirstChild("Gun"))
        else
            OrionLib:MakeNotification({Name = "AimBot",Content = "You need a Gun first",Image = "rbxassetid://7733771628",Time = 5})
            return
        end
    end

    local murdererPlayer = Players:FindFirstChild(murderer)
    if not murdererPlayer or not murdererPlayer.Character then
        OrionLib:MakeNotification({Name = "AimBot",Content = "Could not find the murderer's character.",Image = "rbxassetid://7733771628",Time = 5})
        return
    end

    local murdererHRP = murdererPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not murdererHRP then
        OrionLib:MakeNotification({Name = "AimBot",Content = "Could not find the Murderer maybe died",Image = "rbxassetid://7733771628",Time = 5})
        return
    end

    local predictedPosition = getPredictedPosition(murdererPlayer, shootOffset)

    local args = {
        [1] = 1,
        [2] = predictedPosition,
        [3] = "AH2"
    }

    localPlayer.Character.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))
end

-- Time GUI
local player = Players.LocalPlayer
local surfaceGuiTextLabel = Workspace:WaitForChild("RoundTimerPart"):WaitForChild("SurfaceGui"):WaitForChild("Timer")

-- Create TimerGui
local TimGui = Instance.new("ScreenGui")
TimGui.Name = "TimerGui"
TimGui.Parent = player:WaitForChild("PlayerGui")
TimGui.ResetOnSpawn = false

local Timer = Instance.new("TextLabel")
Timer.Size = UDim2.new(0, 200, 0, 50)
Timer.Position = UDim2.new(0.5, -100, 0.1, 0)
Timer.TextColor3 = Color3.fromRGB(255, 255, 255)
Timer.BackgroundTransparency = 1
Timer.TextSize = 50
Timer.Text = "Loading..."
Timer.Font = Enum.Font.SourceSans
Timer.TextStrokeTransparency = 0.5
Timer.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
Timer.Parent = TimGui

-- Function to update Timer
local function updateTimer()
    if TimeGUI then
        local surfaceGui = surfaceGuiTextLabel.Parent
        if surfaceGui and surfaceGui:IsA("SurfaceGui") and surfaceGui.Enabled then
            Timer.Text = surfaceGuiTextLabel.Text
            TimGui.Enabled = true
        else
            TimGui.Enabled = false
        end
    else
        TimGui.Enabled = false
    end
end

-- Floating Button UI
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

-- Drag UI functionality
local dragging = false
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

button.Activated:Connect(function()
    shoot()
end)

local function createGunDropHighlight(part)
    if not part:FindFirstChild("GunDropHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "GunDropHighlight"
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.OutlineTransparency = 1
        highlight.FillColor = Color3.fromRGB(255, 255, 0)
        highlight.Adornee = part
        highlight.Parent = part

        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "GunDropBillboard"
        billboardGui.Adornee = part
        billboardGui.Size = UDim2.new(0, 200, 0.5, 60)
        billboardGui.StudsOffset = Vector3.new(0, 1.5, 0)
        billboardGui.AlwaysOnTop = true

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.Position = UDim2.new(0, 0, 0, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        textLabel.TextStrokeTransparency = 0.5
        textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        textLabel.Font = Enum.Font.Roboto
        textLabel.TextSize = 24
        textLabel.Text = "Gun"
        textLabel.TextXAlignment = Enum.TextXAlignment.Center
        textLabel.TextYAlignment = Enum.TextYAlignment.Center
        textLabel.Parent = billboardGui

        billboardGui.Parent = part
    else
        OrionLib:MakeNotification({Name = "DeBug",Content = "Highlight or Billboard already exists.",Image = "rbxassetid://7733771628",Time = 5})
    end
end

local function updateGunDropHighlights()
    if gunDropESP then
        for part, _ in pairs(gunDropCache) do
            if not part:IsDescendantOf(Workspace) or part.Name ~= "GunDrop" then
                gunDropCache[part] = nil
                if part:FindFirstChild("GunDropHighlight") then
                    part.GunDropHighlight:Destroy()
                end
                if part:FindFirstChild("GunDropBillboard") then
                    part.GunDropBillboard:Destroy()
                end
            end
        end

        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Name == "GunDrop" and not gunDropCache[part] then
                gunDropCache[part] = true
                createGunDropHighlight(part)
                OrionLib:MakeNotification({Name = "GunEsp",Content = "Gun Droped Find Yellow Highlight on Map",Image = "rbxassetid://7733771628",Time = 5})
            end
        end
    else
        for part, _ in pairs(gunDropCache) do
            if part:FindFirstChild("GunDropHighlight") then
                part.GunDropHighlight:Destroy()
            end
            if part:FindFirstChild("GunDropBillboard") then
                part.GunDropBillboard:Destroy()
            end
        end
        gunDropCache = {}
    end
end

-- ESP Player Functions
local function addHighlight(character, color)
    if EspPlayer and character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local existingHighlight = humanoidRootPart:FindFirstChild("Highlight")
            if existingHighlight then
                existingHighlight:Destroy()
            end

            local highlight = Instance.new("Highlight")
            highlight.Adornee = character
            highlight.Parent = humanoidRootPart
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.FillColor = color
            highlight.Name = "Highlight"
        end
    end
end

local function removeHighlight(character)
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local highlight = humanoidRootPart:FindFirstChild("Highlight")
            if highlight then
                highlight:Destroy()
            end
        end
    end
end

local function addBillboard(character, roleName, color)
    if EspPlayer and character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart and not humanoidRootPart:FindFirstChild("BillboardGui") then
            local billboard = Instance.new("BillboardGui")
            billboard.Parent = humanoidRootPart
            billboard.Adornee = humanoidRootPart
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.Size = UDim2.new(0, 100, 0, 50)
            billboard.AlwaysOnTop = true
            billboard.LightInfluence = 0

            local frame = Instance.new("Frame")
            frame.Parent = billboard
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundTransparency = 1

            local textLabel = Instance.new("TextLabel")
            textLabel.Parent = frame
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = color
            textLabel.Font = Enum.Font.PermanentMarker
            textLabel.TextSize = 24
            textLabel.Text = roleName
            textLabel.TextStrokeTransparency = 0
            textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        end
    end
end

local function removeBillboard(character)
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local billboard = humanoidRootPart:FindFirstChild("BillboardGui")
            if billboard then
                billboard:Destroy()
            end
        end
    end
end

local function isNormalMapPresent()
    for _, descendant in ipairs(Workspace:GetDescendants()) do
        if descendant.Name == "Normal" then
            return true
        end
    end
    return false
end

local murderer = nil
local sheriff = nil
local hero = nil
local PText1 = false
local PText2 = true
local gameAboutToStart = false
local gameEnded = false

local function UpdatePlayerESP()
    if isNormalMapPresent() then
        if gameAboutToStart then
            OrionLib:MakeNotification({Name = "Esp",Content = "Enabling Esp",Image = "rbxassetid://7733771628",Time = 5})
            PText2 = false
        end

        murderer = GetMurderer()
        sheriff = GetSheriff()
        hero = GetHero()

        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                removeHighlight(player.Character)
                removeBillboard(player.Character)
                if player.Name == murderer then
                    addHighlight(player.Character, Color3.fromRGB(255, 0, 0))
                    addBillboard(player.Character, "Murderer", Color3.fromRGB(255, 0, 0))
                elseif player.Name == sheriff then
                    addHighlight(player.Character, Color3.fromRGB(0, 150, 255))
                    addBillboard(player.Character, "Sheriff", Color3.fromRGB(0, 150, 255))
                elseif player.Name == hero then
                    addHighlight(player.Character, Color3.fromRGB(230, 230, 250))
                    addBillboard(player.Character, "Hero", Color3.fromRGB(230, 230, 250))
                else
                    addHighlight(player.Character, Color3.fromRGB(0, 255, 0))
                end
            end
        end
    else
        if not gameEnded then
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    removeHighlight(player.Character)
                    removeBillboard(player.Character)
                end
            end
            OrionLib:MakeNotification({Name = "Player Esp",Content = "Game Ended. Disabling the Esp",Image = "rbxassetid://7733771628",Time = 5})
            PText1 = true
            PText2 = true
        end
    end
end

local updateTimerInterval = 0.1
local updateGunDropHighlightsInterval = 0.3

local updateTimerTime = 0
local updateGunDropHighlightsTime = 0

RunService.Heartbeat:Connect(function(deltaTime)
    updateTimerTime = updateTimerTime + deltaTime
    updateGunDropHighlightsTime = updateGunDropHighlightsTime + deltaTime

    if updateTimerTime >= updateTimerInterval then
        updateTimer()
        updateTimerTime = 0
    end

    if updateGunDropHighlightsTime >= updateGunDropHighlightsInterval then
        updateGunDropHighlights()
        updateGunDropHighlightsTime = 0
    end
end)

local function checkPlayerGunInventory(player)
    player.Backpack.ChildAdded:Connect(function(child)
        if child.Name == "Gun" then
            UpdatePlayerESP()
        end
    end)

    player.CharacterAdded:Connect(function(character)
        character.ChildAdded:Connect(function(child)
            if child.Name == "Gun" then
                UpdatePlayerESP()
            end
        end)
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    checkPlayerGunInventory(player)
end

Players.PlayerAdded:Connect(checkPlayerGunInventory)

local hasUpdatedESP = false

local function checkRoles()
    local murderer1 = GetMurderer()
    local sheriff1 = GetSheriff()

    if murderer1 or sheriff1 then
        if not hasUpdatedESP then
            UpdatePlayerESP()
            hasUpdatedESP = true
        end
    else
        hasUpdatedESP = false
    end
end

local function isMapPresent()
    for _, descendant in ipairs(Workspace:GetDescendants()) do
        if descendant.Name == "Normal" then
            return true
        end
    end
    return false
end

local previousMapState = isMapPresent()

local function checkMapPresence()
    local currentMapState = isNormalMapPresent()
    if currentMapState ~= previousMapState then
        previousMapState = currentMapState
        UpdatePlayerESP()
    end
end

local roleCheckInterval = 1
RunService.Heartbeat:Connect(function(deltaTime)
    checkMapPresence()
    checkRoles()
    wait(roleCheckInterval)
end)

checkMapPresence()
checkRoles()

-- Orion Properties
local TabG1 = Window:MakeTab({Name = "Murder Mistery 2",Icon = "rbxassetid://7733799901",PremiumOnly = false})

local Section2 = TabG1:AddSection({Name = "AimBot"})

if Device == "Mobile" then
    TabG1:AddToggle({
        Name = "ButtonShoot",
        Default = false,
        Callback = function(Value)
            toggleButton(Value)
        end    
    })
end

TabG1:AddBind({
	Name = "Shoot Keybind",
	Default = Enum.KeyCode.Q,
	Hold = false,
	Callback = function()
		shoot()
	end    
})

TabG1:AddTextbox({
    Name = "Textbox",
    Default = "Shoot Offset",
    TextDisappear = true,
    Callback = function(Value)
        local text = Value
        local num = tonumber(text)
        
        if not num then
            OrionLib:MakeNotification({Name = "AimBot",Content = "Not Valid Number" .. text,Image = "rbxassetid://4483345998",Time = 5})
            return
        end
        
        if num > 5 then
            OrionLib:MakeNotification({Name = "AimBot",Content = "An offset with a multiplier of 5 might not at all shoot the murderer!",Image = "rbxassetid://4483345998",Time = 5})
        end
        
        if num < 0 then
            OrionLib:MakeNotification({Name = "AimBot",Content = "An offset with a negative multiplier will make a shot BEHIND the murderer's walk direction.",Image = "rbxassetid://4483345998",Time = 5})
        end
        
        shootOffset = num
        OrionLib:MakeNotification({Name = "AimBot",Content = "Offset has been set." .. num,Image = "rbxassetid://4483345998",Time = 5})
    end    
})

local Section2 = TabG1:AddSection({Name = "Esp:"})

TabG1:AddToggle({
        Name = "Player Esp",
        Default = false,
        Callback = function(Value)
            EspPlayer = Value
        end    
    })

TabG1:AddToggle({
        Name = "GunEsp",
        Default = false,
        Callback = function(Value)
            gunDropESP = Value
        end    
    })

local Section2 = TabG1:AddSection({Name = "Mics:"})

TabG1:AddToggle({
        Name = "Timer",
        Default = false,
        Callback = function(Value)
            TimeGUI = Value
        end    
    })
