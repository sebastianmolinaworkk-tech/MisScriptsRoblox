--[[ 
    GABRIEL: THE ABSOLUTE DIVINE FRAMEWORK
    VERSION: ULTIMATE EXTREME
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humRoot = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- --- CONFIGURACIÓN DE AMBIENTE EXTREMO ---
local function configurarMundo()
    local colorCorrection = Instance.new("ColorCorrectionEffect", Lighting)
    colorCorrection.TintColor = Color3.fromRGB(255, 255, 200)
    colorCorrection.Saturation = 0.5
    colorCorrection.Brightness = 0.2
    
    local bloom = Instance.new("BloomEffect", Lighting)
    bloom.Intensity = 2
    bloom.Threshold = 0.5
    
    return colorCorrection, bloom
end

-- --- SISTEMA DE ALAS MATEMÁTICAS (Inspirado en image_4.png) ---
local function generarAlasDivinas()
    local alas = Instance.new("Model", char)
    alas.Name = "DivineWings"
    
    local function crearPluma(offset, rot)
        local p = Instance.new("Part", alas)
        p.Size = Vector3.new(0.5, 4, 1)
        p.Color = Color3.fromRGB(255, 255, 255)
        p.Material = Enum.Material.Neon
        p.CanCollide = false
        p.Massless = true
        
        local weld = Instance.new("Weld", p)
        weld.Part0 = humRoot
        weld.Part1 = p
        weld.C0 = CFrame.new(offset) * CFrame.Angles(0, 0, math.rad(rot))
        return p
    end

    -- Generar 12 plumas por lado para llegar a la silueta de image_4.png
    for i = 1, 12 do
        crearPluma(Vector3.new(2 + (i*0.2), 2 + (i*0.1), 0.5), 45 + (i*5))
        crearPluma(Vector3.new(-2 - (i*0.2), 2 + (i*0.1), 0.5), -45 - (i*5))
    end
end

-- --- SISTEMA DE DIÁLOGOS Y ATAQUES ---
local function ejecutarSentencia()
    local lineas = {
        "MACHINE...",
        "I WILL CUT YOU APART...",
        "SPLAY THE GORE OF YOUR PROFANE FORM ACROSS THE STARS!",
        "I WILL GRIND YOU DOWN UNTIL THE VERY SPARKS CRY FOR MERCY!",
        "MY HANDS SHALL RELISH ENDING YOU... HERE AND NOW!",
        "TWICE... HAVE I BEEN BEATEN BY AN OBJECT...",
        "I'VE NEVER KNOWN SUCH... HUMILIATION!",
        "BUT THE LIGHT OF THE FATHER STILL BURNS WITHIN ME!",
        "BEHOLD! THE POWER OF AN ANGEL!"
    }

    -- Lógica de God Mode y Silueta (Referencia image_4.png y image_5.png)
    local god = hum.HealthChanged:Connect(function() hum.Health = hum.MaxHealth end)
    
    -- Hacer silueta negra total
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then v.Color = Color3.new(0,0,0) v.Material = Enum.Material.Neon end
        if v:IsA("Accessory") then v:Destroy() end
    end

    -- Levitación extrema con Shake de cámara
    humRoot.Anchored = true
    for i = 1, 200 do
        humRoot.CFrame = humRoot.CFrame * CFrame.new(0, 0.1, 0)
        workspace.CurrentCamera.FieldOfView = 70 + math.random(-2, 2)
        task.wait(0.01)
    end

    -- Discurso masivo
    for _, msg in pairs(lineas) do
        local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if chatEvent then chatEvent.SayMessageRequest:FireServer(msg, "All") end
        task.wait(2.5)
    end

    -- ATAQUE FINAL: EXPLOSIÓN DE MALLA
    local boom = Instance.new("Part", workspace)
    boom.Shape = Enum.PartType.Ball
    boom.Size = Vector3.new(1,1,1)
    boom.Position = humRoot.Position
    boom.Color = Color3.fromRGB(255, 255, 0) -- Amarillo image_5.png
    boom.Material = Enum.Material.Neon
    boom.Anchored = true
    boom.CanCollide = false
    
    TweenService:Create(boom, TweenInfo.new(1), {Size = Vector3.new(200,200,200), Transparency = 1}):Play()
    
    -- Detección de daño extrema
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Humanoid") and p ~= player then
            p.Character.Humanoid.Health = 0
        end
    end
end

-- EJECUCIÓN DEL RETO
local cc, bl = configurarMundo()
generarAlasDivinas()
ejecutarSentencia()
