-- MoonLight | 2.0.5

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Luna Lib
local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/main/source.lua", true))()

-- WINDOW
local Window = Luna:CreateWindow({
	Name = "MoonLight", -- This Is Title Of Your Window
	Subtitle = nil, -- A Gray Subtitle next To the main title.
	LogoID = "82795327169782", -- The Asset ID of your logo. Set to nil if you do not have a logo for Luna to use.
	LoadingEnabled = true, -- Whether to enable the loading animation. Set to false if you do not want the loading screen or have your own custom one.
	LoadingTitle = "MoonLight", -- Header for loading screen
	LoadingSubtitle = "by GrandpaBro" -- Subtitle for loading sscree
}) 

local MM2Tab = Window:CreateTab({
	Name = "MM2",
	Icon = "view_in_ar",
	ImageSource = "Material",
	ShowTitle = true
})

local SettingsTab = Window:CreateTab({
	Name = "MM2",
	Icon = "view_in_ar",
	ImageSource = "Material",
	ShowTitle = true
})

-- VARS
local shootOffset = 2.8
local EspPlayer = false
local ESPTransparency = 0.7
local MobileShootButtonEnabled = false
local RoleNotify = false
local cachedPlayerData = {}
local notifiedRoles = {}
local timerGuiRef = nil
local timerLabelRef = nil

-- FUNCTIONS
local function notifyWithAvatar(title, message, playerName)
	local Players = game:GetService("Players")
	local StarterGui = game:GetService("StarterGui")

	local function getUserId(name)
		local player = Players:FindFirstChild(name)
		if player then
			return player.UserId
		else
			local success, result = pcall(function()
				return Players:GetUserIdFromNameAsync(name)
			end)
			if success then
				return result
			end
		end
		return 1 
	end

	local userId = getUserId(playerName)
	local imageUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(userId) .. "&width=420&height=420&format=png"

	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = message,
			Icon = imageUrl,
			Duration = 5
		})
	end)
end

local function getPlayerRole(player)
	return cachedPlayerData[player.Name] and cachedPlayerData[player.Name].Role or "Innocent"
end

local function refreshPlayerData()
	local success, data = pcall(function()
		return ReplicatedStorage.Remotes.Extras.GetPlayerData:InvokeServer()
	end)

	if success then
		local hasHero = false
		for name, info in pairs(data) do
			if info.Role == "Hero" then
				hasHero = true
				break
			end
		end

		local queue = {}
		local newNotifiedRoles = {}

		for name, info in pairs(data) do
			local role = info.Role
			local key = name .. role
			local isLocalPlayer = (name == LocalPlayer.Name)

			local shouldNotify =
				(role == "Murderer") or
				(role == "Hero") or
				(role == "Sheriff" and not hasHero)

			if RoleNotify and shouldNotify then
				-- Always notify if new, or if the role has changed
				if not notifiedRoles[key] then
					table.insert(queue, {
						title = role,
						msg = isLocalPlayer and "You" or name,
						name = name
					})
				end
				newNotifiedRoles[key] = true
			end
		end

		-- Send notifications with short delay
		task.spawn(function()
			for _, notif in ipairs(queue) do
				notifyWithAvatar(notif.title, notif.msg, notif.name)
				task.wait(0.1)
			end
		end)

		-- Refresh the cache
		notifiedRoles = newNotifiedRoles
		cachedPlayerData = data
	end
end

-- ESP
local function addMurderText(character)
	local head = character:FindFirstChild("Head")
	if head and not head:FindFirstChild("MurderTag") then
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "MurderTag"
		billboard.Size = UDim2.new(0, 100, 0, 40)
		billboard.Adornee = head
		billboard.StudsOffset = Vector3.new(0, 1.5, 0)
		billboard.AlwaysOnTop = true
		billboard.Parent = head

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = "Murder"
		label.TextColor3 = Color3.fromRGB(255, 0, 0)
		label.TextStrokeTransparency = 0.5
		label.TextStrokeColor3 = Color3.new(0, 0, 0)
		label.Font = Enum.Font.GothamBold
		label.TextScaled = true
		label.Parent = billboard
	end
end

local function applyHighlight(player)
	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end

	local role = getPlayerRole(player)
	local color = Color3.fromRGB(0, 255, 0)
	if role == "Murderer" then
		color = Color3.fromRGB(255, 0, 0)
		addMurderText(character)
	elseif role == "Sheriff" then
		color = Color3.fromRGB(0, 150, 255)
	elseif role == "Hero" then
		color = Color3.fromRGB(255, 255, 0)
	end

	for _, v in pairs(character:GetChildren()) do
		if v:IsA("Highlight") then v:Destroy() end
	end

	local highlight = Instance.new("Highlight")
	highlight.Adornee = character
	highlight.FillColor = color
	highlight.FillTransparency = ESPTransparency
	highlight.OutlineColor = color
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Name = "Highlight"
	highlight.Parent = character
end

local function updatePlayerHighlights()
	if not EspPlayer then return end

	local foundMurder, foundSheriff = false, false
	for _, info in pairs(cachedPlayerData) do
		if info.Role == "Murderer" then foundMurder = true end
		if info.Role == "Sheriff" then foundSheriff = true end
	end

	-- Show/hide timerGui
	if timerGuiRef then
		timerGuiRef.Enabled = (foundMurder or foundSheriff)
	end

	if not (foundMurder or foundSheriff) then
		for _, p in ipairs(Players:GetPlayers()) do
			local c = p.Character
			if c and c:FindFirstChild("Highlight") then c.Highlight:Destroy() end
			local head = c and c:FindFirstChild("Head")
			if head and head:FindFirstChild("MurderTag") then head.MurderTag:Destroy() end
		end
		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then applyHighlight(player) end
	end
end

-- SHOOT
local function getPredictedPosition(targetPlayer)
	local hrp = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
	local hum = targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid")
	if not hrp or not hum then return nil end
	local velocity = hrp.AssemblyLinearVelocity
	local direction = hum.MoveDirection
	return hrp.Position + (velocity * Vector3.new(0, 0.5, 0)) * (shootOffset / 15) + direction * shootOffset
end

local function shoot()
	refreshPlayerData()
	local me = LocalPlayer
	local role = getPlayerRole(me)

	if role ~= "Sheriff" and role ~= "Hero" then
		local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
	Title = "Aimbot",
	Text = "You are not a Sheriff/Hero.",
	Duration = 5
})
		return
	end

	local char = me.Character
	local gun = char and char:FindFirstChild("Gun") or me.Backpack:FindFirstChild("Gun")
	if not gun then
		local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
	Title = "AimBot",
	Text = "Wheres your gun? ",
	Duration = 5
})
		return
	end

	if not char:FindFirstChild("Gun") then
		char.Humanoid:EquipTool(gun)
		task.wait(0.15)
	end

	local target
	for _, player in ipairs(Players:GetPlayers()) do
		if getPlayerRole(player) == "Murderer" and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			target = player
			break
		end
	end
	if not target then return end

	local predicted = getPredictedPosition(target)
	if predicted and gun:FindFirstChild("KnifeLocal") and gun.KnifeLocal:FindFirstChild("CreateBeam") then
		local remote = gun.KnifeLocal.CreateBeam:FindFirstChild("RemoteFunction")
		if remote then remote:InvokeServer(1, predicted, "AH2") end
	end
end

-- GUN DROP ESP + NOTIFY
Workspace.DescendantAdded:Connect(function(descendant)
	if descendant:IsA("BasePart") and descendant.Name == "GunDrop" then
		local h = Instance.new("Highlight")
		h.Name = "GunDropHighlight"
		h.FillColor = Color3.fromRGB(255, 255, 0)
		h.OutlineTransparency = 1
		h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		h.Adornee = descendant
		h.Parent = descendant

		local tag = Instance.new("BillboardGui")
		tag.Name = "GunDropText"
		tag.Size = UDim2.new(0, 100, 0, 40)
		tag.Adornee = descendant
		tag.StudsOffset = Vector3.new(0, 1.5, 0)
		tag.AlwaysOnTop = true
		tag.Parent = descendant

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = "Gun Drop"
		label.TextColor3 = Color3.fromRGB(255, 255, 0)
		label.TextStrokeTransparency = 0.5
		label.TextStrokeColor3 = Color3.new(0, 0, 0)
		label.Font = Enum.Font.GothamBold
		label.TextScaled = true
		label.Parent = tag

	local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
	Title = "Gun Esp",
	Text = "The Gun was Drop",
	Duration = 5
})
	end
end)

-- TIMER GUI
local function createTimer()
	local part = Workspace:FindFirstChild("RoundTimerPart")
	local label = part and part:FindFirstChild("SurfaceGui") and part.SurfaceGui:FindFirstChild("Timer")
	if not label then return end

	local gui = Instance.new("ScreenGui")
    gui.Name = "MM2TimerGui"
    gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	timerGuiRef = gui
	timerLabelRef = label

	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(0, 200, 0, 50)
	text.Position = UDim2.new(0.5, -100, 0.1, 0)
	text.BackgroundTransparency = 1
	text.TextColor3 = Color3.new(1, 1, 1)
	text.TextStrokeTransparency = 0.5
	text.Font = Enum.Font.SourceSans
	text.TextSize = 48
	text.Parent = gui

	RunService.RenderStepped:Connect(function()
		if timerGuiRef and timerLabelRef then
			text.Text = timerLabelRef.Text
		end
	end)
end

-- MOBILE SHOOT BUTTON
local function createMobileShootButton()
    local gui = Instance.new("ScreenGui")
    gui.Name = "MobileShootUI"
    gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
 

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 150, 0, 60)
	button.Position = UDim2.new(0.85, 0, 0.8, 0)
	button.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
	button.BackgroundTransparency = 0.2
	button.Text = "Shoot"
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextSize = 22
	button.Font = Enum.Font.SourceSansBold
	button.Active = true
	button.Draggable = true
	button.Parent = gui

	button.MouseButton1Click:Connect(shoot)

	RunService.RenderStepped:Connect(function()
		gui.Enabled = MobileShootButtonEnabled
	end)
end

-- Elements Ui
local LabelAimbot = MM2Tab:CreateLabel({
	Text = "Aimbot",
	Style = 1
})

local Toggle1 = MM2Tab:CreateToggle({
	Name = "Mobile Shoot",
	Description = nil,
	CurrentValue = false,
    	Callback = function(val)
        MobileShootButtonEnabled = val 
    	end}, "UiMobile")

local Bind = MM2Tab:CreateBind({
	Name = "Keybind",
	Description = nil, 
	CurrentBind = "R",
	HoldToInteract = false, 
    	Callback = function(BindState)
        shoot()
    	end,
	OnChangedCallback = function(Bind) 
	end,
    }, "KeyShoot") 

local Input = MM2Tab:CreateInput({
	Name = "Shoot Offset",
	Description = nil,
	PlaceholderText = "2.8",
	CurrentValue = "2.8", 
	Numeric = true, 
	MaxCharacters = nil, 
	Enter = false, 
    	Callback = function(val) 
       local n = tonumber(val)
   	if n then shootOffset = n end
      end}, "Offset") 
      
local LabelESP = MM2Tab:CreateLabel({
	Text = "ESP",
	Style = 1
})

local Toggle2 = MM2Tab:CreateToggle({
	Name = "Enable",
	Description = nil,
	CurrentValue = false,
    	Callback = function(val)
       	 EspPlayer = val
	if not val then
		for _, p in ipairs(Players:GetPlayers()) do
			local c = p.Character
			if c and c:FindFirstChild("Highlight") then c.Highlight:Destroy() end
			local head = c and c:FindFirstChild("Head")
			if head and head:FindFirstChild("MurderTag") then head.MurderTag:Destroy() end
		end
	end
    	end}, "Esp")


local Slider = MM2Tab:CreateSlider({
	Name = "ESP Transparency",
	Range = {0, 100}, -- The Minimum And Maximum Values Respectively
	Increment = 5, 
	CurrentValue = 90, -- The Starting Value
    	Callback = function(val)
        ESPTransparency = val / 100
    	updatePlayerHighlights()
   	end}, "FillEsp") 

local Toggle3 = MM2Tab:CreateToggle({
	Name = "RoleNofication",
	Description = nil,
	CurrentValue = false,
    	Callback = function(val)
        RoleNotify = val
      	end}, "RoleNotification") 

local LabelMisc = MM2Tab:CreateLabel({
	Text = "Misc",
	Style = 1
})

local Toggle4 = MM2Tab:CreateToggle({
	Name = "Timer",
	Description = nil,
	CurrentValue = false,
    	Callback = function(val)
        	if timerGuiRef then timerGuiRef.Enabled = val end
    	end}, "Timer")

-- INIT
createTimer()
createMobileShootButton()

Window:CreateHomeTab({
	SupportedExecutors = {}, -- A Table Of Executors Your Script Supports. Add strings of the executor names for each executor.
	DiscordInvite = "", -- The Discord Invite Link. Do Not Include discord.gg/ | Only Include the code.
	Icon = 1, -- By Default, The Icon Is The Home Icon. If You would like to change it to dashboard, replace the interger with 2
})

SettingsTab:BuildThemeSection() -- Tab Should e the name of the tab you are adding this section to.
SettingsTab:BuildConfigSection() -- Tab Should be the name of the tab you are adding this section to.

task.spawn(function()
	while true do
		refreshPlayerData()
		updatePlayerHighlights()
		task.wait(1.5)
	end
end)
