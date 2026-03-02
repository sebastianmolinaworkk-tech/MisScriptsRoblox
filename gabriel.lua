-- FRAMEWORK GABRIEL ULTIMATE V4
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humRoot = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- --- MOTOR DE CHAT ---
local function hablar(texto)
    local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvent then chatEvent.SayMessageRequest:FireServer(texto, "All") end
end

-- --- SISTEMA DE EFECTOS VISUALES (Pilar de Luz como en image_1000037356) ---
local function crearPilar()
    local pilar = Instance.new("Part", workspace)
    pilar.Anchored = true
    pilar.CanCollide = false
    pilar.Material = Enum.Material.Neon
    pilar.Color = Color3.fromRGB(255, 255, 0)
    pilar.Transparency = 0.5
    pilar.Size = Vector3.new(15, 500, 15)
    pilar.Position = humRoot.Position + Vector3.new(0, 240, 0)
    
    TS:Create(pilar, TweenInfo.new(2), {Transparency = 1}):Play()
    task.delay(2, function() pilar:Destroy() end)
end

-- --- FUNCIONES DE ATAQUE (MOVESET) ---

-- 1. JUSTICE DASH
local function justiceDash()
    hablar("JUSTICE!")
    local bodyVel = Instance.new("BodyVelocity", humRoot)
    bodyVel.Velocity = humRoot.CFrame.LookVector * 150
    bodyVel.MaxForce = Vector3.new(math.huge, 0, math.huge)
    
    task.spawn(function()
        for i = 1, 10 do
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p ~= player then
                    local d = (humRoot.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if d < 12 then 
                        p.Character.HumanoidRootPart.Velocity = humRoot.CFrame.LookVector * 100 + Vector3.new(0, 50, 0)
                    end
                end
            end
            task.wait(0.05)
        end
        bodyVel:Destroy()
    end)
end

-- 2. REAL ANGEL (Teleport & Push)
local function realAngel()
    local target = nil
    local minDist = 100
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local d = (humRoot.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < minDist then minDist = d; target = p.Character end
        end
    end
    
    if target then
        humRoot.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        hablar("NOTHING BUT SCRAP!")
        target.HumanoidRootPart.Velocity = humRoot.CFrame.LookVector * -120 + Vector3.new(0, 40, 0)
    end
end

-- 3. MACHINE (Aimbot & Animation Attack)
local function machineAttack()
    local target = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then target = p.Character; break end
    end
    
    if target then
        hablar("MACHINE, I WILL CUT YOU DOWN!")
        hum.WalkSpeed = 100
        local connection
        connection = RS.Heartbeat:Connect(function()
            if target and target:FindFirstChild("HumanoidRootPart") then
                humRoot.CFrame = CFrame.lookAt(humRoot.Position, target.HumanoidRootPart.Position)
                if (humRoot.Position - target.HumanoidRootPart.Position).Magnitude < 5 then
                    connection:Disconnect()
                    hum.WalkSpeed = 16
                    -- Animación de pateo
                    target.HumanoidRootPart.Velocity = humRoot.CFrame.LookVector * 200 + Vector3.new(0, 80, 0)
                    hablar("BEGONE!")
                end
            end
        end)
    end
end

-- --- PANEL DE CONTROL (GUI) ---
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0.2, 0, 0.4, 0)
frame.Position = UDim2.new(0.02, 0, 0.3, 0)
frame.BackgroundTransparency = 0.5
frame.BackgroundColor3 = Color3.new(0,0,0)

local function crearBoton(nombre, pos, func)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0.9, 0, 0.2, 0)
    b.Position = pos
    b.Text = nombre
    b.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    b.MouseButton1Click:Connect(func)
end

crearBoton("JUSTICE DASH", UDim2.new(0.05, 0, 0.05, 0), justiceDash)
crearBoton("REAL ANGEL", UDim2.new(0.05, 0, 0.3, 0), realAngel)
crearBoton("MACHINE", UDim2.new(0.05, 0, 0.55, 0), machineAttack)

-- --- INTRO CINEMÁTICA ---
task.spawn(function()
    hum.HealthChanged:Connect(function() hum.Health = hum.MaxHealth end) -- God Mode
    crearPilar()
    
    -- Silueta Negra Forzada
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then v.Color = Color3.new(0,0,0) v.Material = Enum.Material.Neon end
        if v:IsA("Accessory") then v.Handle.Transparency = 1 end
    end

    humRoot.Anchored = true
    humRoot.CFrame = humRoot.CFrame * CFrame.new(0, 20, 0)
    
    hablar("MACHINE...")
    task.wait(2)
    hablar("I WILL CUT YOU APART!")
    task.wait(2)
    hablar("SPLAY THE GORE OF YOUR PROFANE FORM ACROSS THE STARS!")
    task.wait(2)
    
    humRoot.Anchored = false -- ¡AHORA SÍ TE PUEDES MOVER!
    hablar("BEHOLD THE POWER OF AN ANGEL!")
end)
