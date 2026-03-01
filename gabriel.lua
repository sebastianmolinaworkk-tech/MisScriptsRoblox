local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humRoot = char:WaitForChild("HumanoidRootPart")

-- 1. FUNCIÓN PARA HABLAR EN EL CHAT (QUE TODOS VEAN)
local function hablarEnChat(texto)
    -- Esto usa el evento del chat de Roblox que Delta puede disparar
    local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvent then
        chatEvent.SayMessageRequest:FireServer(texto, "All")
    end
end

-- 2. INTERFAZ DORADA (VISUAL PARA TI)
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

-- 3. ANIMACIÓN DE INTRODUCCIÓN (EL LEVITAR)
local function animacionIntro()
    local bv = Instance.new("BodyVelocity", humRoot)
    bv.Velocity = Vector3.new(0, 2, 0) -- Te eleva suavemente
    bv.MaxForce = Vector3.new(0, 4000, 0)
    
    -- EFECTO DE LUZ DORADA (TODOS VEN LA LUZ SI EL SCRIPT ES LADO SERVIDOR, PERO AQUÍ ES CLIENTE)
    local luz = Instance.new("PointLight", humRoot)
    luz.Color = Color3.fromRGB(255, 215, 0)
    luz.Brightness = 10
    luz.Range = 25

    return bv, luz
end

-- 4. EJECUCIÓN CINEMÁTICA
task.spawn(function()
    local levitar, brillo = animacionIntro()
    
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

    levitar:Destroy() -- Dejas de flotar
    label.Text = "BEHOLD! THE POWER OF AN ANGEL!"
    task.wait(2)
    gui:Destroy()
end)
