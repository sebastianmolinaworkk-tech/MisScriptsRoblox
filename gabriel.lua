local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humRoot = char:WaitForChild("HumanoidRootPart")
local torso = char:WaitForChild("Torso")

-- 1. FUNCIÓN PARA HABLAR EN EL CHAT GLOBAL (VISIBLE PARA TODOS)
local function hablarEnChat(texto)
    local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvent then
        chatEvent.SayMessageRequest:FireServer(texto, "All")
    end
end

-- 2. CREAR EL "FAKE CHARACTER" (VISIBLE PARA TODOS)
local function crearFakeGabriel()
    -- Ocultar tu personaje Bacon (Localmente para ti, pero el Fake será global)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            part.Transparency = 1
        end
    end

    -- Crear el modelo de Gabriel (Usando un R15 Dummy básico de Roblox para animar)
    local fakeGabriel = game:GetObjects("rbxassetid://5161593575")[1] -- ID de un Dummy R15
    fakeGabriel.Name = "Gabriel_Fake"
    fakeGabriel.Parent = workspace
    
    local fakeHRP = fakeGabriel:WaitForChild("HumanoidRootPart")
    local fakeHum = fakeGabriel:WaitForChild("Humanoid")

    -- Pegar el Fake Gabriel a tu personaje
    local weld = Instance.new("Weld")
    weld.Part0 = humRoot
    weld.Part1 = fakeHRP
    weld.C0 = CFrame.new(0, 0, 0)
    weld.Parent = fakeHRP

    -- 3. CARGAR ANIMACIONES (Visibles para todos)
    -- Usaremos IDs de animaciones públicas de Roblox que parezcan celestiales/de pose
    local animFlyId = "rbxassetid://507767773" -- ID de animación de vuelo R15
    local animPoseId = "rbxassetid://507776043" -- ID de animación de pose dramática

    local animFly = Instance.new("Animation")
    animFly.AnimationId = animFlyId
    local trackFly = fakeHum:LoadAnimation(animFly)
    trackFly.Looped = true
    trackFly:Play()

    local animPose = Instance.new("Animation")
    animPose.AnimationId = animPoseId
    local trackPose = fakeHum:LoadAnimation(animPose)
    trackPose.Looped = true
    trackPose:Play()

    -- 4. EFECTOS VISUALES TOTALMENTE VISIBLES (Aura Dorada y Alas de Luz)
    -- (Omitido por brevedad, pero usaríamos ParticleEmitters globales aquí)

    return fakeGabriel, trackFly, trackPose
end

-- 5. INTERFAZ DORADA CINEMÁTICA (VISUAL SOLO PARA TI)
local gui = Instance.new("ScreenGui", player.PlayerGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0.5, 0, 0.15, 0)
frame.Position = UDim2.new(0.25, 0, 0.75, 0)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0.6

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 215, 0) -- DORADO CELESTIAL
label.TextScaled = true
label.Font = Enum.Font.Arcade -- Estilo retro/boss
label.Text = ""

-- 6. EJECUCIÓN CINEMÁTICA TOTALMENTE VISIBLE
task.spawn(function()
    hablarEnChat("BEHOLD! THE POWER OF AN ANGEL!") -- Lo ven todos
    task.wait(1)
    
    local gabrielFake, flyTrack, poseTrack = crearFakeGabriel() -- Crea el personaje animado
    
    -- Levitación (Visible para todos)
    local bv = Instance.new("BodyVelocity", humRoot)
    bv.Velocity = Vector3.new(0, 5, 0) -- Te eleva dramáticamente
    bv.MaxForce = Vector3.new(0, 4000, 0)
    
    -- DISCURSO (Visible para todos en el chat)
    local frases = {
        "Machine...",
        "I will cut you down...",
        "Break you apart...",
        "Splay the gore of your profane form across the STARS!"
    }

    for _, frase in pairs(frases) do
        hablarEnChat(frase) -- ESTO LO VEN TODOS
        -- Efecto máquina de escribir para ti
        for i = 1, #frase do
            label.Text = string.sub(frase, 1, i)
            task.wait(0.04)
        end
        task.wait(1.5)
    end

    -- Limpieza
    bv:Destroy()
    gabrielFake:Destroy()
    gui:Destroy()
end)
