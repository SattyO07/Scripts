-- Values
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Players = game:GetService("Players")
local camera = game.Workspace.CurrentCamera
local RunService = game:GetService("RunService")
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Unknownkellymc1/Orion/main/source')))()

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
local Tab1 = Window:MakeTab({Name = "Universal", Icon = "rbxassetid://7733954760", PremiumOnly = false})

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

Tab2:AddButton({
    Name = "Console",
    Callback = function()
        game.StarterGui:SetCore("DevConsoleVisible", true)
		end
})

-- [[Mm2] --
local gameId = game.GameId

if gameId == "142823291" then
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/SattyO07/Scripts/main/Tabs/Mm2.lua')))()
end
-- [Info] --
local InfoT = Window:MakeTab({Name = "Info", Icon = "rbxassetid://7733964719", PremiumOnly = false})

local SecInf1 = InfoT:AddSection({Name = "Stats:"})

local fpsLabel = InfoT:AddLabel("Current FPS: 0")
local ExeLabel = InfoT:AddLabel("Device: ".. Device)
local ExeLabel = InfoT:AddLabel("Executor: ".. Exe)
local playerCountLabel = InfoT:AddLabel("Player Count: 0/0")

local SecInf2 = InfoT:AddSection({Name = "Configs:"})
InfoT:AddButton({
	Name = "Destroy Gui",
	Callback = function() OrionLib:Destroy()end})


OrionLib:Init()
RunService.RenderStepped:Connect(function()
    UpdateFps = math.floor(1 / RunService.RenderStepped:Wait())
    playerCountLabel:Set("Player Count: " .. #game.Players:GetPlayers() .. "/" .. game.Players.MaxPlayers)
    fpsLabel:Set("Current FPS: " .. UpdateFps)
end)
