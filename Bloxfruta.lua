loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source"))() 

wait(1)

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
    Name = "🌑 Ronal PVPS",
    LoadingTitle = "Ronal PVPS - Blox Fruits",
    LoadingSubtitle = "by Grok",
    ConfigurationSaving = {
        Enabled = false,
    },
})

-- Texto blanco grande en pantalla al ejecutar
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(0.6, 0, 0.2, 0)
textLabel.Position = UDim2.new(0.2, 0, 0.4, 0)
textLabel.BackgroundTransparency = 1
textLabel.Text = "RONAL PVPS CARGADO"
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.TextScaled = true
textLabel.Font = Enum.Font.GothamBold
textLabel.Parent = screenGui

wait(3)
textLabel:Destroy()

-- === VARIABLES ===
local FastAttackRange = 5000

-- === TABS ===
local MainTab = Window:CreateTab("🏠 Main", 4483362458)
local CombatTab = Window:CreateTab("⚔️ Combat", 4483362458)
local VisualTab = Window:CreateTab("👁️ Visuals", 4483362458)

-- Main Tab (Volar)
MainTab:CreateToggle({
    Name = "Volar (WASD + Space/Ctrl)",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        flyEnabled = Value
        if Value then startFly() else stopFly() end
    end,
})

MainTab:CreateSlider({
    Name = "Velocidad de Vuelo",
    Range = {40, 300},
    Increment = 10,
    CurrentValue = 120,
    Flag = "FlySpeed",
    Callback = function(Value)
        flySpeed = Value
    end,
})

-- Combat Tab
CombatTab:CreateToggle({
    Name = "Fast Attack (Range: " .. FastAttackRange .. ")",
    CurrentValue = false,
    Flag = "FastAttack",
    Callback = function(Value)
        fastAttackEnabled = Value
        if Value then startFastAttack() else stopFastAttack() end
    end,
})

CombatTab:CreateToggle({
    Name = "Hitbox Enorme Buddha",
    CurrentValue = false,
    Flag = "Hitbox",
    Callback = function(Value)
        hitboxEnabled = Value
        if Value then startHitbox() else stopHitbox() end
    end,
})

CombatTab:CreateToggle({
    Name = "Auto Aimbot Suave",
    CurrentValue = false,
    Flag = "Aimbot",
    Callback = function(Value)
        autoAimbotEnabled = Value
        if Value then startAimbot() else stopAimbot() end
    end,
})

CombatTab:CreateToggle({
    Name = "Auto Race V3",
    CurrentValue = false,
    Flag = "RaceV3",
    Callback = function(Value)
        autoRaceV3 = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Auto Race V4",
    CurrentValue = false,
    Flag = "RaceV4",
    Callback = function(Value)
        autoRaceV4 = Value
    end,
})

-- Visual Tab
VisualTab:CreateToggle({
    Name = "ESP Enemigos",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)
        espEnabled = Value
        if Value then startESP() else stopESP() end
    end,
})

VisualTab:CreateToggle({
    Name = "ESP Huevos de Pascua",
    CurrentValue = false,
    Flag = "EggESP",
    Callback = function(Value)
        eggESPEnabled = Value
        if Value then startEggESP() else stopEggESP() end
    end,
})

-- Funciones básicas (optimizadas)
local flyEnabled, flySpeed = false, 120
local bv, bg, flyRender = nil, nil, nil
local fastAttackEnabled = false
local attackConnection = nil
local hitboxEnabled = false
local hitboxSize = 2000
local hitboxConnection = nil
local autoAimbotEnabled = false
local aimbotConnection = nil
local autoRaceV3, autoRaceV4 = false, false
local espEnabled = false
local eggESPEnabled = false

local function startFly()
    if bv then return end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    bv = Instance.new("BodyVelocity") bv.MaxForce = Vector3.new(9e9,9e9,9e9) bv.Velocity = Vector3.new() bv.Parent = root
    bg = Instance.new("BodyGyro") bg.MaxTorque = Vector3.new(9e9,9e9,9e9) bg.P = 12500 bg.Parent = root
    char.Humanoid.PlatformStand = true
    flyRender = RunService.RenderStepped:Connect(function()
        if not flyEnabled or not bv then return end
        local move = Vector3.new()
        if flyKeys.W then move += camera.CFrame.LookVector end
        if flyKeys.S then move -= camera.CFrame.LookVector end
        if flyKeys.A then move -= camera.CFrame.RightVector end
        if flyKeys.D then move += camera.CFrame.RightVector end
        if flyKeys.Space then move += Vector3.new(0,1,0) end
        if flyKeys.LeftControl then move -= Vector3.new(0,1,0) end
        bv.Velocity = move.Magnitude > 0 and move.Unit * flySpeed or Vector3.new()
        bg.CFrame = camera.CFrame
    end)
end

local function stopFly()
    flyEnabled = false
    if flyRender then flyRender:Disconnect() flyRender = nil end
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand = false end
end

local function startFastAttack()
    if attackConnection then return end
    attackConnection = RunService.Heartbeat:Connect(function()
        if not fastAttackEnabled then return end
        local char = player.Character
        if char then
            local tool = char:FindFirstChildWhichIsA("Tool")
            if tool then tool:Activate() end
        end
    end)
end

local function stopFastAttack()
    if attackConnection then attackConnection:Disconnect() attackConnection = nil end
end

local function startHitbox()
    if hitboxConnection then return end
    hitboxConnection = RunService.Heartbeat:Connect(function()
        if not hitboxEnabled then return end
        local char = player.Character
        if not char then return end
        local newSize = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name \~= "HumanoidRootPart" then
                part.Size = newSize
                part.Transparency = 1
                part.CanCollide = false
            end
        end
    end)
end

local function stopHitbox()
    if hitboxConnection then hitboxConnection:Disconnect() hitboxConnection = nil end
end

local function startAimbot()
    if aimbotConnection then return end
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not autoAimbotEnabled then return end
        local closest, dist = nil, 350
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr \~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                local d = (plr.Character.HumanoidRootPart.Position - camera.CFrame.Position).Magnitude
                if d < dist then dist = d closest = plr.Character.HumanoidRootPart end
            end
        end
        if closest then
            local target = closest.Position + Vector3.new(0,2,0)
            camera.CFrame =
