-- Values
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Players = game:GetService("Players")
local camera = game.Workspace.CurrentCamera
local RunService = game:GetService("RunService")
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Unknownkellymc1/Orion/main/source')))()
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Universal Functions --
-- Noclip
local Noclip = nil
local Clip = nil

function noclip()
	Clip = false
	local function Nocl()
		if Clip == false and game.Players.LocalPlayer.Character ~= nil then
			for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
				if v:IsA('BasePart') and v.CanCollide and v.Name ~= floatName then
					v.CanCollide = false
				end
			end
		end
		wait(0.21) -- basic optimization
	end
	Noclip = game:GetService('RunService').Stepped:Connect(Nocl)
end

function clip()
	if Noclip then Noclip:Disconnect() end
	Clip = true
end
-- Fling
local function FlingPlayer(playerToFling)
    if FlingDetectionEnabled then
        OrionLib:MakeNotification({
	Name = "Nofication",
	Content = "Pls Off first the AntiFling.",
	Image = "rbxassetid://4483345998",
	Time = 5})
        return
    end

    if not playerToFling then
        OrionLib:MakeNotification({
	Name = "Nofication",
	Content = "Player Target Invalid",
	Image = "rbxassetid://4483345998",
	Time = 5})
        return
    end

    local player = game.Players.LocalPlayer
    local Targets = {playerToFling}

    local SkidFling = function(TargetPlayer)
        local Character = player.Character
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
            if THumanoid and THumanoid.Sit then
            end
            if THead then
                if THead.Velocity.Magnitude > 500 then
        OrionLib:MakeNotification({
	Name = "Nofication",
	Content = "Already Flung Away.",
	Image = "rbxassetid://4483345998",
	Time = 5})
                    return
                end
            elseif not THead and Handle then
                if Handle.Velocity.Magnitude > 500 then
        OrionLib:MakeNotification({
	Name = "Nofication",
	Content = "Already Flung Away.",
	Image = "rbxassetid://4483345998",
	Time = 5})
                    return
                end
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

                            FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                        else
                            FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(-90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                            task.wait()
                        end
                    else
                        break
                    end
                until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or TargetPlayer.Character ~= TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
            end

            workspace.FallenPartsDestroyHeight = 0 / 0

            local BV = Instance.new("BodyVelocity")
            BV.Name = "EpixVel"
            BV.Parent = RootPart
            BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
            BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

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
	Name = "Nofication",
	Content = "Can't find a proper part of the target player to fling.",
	Image = "rbxassetid://4483345998",
	Time = 5})
            end

            BV:Destroy()
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            workspace.CurrentCamera.CameraSubject = Humanoid

            repeat
                RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
                Humanoid:ChangeState("GettingUp")
                for _, part in pairs(Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Velocity, part.RotVelocity = Vector3.new(), Vector3.new()
                    end
                end
                task.wait()
            until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
            workspace.FallenPartsDestroyHeight = getgenv().FPDH
        else
            OrionLib:MakeNotification({
	Name = "Nofication",
	Content = "No valid character of the target player. They may have died.",
	Image = "rbxassetid://4483345998",
	Time = 5})
        end
    end

    SkidFling(Targets[1])
end
-- AntiFling
local function PlayerAdded(Player)
    if not FlingDetectionEnabled then return end
    local Detected = false
    local Character;
    local PrimaryPart;

    local function CharacterAdded(NewCharacter)
        Character = NewCharacter
        repeat
            wait()
            PrimaryPart = NewCharacter:FindFirstChild("HumanoidRootPart")
        until PrimaryPart
        Detected = false
    end

    CharacterAdded(Player.Character or Player.CharacterAdded:Wait())
    Player.CharacterAdded:Connect(CharacterAdded)
    RunService.Heartbeat:Connect(function()
        if (Character and Character:IsDescendantOf(workspace)) and (PrimaryPart and PrimaryPart:IsDescendantOf(Character)) then
            if PrimaryPart.AssemblyAngularVelocity.Magnitude > 50 or PrimaryPart.AssemblyLinearVelocity.Magnitude > 100 then
                Detected = true
                for i,v in ipairs(Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                        v.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        v.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
                    end
                end
                PrimaryPart.CanCollide = false
                PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                PrimaryPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
            end
        end
    end)
end

for i,v in ipairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then
        PlayerAdded(v)
    end
end
Players.PlayerAdded:Connect(PlayerAdded)

local LastPosition = nil
RunService.Heartbeat:Connect(function()
    if not FlingDetectionEnabled then return end
    pcall(function()
        local PrimaryPart = LocalPlayer.Character.PrimaryPart
        if PrimaryPart.AssemblyLinearVelocity.Magnitude > 250 or PrimaryPart.AssemblyAngularVelocity.Magnitude > 250 then
            PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            PrimaryPart.CFrame = LastPosition

            OrionLib:MakeNotification({
	Name = "Anti Fling",
	Content = "You were flung. Neutralizing velocity.",
	Image = "rbxassetid://4483345998",
	Time = 2
})

        elseif PrimaryPart.AssemblyLinearVelocity.Magnitude < 50 or PrimaryPart.AssemblyAngularVelocity.Magnitude > 50 then
            LastPosition = PrimaryPart.CFrame
        end
    end)
end)

-- Info Functions --
-- Function Fps
local UpdateFps = 0
local LastTime = tick()

RunService.RenderStepped:Connect(function()
		wait(2)
    local DeltaTime = tick() - LastTime
    LastTime = tick()
end)

-- Function Executor
local Exe = identifyexecutor()

--Function Device
local Device = nil
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    Device = "Mobile"
elseif UserInputService.KeyboardEnabled and not UserInputService.TouchEnabled then
    Device = "Computer"
elseif UserInputService.GamepadEnabled and not UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    Device = "Console"
end

-- Window
local GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local Window = OrionLib:MakeWindow({Name = "MoonLight : [" .. GameName .. "]", HidePremium = false, SaveConfig = false, ConfigFolder = "ReaperSaved"})

-- [Universal] --
local Tab1 = Window:MakeTab({Name = "Universal", Icon = "rbxassetid://7733954760", PremiumOnly = false, IntroText = "Welcome", IntroIcon = "rbxassetid://5998624788"})

local UniText1 = Tab1:AddParagraph("Player's select:", "Select a Player's first.")

local selectedPlayer = nil

local function GetPlayers()
    local playerNames = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.DisplayName .. " (@" .. player.Name .. ")")
        end
    end
    table.sort(playerNames) 
    return playerNames
end

local function FindPlayerByName(displayNameWithUsername)
    for _, player in pairs(Players:GetPlayers()) do
        if player.DisplayName .. " (@" .. player.Name .. ")" == displayNameWithUsername then
            return player
        end
    end
    return nil
end

local playerDropdown

local function UpdateDropdown()
    local players = GetPlayers()
    playerDropdown:Refresh(players, true) 
end

playerDropdown = Tab1:AddDropdown({
    Name = "Player Select:",
    Default = "",
    Options = GetPlayers(),
    Callback = function(Value)
        selectedPlayer = FindPlayerByName(Value)
    end    
})

Tab1:AddButton({
    Name = "Teleport",
    Callback = function()
        if not selectedPlayer then
            OrionLib:MakeNotification({
                Name = "Notification",
                Content = "No player selected.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
            return
        end

        if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame
        else
            OrionLib:MakeNotification({
                Name = "Notification",
                Content = "No player selected.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end    
})

Tab1:AddButton({
    Name = "Fling",
    Callback = function()
        if not selectedPlayer then
        OrionLib:MakeNotification({
	Name = "Notification",
        Content = "No player selected.",
	Image = "rbxassetid://4483345998",
	Time = 5})
            return
        end
        FlingPlayer(selectedPlayer)
    end    
})

Tab1:AddToggle({
    Name = "Spectate",
    Default = false,
    Callback = function(Value)
        if not selectedPlayer then
            if Value then
                OrionLib:MakeNotification({
                    Name = "Notification",
                    Content = "No player selected.",
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
            end
            return
        end

        if Value and selectedPlayer then
            workspace.CurrentCamera.CameraSubject = selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
        else
            workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        end
    end    
})

Players.PlayerAdded:Connect(function(player)
    UpdateDropdown()
end)

Players.PlayerRemoving:Connect(function(player)
    UpdateDropdown()
end)

local UniText1 = Tab1:AddParagraph("Mics:", "Random things maybe help.")

Tab1:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(value)
        if value then
            noclip()
        else
            clip()
        end
    end
})

Tab1:AddToggle({
    Name = "Anti Fling",
    Default = false,
    Callback = function(Value)
        FlingDetectionEnabled = Value
    end    
})

Tab1:AddToggle({
	Name = "Anti AFK",
	Default = false,
	Callback = function(Value)
		if Value then
    local afk = game:service'VirtualUser'
    game:service'Players'.LocalPlayer.Idled:connect(function()
        afk:CaptureController()
        afk:ClickButton2(Vector2.new())
    end)
			end
	end    
})

-- [Scripts] --
local Tab2 = Window:MakeTab({Name = "Scripts", Icon = "rbxassetid://7734111084", PremiumOnly = false})

local SciText1 = Tab2:AddParagraph("Scripts:", "Random From internet.")

Tab2:AddButton({
    Name = "Yarhm",
    Callback = function()
        loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-YARHM-12403"))()
    end
})

local SciText2 = Tab2:AddParagraph("Build Scripts:", "May Help from Building scripts")

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

-- [[Mm2]] --
-- Variables
local gunDropESP = false
local EspPlayer = false
local shootOffset = 2.8
local gunDropCache = {}
local TimeGUI = false

-- Functions Mm2
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
            OrionLib:MakeNotification({Name = "Player Esp",Content = "Game Ended Disabling the Esp",Image = "rbxassetid://7733771628",Time = 5})
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
    local function checkForGun(character)
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            backpack.ChildAdded:Connect(function(child)
                if child.Name == "Gun" then
                    UpdatePlayerESP()
                end
            end)
        end

        character.ChildAdded:Connect(function(child)
            if child.Name == "Gun" then
                UpdatePlayerESP()
            end
        end)
    end

    player.CharacterAdded:Connect(function(character)
        checkForGun(character)
    end)

    if player.Character then
        checkForGun(player.Character)
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    checkPlayerGunInventory(player)
end

Players.PlayerAdded:Connect(checkPlayerGunInventory)

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
local Tab3 = Window:MakeTab({Name = "MM2", Icon = "rbxassetid://7733954760", PremiumOnly = false})

local Section2 = Tab3:AddSection({Name = "AimBot"})

if Device == "Mobile" then
  local Buttonuiw = Tab3:AddToggle({
        Name = "ButtonShoot",
        Default = false,
        Callback = function(Value)
            toggleButton(Value)
        end    
    })
end

local keybindshoot = Tab3:AddBind({
	Name = "Shoot Keybind",
	Default = Enum.KeyCode.Q,
	Hold = false,
	Callback = function()
		shoot()
	end    
})

local offsetbox =Tab3:AddTextbox({
    Name = "Shoot Offset",
    Default = "2.8",
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

local Section2 = Tab3:AddSection({Name = "Esp:"})

local Playerespe =Tab3:AddToggle({
        Name = "Player Esp",
        Default = false,
        Callback = function(Value)
            EspPlayer = Value
        end    
    })

local Gunespe = Tab3:AddToggle({
        Name = "GunEsp",
        Default = false,
        Callback = function(Value)
            gunDropESP = Value
        end    
    })

local Section3 = Tab3:AddSection({Name = "Mics:"})

local timeruiw = Tab3:AddToggle({
        Name = "Timer",
        Default = false,
        Callback = function(Value)
            TimeGUI = Value
        end    
    })

-- [Info] --
local InfoT = Window:MakeTab({Name = "Mics", Icon = "rbxassetid://7733964719", PremiumOnly = false})

local SecInf1 = InfoT:AddSection({Name = "Stats:"})

local fpsLabel = InfoT:AddLabel("Current FPS: 0")
local ExeLabel = InfoT:AddLabel("Device: ".. Device)
local ExeLabel = InfoT:AddLabel("Executor: ".. Exe)
local playerCountLabel = InfoT:AddLabel("Player Count: 0/0")
 
local SecInf2 = InfoT:AddSection({Name = "Configs:"})

InfoT:AddButton({
    Name = "Console",
    Callback = function()
        game.StarterGui:SetCore("DevConsoleVisible", true)end})

InfoT:AddButton({
	Name = "Destroy Gui",
	Callback = function() OrionLib:Destroy()end})


OrionLib:Init()
RunService.RenderStepped:Connect(function()
    UpdateFps = math.floor(1 / RunService.RenderStepped:Wait(5))
    playerCountLabel:Set("Player Count: " .. #game.Players:GetPlayers() .. "/" .. game.Players.MaxPlayers)
    fpsLabel:Set("Current FPS: " .. UpdateFps)
end)
