local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "NoAFKGui"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0.5, -150, 0.7, -125)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.Name = "MainFrame"
frame.ZIndex = 5
frame:TweenSize(UDim2.new(0, 300, 0, 250), "Out", "Back", 0.3, true)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "NoAFK Control"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.TextSize = 20

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.8, 0, 0, 40)
toggle.Position = UDim2.new(0.1, 0, 0, 50)
toggle.Text = "Включить NoAFK"
toggle.Font = Enum.Font.Gotham
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggle.TextSize = 18
toggle.BorderSizePixel = 0
toggle.AutoButtonColor = true

local musicToggle = Instance.new("TextButton", frame)
musicToggle.Size = UDim2.new(0.8, 0, 0, 40)
musicToggle.Position = UDim2.new(0.1, 0, 0, 100)
musicToggle.Text = "Музыка: ВЫКЛ"
musicToggle.Font = Enum.Font.Gotham
musicToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
musicToggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
musicToggle.TextSize = 18
musicToggle.BorderSizePixel = 0

local styleToggle = Instance.new("TextButton", frame)
styleToggle.Size = UDim2.new(0.8, 0, 0, 40)
styleToggle.Position = UDim2.new(0.1, 0, 0, 150)
styleToggle.Text = "Тема: Тёмная"
styleToggle.Font = Enum.Font.Gotham
styleToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
styleToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
styleToggle.TextSize = 18
styleToggle.BorderSizePixel = 0

local author = Instance.new("TextLabel", frame)
author.Text = "Автор: @Plablogx (TG)"
author.Size = UDim2.new(1, 0, 0, 30)
author.Position = UDim2.new(0, 0, 1, -30)
author.BackgroundTransparency = 1
author.TextColor3 = Color3.fromRGB(180, 180, 180)
author.TextSize = 14
author.Font = Enum.Font.Gotham

-- Music setup
local music = Instance.new("Sound", SoundService)
music.SoundId = "rbxassetid://1843523604" -- chill beat
music.Volume = 1
music.Looped = true

-- Notification function
local function notify(msg)
	StarterGui:SetCore("SendNotification", {
		Title = "NoAFK",
		Text = msg,
		Duration = 3
	})
end

-- Movement logic
local running = false
local radius = 10
local step = 0

RunService.Heartbeat:Connect(function(dt)
	if running and character and character:FindFirstChild("HumanoidRootPart") then
		step += dt * 1.5
		local offset = Vector3.new(math.cos(step) * radius, 0, math.sin(step) * radius)
		character:MoveTo(character:GetPivot().Position + offset)
	end
end)

-- Toggles
toggle.MouseButton1Click:Connect(function()
	running = not running
	toggle.Text = running and "Остановить NoAFK" or "Включить NoAFK"
	toggle.BackgroundColor3 = running and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
	notify(running and "AFK отключено: вы двигаетесь" or "AFK включено")
	print("AFK: ", running and "ON" or "OFF")
end)

musicToggle.MouseButton1Click:Connect(function()
	if music.IsPlaying then
		music:Stop()
		musicToggle.Text = "Музыка: ВЫКЛ"
	else
		music:Play()
		musicToggle.Text = "Музыка: ВКЛ"
	end
end)

styleToggle.MouseButton1Click:Connect(function()
	local isDark = frame.BackgroundColor3 == Color3.fromRGB(30, 30, 30)
	frame.BackgroundColor3 = isDark and Color3.fromRGB(240, 240, 240) or Color3.fromRGB(30, 30, 30)
	title.TextColor3 = isDark and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
	toggle.TextColor3 = isDark and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
	musicToggle.TextColor3 = toggle.TextColor3
	styleToggle.Text = isDark and "Тема: Светлая" or "Тема: Тёмная"
	notify("Тема изменена")
end)
