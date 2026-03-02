local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local char = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
local humRoot = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- --- CONFIGURACIÓN DE CHAT ---
local function hablarEnChat(texto)
    local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvent then
        chatEvent.SayMessageRequest:FireServer(texto, "All")
    end
end

-- --- ATAQUE: EXPLOSIÓN DE JUSTICIA ---
local function justiciaDivina()
    local explosion = Instance.new("Explosion")
    explosion.Position = humRoot.Position
    explosion.BlastRadius = 35
    explosion.BlastPressure = 1000000
    explosion.Parent = workspace
    
    local p = Instance.new("Part", workspace)
    p.Anchored = true
    p.CanCollide = false
    p.Shape = Enum.PartType.Ball
    p.Color = Color3.fromRGB(255, 230, 100) -- Amarillo brillante
    p.Material = Enum.Material.Neon
    p.Position = humRoot.Position
    
    TweenService:Create(p, TweenInfo.new(0.7), {Size = Vector3.new(70,70,70), Transparency = 1}):Play()
    task.delay(0.7, function() p:Destroy() end)
end

-- --- INICIO DE LA SECUENCIA GABRIEL ---
task.spawn(function()
    -- 1. Activar God Mode (Invencibilidad)
    local god = hum.HealthChanged:Connect(function() hum.Health = hum.MaxHealth end)
    
    -- 2. Efectos Visuales (Silueta y Aura Amarilla)
    local luz = Instance.new("PointLight", humRoot)
    luz.Color = Color3.fromRGB(255, 255, 120)
    luz.Range = 100
    luz.Brightness = 25
    
    -- Hacer al personaje una silueta oscura durante la intro
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.Color = Color3.new(0,0,0) end
    end

    humRoot.Anchored = true
    humRoot.CFrame = humRoot.CFrame * CFrame.new(0, 15, 0) -- Levitación
    
    -- 3. SILENCIO INICIAL (Pose Dramática)
    task.wait(4) 

    -- 4. EL DIÁLOGO COMPLETO (Sincronizado)
    hablarEnChat("MACHINE...")
    task.wait(2)
    hablarEnChat("I WILL CUT YOU APART...")
    task.wait(2)
    hablarEnChat("SPLAY THE GORE OF YOUR PROFANE FORM ACROSS THE STARS!")
    task.wait(2.5)
    hablarEnChat("I WILL GRIND YOU DOWN UNTIL THE VERY SPARKS CRY FOR MERCY!")
    task.wait(2)
    hablarEnChat("MY HANDS SHALL RELISH ENDING YOU... HERE AND NOW!")
    task.wait(2)

    -- 5. ATAQUE FINAL Y LIBERACIÓN
    humRoot.Anchored = false
    justiciaDivina()
    hablarEnChat("BEHOLD! THE POWER OF AN ANGEL!")
    
    -- Restaurar colores originales
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.Color = Color3.new(1,1,1) end -- Ajustar según skin
    end

    task.wait(3)
    luz:Destroy()
    god:Disconnect() -- Fin del God Mode
end)
