local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humRoot = char:WaitForChild("HumanoidRootPart")

-- 1. LIMPIAR SI YA EXISTE
if char:FindFirstChild("SuperAuto") then char.SuperAuto:Destroy() end
if player.PlayerGui:FindFirstChild("CarGui") then player.PlayerGui.CarGui:Destroy() end

-- 2. CREAR EL AUTO (VISIBLE PARA TODOS)
local carModel = Instance.new("Model", char)
carModel.Name = "SuperAuto"

local body = Instance.new("Part", carModel)
body.Size = Vector3.new(6, 2, 8)
body.Color = Color3.fromRGB(255, 0, 0)
body.Material = Enum.Material.Neon
body.CanCollide = false
body.Massless = true

local weld = Instance.new("Weld", body)
weld.Part0 = humRoot
weld.Part1 = body
weld.C0 = CFrame.new(0, -2, 0)

-- 3. INTERFAZ MÓVIL REFORZADA
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "CarGui"

local function crearBtn(txt, pos, color)
    local b = Instance.new("TextButton", gui)
    b.Size = UDim2.new(0.2, 0, 0.15, 0)
    b.Position = pos
    b.Text = txt
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.BlackOpsOne
    b.TextScaled = true
    return b
end

local btnAcc = crearBtn("GAS", UDim2.new(0.75, 0, 0.7, 0), Color3.new(0, 0.6, 0))
local btnBrk = crearBtn("FRENO", UDim2.new(0.05, 0, 0.7, 0), Color3.new(0.6, 0, 0))
local speedLabel = Instance.new("TextLabel", gui)
speedLabel.Size = UDim2.new(0.2, 0, 0.1, 0)
speedLabel.Position = UDim2.new(0.4, 0, 0.85, 0)
speedLabel.Text = "0 KM/H"
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1, 1, 1)

-- 4. CONTROL DE CONDUCCIÓN
local velocidad = 0
local acelerando = false
local frenando = false

btnAcc.MouseButton1Down:Connect(function() acelerando = true end)
btnAcc.MouseButton1Up:Connect(function() acelerando = false end)
btnBrk.MouseButton1Down:Connect(function() frenando = true end)
btnBrk.MouseButton1Up:Connect(function() frenando = false end)

RunService.RenderStepped:Connect(function()
    if acelerando then
        velocidad = math.min(velocidad + 1, 80) -- Max 80 para que no te eche el juego
    elseif frenando then
        velocidad = math.max(velocidad - 2, -30)
    else
        velocidad = velocidad * 0.95 -- Fricción natural
    end

    if math.abs(velocidad) > 0.1 then
        humRoot.CFrame = humRoot.CFrame * CFrame.new(0, 0, -velocidad/10)
    end
    
    speedLabel.Text = math.floor(math.abs(velocidad)) .. " KM/H"

    -- SISTEMA DE CHOQUE (TODOS LO VEN)
    if math.abs(velocidad) > 20 then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (humRoot.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if d < 7 then
                    local v = Instance.new("BodyVelocity", p.Character.HumanoidRootPart)
                    v.Velocity = (p.Character.HumanoidRootPart.Position - humRoot.Position).Unit * 50 + Vector3.new(0, 30, 0)
                    v.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                    task.wait(0.1)
                    v:Destroy()
                end
            end
        end
    end
end)
