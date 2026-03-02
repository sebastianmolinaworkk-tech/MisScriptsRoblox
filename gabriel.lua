local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humRoot = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- 1. CREAR EL VEHÍCULO (VISIBLE PARA TODOS)
local function crearAuto()
    local carModel = Instance.new("Model", char)
    carModel.Name = "SuperAuto"

    -- Chasis (El cuerpo del auto)
    local body = Instance.new("Part", carModel)
    body.Size = Vector3.new(6, 2, 10)
    body.Color = Color3.fromRGB(255, 0, 0) -- Rojo Ferrari
    body.Material = Enum.Material.Neon
    body.CanCollide = false
    
    local weld = Instance.new("Weld", body)
    weld.Part0 = humRoot
    weld.Part1 = body
    weld.C0 = CFrame.new(0, -2, 0)

    -- Volante con "Animación" (Gira con la dirección)
    local volante = Instance.new("Part", carModel)
    volante.Size = Vector3.new(1, 1, 0.2)
    volante.Shape = Enum.PartType.Cylinder
    volante.Color = Color3.new(0,0,0)
    
    local vWeld = Instance.new("Weld", volante)
    vWeld.Part0 = body
    vWeld.Part1 = volante
    vWeld.C0 = CFrame.new(0, 1.5, -2) * CFrame.Angles(0, math.rad(90), 0)

    return body, vWeld
end

local carBody, steeringWeld = crearAuto()

-- 2. INTERFAZ DE CONDUCCIÓN (Móvil)
local gui = Instance.new("ScreenGui", player.PlayerGui)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(1, 0, 1, 0)
main.BackgroundTransparency = 1

-- Botones
local function crearBoton(nombre, pos, texto)
    local btn = Instance.new("TextButton", main)
    btn.Name = nombre
    btn.Size = UDim2.new(0.2, 0, 0.2, 0)
    btn.Position = pos
    btn.Text = texto
    btn.BackgroundColor3 = Color3.new(0,0,0)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundTransparency = 0.5
    return btn
end

local btnAcc = crearBoton("Acelerar", UDim2.new(0.7, 0, 0.7, 0), "GAS")
local btnBrk = crearBoton("Frenar", UDim2.new(0.1, 0, 0.7, 0), "FRENO")
local speedLabel = Instance.new("TextLabel", main)
speedLabel.Size = UDim2.new(0.2, 0, 0.1, 0)
speedLabel.Position = UDim2.new(0.4, 0, 0.8, 0)
speedLabel.Text = "0 KM/H"

-- 3. LÓGICA DE MOVIMIENTO Y CHOQUES (VISIBLE PARA TODOS)
local velocidad = 0
local girando = 0

btnAcc.MouseButton1Down:Connect(function() velocidad = 100 end)
btnAcc.MouseButton1Up:Connect(function() velocidad = 0 end)
btnBrk.MouseButton1Down:Connect(function() velocidad = -50 end)
btnBrk.MouseButton1Up:Connect(function() velocidad = 0 end)

RunService.Heartbeat:Connect(function()
    if velocidad ~= 0 then
        humRoot.Velocity = humRoot.CFrame.LookVector * velocidad
        speedLabel.Text = math.floor(humRoot.Velocity.Magnitude) .. " KM/H"
        
        -- Animación volante
        steeringWeld.C1 = CFrame.Angles(0, 0, math.sin(tick()*5))
    end
    
    -- SISTEMA DE CHOQUE (Manda a volar a otros)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (humRoot.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if dist < 8 and velocidad > 20 then
                -- Fuerza de empuje
                local push = Instance.new("BodyVelocity", p.Character.HumanoidRootPart)
                push.Velocity = (p.Character.HumanoidRootPart.Position - humRoot.Position).Unit * 100 + Vector3.new(0, 50, 0)
                push.MaxForce = Vector3.new(100000, 100000, 100000)
                task.wait(0.2)
                push:Destroy()
            end
        end
    end
end)
