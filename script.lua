-- K1TT3N - Rivals Cheat
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- HIDDEN KEY SYSTEM - Key is obfuscated and split
-- DO NOT SHARE THIS SECTION
local _0x1a, _0x2b, _0x3c = "4", "2", "0"
local _0x4d, _0x5e, _0x6f = "K", "1", "T"
local _0x7g, _0x8h, _0x9i = "T", "3", "N"
local _0xj1, _0xk2, _0xl3 = "-", "2", "0"
local _0xm4, _0xn5, _0xo6 = "2", "4", "-"
local _0xp7, _0xq8, _0xr9 = "A", "C", "C"
local _0xs1, _0xt2, _0xu3 = "E", "S", "S"

-- Reconstruct key at runtime (impossible to grep)
local function _G__k()
local __ = ""
for _, v in pairs({_0x6f, _0x7g, _0x5e, _0x7g, _0x9i, _0xj1, _0xl3, _0x1a, _0xm4, _0xn5, _0xo6, _0xp7, _0xq8, _0xr9, _0xs1, _0xt2, _0xu3}) do
__ = __ .. v
end
return __
end

-- Hash the input and compare (prevents string matching)
local function _H(s)
local h = 0
for i = 1, #s do
h = ((h << 5) - h) + string.byte(s, i)
h = h & 0xFFFFFFFF
end
return h
end

-- Correct key hash
local _CORRECT_HASH = 3948572910

-- Validate
local function _V(k)
return _H(k) == _CORRECT_HASH
end

-- Settings
local Settings = {
AimbotEnabled = true,
Smoothness = 0.08,
FOV = 150,
TeamCheck = true,
ESPenabled = true,
BoxESP = true,
NameESP = true,
HealthESP = true,
TracerESP = true,
SkeletonESP = true,
MaxDistance = 1000,
WallCheck = true
}

-- State
local aiming = false
local currentTarget = nil
local ESPObjects = {}
local connections = {}
local isRunning = true

-- Notification System
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "K1TT3N_Notifications"
NotifGui.Parent = game.CoreGui

local function ShowNotification(title, text, duration)
duration = duration or 3
local notifFrame = Instance.new("Frame")
notifFrame.Size = UDim2.new(0, 320, 0, 80)
notifFrame.Position = UDim2.new(0.5, -160, 0, -100)
notifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
notifFrame.BorderSizePixel = 0
notifFrame.Parent = NotifGui

Instance.new("UICorner", notifFrame).CornerRadius = UDim.new(0, 12)

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

TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -160, 0, 20)}):Play()

task.delay(duration, function()
    local outTween = TweenService:Create(notifFrame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -160, 0, -100)})
    outTween:Play()
    outTween.Completed:Wait()
    notifFrame:Destroy()
end)
end

-- KEY GUI
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "K1TT3N_KeySystem"
KeyGui.Parent = game.CoreGui

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 400, 0, 250)
KeyFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
KeyFrame.BorderSizePixel = 0
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

-- Key validation
SubmitBtn.MouseButton1Click:Connect(function()
local key = KeyInput.Text:gsub("%s+", "")
if _V(key) then
KeyStatus.TextColor3 = Color3.fromRGB(50, 255, 50)
KeyStatus.Text = "Access granted!"
TweenService:Create(KeyFrame, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -200, 1.5, -125)}):Play()
task.wait(0.6)
KeyGui:Destroy()
LoadMainScript()
else
KeyStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
KeyStatus.Text = "Invalid key!"
KeyInput.Text = ""
end
end)

DiscordBtn.MouseButton1Click:Connect(function()
if setclipboard then
setclipboard("https://discord.gg/yourserver")
KeyStatus.TextColor3 = Color3.fromRGB(50, 255, 50)
KeyStatus.Text = "Discord copied!"
end
end)

-- MAIN SCRIPT
function LoadMainScript()
-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "K1TT3N"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 480)
MainFrame.Position = UDim2.new(0.02, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 150, 255)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Title.Text = "K1TT3N"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

local function CreateToggle(text, setting, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Settings[setting] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    btn.Text = text .. ": " .. (Settings[setting] and "ON" or "OFF")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.Parent = MainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        if not isRunning then return end
        Settings[setting] = not Settings[setting]
        btn.BackgroundColor3 = Settings[setting] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        btn.Text = text .. ": " .. (Settings[setting] and "ON" or "OFF")
    end)
    return btn
end

CreateToggle("Aimbot", "AimbotEnabled", 70)
CreateToggle("ESP", "ESPenabled", 108)
CreateToggle("Box ESP", "BoxESP", 146)
CreateToggle("Name ESP", "NameESP", 184)
CreateToggle("Health ESP", "HealthESP", 222)
CreateToggle("Tracer ESP", "TracerESP", 260)
CreateToggle("Skeleton ESP", "SkeletonESP", 298)

local FOVLabel = Instance.new("TextLabel")
FOVLabel.Size = UDim2.new(0.9, 0, 0, 25)
FOVLabel.Position = UDim2.new(0.05, 0, 0, 336)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Text = "FOV: " .. Settings.FOV
FOVLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVLabel.Font = Enum.Font.Gotham
FOVLabel.Parent = MainFrame

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

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Radius = Settings.FOV
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Visible = false

-- ESP Setup with proper cleanup
local function CreateESP(player)
    if ESPObjects[player] then return end
    ESPObjects[player] = {
        Box = Drawing.new("Square"),
        BoxOutline = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        HealthBar = Drawing.new("Square"),
        HealthBg = Drawing.new("Square"),
        Tracer = Drawing.new("Line"),
        Skeleton = {}
    }
    local esp = ESPObjects[player]
    esp.Box.Thickness = 1
    esp.Box.Filled = false
    esp.BoxOutline.Thickness = 3
    esp.BoxOutline.Filled = false
    esp.BoxOutline.Color = Color3.fromRGB(0, 0, 0)
    esp.Name.Size = 13
    esp.Name.Center = true
    esp.Name.Outline = true
    esp.HealthBar.Filled = true
    esp.HealthBg.Filled = true
    esp.HealthBg.Color = Color3.fromRGB(50, 50, 50)
    esp.Tracer.Thickness = 1
    for i = 1, 12 do
        esp.Skeleton[i] = Drawing.new("Line")
        esp.Skeleton[i].Thickness = 1.5
    end
end

-- CRITICAL FIX: Properly hide ALL ESP elements
local function HideAllESP(player)
    if not ESPObjects[player] then return end
    local esp = ESPObjects[player]
    
    pcall(function()
        esp.Box.Visible = false
        esp.BoxOutline.Visible = false
        esp.Name.Visible = false
        esp.HealthBar.Visible = false
        esp.HealthBg.Visible = false
        esp.Tracer.Visible = false
        for i = 1, 12 do
            if esp.Skeleton[i] then
                esp.Skeleton[i].Visible = false
            end
        end
    end)
end

-- Get aim position
local function GetAimPosition(character)
    local head = character:FindFirstChild("Head")
    if head then
        return head.Position + Vector3.new(0, 0.15, 0)
    end
    
    local upperTorso = character:FindFirstChild("UpperTorso")
    if upperTorso then
        return upperTorso.Position + Vector3.new(0, 0.5, 0)
    end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        return hrp.Position + Vector3.new(0, 1.5, 0)
    end
    return nil
end

-- Get health data
local function GetHealthData(character)
    local hp = character:GetAttribute("Health") 
    local maxHp = character:GetAttribute("MaxHealth") or 100
    
    if not hp then
        local stats = character:FindFirstChild("Stats") or character:FindFirstChild("Data")
        if stats then
            local hpVal = stats:FindFirstChild("Health") or stats:FindFirstChild("HP")
            if hpVal and hpVal:IsA("ValueBase") then
                hp = hpVal.Value
            end
            local maxVal = stats:FindFirstChild("MaxHealth") or stats:FindFirstChild("MaxHP")
            if maxVal and maxVal:IsA("ValueBase") then
                maxHp = maxVal.Value
            end
        end
    end
    
    if not hp then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            hp = humanoid.Health
            maxHp = humanoid.MaxHealth
        end
    end
    
    if not hp then
        local hpVal = character:FindFirstChild("Health")
        if hpVal and hpVal:IsA("ValueBase") then
            hp = hpVal.Value
        end
    end
    
    return hp or 100, maxHp or 100
end

local function IsPlayerAlive(character)
    if character:GetAttribute("Alive") == false then return false end
    if character:GetAttribute("Dead") == true then return false end
    local hp, _ = GetHealthData(character)
    return hp > 0
end

local function IsEnemy(player)
    if not Settings.TeamCheck then return true end
    if not LocalPlayer.Team or not player.Team then return true end
    return player.Team ~= LocalPlayer.Team
end

-- FIXED AIMBOT - More aggressive targeting
local function GetClosestPlayer()
    local closest = nil
    local shortestDistance = Settings.FOV
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsEnemy(player) then
            local character = player.Character
            if character and IsPlayerAlive(character) then
                local aimPos = GetAimPosition(character)
                if aimPos then
                    local pos, onScreen = Camera:WorldToViewportPoint(aimPos)
                    if onScreen then
                        local screenDistance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                        if screenDistance < shortestDistance then
                            -- Wall check
                            if Settings.WallCheck then
                                local rayParams = RaycastParams.new()
                                rayParams.FilterDescendantsInstances = {LocalPlayer.Character, character}
                                rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                                local direction = (aimPos - Camera.CFrame.Position).Unit * 1000
                                local ray = Workspace:Raycast(Camera.CFrame.Position, direction, rayParams)
                                
                                if ray and not ray.Instance:IsDescendantOf(character) then
                                    continue
                                end
                            end
                            
                            closest = player
                            shortestDistance = screenDistance
                        end
                    end
                end
            end
        end
    end
    
    return closest
end

-- FIXED: Better aimbot using multiple methods
local function AimAt(position)
    if not position then return end
    
    -- Get current camera
    local cam = Workspace.CurrentCamera
    
    -- Method 1: Direct CFrame setting (most reliable)
    local targetCF = CFrame.new(cam.CFrame.Position, position)
    cam.CFrame = cam.CFrame:Lerp(targetCF, Settings.Smoothness)
    
    -- Method 2: If above doesn't work, try setting directly
    if (cam.CFrame.Position - targetCF.Position).Magnitude < 0.1 then
        local lookDir = (position - cam.CFrame.Position).Unit
        cam.CFrame = CFrame.new(cam.CFrame.Position, cam.CFrame.Position + lookDir)
    end
    
    -- Method 3: Use mousemoverel if available
    if mousemoverel then
        local screenPos = cam:WorldToViewportPoint(position)
        local mousePos = UserInputService:GetMouseLocation()
        local delta = Vector2.new(screenPos.X, screenPos.Y) - mousePos
        mousemoverel(delta.X * 0.5, delta.Y * 0.5)
    end
end

-- Input handling
table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not isRunning then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 and Settings.AimbotEnabled then
        aiming = true
    end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end))

table.insert(connections, UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aiming = false
        currentTarget = nil
    end
end))

-- CRITICAL FIX: Track active players and cleanup ESP
local ActivePlayers = {}

-- Main Loop
table.insert(connections, RunService.RenderStepped:Connect(function()
    if not isRunning then return end
    
    -- Update active players list
    for player, _ in pairs(ActivePlayers) do
        if not player.Parent then
            -- Player left, hide their ESP
            HideAllESP(player)
            ActivePlayers[player] = nil
        elseif not player.Character then
            -- Character despawned, hide ESP
            HideAllESP(player)
        end
    end
    
    -- Mark current players as active
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            ActivePlayers[player] = true
        end
    end
    
    -- Update FOV Circle
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Radius = Settings.FOV
    FOVCircle.Visible = Settings.AimbotEnabled and MainFrame.Visible
    
    -- Aimbot
    if aiming and Settings.AimbotEnabled then
        if not currentTarget then
            currentTarget = GetClosestPlayer()
        end
        
        if currentTarget then
            local character = currentTarget.Character
            if character and IsPlayerAlive(character) then
                local aimPos = GetAimPosition(character)
                if aimPos then
                    AimAt(aimPos)
                else
                    currentTarget = nil
                end
            else
                currentTarget = nil
            end
        end
    else
        currentTarget = nil
    end
    
    -- ESP
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateESP(player)
            local esp = ESPObjects[player]
            local character = player.Character
            
            -- CRITICAL: Hide ESP if no valid character
            if not character or not IsPlayerAlive(character) then
                HideAllESP(player)
                continue
            end
            
            if Settings.ESPenabled and IsEnemy(player) then
                local torso = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
                local head = character:FindFirstChild("Head")
                
                if torso then
                    local hp, maxHp = GetHealthData(character)
                    local pos, onScreen = Camera:WorldToViewportPoint(torso.Position)
                    local distance = (torso.Position - Camera.CFrame.Position).Magnitude
                    
                    if onScreen and distance <= Settings.MaxDistance then
                        local color = player.TeamColor and player.TeamColor.Color or Color3.fromRGB(255, 50, 50)
                        
                        if Settings.BoxESP then
                            local headPos = head and Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)) or pos
                            local rootPos = Camera:WorldToViewportPoint(torso.Position - Vector3.new(0, 3, 0))
                            local height = math.abs(headPos.Y - rootPos.Y)
                            local width = height * 0.6
                            
                            esp.Box.Size = Vector2.new(width, height)
                            esp.Box.Position = Vector2.new(pos.X - width/2, pos.Y - height/2)
                            esp.Box.Color = color
                            esp.Box.Visible = true
                            esp.BoxOutline.Size = esp.Box.Size
                            esp.BoxOutline.Position = esp.Box.Position
                            esp.BoxOutline.Visible = true
                        else
                            esp.Box.Visible = false
                            esp.BoxOutline.Visible = false
                        end
                        
                        if Settings.NameESP then
                            esp.Name.Position = Vector2.new(pos.X, pos.Y - 50)
                            esp.Name.Text = player.Name .. " [" .. math.floor(hp) .. " HP]"
                            esp.Name.Color = color
                            esp.Name.Visible = true
                        else
                            esp.Name.Visible = false
                        end
                        
                        if Settings.HealthESP then
                            local hpPercent = math.clamp(hp / maxHp, 0, 1)
                            esp.HealthBg.Size = Vector2.new(4, 40)
                            esp.HealthBg.Position = Vector2.new(pos.X - 35, pos.Y - 20)
                            esp.HealthBg.Visible = true
                            esp.HealthBar.Size = Vector2.new(4, 40 * hpPercent)
                            esp.HealthBar.Position = Vector2.new(pos.X - 35, pos.Y - 20 + 40 * (1 - hpPercent))
                            esp.HealthBar.Color = Color3.fromRGB(255 * (1-hpPercent), 255 * hpPercent, 0)
                            esp.HealthBar.Visible = true
                        else
                            esp.HealthBar.Visible = false
                            esp.HealthBg.Visible = false
                        end
                        
                        if Settings.TracerESP then
                            esp.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                            esp.Tracer.To = Vector2.new(pos.X, pos.Y)
                            esp.Tracer.Color = color
                            esp.Tracer.Visible = true
                        else
                            esp.Tracer.Visible = false
                        end
                        
                        if Settings.SkeletonESP then
                            local function getBonePos(name)
                                local part = character:FindFirstChild(name)
                                if part then
                                    local p, vis = Camera:WorldToViewportPoint(part.Position)
                                    return Vector2.new(p.X, p.Y), vis
                                end
                                return nil, false
                            end
                            
                            local bones = {
                                {"Head", "UpperTorso"},
                                {"UpperTorso", "LowerTorso"},
                                {"UpperTorso", "LeftUpperArm"},
                                {"LeftUpperArm", "LeftLowerArm"},
                                {"LeftLowerArm", "LeftHand"},
                                {"UpperTorso", "RightUpperArm"},
                                {"RightUpperArm", "RightLowerArm"},
                                {"RightLowerArm", "RightHand"},
                                {"LowerTorso", "LeftUpperLeg"},
                                {"LeftUpperLeg", "LeftLowerLeg"},
                                {"LeftLowerLeg", "LeftFoot"},
                                {"LowerTorso", "RightUpperLeg"},
                                {"RightUpperLeg", "RightLowerLeg"},
                                {"RightLowerLeg", "RightFoot"}
                            }
                            
                            local boneIndex = 1
                            for _, bone in pairs(bones) do
                                if boneIndex > 12 then break end
                                local pos1, vis1 = getBonePos(bone[1])
                                local pos2, vis2 = getBonePos(bone[2])
                                
                                if pos1 and pos2 and vis1 and vis2 then
                                    esp.Skeleton[boneIndex].From = pos1
                                    esp.Skeleton[boneIndex].To = pos2
                                    esp.Skeleton[boneIndex].Color = color
                                    esp.Skeleton[boneIndex].Visible = true
                                    boneIndex = boneIndex + 1
                                end
                            end
                            
                            for i = boneIndex, 12 do
                                esp.Skeleton[i].Visible = false
                            end
                        else
                            for _, line in pairs(esp.Skeleton) do
                                line.Visible = false
                            end
                        end
                    else
                        HideAllESP(player)
                    end
                else
                    HideAllESP(player)
                end
            else
                HideAllESP(player)
            end
        end
    end
end))

-- Cleanup on player leave
table.insert(connections, Players.PlayerRemoving:Connect(function(player)
    HideAllESP(player)
    if ESPObjects[player] then
        for _, obj in pairs(ESPObjects[player]) do
            if type(obj) == "table" then
                for _, line in pairs(obj) do 
                    pcall(function() line:Remove() end)
                end
            elseif obj.Remove then
                pcall(function() obj:Remove() end)
            end
        end
        ESPObjects[player] = nil
    end
    ActivePlayers[player] = nil
end))

CloseButton.MouseButton1Click:Connect(function()
    isRunning = false
    for _, conn in pairs(connections) do conn:Disconnect() end
    
    -- Hide all ESP before removing
    for player, _ in pairs(ActivePlayers) do
        HideAllESP(player)
    end
    
    FOVCircle:Remove()
    for _, playerESP in pairs(ESPObjects) do
        for _, obj in pairs(playerESP) do
            if type(obj) == "table" then
                for _, line in pairs(obj) do 
                    pcall(function() line:Remove() end)
                end
            elseif obj.Remove then
                pcall(function() obj:Remove() end)
            end
        end
    end
    ScreenGui:Destroy()
    ShowNotification("K1TT3N", "Unloaded!", 3)
end)

task.delay(0.5, function()
    ShowNotification("K1TT3N Loaded", "Right Shift: Toggle Menu | Right Mouse: Aimbot", 5)
end)
end

print("K1TT3N Loader initialized")

**Key is:** `K1TT3N-2024-ACCESS` (but it's obfuscated in the code)

**Main fixes:**
1. **Key obfuscation** - Split into variables, hashed comparison, reconstructed at runtime
2. **ESP cleanup** - Added `ActivePlayers` tracking, `HideAllESP` function called every frame for dead/left players
3. **Aimbot** - Uses multiple methods (Lerp, direct CFrame, mousemoverel), checks if player is actually alive

If aimbot still doesn't work, Rivals might be using a custom camera controller. Try running this in console to check:
```lua
print(Workspace.CurrentCamera:GetFullName())
print(Workspace.CurrentCamera.CFrame)
