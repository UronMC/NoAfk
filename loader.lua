-- Anti-AFK Script with Modern GUI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AntiAFK_GUI"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.2
frame.Parent = gui
frame.Active = true
frame.Draggable = true

-- Rounded corners
local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 15)
uicorner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Anti-AFK"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = frame

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Position = UDim2.new(0, 10, 0, 40)
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Inactive"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame

-- Last Action Label
local lastActionLabel = Instance.new("TextLabel")
lastActionLabel.Position = UDim2.new(0, 10, 0, 65)
lastActionLabel.Size = UDim2.new(1, -20, 0, 20)
lastActionLabel.BackgroundTransparency = 1
lastActionLabel.Text = "Last Action: N/A"
lastActionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
lastActionLabel.Font = Enum.Font.Gotham
lastActionLabel.TextSize = 14
lastActionLabel.TextXAlignment = Enum.TextXAlignment.Left
lastActionLabel.Parent = frame

-- Action Count Label
local actionCountLabel = Instance.new("TextLabel")
actionCountLabel.Position = UDim2.new(0, 10, 0, 90)
actionCountLabel.Size = UDim2.new(1, -20, 0, 20)
actionCountLabel.BackgroundTransparency = 1
actionCountLabel.Text = "Actions Performed: 0"
actionCountLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
actionCountLabel.Font = Enum.Font.Gotham
actionCountLabel.TextSize = 14
actionCountLabel.TextXAlignment = Enum.TextXAlignment.Left
actionCountLabel.Parent = frame

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Position = UDim2.new(0, 10, 1, -40)
toggleButton.Size = UDim2.new(0.5, -15, 0, 30)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
toggleButton.Text = "Enable"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14
toggleButton.Parent = frame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggleButton

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Position = UDim2.new(0.5, 5, 1, -40)
closeButton.Size = UDim2.new(0.5, -15, 0, 30)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "Close"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeButton

-- Anti-AFK Logic
local antiAFKEnabled = false
local actionCount = 0
local lastActionTime = "N/A"

local function updateStatus()
    statusLabel.Text = "Status: " .. (antiAFKEnabled and "Active" or "Inactive")
    lastActionLabel.Text = "Last Action: " .. lastActionTime
    actionCountLabel.Text = "Actions Performed: " .. actionCount
end

local function performAction()
    -- Simulate activity
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())

    -- Move character slightly
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.MoveTo then
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local currentPosition = rootPart.Position
            local newPosition = currentPosition + Vector3.new(0, 0, 1)
            humanoid:MoveTo(newPosition)
        end
    end

    -- Update info
    actionCount = actionCount + 1
    lastActionTime = os.date("%H:%M:%S")
    updateStatus()
end

local antiAFKConnection

toggleButton.MouseButton1Click:Connect(function()
    antiAFKEnabled = not antiAFKEnabled
    toggleButton.Text = antiAFKEnabled and "Disable" or "Enable"
    updateStatus()

    if antiAFKEnabled then
        antiAFKConnection = RunService.Heartbeat:Connect(function(step)
            performAction()
            wait(60) -- Perform action every 60 seconds
        end)
    else
        if antiAFKConnection then
            antiAFKConnection:Disconnect()
            antiAFKConnection = nil
        end
    end
end)

closeButton.MouseButton1Click:Connect(function()
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
    end
    gui:Destroy()
end)

-- Initial status update
updateStatus()
