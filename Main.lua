-- Values
local plrs = game.Players
local playerNames = {}
local RunService = game:GetService("RunService")
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Unknownkellymc1/Orion/main/source')))()

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

-- Window
local GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local Window = OrionLib:MakeWindow({Name = "MoonLight : [" .. GameName .. "]", HidePremium = false, SaveConfig = false, ConfigFolder = "ReaperSaved"})

-- [Universal]--
local Tab1 = Window:MakeTab({Name = "Universal", Icon = "rbxassetid://7733954760", PremiumOnly = false})

Tab1:AddParagraph("Player Selections", "Use DropDown to choose a Target player")

local selectedPlayer
local selectPlayers = Tab1:AddDropdown({
    Name = "Players",
    Default = "No Players",
    Options = playerNames,
    Callback = function(selectedplrName)
        selectedPlayer = plrs:FindFirstChild(selectedplrName)
    end
})

local function refreshPlayerDropdown()
    updatePlayerNames()
    selectPlayers:Refresh(playerNames, true)
end

plrs.PlayerAdded:Connect(refreshPlayerDropdown)
plrs.PlayerRemoving:Connect(refreshPlayerDropdown)

local teleportButton = Tab1:AddButton({
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

Tab1:AddButton({
    Name = "Apply Walk Speed",
    Callback = function()
        local speed = tonumber(Tab1:GetTextbox("Walk Speed").Value)
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

Tab1:AddButton({
    Name = "Apply Jump Power",
    Callback = function()
        local jumpPower = tonumber(Tab1:GetTextbox("Jump Power").Value)
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

Tab1:AddButton({
    Name = "Apply Field of View",
    Callback = function()
        local fov = tonumber(Tab1:GetTextbox("Field of View").Value)
        if fov then
            game.Workspace.CurrentCamera.FieldOfView = fov
        end
    end
})

Tab1:AddParagraph("Dev Console", "Check output Developer console")

Tab1:AddButton({
    Name = "Dev Console",
    Callback = function()
        game.StarterGui:SetCore("DevConsoleVisible", true)
    end
})

-- [Scripts] --
local Tab2 = Window:MakeTab({Name = "Scripts", Icon = "rbxassetid://7733774602", PremiumOnly = false})

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

Tab2:AddButton({
    Name = "DomainX",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/DomainX/main/source", true))()
    end
})

local text2 = Tab2:AddParagraph("Scripts","Useful Scripts to avoid Exploiters.")

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
    Name = "Yarhm Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Joystickplays/psychic-octo-invention/main/yarhm.lua", false))()
    end
})


-- [Info] --
local Tab3 = Window:MakeTab({Name = "Info", Icon = "rbxassetid://7733964719", PremiumOnly = false})

Tab3:AddLabel("MoonLight Hub")

local playerCountLabel = Tab3:AddLabel("Player Count: " .. #plrs:GetPlayers() .. "/" .. game.Players.MaxPlayers)
local fpsLabel = Tab3:AddLabel("Current FPS: " .. UpdateFps)

RunService.RenderStepped:Connect(function()
    playerCountLabel:Set("Player Count: " .. #plrs:GetPlayers() .. "/" .. game.Players.MaxPlayers)
    fpsLabel:Set("Current FPS: " .. UpdateFps)
end)

-- Initialize the library
OrionLib:Init()
