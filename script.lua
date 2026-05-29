--[[
    K1TT3N - Rivals Cheat (Refactored)
    By: [Your Name/Alias]
    Version: 1.1
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

-- Local Player & Camera
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Settings Table
local Settings = {
    AimbotEnabled = true,
    Smoothness = 0.08, -- Lower value = faster, higher = smoother
    FOV = 150,         -- Field of View in degrees
    TeamCheck = true,  -- Check if the target is on your team
    ESPenabled = true,
    BoxESP = true,
    NameESP = true,
    HealthESP = true,
    TracerESP = true,
    SkeletonESP = true,
    MaxDistance = 1000, -- Max distance for ESP/Aimbot
    WallCheck = true,   -- Check if target is behind a wall (for Aimbot)
    MenuKey = Enum.KeyCode.RightShift, -- Key to toggle the menu
    AimbotKey = Enum.UserInputType.MouseButton2 -- Input type to activate aimbot (e.g., MouseButton2, Keyboard)
}

-- State Variables
local aiming = false
local currentTarget = nil
local espCache = {} -- Cache for player ESP elements
local connections = {} -- Store connections for cleanup
local isScriptActive = true -- Global flag to control script execution

-- Internal Utilities
local function GetMouseLocation()
    return UserInputService:GetMouseLocation()
end

-- Function to safely get a player's character and humanoid
local function GetPlayerCharacterAndHumanoid(player)
    local character = player.Character
    if not character then return nil, nil end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return character, nil end
    return character, humanoid
end

-- Function to get player's team or a default value
local function GetPlayerTeam(player)
    if not player or not player.Team then return nil end
    return player.Team.Name -- Assuming Team names are unique identifiers
end

-- Function to check if two players are enemies
local function IsEnemy(player1, player2)
    if not Settings.TeamCheck then return true end -- If team check is off, everyone is an enemy

    local team1 = GetPlayerTeam(player1)
    local team2 = GetPlayerTeam(player2)

    if not team1 or not team2 then return true end -- If teams aren't assigned, assume they are enemies
    return team1 ~= team2
end

-- Function to convert world position to screen position
local function WorldToScreen(worldPosition)
    local cam = Workspace.CurrentCamera
    if not cam then return nil end
    local success, screenPos = pcall(cam.WorldToScreenPoint, cam, worldPosition)
    if success and screenPos.Z > 0 then
        return Vector2.new(screenPos.X, screenPos.Y)
    else
        return nil
    end
end

-- Function to calculate distance between two Vector2 points
local function GetScreenDistance(p1, p2)
    return (p1 - p2).Magnitude
end

--[[
    =====================================================================
    KEY SYSTEM
    =====================================================================
]]
local _KEY_PARTS = {
    -- K1TT3N-2024-ACCESS
    part1 = {"K", "1", "T", "T", "3", "N"}, -- K1TT3N (using _0x6f, _0x5e, _0x7g, _0x9i, _0x7g, _0x9i --corrected)
    part2 = {"-", "2", "0", "2", "4"},      -- -2024
    part3 = {"-", "A", "C", "C", "E", "S", "S"} -- -ACCESS
}
local _CORRECT_HASH = 3948572910 -- Calculated hash for "K1TT3N-2024-ACCESS"

local function CalculateHash(str)
    local h = 0
    for i = 1, #str do
        h = ((h << 5) - h) + string.byte(str, i)
        h = h & 0xFFFFFFFF -- Ensure 32-bit integer
    end
    return h
end

local function ValidateKey(key)
    return CalculateHash(key) == _CORRECT_HASH
end

local function ReconstructKey()
    local key = ""
    for _, part in pairs(_KEY_PARTS) do
        for _, char in pairs(part) do
            key = key .. char
        end
    end
    return key
end

--[[
    =====================================================================
    NOTIFICATION SYSTEM
    =====================================================================
]]
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "K1TT3N_Notifications"
NotifGui.ResetOnSpawn = false -- Important for multiple notifications
NotifGui.Parent = game.CoreGui

local function ShowNotification(title, text, duration)
    if not isScriptActive then return end -- Don't show if script is inactive
    duration = duration or 3

    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 320, 0, 80)
    notifFrame.Position = UDim2.new(0.5, -160, 0, -100) -- Start off-screen top
    notifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = NotifGui

    local uiCorner = Instance.new("UICorner", notifFrame)
    uiCorner.CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", notifFrame)
    stroke.Color = Color3.fromRGB(0, 150, 255)
    stroke.Thickness = 1.5

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 28)
    titleLabel.Position = UDim2.new(0, 10, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notifFrame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 0, 35)
    textLabel.Position = UDim2.new(0, 10, 0, 38)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextWrapped = true
    textLabel.Parent = notifFrame

    -- Animate in
    TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -160, 0, 20)}):Play()

    -- Animate out after duration
    task.delay(duration, function()
        if not notifFrame or not notifFrame.Parent then return end -- Check if destroyed already
        local outTween = TweenService:Create(notifFrame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -160, 0, -100)})
        outTween:Play()
        outTween.Completed:Wait()
        if notifFrame then notifFrame:Destroy() end
    end)
end

--[[
    =====================================================================
    KEY GUI
    =====================================================================
]]
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "K1TT3N_KeySystem"
KeyGui.ResetOnSpawn = false
KeyGui.Parent = game.CoreGui

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 400, 0, 250)
KeyFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.Parent = KeyGui

Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)
local KeyStroke = Instance.new("UIStroke", KeyFrame)
KeyStroke.Color = Color3.fromRGB(0, 150, 255)
KeyStroke.Thickness = 2

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 50)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "K1TT3N"
KeyTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
KeyTitle.TextSize = 28
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Parent = KeyFrame

local KeySubtitle = Instance.new("TextLabel")
KeySubtitle.Size = UDim2.new(1, 0, 0, 30)
KeySubtitle.Position = UDim2.new(0, 0, 0, 45)
KeySubtitle.BackgroundTransparency = 1
KeySubtitle.Text = "Enter access key"
KeySubtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
KeySubtitle.TextSize = 14
KeySubtitle.Font = Enum.Font.Gotham
KeySubtitle.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0.8, 0, 0, 45)
KeyInput.Position = UDim2.new(0.1, 0, 0, 90)
KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 16
KeyInput.Font = Enum.Font.Gotham
KeyInput.PlaceholderText = "Enter key..."
KeyInput.ClearTextOnFocus = false
KeyInput.Parent = KeyFrame

Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 8)

local KeyStatus = Instance.new("TextLabel")
KeyStatus.Size = UDim2.new(0.8, 0, 0, 25)
KeyStatus.Position = UDim2.new(0.1, 0, 0, 145)
KeyStatus.BackgroundTransparency = 1
KeyStatus.Text = ""
KeyStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
KeyStatus.TextSize = 13
KeyStatus.Font = Enum.Font.Gotham
KeyStatus.Parent = KeyFrame

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0.8, 0, 0, 40)
SubmitBtn.Position = UDim2.new(0.1, 0, 0, 175)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SubmitBtn.Text = "SUBMIT"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.TextSize = 16
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.Parent = KeyFrame
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 8)

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(0.8, 0, 0, 30)
DiscordBtn.Position = UDim2.new(0.1, 0, 0, 220)
DiscordBtn.BackgroundTransparency = 1
DiscordBtn.Text = "Get Key from Discord"
DiscordBtn.TextColor3 = Color3.fromRGB(100, 150, 255)
DiscordBtn.TextSize = 12
DiscordBtn.Font = Enum.Font.Gotham
DiscordBtn.Parent = KeyFrame

-- Key validation logic
SubmitBtn.MouseButton1Click:Connect(function()
    local enteredKey = KeyInput.Text:gsub("%s+", "") -- Remove whitespace
    if ValidateKey(enteredKey) then
        KeyStatus.TextColor3 = Color3.fromRGB(50, 255, 50)
        KeyStatus.Text = "Access granted!"
        TweenService:Create(KeyFrame, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -200, 1.5, -125)}):Play() -- Move off-screen
        task.wait(0.6)
        KeyGui:Destroy()
        LoadMainScript() -- Load the actual cheat script
    else
        KeyStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
        KeyStatus.Text = "Invalid key!"
        KeyInput.Text = "" -- Clear input on failure
    end
end)

DiscordBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard("https://discord.gg/yourserver") -- !!! REPLACE WITH YOUR ACTUAL DISCORD INVITE !!!
        KeyStatus.TextColor3 = Color3.fromRGB(50, 255, 50)
        KeyStatus.Text = "Discord copied!"
    else
        KeyStatus.TextColor3 = Color3.fromRGB(255, 150, 0)
        KeyStatus.Text = "setclipboard unavailable."
    end
end)

--[[
    =====================================================================
    MAIN SCRIPT LOADER
    =====================================================================
]]
function LoadMainScript()
    ShowNotification("K1TT3N", "Loading...", 2)

    -- GUI Setup
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "K1TT3N_Main"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 280, 0, 480)
    MainFrame.Position = UDim2.new(0.02, 0, 0.15, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(0, 150, 255)
    MainStroke.Thickness = 2

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Title.Text = "K1TT3N"
    Title.TextColor3 = Color3.fromRGB(0, 200, 255)
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame
    Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

    -- Function to create toggle buttons
    local function CreateToggle(text, settingKey, yPos)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 32)
        btn.Position = UDim2.new(0.05, 0, 0, yPos)
        btn.BackgroundColor3 = Settings[settingKey] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        btn.Text = text .. ": " .. (Settings[settingKey] and "ON" or "OFF")
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Font = Enum.Font.Gotham
        btn.Parent = MainFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        btn.MouseButton1Click:Connect(function()
            if not isScriptActive then return end
            Settings[settingKey] = not Settings[settingKey]
            btn.BackgroundColor3 = Settings[settingKey] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
            btn.Text = text .. ": " .. (Settings[settingKey] and "ON" or "OFF")
            -- Special handling for FOV circle visibility
            if settingKey == "AimbotEnabled" then
                FOVCircle.Visible = Settings.AimbotEnabled and MainFrame.Visible -- Show/hide based on Aimbot toggle and Menu visibility
            end
        end)
        return btn
    end

    -- Create Toggles
    CreateToggle("Aimbot", "AimbotEnabled", 70)
    CreateToggle("ESP", "ESPenabled", 108)
    CreateToggle("Box ESP", "BoxESP", 146)
    CreateToggle("Name ESP", "NameESP", 184)
    CreateToggle("Health ESP", "HealthESP", 222)
    CreateToggle("Tracer ESP", "TracerESP", 260)
    CreateToggle("Skeleton ESP", "SkeletonESP", 298)

    -- FOV Slider (Example - needs more work for actual slider)
    local FOVLabel = Instance.new("TextLabel")
    FOVLabel.Size = UDim2.new(0.9, 0, 0, 25)
    FOVLabel.Position = UDim2.new(0.05, 0, 0, 336)
    FOVLabel.BackgroundTransparency = 1
    FOVLabel.Text = "FOV: " .. Settings.FOV
    FOVLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    FOVLabel.Font = Enum.Font.Gotham
    FOVLabel.Parent = MainFrame

    -- Placeholder for FOV Slider - you'd need to implement a slider UI element
    -- For now, we'll just display the value.
    -- Example: Add a TextButton to increase/decrease FOV for testing
    local FOVIncreaseBtn = Instance.new("TextButton")
    FOVIncreaseBtn.Size = UDim2.new(0.4, 0, 0, 25)
    FOVIncreaseBtn.Position = UDim2.new(0.55, 0, 0, 336)
    FOVIncreaseBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)
    FOVIncreaseBtn.Text = "+"
    FOVIncreaseBtn.TextColor3 = Color3.fromRGB(255,255,255)
    FOVIncreaseBtn.TextSize = 14
    FOVIncreaseBtn.Font = Enum.Font.GothamBold
    FOVIncreaseBtn.Parent = MainFrame
    Instance.new("UICorner", FOVIncreaseBtn).CornerRadius = UDim.new(0, 4)
    FOVIncreaseBtn.MouseButton1Click:Connect(function()
        Settings.FOV = math.min(Settings.FOV + 5, 360)
        FOVLabel.Text = "FOV: " .. Settings.FOV
        FOVCircle.Radius = Settings.FOV -- Update circle immediately
    end)

    local FOVDecreaseBtn = Instance.new("TextButton")
    FOVDecreaseBtn.Size = UDim2.new(0.1, 0, 0, 25)
    FOVDecreaseBtn.Position = UDim2.new(0.05, 0, 0, 336)
    FOVDecreaseBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)
    FOVDecreaseBtn.Text = "-"
    FOVDecreaseBtn.TextColor3 = Color3.fromRGB(255,255,255)
    FOVDecreaseBtn.TextSize = 14
    FOVDecreaseBtn.Font = Enum.Font.GothamBold
    FOVDecreaseBtn.Parent = MainFrame
    Instance.new("UICorner", FOVDecreaseBtn).CornerRadius = UDim.new(0, 4)
    FOVDecreaseBtn.MouseButton1Click:Connect(function()
        Settings.FOV = math.max(Settings.FOV - 5, 10)
        FOVLabel.Text = "FOV: " .. Settings.FOV
        FOVCircle.Radius = Settings.FOV -- Update circle immediately
    end)


    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0.9, 0, 0, 35)
    CloseButton.Position = UDim2.new(0.05, 0, 0, 425)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    CloseButton.Text = "CLOSE / UNLOAD"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = MainFrame
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 6)

    -- FOV Circle Drawing (Using Drawing API)
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1.5
    FOVCircle.NumSides = 64
    FOVCircle.Radius = Settings.FOV
    FOVCircle.Filled = false
    FOVCircle.Color = Color3.fromRGB(255, 255, 255)
    FOVCircle.Visible = Settings.AimbotEnabled and MainFrame.Visible -- Initially visible if aimbot is on and menu is open

    -- Function to clean up all drawings for a player
    local function CleanupPlayerDrawings(player)
        if espCache[player] then
            -- Safely remove drawings
            for _, drawing in pairs(espCache[player]) do
                if drawing and drawing.Remove then
                    pcall(drawing.Remove)
                end
            end
            espCache[player] = nil
        end
    end

    -- Function to get character stats (health, max health) more robustly
    local function GetCharacterStats(character)
        local hp = 100
        local maxHp = 100

        -- Try Attributes first (modern approach)
        if character:GetAttribute("Health") ~= nil then hp = character:GetAttribute("Health") end
        if character:GetAttribute("MaxHealth") ~= nil then maxHp = character:GetAttribute("MaxHealth") end

        -- Fallback to Humanoid
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            hp = humanoid.Health
            maxHp = humanoid.MaxHealth
        end

        -- Fallback to Value objects (older method)
        local statsFolder = character:FindFirstChild("Stats")
        if statsFolder then
            local hpVal = statsFolder:FindFirstChild("Health") or statsFolder:FindFirstChild("HP")
            if hpVal and hpVal:IsA("ValueBase") then hp = hpVal.Value end
            local maxVal = statsFolder:FindFirstChild("MaxHealth") or statsFolder:FindFirstChild("MaxHP")
            if maxVal and maxVal:IsA("ValueBase") then maxHp = maxVal.Value end
        end

        return hp, maxHp
    end

    -- Function to get the primary aiming part (Head is best)
    local function GetAimPart(character)
        local head = character:FindFirstChild("Head")
        if head then return head end

        local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
        if torso then return torso end

        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then return hrp end

        return nil -- No suitable part found
    end

    -- Function to get the root part for ESP positioning
    local function GetRootPart(character)
        return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    end

    -- Function to get skeleton bone connections
    local function GetSkeletonBones()
        -- Define bone connections (adjust if character rig is different)
        -- Format: {ParentBoneName, ChildBoneName}
        return {
            {"Head", "Neck"}, {"Neck", "Torso"}, -- Head structure
            {"Torso", "LeftShoulder"}, {"LeftShoulder", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"}, -- Left Arm
            {"Torso", "RightShoulder"}, {"RightShoulder", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"}, -- Right Arm
            {"Torso", "LeftHip"}, {"LeftHip", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"}, -- Left Leg
            {"Torso", "RightHip"}, {"RightHip", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"} -- Right Leg
        }
    end
    local skeletonBoneConnections = GetSkeletonBones()

    -- Main Render Loop (ESP and Aimbot logic)
    table.insert(connections, RunService.RenderStepped:Connect(function()
        if not isScriptActive then return end

        local mousePos = GetMouseLocation()
        Camera = Workspace.CurrentCamera -- Ensure camera is updated

        -- Update FOV Circle position and visibility
        FOVCircle.Position = mousePos
        FOVCircle.Radius = Settings.FOV
        FOVCircle.Visible = Settings.AimbotEnabled and MainFrame.Visible and not aiming -- Show only when aimbot is enabled and menu is visible, and not actively aiming

        -- Aimbot Targeting
        if aiming and Settings.AimbotEnabled then
            local bestTarget = nil
            local minScreenDist = Settings.FOV -- Use FOV as initial max distance on screen

            -- Find the closest enemy within FOV
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and IsEnemy(player, LocalPlayer) then
                    local character, humanoid = GetPlayerCharacterAndHumanoid(player)
                    if character and humanoid and humanoid.Health > 0 then
                        local aimPart = GetAimPart(character)
                        if aimPart then
                            local screenPos = WorldToScreen(aimPart.Position)
                            if screenPos then
                                local screenDist = GetScreenDistance(mousePos, screenPos)

                                -- Wall Check (using Raycast)
                                local isVisible = true
                                if Settings.WallCheck then
                                    local rayParams = RaycastParams.new()
                                    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, character}
                                    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                                    local direction = (aimPart.Position - Camera.CFrame.Position).Unit * Settings.MaxDistance
                                    local raycastResult = Workspace:Raycast(Camera.CFrame.Position, direction, rayParams)

                                    if raycastResult and not raycastResult.Instance:IsDescendantOf(character) then
                                        isVisible = false -- Hit something before the target
                                    end
                                end

                                if screenDist < minScreenDist and isVisible then
                                    minScreenDist = screenDist
                                    bestTarget = player -- Store the player object
                                end
                            end
                        end
                    end
                end
            end

            currentTarget = bestTarget -- Update the target

            -- Aiming Logic
            if currentTarget then
                local targetChar = currentTarget.Character
                local aimPart = GetAimPart(targetChar)
                if aimPart then
                    local aimPos = aimPart.Position
                    local camPos = Camera.CFrame.Position
                    local lookVector = (aimPos - camPos).Unit
                    local targetCF = CFrame.new(camPos, camPos + lookVector)

                    -- Smooth Aiming
                    Camera.CFrame = Camera.CFrame:Lerp(targetCF, Settings.Smoothness)
                else
                    currentTarget = nil -- Target lost its aim part
                end
            end
        else
            currentTarget = nil -- Clear target if not aiming
        end

        -- ESP Logic
        if Settings.ESPenabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and IsEnemy(player, LocalPlayer) then
                    local character, humanoid = GetPlayerCharacterAndHumanoid(player)

                    if character and humanoid and humanoid.Health > 0 then
                        local rootPart = GetRootPart(character)
                        local aimPart = GetAimPart(character) -- Using aim part for screen position

                        if rootPart and aimPart then
                            local screenPos = WorldToScreen(aimPart.Position)
                            local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude

                            if screenPos and distance <= Settings.MaxDistance then
                                -- Ensure cache entry exists
                                if not espCache[player] then
                                    espCache[player] = {}
                                end
                                local cache = espCache[player]

                                -- Get player color (team color)
                                local playerColor = player.TeamColor and player.TeamColor.Color or Color3.fromRGB(255, 50, 50) -- Default Red

                                -- Update or Create Drawings
                                local hp, maxHp = GetCharacterStats(character)
                                local hpRatio = math.clamp(hp / maxHp, 0, 1)
                                local healthColor = Color3.fromRGB(255 * (1 - hpRatio), 255 * hpRatio, 0) -- Green to Red

                                -- Box ESP
                                if Settings.BoxESP then
                                    local boxSize = Vector2.new(60, 100) -- Adjust these values
                                    local boxOffset = Vector2.new(boxSize.X / 2, boxSize.Y * 0.6) -- Offset to center base
                                    local boxPos = screenPos - boxOffset

                                    if not cache.Box then cache.Box = Drawing.new("Square") end
                                    cache.Box.Size = boxSize
                                    cache.Box.Position = boxPos
                                    cache.Box.Color = playerColor
                                    cache.Box.Visible = true
                                    cache.Box.Thickness = 1

                                    if not cache.BoxOutline then cache.BoxOutline = Drawing.new("Square") end
                                    cache.BoxOutline.Size = boxSize + Vector2.new(4, 4) -- Slightly larger for outline
                                    cache.BoxOutline.Position = boxPos - Vector2.new(2, 2)
                                    cache.BoxOutline.Color = Color3.fromRGB(0, 0, 0) -- Black outline
                                    cache.BoxOutline.Visible = true
                                    cache.BoxOutline.Thickness = 3
                                else
                                    if cache.Box then cache.Box.Visible = false end
                                    if cache.BoxOutline then cache.BoxOutline.Visible = false end
                                end

                                -- Name & Health ESP
                                if Settings.NameESP or Settings.HealthESP then
                                    local textYOffset = -60 -- Adjust as needed
                                    local textPos = Vector2.new(screenPos.X, screenPos.Y + textYOffset)

                                    local nameText = player.Name .. " [" .. math.floor(hp) .. " HP]"
                                    if not cache.Name then cache.Name = Drawing.new("Text") end
                                    cache.Name.Position = textPos
                                    cache.Name.Text = nameText
                                    cache.Name.Color = playerColor
                                    cache.Name.Size = 14
                                    cache.Name.Center = true
                                    cache.Name.Outline = true
                                    cache.Name.OutlineColor = Color3.fromRGB(0,0,0)
                                    cache.Name.Visible = Settings.NameESP

                                    -- Health Bar
                                    if Settings.HealthESP then
                                        local barWidth = 40
                                        local barHeight = 6
                                        local barOffset = Vector2.new(barWidth / 2, barHeight / 2)
                                        local barPos = Vector2.new(screenPos.X - barOffset.X, screenPos.Y - 40 - barOffset.Y) -- Position above name

                                        if not cache.HealthBg then cache.HealthBg = Drawing.new("Square") end
                                        cache.HealthBg.Size = Vector2.new(barWidth, barHeight)
                                        cache.HealthBg.Position = barPos
                                        cache.HealthBg.Color = Color3.fromRGB(50, 50, 50) -- Background
                                        cache.HealthBg.Visible = true
                                        cache.HealthBg.Filled = true

                                        if not cache.HealthBar then cache.HealthBar = Drawing.new("Square") end
                                        cache.HealthBar.Size = Vector2.new(barWidth * hpRatio, barHeight)
                                        cache.HealthBar.Position = Vector2.new(barPos.X, barPos.Y)
                                        cache.HealthBar.Color = healthColor
                                        cache.HealthBar.Visible = true
                                        cache.HealthBar.Filled = true
                                    else
                                        if cache.HealthBar then cache.HealthBar.Visible = false end
                                        if cache.HealthBg then cache.HealthBg.Visible = false end
                                    end
                                else
                                    if cache.Name then cache.Name.Visible = false end
                                    if cache.HealthBar then cache.HealthBar.Visible = false end
                                    if cache.HealthBg then cache.HealthBg.Visible = false end
                                end

                                -- Tracer ESP
                                if Settings.TracerESP then
                                    if not cache.Tracer then cache.Tracer = Drawing.new("Line") end
                                    cache.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y) -- Bottom center of screen
                                    cache.Tracer.To = screenPos
                                    cache.Tracer.Color = playerColor
                                    cache.Tracer.Thickness = 1.5
                                    cache.Tracer.Visible = true
                                else
                                    if cache.Tracer then cache.Tracer.Visible = false end
                                end

                                -- Skeleton ESP
                                if Settings.SkeletonESP then
                                    if not cache.SkeletonLines then cache.SkeletonLines = {} end
                                    local boneIndex = 1
                                    for _, bonePair in pairs(skeletonBoneConnections) do
                                        local part1 = character:FindFirstChild(bonePair[1])
                                        local part2 = character:FindFirstChild(bonePair[2])

                                        if part1 and part2 then
                                            local pos1, vis1 = WorldToScreen(part1.Position)
                                            local pos2, vis2 = WorldToScreen(part2.Position)

                                            if pos1 and pos2 and vis1 and vis2 then
                                                if not cache.SkeletonLines[boneIndex] then
                                                    cache.SkeletonLines[boneIndex] = Drawing.new("Line")
                                                    cache.SkeletonLines[boneIndex].Thickness = 1.5
                                                end
                                                cache.SkeletonLines[boneIndex].From = pos1
                                                cache.SkeletonLines[boneIndex].To = pos2
                                                cache.SkeletonLines[boneIndex].Color = playerColor
                                                cache.SkeletonLines[boneIndex].Visible = true
                                                boneIndex = boneIndex + 1
                                            end
                                        end
                                    end
                                    -- Hide unused skeleton lines
                                    for i = boneIndex, #cache.SkeletonLines do
                                        if cache.SkeletonLines[i] then cache.SkeletonLines[i].Visible = false end
                                    end
                                else
                                    if cache.SkeletonLines then
                                        for _, line in pairs(cache.SkeletonLines) do
                                            if line then line.Visible = false end
                                        end
                                    end
                                end

                            else
                                -- Player out of range or not on screen, hide their ESP
                                CleanupPlayerDrawings(player)
                            end
                        else
                            -- Missing crucial parts, hide ESP
                            CleanupPlayerDrawings(player)
                        end
                    else
                        -- Player is dead or character not found, hide ESP
                        CleanupPlayerDrawings(player)
                    end
                else
                    -- Player is not an enemy or is LocalPlayer, hide their ESP
                    CleanupPlayerDrawings(player)
                end
            end
        end

        -- Cleanup drawings for players who have left the game
        local currentPlayers = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                currentPlayers[player] = true
            end
        end
        for player, _ in pairs(espCache) do
            if not currentPlayers[player] then
                CleanupPlayerDrawings(player)
            end
        end

    end))

    -- Input Handling
    table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end -- Ignore if Roblox processed the input (e.g., typing in chat)

        -- Toggle Menu
        if input.KeyCode == Settings.MenuKey then
            MainFrame.Visible = not MainFrame.Visible
            FOVCircle.Visible = Settings.AimbotEnabled and MainFrame.Visible -- Update FOV visibility when menu is toggled
        end

        -- Handle Aimbot Activation (using InputType)
        if Settings.AimbotEnabled and input.UserInputType == Settings.AimbotKey then
            aiming = true
        end
    end))

    table.insert(connections, UserInputService.InputEnded:Connect(function(input)
        -- Handle Aimbot Deactivation
        if Settings.AimbotEnabled and input.UserInputType == Settings.AimbotKey then
            aiming = false
            currentTarget = nil -- Clear target when aimbot is released
        end
    end))

    -- Cleanup function when script is unloaded
    CloseButton.MouseButton1Click:Connect(function()
        isScriptActive = false -- Stop loops and further actions

        -- Disconnect all connections
        for _, conn in pairs(connections) do
            pcall(conn.Disconnect, conn)
        end
        connections = {} -- Clear the table

        -- Remove all drawings
        FOVCircle:Remove()
        for _, playerCache in pairs(espCache) do
            for _, drawing in pairs(playerCache) do
                if drawing and drawing.Remove then
                    pcall(drawing.Remove)
                end
            end
        end
        espCache = {}

        -- Destroy GUI elements
        if ScreenGui then ScreenGui:Destroy() end
        if NotifGui then NotifGui:Destroy() end -- Destroy notifications too

        ShowNotification("K1TT3N", "Unloaded successfully!", 3)
        task.wait(1) -- Give time for notification to show before potential executor cleanup
    end)

    ShowNotification("K1TT3N", "Script loaded!", 5)
end

--[[
    =====================================================================
    INITIALIZATION
    =====================================================================
]]
-- Pre-calculate key parts for the Key System (optional, for clarity)
-- Ensure this matches your desired key: K1TT3N-2024-ACCESS
_KEY_PARTS.part1 = {"K", "1", "T", "T", "3", "N"} -- K1TT3N (Corrected from your original)
_KEY_PARTS.part2 = {"-", "2", "0", "2", "4"}      -- -2024
_KEY_PARTS.part3 = {"-", "A", "C", "C", "E", "S", "S"} -- -ACCESS

-- Attempt to load the script immediately if the key is valid (useful for testing without the GUI)
-- Remove or comment this out if you always want the key GUI to show first
-- if ValidateKey(ReconstructKey()) then
--     LoadMainScript()
-- else
--     print("K1TT3N: Key validation failed during initial load.")
-- end

print("K1TT3N Loader Initialized. Waiting for key input...")

-- If the key GUI doesn't appear, it means either the KeyGui setup failed,
-- or the script itself didn't fully execute before Roblox reset it.
-- Ensure your executor isn't clearing the script environment.
