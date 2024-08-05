-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables
local playerData = {}
local highlightEnabled = true
local shootOffset = 2.8

-- Functions
local function GetRole(role, selfCheck)
    local Target = nil
    local Table = ReplicatedStorage.Remotes.Extras.GetPlayerData:InvokeServer()
    for i,v in next, Table do
        if v.Role == role and not selfCheck then
            Target = i
        elseif selfCheck and v.Role == "Innocent" and i == Players.LocalPlayer.Name then
            Target = i
        end
    end
    return Target
end

local function findMurderer()
    return GetRole("Murderer", false)
end

local function findSheriff()
    return GetRole("Sheriff", false)
end

local function getPredictedPosition(player, shootOffset)
    if not player.Character then
        warn("No character found for player")
        return Vector3.new(0, 0, 0)
    end

    local character = player.Character
    local playerHRP = character:FindFirstChild("UpperTorso") or character:FindFirstChild("HumanoidRootPart")
    local playerHum = character:FindFirstChild("Humanoid")

    if not playerHRP or not playerHum then
        warn("Could not find the player's HumanoidRootPart or Humanoid")
        return Vector3.new(0, 0, 0)
    end

    local playerPosition = playerHRP.Position
    local velocity = playerHRP.AssemblyLinearVelocity
    local playerMoveDirection = playerHum.MoveDirection
    local playerLookVec = playerHRP.CFrame.LookVector
    local yVelFactor = velocity.Y > 0 and -1 or 0.5

    local predictedPosition = playerHRP.Position + ((velocity * Vector3.new(0, 0.5, 0))) * (shootOffset / 15) + playerMoveDirection * shootOffset

    return predictedPosition
end

-- Shoot
local function shoot()
    local localPlayer = Players.LocalPlayer
    
    -- Check if localPlayer is not the sheriff
    if findSheriff() ~= localPlayer.Name then
        warn("You're not sheriff/hero.")
        return
    end

    -- Find the murderer
    local murderer = findMurderer()
    if not murderer then
        warn("No murderer to shoot.")
        return
    end

    -- Ensure localPlayer has a gun
    if not localPlayer.Character:FindFirstChild("Gun") then
        local hum = localPlayer.Character:FindFirstChild("Humanoid")
        if localPlayer.Backpack:FindFirstChild("Gun") then
            hum:EquipTool(localPlayer.Backpack:FindFirstChild("Gun"))
        else
            warn("You don't have the gun..?")
            return
        end
    end

    -- Get the murderer's HumanoidRootPart
    local murdererPlayer = Players:FindFirstChild(murderer)
    if not murdererPlayer then
        warn("Could not find the murderer's player.")
        return
    end
    local murdererHRP = murdererPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not murdererHRP then
        warn("Could not find the murderer's HumanoidRootPart.")
        return
    end

    -- Predict the position to shoot
    local predictedPosition = getPredictedPosition(murdererPlayer, shootOffset)

    -- Prepare arguments for the remote function
    local args = {
        [1] = 1,
        [2] = predictedPosition,
        [3] = "AH2"
    }

    -- Invoke the remote function to shoot
    localPlayer.Character.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))
end

-- UI
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CrosshairGui"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Create the frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 60)
frame.Position = UDim2.new(0.5, -75, 0.5, -30)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(0, 0, 255)
frame.BackgroundTransparency = 0.8
frame.Parent = screenGui

-- Add a corner to the frame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Create the inner frame
local innerFrame = Instance.new("Frame")
innerFrame.Size = UDim2.new(1, -4, 1, -4)
innerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
innerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
innerFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
innerFrame.BackgroundTransparency = 0.8
innerFrame.Parent = frame

-- Add a corner to the inner frame
local innerCorner = Instance.new("UICorner")
innerCorner.CornerRadius = UDim.new(0, 10)
innerCorner.Parent = innerFrame

-- Create the image label
local imageLabel = Instance.new("ImageLabel")
imageLabel.Size = UDim2.new(0, 50, 0, 50)
imageLabel.Image = "rbxassetid://7733765307"
imageLabel.BackgroundTransparency = 1
imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
imageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
imageLabel.Parent = innerFrame

-- Create the button
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

-- ESP
local function addHighlight(character, color)
    if highlightEnabled and character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart and not humanoidRootPart:FindFirstChild("Highlight") then
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

-- ESP Loop
while true do
    local murderer = findMurderer()
    local sheriff = findSheriff()

    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            removeHighlight(player.Character)
            if player.Name == murderer then
                addHighlight(player.Character, Color3.fromRGB(255, 0, 0))
            elseif player.Name == sheriff then
                addHighlight(player.Character, Color3.fromRGB(0, 150, 255))
            else
                addHighlight(player.Character, Color3.fromRGB(0, 255, 0))
            end
        end
    end

    wait(1)
end

while true do
    print("Murd : " .. tostring(findMurderer())) 
    print("Sheriff : " .. tostring(findSheriff()))
    wait(1)
end
