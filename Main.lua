-- Values
local Players = game:GetService("Players")
local plrs = game.Players
local RunService = game:GetService("RunService")
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Unknownkellymc1/Orion/main/source')))()
-- Universal functions --
-- Dropdown
local playerOptions = {}
for _, player in ipairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer then
        table.insert(playerOptions, player.DisplayName.. " (@".. player.Name.. ")")
    end
end

while true do
    wait(5)
    playerOptions = {}
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(playerOptions, player.DisplayName.. " (@".. player.Name.. ")")
        end
    end
    selectplayerdrop.Options = playerOptions
end

-- Fling
local SkidFling = function(TargetPlayer)
    local Character = game.Players.LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid
    local TRootPart
    local THead
    local Accessory
    local Handle

    if TCharacter:FindFirstChildOfClass("Humanoid") then
        THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    end
    if THumanoid and THumanoid.RootPart then
        TRootPart = THumanoid.RootPart
    end
    if TCharacter:FindFirstChild("Head") then
        THead = TCharacter.Head
    end
    if TCharacter:FindFirstChildOfClass("Accessory") then
        Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    end
    if Accessory and Accessory:FindFirstChild("Handle") then
        Handle = Accessory.Handle
    end

    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end

        if THead then
            workspace.CurrentCamera.CameraSubject = THead
        elseif not THead and Handle then
            workspace.CurrentCamera.CameraSubject = Handle
        elseif THumanoid and TRootPart then
            workspace.CurrentCamera.CameraSubject = THumanoid
        end
        if not TCharacter:FindFirstChildWhichIsA("BasePart") then
            return
        end

        local FPos = function(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end

        local SFBasePart = function(BasePart)
            local TimeToWait = 2
            local Time = tick()
            local Angle = 0

            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle = Angle + 100

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0,0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0,1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude/ 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5,0), CFrame.Angles(math.rad(-90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                    end
                else
                    break
                end
            until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= game.Players or TargetPlayer.Character ~= TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
        end

        workspace.FallenPartsDestroyHeight = 0/0

        local BV = Instance.new("BodyVelocity")
        BV.Name = "EpixVel"
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)

        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

        if TRootPart and THead then
            if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                SFBasePart(THead)
            else
                SFBasePart(TRootPart)
            end
        elseif TRootPart and not THead then
            SFBasePart(TRootPart)
        elseif not TRootPart and THead then
            SFBasePart(THead)
        elseif not TRootPart and not THead and Accessory and Handle then
            SFBasePart(Handle)
        else
            OrionLib:MakeNotification({
	Name = "Warning",
	Content = "Can't find a proper part of target player to fling.",
	Image = "rbxassetid://4483345998",
	Time = 3
})
        end

        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = Humanoid

        repeat
            RootPart.CFrame = getgenv().OldPos * CFrame.new(0,.5, 0)
            Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0,.5, 0))
            Humanoid:ChangeState("GettingUp")
            table.foreach(Character:GetChildren(), function(_, x)
                if x:IsA("BasePart") then
                    x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                end
            end)
            task.wait()
        until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
        workspace.FallenPartsDestroyHeight = getgenv().FPDH
    else
        OrionLib:MakeNotification({
	Name = "Fling",
	Content = "No valid character of said target player. May have died.",
	Image = "rbxassetid://4483345998",
	Time = 3
})
    end
end
-- Mm2 Functions --
-- Find Players
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

local shootOffset = 2.8
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
-- Create ButtonUi
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CrosshairGui"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Create frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 60)
frame.Position = UDim2.new(0.5, -75, 0.5, -30)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(0, 0, 255)
frame.BackgroundTransparency = 0.8
frame.Parent = screenGui

-- Create cornered outline
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Create inner frame with black transparent background
local innerFrame = Instance.new("Frame")
innerFrame.Size = UDim2.new(1, -4, 1, -4) 
innerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
innerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
innerFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) 
innerFrame.BackgroundTransparency = 0.8
innerFrame.Parent = frame

-- Create cornered inner frame
local innerCorner = Instance.new("UICorner")
innerCorner.CornerRadius = UDim.new(0, 10)
innerCorner.Parent = innerFrame

-- Create image label
local imageLabel = Instance.new("ImageLabel")
imageLabel.Size = UDim2.new(0, 50, 0, 50)
imageLabel.Image = "rbxassetid://7733765307"
imageLabel.BackgroundTransparency = 1
imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
imageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
imageLabel.Parent = innerFrame

-- Create button
local button = Instance.new("ImageButton")
button.Size = UDim2.new(1, 0, 1, 0)
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
    shoot()
end)

-- Info Functions --
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

-- [Universal] --
local Tab1 = Window:MakeTab({Name = "Universal", Icon = "rbxassetid://7733954760", PremiumOnly = false})

local selectplayerdrop = 1Tab:AddDropdown({
    Name = "Player Select",
    Default = "",
    Options = playerOptions,
    Callback = function(Value)
    end
})

local teleportPlayer = 1Tab:AddButton({
    Name = "Teleport",
    Callback = function()
        local selectedPlayer = game.Players:FindFirstChild(selectplayerdrop.Value)
        if selectedPlayer then
            local character = game.Players.LocalPlayer.Character
            if character then
                character.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame
            end
        else
            OrionLib:MakeNotification({
	Name = "Warning",
	Content = "You need to select a player first.",
	Image = "rbxassetid://4483345998",
	Time = 3
})
        end
    end
})

local flingButton = 1Tab:AddButton({
    Name = "Fling",
    Callback = function()
        local selectedPlayer = game.Players:FindFirstChild(selectplayerdrop.Value)
        if selectedPlayer then
            if selectedPlayer ~= game.Players.LocalPlayer then
                SkidFling(selectedPlayer)
            else
                OrionLib:MakeNotification({
	Name = "Warning",
	Content = "You can't fling Yourself.",
	Image = "rbxassetid://4483345998",
	Time = 3
})
            end
        else
            OrionLib:MakeNotification({
	Name = "Warning",
	Content = "You need to select a player first.",
	Image = "rbxassetid://4483345998",
	Time = 3
})
        end
    end
})

local spectateToggle = 1Tab:AddToggle({
    Name = "Spectate",
    Default = false,
    Callback = function(Value)
        if Value then
            local selectedPlayer = game.Players:FindFirstChild(selectplayerdrop.Value)
            if selectedPlayer then
                local character = game.Players.LocalPlayer.Character
                if character then
                    character.HumanoidRootPart.Anchored = true
                    character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    character.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                end
            else
                OrionLib:MakeNotification({
	Name = "Warning",
	Content = "You need to select a player first.",
	Image = "rbxassetid://4483345998",
	Time = 3
})
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
local Tab2 = Window:MakeTab({Name = "Scripts", Icon = "rbxassetid://7734111084", PremiumOnly = false})

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

Tab2:AddButton({
    Name = "Yarhm",
    Callback = function()
        loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-YARHM-12403"))()
    end
})

Tab2:AddButton({
    Name = "Console",
    Callback = function()
        game.StarterGui:SetCore("DevConsoleVisible", true)
		end
})

-- [[Mm2]] --
    local Tab3 = Window:MakeTab({
    Name = "Murder Mystery 2",
    Icon = "rbxassetid://7733799795",
    PremiumOnly = false,
})

local parsilentaim = Tab3:AddParagraph("Silent Aim:", "Offset 2.8 default")

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
		shoot()
	end    
})

local AimOffset = Tab3:AddTextbox({
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

local ParEsp = Tab3:AddParagraph("Esp:", "Locate a players (Fixing)")

-- [Info] --
local InfoT = Window:MakeTab({Name = "Info", Icon = "rbxassetid://7733964719", PremiumOnly = false})

local playerCountLabel = InfoT:AddLabel("Player Count: " .. #plrs:GetPlayers() .. "/" .. game.Players.MaxPlayers)
local fpsLabel = InfoT:AddLabel("Current FPS: " .. UpdateFps)

RunService.RenderStepped:Connect(function()
    playerCountLabel:Set("Player Count: " .. #plrs:GetPlayers() .. "/" .. game.Players.MaxPlayers)
    fpsLabel:Set("Current FPS: " .. UpdateFps)
end)

-- Initialize the library
OrionLib:Init()
