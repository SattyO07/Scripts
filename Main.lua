-- Values
local plrs = game.Players
local playerNames = {}
local UserInputService = game:GetService("UserInputService")
local GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local RunService = game:GetService("RunService")

-- Function to update player names
local function updatePlayerNames()
    playerNames = {}
    for _, player in ipairs(plrs:GetPlayers()) do
        table.insert(playerNames, player.Name)
    end
end

spawn(updatePlayerNames)

-- FPS
local UpdateFps = 0
local LastTime = tick()

RunService.RenderStepped:Connect(function()
    local DeltaTime = tick() - LastTime
    LastTime = tick()

    UpdateFps = math.floor(1 / DeltaTime)
end)

-- Update player count
local PlayerCount = "0/0"
local function updatePlayerCount()
    local currentPlayerCount = #plrs:GetPlayers()
    local maxPlayerCount = game.Players.MaxPlayers

    PlayerCount = currentPlayerCount .. "/" .. maxPlayerCount
end

-- Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Unknownkellymc1/Orion/main/source')))()

-- Window
local Window = OrionLib:MakeWindow({Name = "MoonLight : [" .. GameName .. "]", HidePremium = false, SaveConfig = false, ConfigFolder = "ReaperSaved"})

-- Tabs
local Tab1 = Window:MakeTab({Name = "Universal", Icon = "rbxassetid://7733954760", PremiumOnly = false})
local Tab2 = Window:MakeTab({Name = "Scripts", Icon = "rbxassetid://7733774602", PremiumOnly = false})
local Tab3 = Window:MakeTab({Name = "Info", Icon = "rbxassetid://7733964719", PremiumOnly = false})

-- [Universal]--
local Character = Tab1:AddSection({Name = "Character:"})

local speedSlider
local speedToggle

speedSlider = Tab1:AddSlider({
    Name = "Set Speed",
    Min = 0,
    Max = 1000,
    Default = 16,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Value",
    Callback = function(speed)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
})

speedToggle = Tab1:AddToggle({
    Name = "Enable Speed",
    Default = false,
    Callback = function(enabled)
        speedSlider:SetEnabled(enabled)
        if not enabled then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 
        end
    end
})

local jumpPowerSlider
local jumpPowerToggle

jumpPowerSlider = Tab1:AddSlider({
    Name = "Set Jump Power",
    Min = 0,
    Max = 500,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Value",
    Callback = function(jumpPower)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = jumpPower
    end
})

jumpPowerToggle = Tab1:AddToggle({
    Name = "Enable Jump Power",
    Default = false,
    Callback = function(enabled)
        jumpPowerSlider:SetEnabled(enabled)
        if not enabled then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50 
        end
    end
})

local fovSlider
local fovToggle

fovSlider = Tab1:AddSlider({
    Name = "Set FOV",
    Min = 70,
    Max = 120,
    Default = 70, -- Default FOV value
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Value",
    Callback = function(fov)
        game.Workspace.CurrentCamera.FieldOfView = fov
    end
})

fovToggle = Tab1:AddToggle({
    Name = "Enable FOV",
    Default = false,
    Callback = function(enabled)
        fovSlider:SetEnabled(enabled)
        if not enabled then
            game.Workspace.CurrentCamera.FieldOfView = 70 -- Default FOV
        end
    end
})

Tab1:AddButton({
    Name = "Reset Character",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character

        if character then
            character:BreakJoints()
        end
    end
})

updatePlayerNames()
local players = Tab1:AddSection({Name = "Players:"})

local selectedPlayer
local selectPlayers = Tab1:AddDropdown({
    Name = "Players",
    Default = "No Players",
    Options = playerNames,
    Callback = function(selectedplrName)
        selectedPlayer = plrs:FindFirstChild(selectedplrName)
    end
})

local teleportButton 
teleportButton = Tab1:AddButton({
    Name = "Teleport",
    Enabled = false,
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

local spectateToggle 
spectateToggle = Tab1:AddToggle({
    Name = "Spectate",
    Default = false,
    Callback = function(Value)
        if selectedPlayer then
            if Value then
                spectatePlayer(selectedPlayer)
            else
                stopSpectating()
            end
        end
    end
})

Tab1:AddButton({
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

        local function notif(str, dur)
            game.StarterGui:SetCore("SendNotification", {
                Title = "Fling Gui",
                Text = str,
                Duration = dur or 3
            })
        end

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
            notif("Invalid player")
        end
    end
})

-- [Scripts]--
local ToolGui = Tab2:AddSection({Name = "Tools Gui:"})

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
    Name = "Dark Dex",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SpaceYes/Lua/Main/DarkDex.lua"))()
    end    
})

Tab2:AddButton({
    Name = "DomainX",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/DomainX/main/source", true))()
    end    
})

-- [Info]--
Tab3:AddLabel("MoonLight Hub")

Tab3:AddLabel("Player Count: " .. PlayerCount)
RunService.RenderStepped:Connect(updatePlayerCount)

Tab3:AddLabel("Current FPS: ")
RunService.RenderStepped:Connect(function()
    Tab3:UpdateLabel("Current FPS: " .. UpdateFps)
end)

OrionLib:Init()
