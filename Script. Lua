local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Death Hub",
    LoadingTitle = "Made my calaverita",
    Icon = "rabbit",
    LoadingSubtitle = "comprame mas hubs papi",
    ConfigurationSaving = {
      Enabled = false,
      FolderName = tommy,
      FileName = "tommy"
   },
    Discord = {Enabled = false},
    KeySystem = false
})

repeat wait() until game:GetService("ReplicatedStorage").Util.CameraShaker.Main

local ss = require(game:GetService("ReplicatedStorage").Util.CameraShaker.Main)
local xx = function() return nil end

ss.StartShake = xx
ss.ShakeOnce = xx
ss.ShakeSustain = xx
ss.CamerShakeInstance = xx
ss.Shake = xx
ss.Start = xx

local running = false
local TeleportEnabled = false
local SelectedPlayer = nil
local TeleportConnection = nil
local TweenSpeed = {X = 350, Y = 350}
local PredictionStrength = 0
local SafeZoneActive = false
local SafeZoneConnection = nil
local OriginalPosition = nil
local FastAttackEnabled = false
local FastAttackConnection = nil
local FastAttackRange = 5000
local ESPEnabled = true
local ESPBoxes = false
local ESPNames = true
local EliteESP = false
local ESPDistance = true
local ESPMaxDistance = 99999999
local OriginalCamera = nil
local SpectateConnection = nil
local ActiveTween = nil

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Net = ReplicatedStorage.Modules.Net
local RegisterHit = Net["RE/RegisterHit"]
local RegisterAttack = Net["RE/RegisterAttack"]

local CombatUtil = require(ReplicatedStorage.Modules.CombatUtil)

local function TP(targetHRP)
    local player = Players.LocalPlayer
    if not player.Character then return end

    local HRP = player.Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = player.Character:FindFirstChild("Humanoid")
    if not HRP or not Humanoid then return end

    HRP.AssemblyLinearVelocity = Vector3.zero
    HRP.AssemblyAngularVelocity = Vector3.zero
    Humanoid:ChangeState(Enum.HumanoidStateType.Physics)

    local predictedPos = targetHRP.Position + (targetHRP.Velocity * PredictionStrength)

    local targetCFrame =
        CFrame.new(predictedPos)
        * CFrame.Angles(0, math.rad(targetHRP.Orientation.Y), 0)
        * CFrame.new(0, YOffset, 0)

    local Distance = (targetCFrame.Position - HRP.Position).Magnitude
    local horizontalDist = math.sqrt(
        (targetCFrame.Position.X - HRP.Position.X)^2 +
        (targetCFrame.Position.Z - HRP.Position.Z)^2
    )
    local verticalDist = math.abs(targetCFrame.Position.Y - HRP.Position.Y)

    local speed = TweenSpeed.X
    if verticalDist > horizontalDist then speed = TweenSpeed.Y end

    if ActiveTween then
        ActiveTween:Cancel()
    end

    ActiveTween = TweenService:Create(
        HRP,
        TweenInfo.new(Distance / speed, Enum.EasingStyle.Linear),
        {CFrame = targetCFrame}
    )

    ActiveTween:Play()

    task.delay(0.05, function()
        if Humanoid then
            Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
end

local TARGET_PARTS = {
    UpperTorso = true,
    LowerTorso = true,
    HumanoidRootPart = true
}

local function SetNoCollide()
    local character = Players.LocalPlayer.Character
    if not character then return end

    for _, v in ipairs(character:GetChildren()) do
        if v:IsA("BasePart") and TARGET_PARTS[v.Name] then
            v.CanCollide = false
            v.CanTouch = false
            v.CanQuery = false
        end
    end
end

local function SetCollide()
    local character = Players.LocalPlayer.Character
    if not character then return end

    for _, v in ipairs(character:GetChildren()) do
        if v:IsA("BasePart") and TARGET_PARTS[v.Name] then
            v.CanCollide = true
            v.CanTouch = true
            v.CanQuery = true
        end
    end
end

local function GetNearestPlayer()
    local myChar = Players.LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    
    local nearestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChild("Humanoid")
            
            if hrp and humanoid and humanoid.Health > 0 then
                local dist = (hrp.Position - myHRP.Position).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    nearestPlayer = player
                end
            end
        end
    end
    
    return nearestPlayer
end


local function GetPlayerList()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer then table.insert(list, p.Name) end
    end
    if #list == 0 then table.insert(list, "None") end
    return list
end

local function StartTeleporting()
    if TeleportConnection then TeleportConnection:Disconnect() end
    TeleportConnection = RunService.Heartbeat:Connect(function()
        if TeleportEnabled and SelectedPlayer and not SafeZoneActive then
            local target = Players:FindFirstChild(SelectedPlayer)
            if target and target.Character then
                local hrp = target.Character:FindFirstChild("HumanoidRootPart")
                if hrp then 
                    TP(hrp)
                    SetNoCollide()
                end
            end
        end
    end)
end

local function StartInstaTeleporting()
    if InstaTpConnection then InstaTpConnection:Disconnect() end
    
    InstaTpConnection = RunService.Stepped:Connect(function()
        if not InstaTeleportEnabled or not SelectedPlayer or SafeZoneActive then return end
        
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        
        pcall(function()
            local char = LocalPlayer.Character
            local target = Players:FindFirstChild(SelectedPlayer)
            
            if char and target and target.Character then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
                
                if hrp and targetHRP then
                    local bangOffset = CFrame.new(0, YOffset, 0) 
                    hrp.CFrame = targetHRP.CFrame * bangOffset
                end
            end
        end)
    end)
end

local function StartSpectating()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    
    if not OriginalCamera then
        OriginalCamera = Camera.CameraSubject
    end
    
    if SpectateConnection then 
        SpectateConnection:Disconnect() 
    end
    
    SpectateConnection = RunService.RenderStepped:Connect(function()
        if not SpectateEnabled or not SelectedPlayer then 
            StopSpectating()
            return 
        end
        
        pcall(function()
            local target = Players:FindFirstChild(SelectedPlayer)
            
            if target and target.Character then
                local targetHumanoid = target.Character:FindFirstChild("Humanoid")
                
                if targetHumanoid then
                    Camera.CameraSubject = targetHumanoid
                else
                    StopSpectating()
                end
            else
                StopSpectating()
            end
        end)
    end)
end

function StopSpectating()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    
    if SpectateConnection then
        SpectateConnection:Disconnect()
        SpectateConnection = nil
    end
    
    if OriginalCamera then
        pcall(function()
            Camera.CameraSubject = OriginalCamera
        end)
    else
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                Camera.CameraSubject = LocalPlayer.Character.Humanoid
            end
        end)
    end
    
    OriginalCamera = nil
end

local Tab = Window:CreateTab("Players", gem)

local Tab2 = Window:CreateTab("Killaura", gem)

local Tab3 = Window:CreateTab("Killaura (NPCs)", gem)

local Tab4 = Window:CreateTab("Misc", gem)

local Tab5 = Window:CreateTab("Teleports", gem)

local Tab6 = Window:CreateTab("ESP", gem)

local Server = Window:CreateTab("Server", gem)

Tab6:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = true,
    Callback = function(v)
        ESPEnabled = v
    end
})

Tab6:CreateToggle({
    Name = "Boxes",
    CurrentValue = true,
    Callback = function(v)
        ESPBoxes = v
    end
})

Tab6:CreateToggle({
    Name = "Names",
    CurrentValue = true,
    Callback = function(v)
        ESPNames = v
    end
})

Tab6:CreateToggle({
    Name = "Distance",
    CurrentValue = false,
    Callback = function(v)
        ESPDistance = v
    end
})

Tab6:CreateToggle({
    Name = "Elite ESP",
    CurrentValue = false,
    Callback = function(v)
        EliteESP = v
    end
})

Tab6:CreateToggle({
    Name = "Fruit ESP",
    CurrentValue = false,
    Callback = function(v)
        FruitEsp = v
    end
})

Tab6:CreateSlider({
    Name = "Max Distance",
    Range = {100, 99999999},
    Increment = 100,
    CurrentValue = 99999999,
    Callback = function(v)
        ESPMaxDistance = v
    end
})

local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ESPObjects = {}
local EliteESPObjects = {}

local function NewDraw(type, props)
    local d = Drawing.new(type)
    for i,v in pairs(props) do
        d[i] = v
    end
    return d
end

local function ClearESP(plr)
    if ESPObjects[plr] then
        for _,obj in pairs(ESPObjects[plr]) do
            obj:Remove()
        end
        ESPObjects[plr] = nil
    end
end

local function ClearEliteESP(obj)
    if EliteESPObjects[obj] then
        for _,espObj in pairs(EliteESPObjects[obj]) do
            espObj:Remove()
        end
        EliteESPObjects[obj] = nil
    end
end

local function GetLevel(plr)
    local data = plr:FindFirstChild("Data")
    if data then
        local level = data:FindFirstChild("Level")
        if level and level.Value then
            return tostring(level.Value)
        end
    end
    return nil
end


local function GetExactLocation(plr)
    local attr = plr:GetAttribute("ExactLocation")
    if attr ~= nil then
        return tostring(attr)
    end

    local v = plr:FindFirstChild("ExactLocation")
    if v and v.Value ~= nil then
        return tostring(v.Value)
    end

    local ls = plr:FindFirstChild("leaderstats")
    if ls then
        local lv = ls:FindFirstChild("ExactLocation")
        if lv and lv.Value ~= nil then
            return tostring(lv.Value)
        end
    end

    return nil
end

RunService.RenderStepped:Connect(function()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then
            ClearESP(plr)
            continue
        end

        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")

        if not ESPEnabled or not hrp or not hum or hum.Health <= 0 then
            ClearESP(plr)
            continue
        end

        local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
        if dist > ESPMaxDistance then
            ClearESP(plr)
            continue
        end

        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        if not onScreen then
            ClearESP(plr)
            continue
        end

        ESPObjects[plr] = ESPObjects[plr] or {}

        if ESPBoxes then
            ESPObjects[plr].Box = ESPObjects[plr].Box or NewDraw("Square", {
                Thickness = 2,
                Filled = false,
                Color = Color3.fromRGB(255, 60, 60)
            })

            local size = Vector2.new(2200 / dist, 3200 / dist)
            ESPObjects[plr].Box.Size = size
            ESPObjects[plr].Box.Position = Vector2.new(
                pos.X - size.X / 2,
                pos.Y - size.Y / 2
            )
            ESPObjects[plr].Box.Visible = true
        elseif ESPObjects[plr].Box then
            ESPObjects[plr].Box.Visible = false
        end

       if ESPNames or ESPDistance then
            ESPObjects[plr].Text = ESPObjects[plr].Text or NewDraw("Text", {
                Size = 16,
                Center = true,
                Outline = true,
                Color = Color3.new(1,1,1)
            })

            local txt = ""

            if ESPNames then
                txt = plr.Name
                
                local level = GetLevel(plr)
                if level then
                    txt ..= " [Lvl " .. level .. "]"
                end
                
                local exactLoc = GetExactLocation(plr)
                if exactLoc then
                    txt ..= " [" .. exactLoc .. "]"
                end
            end

            if ESPDistance then
                txt ..= " (" .. math.floor(dist / 10) .. "m)"
            end

            ESPObjects[plr].Text.Text = txt
            ESPObjects[plr].Text.Position = Vector2.new(pos.X, pos.Y - 25)
            ESPObjects[plr].Text.Visible = true
        elseif ESPObjects[plr].Text then
            ESPObjects[plr].Text.Visible = false
        end

    if EliteESP then
        local eliteNames = {"Diablo", "Deandre", "Urban"}
        
        for _, eliteName in ipairs(eliteNames) do
            local obj = ReplicatedStorage:FindFirstChild(eliteName)
            
            if obj then
                local hrp = obj:FindFirstChild("HumanoidRootPart")
                
                if hrp then
                    local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                    
                    if dist <= ESPMaxDistance then
                        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                        
                        if onScreen then
                            EliteESPObjects[obj] = EliteESPObjects[obj] or {}
                            
                            EliteESPObjects[obj].Box = EliteESPObjects[obj].Box or NewDraw("Square", {
                                Thickness = 3,
                                Filled = false,
                                Color = Color3.fromRGB(255, 215, 0)
                            })
                            
                            local size = Vector2.new(2200 / dist, 3200 / dist)
                            EliteESPObjects[obj].Box.Size = size
                            EliteESPObjects[obj].Box.Position = Vector2.new(
                                pos.X - size.X / 2,
                                pos.Y - size.Y / 2
                            )
                            EliteESPObjects[obj].Box.Visible = true
                            
                            EliteESPObjects[obj].Text = EliteESPObjects[obj].Text or NewDraw("Text", {
                                Size = 18,
                                Center = true,
                                Outline = true,
                                Color = Color3.fromRGB(255, 215, 0)
                            })
                            
                            EliteESPObjects[obj].Text.Text = eliteName .. " (" .. math.floor(dist / 10) .. "m)"
                            EliteESPObjects[obj].Text.Position = Vector2.new(pos.X, pos.Y - 25)
                            EliteESPObjects[obj].Text.Visible = true
                        else
                            ClearEliteESP(obj)
                        end
                    else
                        ClearEliteESP(obj)
                    end
                else
                    ClearEliteESP(obj)
                end
            end
        end
        
        if FruitEsp then
            for _, obj in ipairs(workspace:GetChildren()) do
                if string.find(obj.Name, "Fruit") or obj.Name == "Fruit" then
                    if obj:IsA("Tool") or obj:IsA("Model") then
                        local hrp = obj:FindFirstChild("Handle")

                        if hrp then
                            local dist = (Camera.CFrame.Position - hrp.Position).Magnitude

                            if dist <= ESPMaxDistance then
                                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

                                if onScreen then
                                    FruitEspObjects[obj] = FruitEspObjects[obj] or {}

                                    FruitEspObjects[obj].Box = FruitEspObjects[obj].Box or NewDraw("Square", {
                                        Thickness = 3,
                                        Filled = false,
                                        Color = Color3.fromRGB(255, 215, 0)
                                    })

                                    local size = Vector2.new(2200 / dist, 3200 / dist)
                                    FruitEspObjects[obj].Box.Size = size
                                    FruitEspObjects[obj].Box.Position = Vector2.new(
                                        pos.X - size.X / 2,
                                        pos.Y - size.Y / 2
                                    )
                                    FruitEspObjects[obj].Box.Visible = true

                                    FruitEspObjects[obj].Text = FruitEspObjects[obj].Text or NewDraw("Text", {
                                        Size = 18,
                                        Center = true,
                                        Outline = true,
                                        Color = Color3.fromRGB(255, 215, 0)
                                    })

                                    FruitEspObjects[obj].Text.Text =
                                        obj.Name .. " (" .. math.floor(dist / 10) .. "m)"
                                    FruitEspObjects[obj].Text.Position =
                                        Vector2.new(pos.X, pos.Y - 25)
                                    FruitEspObjects[obj].Text.Visible = true
                                else
                                    ClearFruitEsp(obj)
                                end
                            else
                                ClearFruitEsp(obj)
                            end
                        else
                            ClearFruitEsp(obj)
                        end
                    end
                end
            end
        end


        local enemiesFolder = workspace:FindFirstChild("Enemies")
        if enemiesFolder then
            for _, eliteName in ipairs(eliteNames) do
                local obj = enemiesFolder:FindFirstChild(eliteName)
                
                if obj then
                    local hrp = obj:FindFirstChild("HumanoidRootPart")
                    
                    if hrp then
                        local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                        
                        if dist <= ESPMaxDistance then
                            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                            
                            if onScreen then
                                EliteESPObjects[obj] = EliteESPObjects[obj] or {}
