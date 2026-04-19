loadstring([[ 
-- Ronal PVPS - Blox Fruits (Anti-Lag + Freeze 2s)
if game.PlaceId \~= 2753915549 then warn("❌ Solo Blox Fruits") return end

-- Freeze pantalla 2 segundos
local freeze = Instance.new("ScreenGui")
local black = Instance.new("Frame")
black.Size = UDim2.new(1,0,1,0)
black.BackgroundColor3 = Color3.new(0,0,0)
black.Parent = freeze
freeze.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
wait(2)
freeze:Destroy()

print("✅ RONAL PVPS cargado")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- GUI simplificada
local sg = Instance.new("ScreenGui") sg.ResetOnSpawn = false sg.Parent = player:WaitForChild("PlayerGui")
local mf = Instance.new("Frame") mf.Size = UDim2.new(0,400,0,800) mf.Position = UDim2.new(0.5,-200,0.5,-400) mf.BackgroundColor3 = Color3.fromRGB(10,10,10) mf.Parent = sg

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(8,8,8)), ColorSequenceKeypoint.new(0.5,Color3.fromRGB(70,70,75)), ColorSequenceKeypoint.new(1,Color3.fromRGB(110,110,115))}
grad.Rotation = 90
grad.Parent = mf

Instance.new("UICorner", mf).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,60)
title.BackgroundTransparency = 0.4
title.BackgroundColor3 = Color3.fromRGB(0,0,0)
title.Text = "🌑 RONAL PVPS"
title.TextColor3 = Color3.fromRGB(0,255,180)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mf
Instance.new("UICorner", title).CornerRadius = UDim.new(0,12)

local function toggle(txt, y, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,-30,0,50)
    f.Position = UDim2.new(0,15,0,y)
    f.BackgroundColor3 = Color3.fromRGB(30,30,35)
    f.BackgroundTransparency = 0.2
    f.Parent = mf
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,8)
    
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.65,0,1,0)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = Color3.fromRGB(240,240,240)
    l.TextScaled = true
    l.Font = Enum.Font.GothamSemibold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.3,0,0.8,0)
    b.Position = UDim2.new(0.67,0,0.1,0)
    b.BackgroundColor3 = Color3.fromRGB(180,0,0)
    b.Text = "OFF"
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.TextScaled = true
    b.Font = Enum.Font.GothamBold
    b.Parent = f
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    
    local on = false
    b.MouseButton1Click:Connect(function()
        on = not on
        b.Text = on and "ON" or "OFF"
        b.BackgroundColor3 = on and Color3.fromRGB(0,220,100) or Color3.fromRGB(180,0,0)
        cb(on)
    end)
end

-- Toggles
toggle("Volar (E +vel | Q -vel)", 80, function(s) flyEnabled = s end)
toggle("Fast Attack", 140, function(s) fastAttackEnabled = s end)
toggle("Hitbox Buddha 2000", 200, function(s) hitboxEnabled = s end)
toggle("Auto Race V3", 260, function(s) autoRaceV3 = s end)
toggle("Auto Race V4", 320, function(s) autoRaceV4 = s end)
toggle("Auto Aimbot Suave", 380, function(s) autoAimbotEnabled = s end)
toggle("ESP Enemigos", 440, function(s) espEnabled = s end)
toggle("ESP Huevos Pascua", 500, function(s) eggESPEnabled = s end)

print("🌑 RONAL PVPS listo - Usa los toggles")
]])()
