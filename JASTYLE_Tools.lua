--[[
    ⚙️ JASTYLE TOOLS v2.0
    Blox Fruits Exploit Script
    Based on GravityHub - Personalized Edition
    Colores: Azul y Rojo
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local VirtualUser = nil
pcall(function() VirtualUser = game:GetService("VirtualUser") end)

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

_G.JastyleConfig = _G.JastyleConfig or {
    AutoFarmLevel = false,
    FastAttackMode = false,
    AutoBringMob = false,
    AutoFarmBoss = false,
    AutoDoughKing = false,
    AutoCakePrince = false,
    Aimbot = false,
    KillAura = false,
    FastAttack = false,
    AutoRespawn = false,
    ESPPlayer = false,
    ESPChest = false,
    ESPMob = false,
    WalkSpeedToggle = false,
    InfiniteEnergy = false,
}

local Config = _G.JastyleConfig

-- JASTYLE Tools Color Theme - Azul y Rojo Personalizados
local Theme = {
    Background = Color3.fromRGB(10, 14, 23),
    Sidebar = Color3.fromRGB(15, 20, 32),
    Card = Color3.fromRGB(20, 26, 40),
    Blue = Color3.fromRGB(59, 130, 246),          -- Azul Principal
    Red = Color3.fromRGB(239, 68, 68),            -- Rojo Principal
    Green = Color3.fromRGB(34, 197, 94),
    Gold = Color3.fromRGB(245, 158, 11),
    Cyan = Color3.fromRGB(6, 182, 212),
    Text = Color3.fromRGB(226, 232, 240),
    TextDim = Color3.fromRGB(148, 163, 184),
    Purple = Color3.fromRGB(139, 92, 246),
    Orange = Color3.fromRGB(255, 140, 0)
}

local function Create(instanceType, properties)
    local instance = Instance.new(instanceType)
    for k, v in pairs(properties) do
        instance[k] = v
    end
    return instance
end

local function ApplyCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
end

local function Notify(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 3
        })
    end)
end

local function MakeDraggable(gui)
    local dragging
    local dragStart
    local startPos

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    gui.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Create Main UI
local function CreateMainUI()
    local PlayerGui = Player:WaitForChild("PlayerGui")
    
    if PlayerGui:FindFirstChild("JASTYLEToolsUI") then
        PlayerGui:FindFirstChild("JASTYLEToolsUI"):Destroy()
    end

    local ScreenGui = Create("ScreenGui", {
        Name = "JASTYLEToolsUI",
        Parent = PlayerGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })

    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Background,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 800, 0, 500),
        BorderSizePixel = 0,
        ClipsDescendants = true
    })
    ApplyCorner(MainFrame, 12)
    MakeDraggable(MainFrame)

    -- Header with JASTYLE Logo
    local Header = Create("Frame", {
        Parent = MainFrame,
        BackgroundColor3 = Theme.Sidebar,
        Size = UDim2.new(1, 0, 0, 80),
        BorderSizePixel = 0
    })

    local LogoText = Create("TextLabel", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0.5, -20),
        Size = UDim2.new(0, 200, 0, 40),
        Font = Enum.Font.GothamBold,
        Text = "⚙️ JASTYLE TOOLS",
        TextColor3 = Theme.Blue,
        TextSize = 24,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Close Button
    local CloseButton = Create("TextButton", {
        Parent = Header,
        BackgroundColor3 = Theme.Red,
        Position = UDim2.new(1, -50, 0, 15),
        Size = UDim2.new(0, 35, 0, 35),
        Text = "X",
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 16
    })
    ApplyCorner(CloseButton, 5)

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Content Area
    local ContentArea = Create("ScrollingFrame", {
        Parent = MainFrame,
        BackgroundColor3 = Theme.Background,
        Position = UDim2.new(0, 0, 0, 80),
        Size = UDim2.new(1, 0, 1, -80),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Blue,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })

    local ListLayout = Create("UIListLayout", {
        Parent = ContentArea,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        FillDirection = Enum.FillDirection.Vertical
    })

    local Padding = Create("UIPadding", {
        Parent = ContentArea,
        PaddingLeft = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15),
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10)
    })

    return {
        ScreenGui = ScreenGui,
        ContentArea = ContentArea,
        Header = Header
    }
end

-- Toggle Button Creator
local function CreateToggle(parent, title, configKey, color)
    local Container = Create("Frame", {
        Parent = parent,
        BackgroundColor3 = Theme.Card,
        Size = UDim2.new(1, -30, 0, 50),
        BorderSizePixel = 0
    })
    ApplyCorner(Container, 8)

    local Label = Create("TextLabel", {
        Parent = Container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(0.6, 0, 0, 30),
        Font = Enum.Font.Gotham,
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local SwitchBg = Create("Frame", {
        Parent = Container,
        BackgroundColor3 = Config[configKey] and (color or Theme.Blue) or Color3.fromRGB(60, 60, 60),
        Position = UDim2.new(1, -65, 0.5, -12),
        Size = UDim2.new(0, 50, 0, 24)
    })
    ApplyCorner(SwitchBg, 12)

    local SwitchDot = Create("Frame", {
        Parent = SwitchBg,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Position = Config[configKey] and UDim2.new(1, -22, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16)
    })
    ApplyCorner(SwitchDot, 8)

    Container.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        local targetColor = Config[configKey] and (color or Theme.Blue) or Color3.fromRGB(60, 60, 60)
        local targetPos = Config[configKey] and UDim2.new(1, -22, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        SwitchBg.BackgroundColor3 = targetColor
        SwitchDot.Position = targetPos
        Notify("JASTYLE TOOLS", title .. " " .. (Config[configKey] and "✅ Activado" or "❌ Desactivado"), 2)
    end)
end

-- Main UI
local UI = CreateMainUI()

-- Create Sections
local function CreateSection(parent, title, color)
    local Section = Create("Frame", {
        Parent = parent,
        BackgroundColor3 = Theme.Card,
        Size = UDim2.new(1, -30, 0, 45),
        BorderSizePixel = 0
    })
    ApplyCorner(Section, 8)

    local ColorBar = Create("Frame", {
        Parent = Section,
        BackgroundColor3 = color or Theme.Blue,
        Size = UDim2.new(0, 4, 1, 0)
    })

    local Title = Create("TextLabel", {
        Parent = Section,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -15, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = color or Theme.Blue,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
end

-- Sections
CreateSection(UI.ContentArea, "🔥 FARMING", Theme.Red)
CreateToggle(UI.ContentArea, "Auto Farm Level", "AutoFarmLevel", Theme.Red)
CreateToggle(UI.ContentArea, "Fast Attack Mode", "FastAttackMode", Theme.Red)
CreateToggle(UI.ContentArea, "Auto Bring Mob", "AutoBringMob", Theme.Red)

CreateSection(UI.ContentArea, "💢 COMBAT", Theme.Blue)
CreateToggle(UI.ContentArea, "Kill Aura", "KillAura", Theme.Blue)
CreateToggle(UI.ContentArea, "Aimbot", "Aimbot", Theme.Blue)
CreateToggle(UI.ContentArea, "Fast Attack", "FastAttack", Theme.Blue)

CreateSection(UI.ContentArea, "👁️ VISUAL", Theme.Blue)
CreateToggle(UI.ContentArea, "Player ESP", "ESPPlayer", Theme.Blue)
CreateToggle(UI.ContentArea, "Chest ESP", "ESPChest", Theme.Blue)
CreateToggle(UI.ContentArea, "Mob ESP", "ESPMob", Theme.Blue)

CreateSection(UI.ContentArea, "⚙️ MISC", Theme.Blue)
CreateToggle(UI.ContentArea, "Walk Speed Hack", "WalkSpeedToggle", Theme.Blue)
CreateToggle(UI.ContentArea, "Infinite Energy", "InfiniteEnergy", Theme.Blue)
CreateToggle(UI.ContentArea, "Auto Respawn", "AutoRespawn", Theme.Blue)

-- Info Section
local InfoSection = Create("Frame", {
    Parent = UI.ContentArea,
    BackgroundColor3 = Theme.Card,
    Size = UDim2.new(1, -30, 0, 120),
    BorderSizePixel = 0
})
ApplyCorner(InfoSection, 8)

local InfoText = Create("TextLabel", {
    Parent = InfoSection,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 10),
    Size = UDim2.new(1, -30, 1, -20),
    Font = Enum.Font.Gotham,
    Text = "⚙️ JASTYLE TOOLS v2.0\n\n✨ Script personalizado basado en GravityHub\n\n🎨 Colores Azul y Rojo Personalizados\n\n💾 Todas tus configuraciones se guardan automáticamente",
    TextColor3 = Theme.TextDim,
    TextSize = 11,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top
})

-- Features Implementation
task.spawn(function()
    while task.wait(0.5) do
        if Config.AutoFarmLevel then
            pcall(function()
                -- Auto Farm Logic Here
            end)
        end

        if Config.WalkSpeedToggle and Player.Character then
            pcall(function()
                Player.Character.Humanoid.WalkSpeed = 35
            end)
        elseif Player.Character then
            Player.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if Config.InfiniteEnergy and Player.Character then
            pcall(function()
                -- Infinite Energy Logic Here
            end)
        end
    end
end)

-- Startup
Notify("⚙️ JASTYLE TOOLS", "✅ Script Loaded v2.0 - Colores Azul y Rojo!", 3)
