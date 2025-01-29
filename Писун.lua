local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")


local function createGui()
    if playerGui:FindFirstChild("PesunBuilder") then
        playerGui.PesunBuilder:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PesunBuilder"
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
    header.Text = "Pesun Builder"
    header.Font = Enum.Font.SourceSansBold
    header.TextSize = 18
    header.TextColor3 = Color3.fromRGB(255, 255, 255)
    header.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    header.TextStrokeTransparency = 0
    header.Parent = mainFrame

    
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -30, 0, 5)
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.TextSize = 18
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Parent = mainFrame

    closeButton.MouseButton1Click:Connect(function()
        screenGui.Enabled = false
    end)

    
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
    createButton.Text = "Создать песун"
    createButton.Font = Enum.Font.SourceSansBold
    createButton.TextSize = 20
    createButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    createButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    createButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    createButton.TextStrokeTransparency = 0
    createButton.Parent = mainFrame

    
    local function showHint(message, duration)
        local hint = Instance.new("TextLabel")
        hint.Size = UDim2.new(0, 300, 0, 50)
        hint.Position = UDim2.new(0.5, -150, 0.9, -25)
        hint.BackgroundTransparency = 0.5
        hint.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        hint.Text = message
        hint.Font = Enum.Font.SourceSansBold
        hint.TextSize = 20
        hint.TextColor3 = Color3.fromRGB(255, 255, 255)
        hint.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        hint.TextStrokeTransparency = 0
        hint.Parent = screenGui

        task.wait(duration or 3)
        hint:Destroy()
    end

    createButton.MouseButton1Click:Connect(function()
        showHint("Песун создан!", 3)
        createButton.Text = "Песун создан!"
        createButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        task.wait(2)
        createButton.Text = "Создать песун"
        createButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    end)

    showHint("Успешно загружено! Разрабы: @ner3lyy", 5)
end


createGui()


player.CharacterAdded:Connect(function()
    task.wait(1) 
    createGui()
end)
