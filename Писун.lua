local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "P*nisBuilder"
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 100)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -50)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.BorderSizePixel = 2
mainFrame.Parent = screenGui

local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
header.Text = "P*nis Builder"
header.Font = Enum.Font.SourceSansBold
header.TextSize = 18
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
header.TextStrokeTransparency = 0
header.Parent = mainFrame


local dragging = false
local dragStart, startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

header.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)


local createButton = Instance.new("TextButton")
createButton.Size = UDim2.new(0, 200, 0, 50)
createButton.Position = UDim2.new(0.5, -100, 0.5, -25)
createButton.Text = "Create p*nis"
createButton.Font = Enum.Font.SourceSansBold
createButton.TextSize = 20
createButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
createButton.TextColor3 = Color3.fromRGB(255, 255, 255)
createButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
createButton.TextStrokeTransparency = 0
createButton.Parent = mainFrame

local barrel
local weldBarrel
local isShooting = false
local shootSound


local hintQueue = {}
local isHintActive = false

local function showHint(message, duration)
    table.insert(hintQueue, {message = message, duration = duration or 3})

    if not isHintActive then
        isHintActive = true
        task.spawn(function()
            while #hintQueue > 0 do
                local hintData = table.remove(hintQueue, 1)
                local hint = Instance.new("TextLabel")
                hint.Size = UDim2.new(0, 300, 0, 50)
                hint.Position = UDim2.new(0.5, -150, 0.9, -25)
                hint.BackgroundTransparency = 0.5
                hint.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                hint.Text = hintData.message
                hint.Font = Enum.Font.SourceSansBold
                hint.TextSize = 20
                hint.TextColor3 = Color3.fromRGB(255, 255, 255)
                hint.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                hint.TextStrokeTransparency = 0
                hint.Parent = screenGui

                wait(hintData.duration)
                hint:Destroy()
            end
            isHintActive = false
        end)
    end
end


local function createMiniGun()
    local character = player.Character or player.CharacterAdded:Wait()
    local lowerTorso = character:FindFirstChild("LowerTorso")

    if not lowerTorso then
        showHint("LowerTorso not found!", 3)
        return
    end

    local torsoColor = lowerTorso.Color

    local function createPart(size, color, parent)
        local part = Instance.new("Part")
        part.Size = size
        part.Color = color
        part.Material = Enum.Material.Metal
        part.CanCollide = false
        part.Anchored = false
        part.Parent = parent
        return part
    end

    barrel = createPart(Vector3.new(1.2, 1.2, 4), torsoColor, character)
    weldBarrel = Instance.new("Weld")
    weldBarrel.Part0 = lowerTorso
    weldBarrel.Part1 = barrel
    weldBarrel.C0 = CFrame.new(0, -0.5, -2)
    weldBarrel.Parent = barrel

    shootSound = Instance.new("Sound")
    shootSound.SoundId = "rbxassetid://6723675399"
    shootSound.Volume = 1
    shootSound.Looped = true
    shootSound.Parent = barrel

    showHint("P*nis coloured to skin color: " .. tostring(torsoColor), 3)

    local function shoot()
        local mouse = player:GetMouse()
        local targetPosition = mouse.Hit.Position
        local direction = (targetPosition - barrel.Position).Unit * 100

        local bullet = createPart(Vector3.new(0.4, 0.4, 1.5), Color3.fromRGB(255, 255, 0), game.Workspace)
        bullet.Material = Enum.Material.Neon
        bullet.CFrame = CFrame.new(barrel.Position, targetPosition)
        bullet.CanCollide = true
        bullet.Massless = false

        bullet.AssemblyLinearVelocity = direction

        game:GetService("Debris"):AddItem(bullet, 10)

        bullet.Touched:Connect(function(hit)
            if hit and hit:IsA("BasePart") and hit.Parent ~= character then
                bullet:Destroy()
            end
        end)
    end

    
    local UIS = game:GetService("UserInputService")
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            isShooting = true
            shootSound:Play()

            while isShooting do
                shoot()
                wait(0.1)
            end
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isShooting = false
            shootSound:Stop()
        end
    end)

    showHint("P*nis created! Hold LMB or touch the screen to pee", 5) 
end

createButton.MouseButton1Click:Connect(function()
    createMiniGun()
    createButton.Text = "P*nis created!"
    createButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    wait(2)
    createButton.Text = "Create p*nis"
    createButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
end)

showHint("Loaded Successfully! Developers: @ner3lyy", 5)
