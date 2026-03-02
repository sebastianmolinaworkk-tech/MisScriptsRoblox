local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humRoot = char:WaitForChild("HumanoidRootPart")

-- 1. FUNCIÓN DE CHAT REFORZADA
local function hablarEnChat(texto)
    local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvent then
        chatEvent.SayMessageRequest:FireServer(texto, "All")
    end
end

-- 2. LIMPIAR GUIS ANTIGUAS (Evita que se duplique el cuadro)
if player.PlayerGui:FindFirstChild("GabrielGui") then
    player.PlayerGui.GabrielGui:Destroy()
end

-- 3. CREAR INTERFAZ DORADA
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "GabrielGui"
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0.5, 0, 0.15, 0)
frame.Position = UDim2.new(0.25, 0, 0.75, 0)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0.5

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 215, 0) -- DORADO
label.TextScaled = true
label.Font = Enum.Font.Arcade
label.Text = ""

-- 4. EFECTO DE LLEGADA Y AURA AMARILLA
local function efectoEntrada()
    local luz = Instance.new("PointLight", humRoot)
    luz.Color = Color3.fromRGB(255, 215, 0)
    luz.Range = 40
    luz.Brightness = 10
    
    local bv = Instance.new("BodyVelocity", humRoot)
    bv.Velocity = Vector3.new(0, 4, 0) -- Levitación suave
    bv.MaxForce = Vector3.new(0, 4000, 0)
    return bv, luz
end

-- 5. EL MOTOR DE VOCES (REPRODUCE EL AUDIO DE GABRIEL)
local function reproducirVoz(idAudio, duracion)
    local sonido = Instance.new("Sound", humRoot)
    sonido.SoundId = "rbxassetid://" .. idAudio
    sonido.Volume = 5 -- Volumen muy alto para que sea imponente
    sonido.MaxDistance = 150 -- Distancia a la que los demás pueden escucharlo
    sonido.EmitterSize = 30
    sonido:Play()
    
    -- Borra el sonido al terminar para evitar lag en tu móvil de 8GB
    task.delay(duracion, function()
        if sonido then sonido:Destroy() end
    end)
end

-- 6. LA SECUENCIA ÉPICA (SINCRONIZADA CON VOZ)
task.spawn(function()
    local levitar, brillo = efectoEntrada()
    
    -- Aquí están las frases, los IDs de audio y el tiempo que dura cada frase
    -- (Nota: Usamos IDs genéricos épicos públicos de Roblox para evitar la censura de audios)
    local secuencias = {
        {texto = "Machine...", audioId = "9073335503", tiempo = 2},
        {texto = "I will cut you down...", audioId = "9073336444", tiempo = 2},
        {texto = "Break you apart...", audioId = "9073337351", tiempo = 2},
        {texto = "Splay the gore of your profane form across the STARS!", audioId = "9073338520", tiempo = 4}
    }

    for _, linea in ipairs(secuencias) do
        -- 1. Iniciar la voz
        reproducirVoz(linea.audioId, linea.tiempo)
        
        -- 2. Enviar mensaje al chat global
        hablarEnChat(linea.texto)
        
        -- 3. Efecto máquina de escribir (sincronizado con la duración del audio)
        for i = 1, #linea.texto do
            label.Text = string.sub(linea.texto, 1, i)
            task.wait((linea.tiempo - 0.2) / #linea.texto)
        end
        task.wait(0.5) -- Pausa dramática entre oraciones
    end

    -- Grito Final
    reproducirVoz("131063630", 4) -- Sonido de impacto divino / explosión final
    label.Text = "BEHOLD! THE POWER OF AN ANGEL!"
    hablarEnChat("BEHOLD! THE POWER OF AN ANGEL!")
    task.wait(3)
    
    -- Limpiar los efectos cuando termine el discurso
    levitar:Destroy()
    brillo:Destroy()
    gui:Destroy()
end)
