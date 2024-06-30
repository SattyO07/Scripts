-- Values
local Players = game:GetService("Players")
local plrs = game.Players
local playerNames = {}
local RunService = game:GetService("RunService")
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Unknownkellymc1/Orion/main/source')))()

-- Function to update player names
local function updatePlayerNames()
    playerNames = {}
    for _, player in ipairs(plrs:GetPlayers()) do
        table.insert(playerNames, player.DisplayName.. " (@".. player.Name.. ")")
    end
end

spawn(updatePlayerNames)

-- Function Assist aim
local shootOffset = 3.5

local function findMurderer()
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Backpack:FindFirstChild("Knife") or (player.Character and player.Character:FindFirstChild("Knife")) then
            return player
        end
    end
    return nil
end

local function findSheriff()
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Backpack:FindFirstChild("Gun") or (player.Character and player.Character:FindFirstChild("Gun")) then
            return player
        end
    end
    return nil
end

local function shootMurderer()
    local localPlayer = game.Players.LocalPlayer
    if findSheriff() ~= localPlayer then
        OrionLib:MakeNotification({
	Name = "Silent Aim",
	Content = "You need Gun first",
	Image = "rbxassetid://4483345998",
	Time = 3
})
        return
    end

    local murderer = findMurderer()
    if not murderer then
        OrionLib:MakeNotification({
	Name = "Silent Aim",
	Content = "No Muderer.",
	Image = "rbxassetid://4483345998",
	Time = 3
})
        return
    end

    if not localPlayer.Character:FindFirstChild("Gun") then
        if localPlayer.Backpack:FindFirstChild("Gun") then
            localPlayer.Character:FindFirstChildOfClass("Humanoid"):EquipTool(localPlayer.Backpack:FindFirstChild("Gun"))
        else
            OrionLib:MakeNotification({
	Name = "Silent Aim",
	Content = "You don't have a Gun.",
	Image = "rbxassetid://4483345998",
	Time = 3
})
            return
        end
    end

    local args = {
        [1] = 1,
        [2] = murderer.Character:FindFirstChild("HumanoidRootPart").Position + murderer.Character:FindFirstChild("Humanoid").MoveDirection * shootOffset,
        [3] = "AH"
    }

    local gun = localPlayer.Character:FindFirstChild("Gun")
    if gun and gun:FindFirstChild("KnifeServer") then
        gun.KnifeServer.ShootGun:InvokeServer(unpack(args))
    else
        OrionLib:MakeNotification({
	Name = "Error",
	Content = "Unable to find the gun or server.",
	Image = "rbxassetid://4483345998",
	Time = 5
})
    end
end
-- Create ScreenGui
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CrosshairGui"
screenGui.Parent = playerGui

-- Create frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 60)
frame.Position = UDim2.new(0.5, -75, 0.5, -30) -- adjusted position to center the frame
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 255) -- blue color
frame.BorderSizePixel = 1 -- thin outline
frame.BorderColor3 = Color3.fromRGB(0, 0, 255) -- blue color
frame.BackgroundTransparency = 0.8 -- 80% transparent
frame.Parent = screenGui

-- Create cornered outline
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Create inner frame with black transparent background
local innerFrame = Instance.new("Frame")
innerFrame.Size = UDim2.new(1, -4, 1, -4) -- adjusted size to fit inside the outline
innerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
innerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
innerFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- black color
innerFrame.BackgroundTransparency = 0.8 -- 80% transparent
innerFrame.Parent = frame

-- Create cornered inner frame
local innerCorner = Instance.new("UICorner")
innerCorner.CornerRadius = UDim.new(0, 10)
innerCorner.Parent = innerFrame

-- Create image label
local imageLabel = Instance.new("ImageLabel")
imageLabel.Size = UDim2.new(0, 50, 0, 50)
imageLabel.Image = "rbxassetid://7733765307"
imageLabel.BackgroundTransparency = 1 -- transparent background
imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
imageLabel.Position = UDim2.new(0.5, 0, 0.5, 0) -- center the image label
imageLabel.Parent = innerFrame

-- Create button
local button = Instance.new("ImageButton")
button.Size = UDim2.new(1, 0, 1, 0) -- changed size to fit the inner frame
button.Position = UDim2.new(0, 0, 0, 0)
button.AnchorPoint = Vector2.new(0, 0)
button.BackgroundTransparency = 1
button.Parent = innerFrame

-- Variables for dragging
local dragging
local dragInput
local dragStart
local startPos
local enabled = true

local UserInputService = game:GetService("UserInputService")

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

-- Function to enable or disable the button
local function toggleButton(state)
    enabled = state
    frame.Visible = state
end

toggleButton(false)

-- Connect the click event to print "Clicked"
button.Activated:Connect(function()
    shootMurderer()
end)

-- Function Fps
local UpdateFps = 0
local LastTime = tick()

RunService.RenderStepped:Connect(function()
    local DeltaTime = tick() - LastTime
    LastTime = tick()

    UpdateFps = math.floor(1 / DeltaTime)
end)

-- Window
local GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local Window = OrionLib:MakeWindow({Name = "MoonLight : [" .. GameName .. "]", HidePremium = false, SaveConfig = false, ConfigFolder = "ReaperSaved"})

-- [Universal]--
local Tab1 = Window:MakeTab({Name = "Universal", Icon = "rbxassetid://8997387937", PremiumOnly = false})

local selectPlayers = Tab1:AddDropdown({
    Name = "Players",
    Default = "No Players",
    Options = playerNames,
    Callback = function(selectedOption)
        for _, player in ipairs(plrs:GetPlayers()) do
            if selectedOption == player.DisplayName.. " (@".. player.Name.. ")" then
                selectedPlayer = player
                print("Selected player: ".. selectedPlayer.Name)
                break
            end
        end
        if not selectedPlayer then
            print("Invalid player selection")
        end
    end
})

local function refreshPlayerDropdown()
    updatePlayerNames()
    selectPlayers.Options = {} -- Clear the options
    for _, player in ipairs(plrs:GetPlayers()) do
        local playerName = player.DisplayName.. " (@".. player.Name.. ")"
        table.insert(selectPlayers.Options, playerName) -- Add new options
    end
end

plrs.PlayerAdded:Connect(refreshPlayerDropdown)
plrs.PlayerRemoving:Connect(refreshPlayerDropdown)

local teleportButton = Tab1:AddButton({
    Name = "Teleport",
    Callback = function()
        if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPosition = selectedPlayer.Character.HumanoidRootPart.Position
            local localPlayerRoot = plrs.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if localPlayerRoot then
                localPlayerRoot.CFrame = CFrame.new(targetPosition)
            end
        end
    end
})

local originalCameraSubject
local isSpectating = false

local function spectatePlayer(player)
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        originalCameraSubject = game.Workspace.CurrentCamera.CameraSubject
        game.Workspace.CurrentCamera.CameraSubject = character.Humanoid
        isSpectating = true
    end
end

local function stopSpectating()
    if isSpectating and originalCameraSubject then
        game.Workspace.CurrentCamera.CameraSubject = originalCameraSubject
        isSpectating = false
    end
end

local spectateToggle = Tab1:AddToggle({
    Name = "Spectate",
    Default = false,
    Callback = function(enabled)
        if selectedPlayer then
            if enabled then
                spectatePlayer(selectedPlayer)
            else
                stopSpectating()
            end
        end
    end
})

local function gplr(String)
    local Found = {}
    local strl = String:lower()
    if strl == "all" then
        for i,v in pairs(game.Players:GetPlayers()) do
            table.insert(Found,v)
        end
    elseif strl == "others" then
        for i,v in pairs(game.Players:GetPlayers()) do
            if v.Name ~= lp.Name then
                table.insert(Found,v)
            end
        end 
    elseif strl == "me" then
        for i,v in pairs(game.Players:GetPlayers()) do
            if v.Name == lp.Name then
                table.insert(Found,v)
            end
        end 
    else
        for i,v in pairs(game.Players:GetPlayers()) do
            if v.Name:lower():sub(1, #String) == String:lower() then
                table.insert(Found,v)
            end
        end 
    end
    return Found 
end

local flingButton = Tab1:AddButton({
    Name = "Fling",
    Callback = function()
        if selectedPlayer == game.Players.LocalPlayer then
            OrionLib:MakeNotification({
                Name = "Warning",
                Content = "You can't fling yourself",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
            return
        end

        local lp = game.Players.LocalPlayer

        local Target = gplr(selectedPlayer.Name)
        if Target[1] then
            Target = Target[1]
            
            local Thrust = Instance.new('BodyThrust', lp.Character.HumanoidRootPart)
            Thrust.Force = Vector3.new(9999, 9999, 9999)
            Thrust.Name = "YeetForce"
            repeat
                lp.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame
                Thrust.Location = Target.Character.HumanoidRootPart.Position
                game:GetService("RunService").Heartbeat:wait()
            until not Target.Character:FindFirstChild("Head")
        else
            OrionLib:MakeNotification({
                Name = "Invalid Player",
                Content = "The selected player is invalid",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

Tab1:AddButton({
    Name = "Copy Username",
    Callback = function()
        if selectedPlayer then
            setclipboard(selectedPlayer.Name)
        end
    end
})

Tab1:AddButton({
    Name = "Copy User ID",
    Callback = function()
        if selectedPlayer then
            setclipboard(tostring(selectedPlayer.UserId))
        end
    end
})

local Text1 = Tab1:AddParagraph("Self Config","Adjust your Some Available Info use Int ex: (10)")

Tab1:AddTextbox({
    Name = "Walk Speed",
    Default = "16",
    TextDisappear = false,
    Callback = function(value)
        local speed = tonumber(value)
        if speed then
            plrs.LocalPlayer.Character.Humanoid.WalkSpeed = speed
        end
    end
})

Tab1:AddTextbox({
    Name = "Jump Power",
    Default = "50",
    TextDisappear = false,
    Callback = function(value)
        local jumpPower = tonumber(value)
        if jumpPower then
            plrs.LocalPlayer.Character.Humanoid.JumpPower = jumpPower
        end
    end
})

Tab1:AddTextbox({
    Name = "Field of View",
    Default = "70",
    TextDisappear = false,
    Callback = function(value)
        local fov = tonumber(value)
        if fov then
            game.Workspace.CurrentCamera.FieldOfView = fov
        end
    end
})

-- [Scripts] --
local Tab2 = Window:MakeTab({Name = "Scripts", Icon = "rbxassetid://8997388036", PremiumOnly = false})

Tab2:AddParagraph("Tools Scripting", "Easy to build a script")

Tab2:AddButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

Tab2:AddButton({
    Name = "Dex v4",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/peyton2465/Dex/master/out.lua"))()
    end
})

Tab2:AddButton({
    Name = "Simple Spy",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"))()
    end
})

local text2 = Tab2:AddParagraph("Scripts", "Useful Scripts to avoid Exploiters.")

Tab2:AddButton({
    Name = "AntiBang",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SattyO07/Scripts/main/AntiBang", true))()
    end
})

Tab2:AddButton({
    Name = "AntiFling",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SattyO07/Scripts/main/AntiFling", true))()
    end
})

-- [[Mm2]] -
    local Tab3 = Window:MakeTab({
    Name = "Murder Mystery 2",
    Icon = "rbxassetid://7733799795",
    PremiumOnly = false,
})

local text3 = Tab3:AddParagraph(" Silent Aim", "Offset 3.5 default i recomended 2 for better Aiming")

local AimUiToggle = Tab3:AddToggle({
    Name = "Shoot Ui",
    Default = false,
    Callback = function(value)
        toggleButton(value) 
    end
})

local AimKeybind = Tab3:AddBind({
	Name = "Shoot Keybind",
	Default = Enum.KeyCode.Q,
	Hold = false,
	Callback = function()
		shootMurderer()
	end    
})

local AimOffset = Tab3:AddTextbox({
	Name = "Aim Offset",
	Default = "3.5",
	TextDisappear = false,
	Callback = function(Value)
		shootOffset = tonumber(Value)
	end	  
})

-- [Info] --
local InfoT = Window:MakeTab({Name = "Info", Icon = "rbxassetid://7733964719", PremiumOnly = false})

local playerCountLabel = InfoT:AddLabel("Player Count: " .. #plrs:GetPlayers() .. "/" .. game.Players.MaxPlayers)
local fpsLabel = InfoT:AddLabel("Current FPS: " .. UpdateFps)

RunService.RenderStepped:Connect(function()
    playerCountLabel:Set("Player Count: " .. #plrs:GetPlayers() .. "/" .. game.Players.MaxPlayers)
    fpsLabel:Set("Current FPS: " .. UpdateFps)
    refreshPlayerDropdown()
end)

-- Initialize the library
OrionLib:Init()
