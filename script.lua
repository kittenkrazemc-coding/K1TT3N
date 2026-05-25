-- K1TT3N - Rivals Cheat
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Settings
local Settings = {
AimbotEnabled = true,
Smoothness = 0.15,
FOV = 150,
TeamCheck = true,
ESPenabled = true,
BoxESP = true,
NameESP = true,
HealthESP = true,
TracerESP = true,
SkeletonESP = true,
MaxDistance = 1000
}

-- State
local aiming = false
local currentTarget = nil
local ESPObjects = {}
local connections = {}
local isRunning = true

-- Modern Notification System (Top Center)
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "K1TT3N_Notifications"
NotifGui.Parent = game.CoreGui
NotifGui.ResetOnSpawn = false

local function ShowNotification(title, text, duration)
duration = duration or 3

local notifFrame = Instance.new("Frame")
notifFrame.Size = UDim2.new(0, 320, 0, 80)
notifFrame.Position = UDim2.new(0.5, -160, 0, -100)
notifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
notifFrame.BackgroundTransparency = 0.1
notifFrame.BorderSizePixel = 0
notifFrame.Parent = NotifGui

local corner = Instance.new("UICorner", notifFrame)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", notifFrame)
stroke.Color = Color3.fromRGB(0, 150, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.3

local gradient = Instance.new("UIGradient", notifFrame)
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 30))
})

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

local targetPos = UDim2.new(0.5, -160, 0, 20)
TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = targetPos}):Play()

task.delay(duration, function()
    local outTween = TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0.5, -160, 0, -100)})
    outTween:Play()
    outTween.Completed:Wait()
    notifFrame:Destroy()
end)
end

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "K1TT3N"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 480)
MainFrame.Position = UDim2.new(0.02, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = Color3.fromRGB(0, 150, 255)
mainStroke.Thickness = 1
mainStroke.Transparency = 0.4

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Title.Text = "K1TT3N"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Position = UDim2.new(0, 0, 0, 42)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Rivals Cheat"
Subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
Subtitle.TextSize = 12
Subtitle.Font = Enum.Font.Gotham
Subtitle.Parent = MainFrame

-- Create Toggle Button
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

-- Toggles
CreateToggle("Aimbot", "AimbotEnabled", 70)
CreateToggle("ESP", "ESPenabled", 108)
CreateToggle("Box ESP", "BoxESP", 146)
CreateToggle("Name ESP", "NameESP", 184)
CreateToggle("Health ESP", "HealthESP", 222)
CreateToggle("Tracer ESP", "TracerESP", 260)
CreateToggle("Skeleton ESP", "SkeletonESP", 298)

-- FOV Slider
local FOVLabel = Instance.new("TextLabel")
FOVLabel.Size = UDim2.new(0.9, 0, 0, 25)
FOVLabel.Position = UDim2.new(0.05, 0, 0, 336)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Text = "FOV: " .. Settings.FOV
FOVLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVLabel.TextSize = 14
FOVLabel.Font = Enum.Font.Gotham
FOVLabel.Parent = MainFrame

local FOVBar = Instance.new("Frame")
FOVBar.Size = UDim2.new(0.9, 0, 0, 8)
FOVBar.Position = UDim2.new(0.05, 0, 0, 361)
FOVBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FOVBar.Parent = MainFrame

Instance.new("UICorner", FOVBar).CornerRadius = UDim.new(0, 4)

local FOVFill = Instance.new("Frame")
FOVFill.Size = UDim2.new((Settings.FOV - 50) / 450, 0, 1, 0)
FOVFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
FOVFill.Parent = FOVBar

Instance.new("UICorner", FOVFill).CornerRadius = UDim.new(0, 4)

local FOVButton = Instance.new("TextButton")
FOVButton.Size = UDim2.new(1, 0, 1, 0)
FOVButton.BackgroundTransparency = 1
FOVButton.Text = ""
FOVButton.Parent = FOVBar

local draggingFOV = false

FOVButton.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 and isRunning then
draggingFOV = true
end
end)

-- Smoothness Slider
local SmoothLabel = Instance.new("TextLabel")
SmoothLabel.Size = UDim2.new(0.9, 0, 0, 25)
SmoothLabel.Position = UDim2.new(0.05, 0, 0, 376)
SmoothLabel.BackgroundTransparency = 1
SmoothLabel.Text = "Smoothness: " .. Settings.Smoothness
SmoothLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SmoothLabel.TextSize = 14
SmoothLabel.Font = Enum.Font.Gotham
SmoothLabel.Parent = MainFrame

local SmoothBar = Instance.new("Frame")
SmoothBar.Size = UDim2.new(0.9, 0, 0, 8)
SmoothBar.Position = UDim2.new(0.05, 0, 0, 401)
SmoothBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SmoothBar.Parent = MainFrame

Instance.new("UICorner", SmoothBar).CornerRadius = UDim.new(0, 4)

local SmoothFill = Instance.new("Frame")
SmoothFill.Size = UDim2.new(Settings.Smoothness / 0.5, 0, 1, 0)
SmoothFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SmoothFill.Parent = SmoothBar

Instance.new("UICorner", SmoothFill).CornerRadius = UDim.new(0, 4)

local SmoothButton = Instance.new("TextButton")
SmoothButton.Size = UDim2.new(1, 0, 1, 0)
SmoothButton.BackgroundTransparency = 1
SmoothButton.Text = ""
SmoothButton.Parent = SmoothBar

local draggingSmooth = false

SmoothButton.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 and isRunning then
draggingSmooth = true
end
end)

-- CLOSE BUTTON
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

-- ESP Functions
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

-- Rivals-specific functions
local function GetAimPosition(character)
local head = character:FindFirstChild("Head")
if head then
return head.Position + Vector3.new(0, 0.1, 0)
end

local hrp = character:FindFirstChild("HumanoidRootPart")
if hrp then
    return hrp.Position + Vector3.new(0, 2, 0)
end

return nil
end

local function GetHealthData(character)
local health = character:GetAttribute("Health") or character:GetAttribute("HP")
local maxHealth = character:GetAttribute("MaxHealth") or character:GetAttribute("MaxHP") or 100

if not health then
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        health = humanoid.Health
        maxHealth = humanoid.MaxHealth
    end
end

if not health then
    local healthVal = character:FindFirstChild("Health")
    if healthVal and healthVal:IsA("ValueBase") then
        health = healthVal.Value
    end
end

return health or 0, maxHealth or 100
end

local function IsEnemy(player)
if not Settings.TeamCheck then return true end
if not LocalPlayer.Team or not player.Team then return true end
return player.Team ~= LocalPlayer.Team
end

local function GetClosestPlayer()
local closest = nil
local shortestDistance = Settings.FOV
local mousePos = UserInputService:GetMouseLocation()

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and IsEnemy(player) then
        local character = player.Character
        if character then
            local isAlive = character:GetAttribute("Alive") or 
                           (character:FindFirstChildOfClass("Humanoid") and 
                            character:FindFirstChildOfClass("Humanoid").Health > 0)
            
            if isAlive then
                local aimPos = GetAimPosition(character)
                if aimPos then
                    local pos, onScreen = Camera:WorldToViewportPoint(aimPos)
                    if onScreen then
                        local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                        if distance < shortestDistance then
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {LocalPlayer.Character, character}
                            rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                            local ray = Workspace:Raycast(Camera.CFrame.Position, (aimPos - Camera.CFrame.Position).Unit * 500, rayParams)
                            
                            if not ray or ray.Instance:IsDescendantOf(character) then
                                closest = player
                                shortestDistance = distance
                            end
                        end
                    end
                end
            end
        end
    end
end

return closest
end

-- Input Connections
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

-- Slider dragging
table.insert(connections, UserInputService.InputChanged:Connect(function(input)
if not isRunning then return end

if draggingFOV and input.UserInputType == Enum.UserInputType.MouseMovement then
    local pos = math.clamp((input.Position.X - FOVBar.AbsolutePosition.X) / FOVBar.AbsoluteSize.X, 0, 1)
    Settings.FOV = math.floor(50 + (pos * 450))
    FOVLabel.Text = "FOV: " .. Settings.FOV
    FOVFill.Size = UDim2.new(pos, 0, 1, 0)
    FOVCircle.Radius = Settings.FOV
end

if draggingSmooth and input.UserInputType == Enum.UserInputType.MouseMovement then
    local pos = math.clamp((input.Position.X - SmoothBar.AbsolutePosition.X) / SmoothBar.AbsoluteSize.X, 0, 1)
    Settings.Smoothness = math.floor(pos * 50) / 100
    SmoothLabel.Text = "Smoothness: " .. Settings.Smoothness
    SmoothFill.Size = UDim2.new(Settings.Smoothness / 0.5, 0, 1, 0)
end
end))

table.insert(connections, UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
draggingFOV = false
draggingSmooth = false
end
end))

-- Main Loop
table.insert(connections, RunService.RenderStepped:Connect(function()
if not isRunning then return end

FOVCircle.Position = UserInputService:GetMouseLocation()
FOVCircle.Radius = Settings.FOV
FOVCircle.Visible = Settings.AimbotEnabled and MainFrame.Visible

if aiming and Settings.AimbotEnabled then
    if not currentTarget then
        currentTarget = GetClosestPlayer()
    end
    
    if currentTarget then
        local character = currentTarget.Character
        if character then
            local isAlive = character:GetAttribute("Alive") or 
                           (character:FindFirstChildOfClass("Humanoid") and 
                            character:FindFirstChildOfClass("Humanoid").Health > 0)
            
            if isAlive then
                local aimPos = GetAimPosition(character)
                if aimPos then
                    local targetCFrame = CFrame.new(Camera.CFrame.Position, aimPos)
                    Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Settings.Smoothness)
                else
                    currentTarget = nil
                end
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

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
        local esp = ESPObjects[player]
        local character = player.Character
        
        if Settings.ESPenabled and character and IsEnemy(player) then
            local torso = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
            local head = character:FindFirstChild("Head")
            
            if torso and head then
                local hp, maxHp = GetHealthData(character)
                
                if hp > 0 then
                    local pos, onScreen = Camera:WorldToViewportPoint(torso.Position)
                    local distance = (torso.Position - Camera.CFrame.Position).Magnitude
                    
                    if onScreen and distance <= Settings.MaxDistance then
                        local color = player.TeamColor and player.TeamColor.Color or Color3.fromRGB(255, 50, 50)
                        
                        if Settings.BoxESP then
                            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
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
                            esp.Name.Text = player.Name
                            esp.Name.Color = color
                            esp.Name.Visible = true
                        else
                            esp.Name.Visible = false
                        end
                        
                        if Settings.HealthESP then
                            local hpPercent = math.clamp(hp / maxHp, 0, 1)
                            esp.HealthBg.Size = Vector2.new(4, 40)
                            esp.HealthBg.Position = Vector2.new(pos.X - 30, pos.Y - 20)
                            esp.HealthBg.Visible = true
                            esp.HealthBar.Size = Vector2.new(4, 40 * hpPercent)
                            esp.HealthBar.Position = Vector2.new(pos.X - 30, pos.Y - 20 + 40 * (1 - hpPercent))
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
                        esp.Box.Visible = false
                        esp.BoxOutline.Visible = false
                        esp.Name.Visible = false
                        esp.HealthBar.Visible = false
                        esp.HealthBg.Visible = false
                        esp.Tracer.Visible = false
                        for _, line in pairs(esp.Skeleton) do
                            line.Visible = false
                        end
                    end
                else
                    esp.Box.Visible = false
                    esp.BoxOutline.Visible = false
                    esp.Name.Visible = false
                    esp.HealthBar.Visible = false
                    esp.HealthBg.Visible = false
                    esp.Tracer.Visible = false
                    for _, line in pairs(esp.Skeleton) do
                        line.Visible = false
                    end
                end
            else
                esp.Box.Visible = false
                esp.BoxOutline.Visible = false
                esp.Name.Visible = false
                esp.HealthBar.Visible = false
                esp.HealthBg.Visible = false
                esp.Tracer.Visible = false
                for _, line in pairs(esp.Skeleton) do
                    line.Visible = false
                end
            end
        else
            esp.Box.Visible = false
            esp.BoxOutline.Visible = false
            esp.Name.Visible = false
            esp.HealthBar.Visible = false
            esp.HealthBg.Visible = false
            esp.Tracer.Visible = false
            for _, line in pairs(esp.Skeleton) do
                line.Visible = false
            end
        end
    end
end
end))

-- Cleanup on player leave
table.insert(connections, Players.PlayerRemoving:Connect(function(player)
if ESPObjects[player] then
for _, obj in pairs(ESPObjects[player]) do
if type(obj) == "table" then
for _, line in pairs(obj) do
line:Remove()
end
else
obj:Remove()
end
end
ESPObjects[player] = nil
end
end))

-- CLOSE FUNCTION
CloseButton.MouseButton1Click:Connect(function()
isRunning = false

for _, conn in pairs(connections) do
    conn:Disconnect()
end

FOVCircle:Remove()
for _, playerESP in pairs(ESPObjects) do
    for _, obj in pairs(playerESP) do
        if type(obj) == "table" then
            for _, line in pairs(obj) do
                line:Remove()
            end
        else
            obj:Remove()
        end
    end
end

ScreenGui:Destroy()
NotifGui:Destroy()

ESPObjects = {}
connections = {}

ShowNotification("K1TT3N", "Script unloaded successfully!", 3)
task.wait(3.5)
end)

-- Notifications
task.delay(0.5, function()
ShowNotification("K1TT3N Loaded", "Right Shift: Toggle Menu | Right Mouse: Aimbot", 5)
end)

print("K1TT3N loaded successfully!")
print("Right Shift = Toggle GUI")
print("Right Mouse = Aimbot")
print("Click CLOSE to unload")

