-- K1TT3N - Rivals Cheat (Fixed)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- KEY SYSTEM
local ValidKeys = {
    "K1TT3N-2024-XENO",
    "K1TT3N-BETA-ACCESS",
    "K1TT3N-DISCORD-USER"
}

local function ValidateKey(inputKey)
    for _, key in pairs(ValidKeys) do
        if inputKey == key then
            return true
        end
    end
    return false
end

-- Key GUI
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
KeySubtitle.Text = "Enter your access key"
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
KeyInput.PlaceholderText = "Enter key here..."
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

-- Check if already validated
local KeyValidated = false

SubmitBtn.MouseButton1Click:Connect(function()
    local key = KeyInput.Text:gsub("%s+", "")
    if ValidateKey(key) then
        KeyValidated = true
        KeyStatus.TextColor3 = Color3.fromRGB(50, 255, 50)
        KeyStatus.Text = "Access granted! Loading..."
        TweenService:Create(KeyFrame, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -200, 1.5, -125)}):Play()
        task.wait(0.6)
        KeyGui:Destroy()
        LoadScript()
    else
        KeyStatus.Text = "Invalid key! Join discord for a valid key."
        KeyInput.Text = ""
    end
end)

DiscordBtn.MouseButton1Click:Connect(function()
    -- Change this to your Discord invite
    local discordLink = "https://discord.gg/yourserver"
    -- Copies to clipboard if supported
    if setclipboard then
        setclipboard(discordLink)
        KeyStatus.TextColor3 = Color3.fromRGB(50, 255, 50)
        KeyStatus.Text = "Discord link copied to clipboard!"
    else
        KeyStatus.Text = "Join: discord.gg/yourserver"
    end
end)

-- MAIN SCRIPT
function LoadScript()
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

    CreateToggle("Aimbot", "AimbotEnabled", 70)
    CreateToggle("ESP", "ESPenabled", 108)
    CreateToggle("Box ESP", "BoxESP", 146)
    CreateToggle("Name ESP", "NameESP", 184)
    CreateToggle("Health ESP", "HealthESP", 222)
    CreateToggle("Tracer ESP", "TracerESP", 260)
    CreateToggle("Skeleton ESP", "SkeletonESP", 298)

    -- Sliders (FOV and Smoothness)
    local FOVLabel = Instance.new("TextLabel")
    FOVLabel.Size = UDim2.new(0.9, 0, 0, 25)
    FOVLabel.Position = UDim2.new(0.05, 0, 0, 336)
    FOVLabel.BackgroundTransparency = 1
    FOVLabel.Text = "FOV: " .. Settings.FOV
    FOVLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
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

    -- Close Button
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

    -- ESP Setup
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

    -- FIXED: Better aimbot targeting for Rivals
    local function GetAimPosition(character)
        -- Try multiple head locations
        local head = character:FindFirstChild("Head")
        if head then
            return head.Position + Vector3.new(0, 0.15, 0)
        end
        
        -- Try UpperTorso for R15
        local upperTorso = character:FindFirstChild("UpperTorso")
        if upperTorso then
            return upperTorso.Position + Vector3.new(0, 0.5, 0)
        end
        
        -- Fallback to HRP
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            return hrp.Position + Vector3.new(0, 1.5, 0)
        end
        return nil
    end

    -- FIXED: Health detection for Rivals
    local function GetHealthData(character)
        -- Method 1: Attributes (most common in Rivals)
        local hp = character:GetAttribute("Health") 
        local maxHp = character:GetAttribute("MaxHealth") or 100
        
        -- Method 2: Folder with values
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
        
        -- Method 3: Humanoid (fallback)
        if not hp then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                hp = humanoid.Health
                maxHp = humanoid.MaxHealth
            end
        end
        
        -- Method 4: Value directly in character
        if not hp then
            local hpVal = character:FindFirstChild("Health")
            if hpVal and hpVal:IsA("ValueBase") then
                hp = hpVal.Value
            end
            local maxVal = character:FindFirstChild("MaxHealth")
            if maxVal and maxVal:IsA("ValueBase") then
                maxHp = maxVal.Value
            end
        end
        
        return hp or 100, maxHp or 100
    end

    -- Check if player is alive
    local function IsPlayerAlive(character)
        -- Check attribute first
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

    -- FIXED: Better aimbot with prediction
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
                                    rayParams.FilterType = Enum.ERaycastFilterType.Blacklist
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

    -- Main Loop
    table.insert(connections, RunService.RenderStepped:Connect(function()
        if not isRunning then return end
        
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
                        local targetCFrame = CFrame.new(Camera.CFrame.Position, aimPos)
                        Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Settings.Smoothness)
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
                
                if Settings.ESPenabled and character and IsEnemy(player) then
                    local torso = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
                    local head = character:FindFirstChild("Head")
                    
                    if torso then
                        local hp, maxHp = GetHealthData(character)
                        
                        if hp > 0 then
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
                                for _, obj in pairs(esp) do
                                    if type(obj) == "table" then
                                        for _, line in pairs(obj) do line.Visible = false end
                                    elseif obj.Remove then
                                        obj.Visible = false
                                    end
                                end
                            end
                        else
                            for _, obj in pairs(esp) do
                                if type(obj) == "table" then
                                    for _, line in pairs(obj) do line.Visible = false end
                                elseif obj.Remove then
                                    obj.Visible = false
                                end
                            end
                        end
                    else
                        for _, obj in pairs(esp) do
                            if type(obj) == "table" then
                                for _, line in pairs(obj) do line.Visible = false end
                            elseif obj.Remove then
                                obj.Visible = false
                            end
                        end
                    end
                else
                    for _, obj in pairs(esp) do
                        if type(obj) == "table" then
                            for _, line in pairs(obj) do line.Visible = false end
                        elseif obj.Remove then
                            obj.Visible = false
                        end
                    end
                end
            end
        end
    end))

    -- Cleanup
    table.insert(connections, Players.PlayerRemoving:Connect(function(player)
        if ESPObjects[player] then
            for _, obj in pairs(ESPObjects[player]) do
                if type(obj) == "table" then
                    for _, line in pairs(obj) do line:Remove() end
                elseif obj.Remove then
                    obj:Remove()
                end
            end
            ESPObjects[player] = nil
        end
    end))

    CloseButton.MouseButton1Click:Connect(function()
        isRunning = false
        for _, conn in pairs(connections) do conn:Disconnect() end
        FOVCircle:Remove()
        for _, playerESP in pairs(ESPObjects) do
            for _, obj in pairs(playerESP) do
                if type(obj) == "table" then
                    for _, line in pairs(obj) do line:Remove() end
                elseif obj.Remove then
                    obj:Remove()
                end
            end
        end
        ScreenGui:Destroy()
        NotifGui:Destroy()
        ShowNotification("K1TT3N", "Unloaded successfully!", 3)
        task.wait(3.5)
    end)

    task.delay(0.5, function()
        ShowNotification("K1TT3N Loaded", "Right Shift: Toggle Menu | Right Mouse: Aimbot", 5)
    end)
end
