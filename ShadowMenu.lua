-- Shadow Menu [PVP] - Roblox LocalScript
-- Replicates the reference UI with ESP / AIMBOT tabs

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ══════════════════════════════════════════
-- STATE
-- ══════════════════════════════════════════
local state = {
    currentTab = "AIMBOT",  -- active tab
    toggles = {
        AIMLOCK  = false,
        WALLCK   = false,
        SHOWFOV  = false,
    },
    fov = 70,
}

-- ══════════════════════════════════════════
-- SCREEN GUI
-- ══════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShadowMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- ══════════════════════════════════════════
-- MAIN FRAME
-- ══════════════════════════════════════════
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 310)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- ══════════════════════════════════════════
-- HEADER BAR
-- ══════════════════════════════════════════
local HeaderBar = Instance.new("Frame")
HeaderBar.Name = "HeaderBar"
HeaderBar.Size = UDim2.new(1, 0, 0, 52)
HeaderBar.Position = UDim2.new(0, 0, 0, 0)
HeaderBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
HeaderBar.BorderSizePixel = 0
HeaderBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(0, 220, 1, 0)
TitleLabel.Position = UDim2.new(0, 18, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "SHADOW MENU  [PVP]"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 17
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = HeaderBar

local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(0, 190, 1, 0)
TabContainer.Position = UDim2.new(1, -200, 0, 0)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = HeaderBar

-- ESP Tab Button — white (inactive at start)
local BtnESP = Instance.new("TextButton")
BtnESP.Name = "BtnESP"
BtnESP.Size = UDim2.new(0, 80, 1, 0)
BtnESP.Position = UDim2.new(0, 0, 0, 0)
BtnESP.BackgroundTransparency = 1
BtnESP.Text = "ESP"
BtnESP.TextSize = 18
BtnESP.Font = Enum.Font.GothamBold
BtnESP.TextColor3 = Color3.fromRGB(255, 255, 255)  -- white = inactive
BtnESP.Parent = TabContainer

-- AIMBOT Tab Button — purple (active at start)
local BtnAIMBOT = Instance.new("TextButton")
BtnAIMBOT.Name = "BtnAIMBOT"
BtnAIMBOT.Size = UDim2.new(0, 100, 1, 0)
BtnAIMBOT.Position = UDim2.new(0, 85, 0, 0)
BtnAIMBOT.BackgroundTransparency = 1
BtnAIMBOT.Text = "AIMBOT"
BtnAIMBOT.TextSize = 18
BtnAIMBOT.Font = Enum.Font.GothamBold
BtnAIMBOT.TextColor3 = Color3.fromRGB(170, 80, 255)  -- purple = active
BtnAIMBOT.Parent = TabContainer

-- Divider line under header
local Divider = Instance.new("Frame")
Divider.Name = "Divider"
Divider.Size = UDim2.new(1, 0, 0, 1)
Divider.Position = UDim2.new(0, 0, 0, 52)
Divider.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

-- ══════════════════════════════════════════
-- CONTENT AREA
-- ══════════════════════════════════════════
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, 0, 1, -53)
ContentArea.Position = UDim2.new(0, 0, 0, 53)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

-- ══════════════════════════════════════════
-- HELPER: CREATE TOGGLE ROW
-- ══════════════════════════════════════════
local function createToggle(parent, labelText, yPos, toggleKey)
    local Row = Instance.new("Frame")
    Row.Name = "Row_" .. toggleKey
    Row.Size = UDim2.new(1, -40, 0, 30)  -- row height reduced
    Row.Position = UDim2.new(0, 20, 0, yPos)
    Row.BackgroundTransparency = 1
    Row.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 140, 1, 0)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 16
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local ToggleBG = Instance.new("Frame")
    ToggleBG.Name = "ToggleBG"
    ToggleBG.Size = UDim2.new(0, 52, 0, 26)
    ToggleBG.Position = UDim2.new(0, 148, 0.5, -13)
    ToggleBG.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    ToggleBG.BorderSizePixel = 0
    ToggleBG.Parent = Row

    local BGCorner = Instance.new("UICorner")
    BGCorner.CornerRadius = UDim.new(1, 0)
    BGCorner.Parent = ToggleBG

    local Knob = Instance.new("Frame")
    Knob.Name = "Knob"
    Knob.Size = UDim2.new(0, 20, 0, 20)
    Knob.Position = UDim2.new(0, 3, 0.5, -10)
    Knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Knob.BorderSizePixel = 0
    Knob.Parent = ToggleBG

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local ClickBtn = Instance.new("TextButton")
    ClickBtn.Size = UDim2.new(1, 0, 1, 0)
    ClickBtn.Position = UDim2.new(0, 0, 0, 0)
    ClickBtn.BackgroundTransparency = 1
    ClickBtn.Text = ""
    ClickBtn.Parent = Row

    local function refreshToggle()
        local on = state.toggles[toggleKey]
        if on then
            ToggleBG.BackgroundColor3 = Color3.fromRGB(120, 60, 220)
            Knob.Position = UDim2.new(0, 29, 0.5, -10)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            ToggleBG.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            Knob.Position = UDim2.new(0, 3, 0.5, -10)
            Knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        end
    end

    ClickBtn.MouseButton1Click:Connect(function()
        state.toggles[toggleKey] = not state.toggles[toggleKey]
        refreshToggle()
    end)

    refreshToggle()
    return Row
end

-- ══════════════════════════════════════════
-- AIMBOT TAB CONTENT
-- Spacing reduzido 25%: era 60px entre itens → agora 45px
-- Posições: 15, 60, 105 (início + 45 cada)
-- ══════════════════════════════════════════
local AimbotTab = Instance.new("Frame")
AimbotTab.Name = "AimbotTab"
AimbotTab.Size = UDim2.new(1, 0, 1, 0)
AimbotTab.BackgroundTransparency = 1
AimbotTab.Visible = true
AimbotTab.Parent = ContentArea

createToggle(AimbotTab, "AIMLOCK",  15, "AIMLOCK")
createToggle(AimbotTab, "WALLCK",   60, "WALLCK")
createToggle(AimbotTab, "SHOWFOV", 105, "SHOWFOV")

-- FOV CONFIG label (posição ajustada ao novo espaçamento)
local FovLabel = Instance.new("TextLabel")
FovLabel.Name = "FovLabel"
FovLabel.Size = UDim2.new(0, 300, 0, 30)
FovLabel.Position = UDim2.new(0, 20, 0, 152)
FovLabel.BackgroundTransparency = 1
FovLabel.Text = "FOV CONFIG"
FovLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FovLabel.TextSize = 17
FovLabel.Font = Enum.Font.GothamBold
FovLabel.TextXAlignment = Enum.TextXAlignment.Left
FovLabel.Parent = AimbotTab

-- FOV Slider track
local SliderTrack = Instance.new("Frame")
SliderTrack.Name = "SliderTrack"
SliderTrack.Size = UDim2.new(0, 300, 0, 6)
SliderTrack.Position = UDim2.new(0, 20, 0, 192)
SliderTrack.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
SliderTrack.BorderSizePixel = 0
SliderTrack.Parent = AimbotTab

local TrackCorner = Instance.new("UICorner")
TrackCorner.CornerRadius = UDim.new(1, 0)
TrackCorner.Parent = SliderTrack

local SliderFill = Instance.new("Frame")
SliderFill.Name = "SliderFill"
SliderFill.Size = UDim2.new(state.fov / 180, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderTrack

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = SliderFill

-- Slider drag logic
local dragging = false
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

SliderTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local mouseX = UIS:GetMouseLocation().X
        local trackPos = SliderTrack.AbsolutePosition.X
        local trackWidth = SliderTrack.AbsoluteSize.X
        local ratio = math.clamp((mouseX - trackPos) / trackWidth, 0, 1)
        state.fov = math.floor(ratio * 180)
        SliderFill.Size = UDim2.new(ratio, 0, 1, 0)
    end
end)

-- ══════════════════════════════════════════
-- ESP TAB CONTENT
-- ══════════════════════════════════════════
local EspTab = Instance.new("Frame")
EspTab.Name = "EspTab"
EspTab.Size = UDim2.new(1, 0, 1, 0)
EspTab.BackgroundTransparency = 1
EspTab.Visible = false
EspTab.Parent = ContentArea

-- Reutiliza createToggle para a aba ESP, mas precisamos de state.toggles separado
-- Adicionamos as chaves ESP no state
state.toggles.ESP_NAME  = false
state.toggles.ESP_BOX   = false
state.toggles.ESP_TRACE = false
state.toggles.ESP_RAGE  = false
state.toggles.ESP_LIFE  = false
state.toggles.ESP_HEAD  = false

-- ── Coluna ESQUERDA ────────────────────────
-- ESP NAME (y=15), ESP BOX (y=60), ESP TRACE (y=105), ESP RAGE (y=150), ESP LIFE (y=195)
local espLeftItems = {
    { label = "ESP NAME",  key = "ESP_NAME",  y = 15  },
    { label = "ESP BOX",   key = "ESP_BOX",   y = 60  },
    { label = "ESP TRACE", key = "ESP_TRACE", y = 105 },
    { label = "ESP RAGE",  key = "ESP_RAGE",  y = 150 },
    { label = "ESP LIFE",  key = "ESP_LIFE",  y = 195 },
}

for _, item in ipairs(espLeftItems) do
    createToggle(EspTab, item.label, item.y, item.key)
end

-- ── Coluna DIREITA ─────────────────────────
-- ESP HEAD (y=15), ESP COLOR / HEX (y=60), Em breve x3 (y=105,150,195)

-- ESP HEAD toggle
state.toggles.ESP_HEAD = false
local function createToggleRight(parent, labelText, yPos, toggleKey)
    local Row = Instance.new("Frame")
    Row.Name = "Row_" .. toggleKey
    Row.Size = UDim2.new(0, 220, 0, 30)
    Row.Position = UDim2.new(0, 260, 0, yPos)
    Row.BackgroundTransparency = 1
    Row.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 110, 1, 0)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 16
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local ToggleBG = Instance.new("Frame")
    ToggleBG.Name = "ToggleBG"
    ToggleBG.Size = UDim2.new(0, 52, 0, 26)
    ToggleBG.Position = UDim2.new(0, 115, 0.5, -13)
    ToggleBG.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    ToggleBG.BorderSizePixel = 0
    ToggleBG.Parent = Row

    local BGCorner = Instance.new("UICorner")
    BGCorner.CornerRadius = UDim.new(1, 0)
    BGCorner.Parent = ToggleBG

    local Knob = Instance.new("Frame")
    Knob.Name = "Knob"
    Knob.Size = UDim2.new(0, 20, 0, 20)
    Knob.Position = UDim2.new(0, 3, 0.5, -10)
    Knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Knob.BorderSizePixel = 0
    Knob.Parent = ToggleBG

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local ClickBtn = Instance.new("TextButton")
    ClickBtn.Size = UDim2.new(1, 0, 1, 0)
    ClickBtn.BackgroundTransparency = 1
    ClickBtn.Text = ""
    ClickBtn.Parent = Row

    local function refreshToggle()
        local on = state.toggles[toggleKey]
        if on then
            ToggleBG.BackgroundColor3 = Color3.fromRGB(120, 60, 220)
            Knob.Position = UDim2.new(0, 29, 0.5, -10)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            ToggleBG.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            Knob.Position = UDim2.new(0, 3, 0.5, -10)
            Knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        end
    end

    ClickBtn.MouseButton1Click:Connect(function()
        state.toggles[toggleKey] = not state.toggles[toggleKey]
        refreshToggle()
    end)

    refreshToggle()
    return Row
end

-- ESP HEAD
createToggleRight(EspTab, "ESP HEAD", 15, "ESP_HEAD")

-- ESP COLOR (input HEX — mesmo padrão do FOVCOLOR)
local EspColorRow = Instance.new("Frame")
EspColorRow.Name = "Row_ESPCOLOR"
EspColorRow.Size = UDim2.new(0, 220, 0, 30)
EspColorRow.Position = UDim2.new(0, 260, 0, 60)
EspColorRow.BackgroundTransparency = 1
EspColorRow.Parent = EspTab

local EspColorLabel = Instance.new("TextLabel")
EspColorLabel.Size = UDim2.new(0, 110, 1, 0)
EspColorLabel.BackgroundTransparency = 1
EspColorLabel.Text = "ESP COLOR"
EspColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
EspColorLabel.TextSize = 16
EspColorLabel.Font = Enum.Font.GothamBold
EspColorLabel.TextXAlignment = Enum.TextXAlignment.Left
EspColorLabel.Parent = EspColorRow

local EspColorPreviewBG = Instance.new("Frame")
EspColorPreviewBG.Name = "EspColorPreviewBG"
EspColorPreviewBG.Size = UDim2.new(0, 52, 0, 26)
EspColorPreviewBG.Position = UDim2.new(0, 115, 0.5, -13)
EspColorPreviewBG.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
EspColorPreviewBG.BorderSizePixel = 0
EspColorPreviewBG.Parent = EspColorRow

local EspColorPreviewCorner = Instance.new("UICorner")
EspColorPreviewCorner.CornerRadius = UDim.new(1, 0)
EspColorPreviewCorner.Parent = EspColorPreviewBG

local EspHexInput = Instance.new("TextBox")
EspHexInput.Name = "EspHexInput"
EspHexInput.Size = UDim2.new(0, 90, 0, 22)
EspHexInput.Position = UDim2.new(0, 115, 0.5, -11)
EspHexInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
EspHexInput.BorderSizePixel = 0
EspHexInput.Text = "#FFFFFF"
EspHexInput.TextColor3 = Color3.fromRGB(255, 255, 255)
EspHexInput.PlaceholderText = "#RRGGBB"
EspHexInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
EspHexInput.TextSize = 12
EspHexInput.Font = Enum.Font.GothamBold
EspHexInput.ClearTextOnFocus = false
EspHexInput.Visible = false
EspHexInput.ZIndex = 10
EspHexInput.Parent = EspColorRow

local EspHexInputCorner = Instance.new("UICorner")
EspHexInputCorner.CornerRadius = UDim.new(0, 4)
EspHexInputCorner.Parent = EspHexInput

EspHexInput.FocusLost:Connect(function()
    local hex = EspHexInput.Text:gsub("#", "")
    if #hex == 6 then
        local r = tonumber(hex:sub(1,2), 16)
        local g = tonumber(hex:sub(3,4), 16)
        local b = tonumber(hex:sub(5,6), 16)
        if r and g and b then
            EspColorPreviewBG.BackgroundColor3 = Color3.fromRGB(r, g, b)
            state.espColor = EspHexInput.Text
        else
            EspHexInput.Text = state.espColor or "#FFFFFF"
        end
    else
        EspHexInput.Text = state.espColor or "#FFFFFF"
    end
    EspHexInput.Visible = false
    EspColorPreviewBG.Visible = true
end)

local EspColorBtn = Instance.new("TextButton")
EspColorBtn.Size = UDim2.new(0, 52, 0, 26)
EspColorBtn.Position = UDim2.new(0, 115, 0.5, -13)
EspColorBtn.BackgroundTransparency = 1
EspColorBtn.Text = ""
EspColorBtn.ZIndex = 5
EspColorBtn.Parent = EspColorRow

EspColorBtn.MouseButton1Click:Connect(function()
    EspColorPreviewBG.Visible = false
    EspHexInput.Visible = true
    EspHexInput:CaptureFocus()
end)

state.espColor = "#FFFFFF"

-- ── Em breve x3 (coluna direita, y=105, 150, 195) ──
local breveTags = { 105, 150, 195 }
for _, yPos in ipairs(breveTags) do
    local BreveRow = Instance.new("Frame")
    BreveRow.Size = UDim2.new(0, 220, 0, 30)
    BreveRow.Position = UDim2.new(0, 260, 0, yPos)
    BreveRow.BackgroundTransparency = 1
    BreveRow.Parent = EspTab

    local BreveLabel = Instance.new("TextLabel")
    BreveLabel.Size = UDim2.new(0, 110, 1, 0)
    BreveLabel.BackgroundTransparency = 1
    BreveLabel.Text = "Em breve"
    BreveLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
    BreveLabel.TextSize = 14
    BreveLabel.Font = Enum.Font.Gotham
    BreveLabel.TextXAlignment = Enum.TextXAlignment.Left
    BreveLabel.Parent = BreveRow

    -- Toggle visual desabilitado (apenas decorativo)
    local BreveBG = Instance.new("Frame")
    BreveBG.Size = UDim2.new(0, 52, 0, 26)
    BreveBG.Position = UDim2.new(0, 115, 0.5, -13)
    BreveBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    BreveBG.BorderSizePixel = 0
    BreveBG.Parent = BreveRow

    local BreveCorner = Instance.new("UICorner")
    BreveCorner.CornerRadius = UDim.new(1, 0)
    BreveCorner.Parent = BreveBG

    local BreveKnob = Instance.new("Frame")
    BreveKnob.Size = UDim2.new(0, 20, 0, 20)
    BreveKnob.Position = UDim2.new(0, 3, 0.5, -10)
    BreveKnob.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    BreveKnob.BorderSizePixel = 0
    BreveKnob.Parent = BreveBG

    local BreveKnobCorner = Instance.new("UICorner")
    BreveKnobCorner.CornerRadius = UDim.new(1, 0)
    BreveKnobCorner.Parent = BreveKnob
end

-- ══════════════════════════════════════════
-- TAB SWITCHING LOGIC
-- Aba ativa = ROXA | Aba inativa = BRANCA
-- ══════════════════════════════════════════
local function switchTab(tab)
    state.currentTab = tab
    if tab == "ESP" then
        EspTab.Visible = true
        AimbotTab.Visible = false
        -- ESP ativo = roxo | AIMBOT inativo = branco
        BtnESP.TextColor3 = Color3.fromRGB(170, 80, 255)
        BtnAIMBOT.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        EspTab.Visible = false
        AimbotTab.Visible = true
        -- AIMBOT ativo = roxo | ESP inativo = branco
        BtnAIMBOT.TextColor3 = Color3.fromRGB(170, 80, 255)
        BtnESP.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

BtnESP.MouseButton1Click:Connect(function() switchTab("ESP") end)
BtnAIMBOT.MouseButton1Click:Connect(function() switchTab("AIMBOT") end)

-- ══════════════════════════════════════════
-- TOGGLE MENU VISIBILITY (INSERT key)
-- ══════════════════════════════════════════
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("[ShadowMenu] Loaded. Press INSERT to toggle.")

-- ══════════════════════════════════════════
-- COLUNA DIREITA — FOVCOLOR + FIRELOCK
-- Alinhadas ao lado direito do AimbotTab
-- X offset: 260 (metade direita do frame)
-- Mesmas posições Y dos toggles da esquerda: 15 e 60
-- ══════════════════════════════════════════

-- ── FOVCOLOR (input de cor HTML) ──────────
local FovColorRow = Instance.new("Frame")
FovColorRow.Name = "Row_FOVCOLOR"
FovColorRow.Size = UDim2.new(0, 220, 0, 30)
FovColorRow.Position = UDim2.new(0, 260, 0, 15)
FovColorRow.BackgroundTransparency = 1
FovColorRow.Parent = AimbotTab

local FovColorLabel = Instance.new("TextLabel")
FovColorLabel.Size = UDim2.new(0, 110, 1, 0)
FovColorLabel.Position = UDim2.new(0, 0, 0, 0)
FovColorLabel.BackgroundTransparency = 1
FovColorLabel.Text = "FOVCOLOR"
FovColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FovColorLabel.TextSize = 16
FovColorLabel.Font = Enum.Font.GothamBold
FovColorLabel.TextXAlignment = Enum.TextXAlignment.Left
FovColorLabel.Parent = FovColorRow

-- Caixa de preview de cor (pill igual ao toggle, mas é só visual)
local FovColorPreviewBG = Instance.new("Frame")
FovColorPreviewBG.Name = "FovColorPreviewBG"
FovColorPreviewBG.Size = UDim2.new(0, 52, 0, 26)
FovColorPreviewBG.Position = UDim2.new(0, 115, 0.5, -13)
FovColorPreviewBG.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
FovColorPreviewBG.BorderSizePixel = 0
FovColorPreviewBG.Parent = FovColorRow

local FovColorPreviewCorner = Instance.new("UICorner")
FovColorPreviewCorner.CornerRadius = UDim.new(1, 0)
FovColorPreviewCorner.Parent = FovColorPreviewBG

-- Input de texto para código HEX (abre ao clicar no preview)
-- Usamos um TextBox oculto que fica ativo quando o usuário clica
local HexInput = Instance.new("TextBox")
HexInput.Name = "HexInput"
HexInput.Size = UDim2.new(0, 90, 0, 22)
HexInput.Position = UDim2.new(0, 115, 0.5, -11)
HexInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
HexInput.BorderSizePixel = 0
HexInput.Text = "#FFFFFF"
HexInput.TextColor3 = Color3.fromRGB(255, 255, 255)
HexInput.PlaceholderText = "#RRGGBB"
HexInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
HexInput.TextSize = 12
HexInput.Font = Enum.Font.GothamBold
HexInput.ClearTextOnFocus = false
HexInput.Visible = false
HexInput.ZIndex = 10
HexInput.Parent = FovColorRow

local HexInputCorner = Instance.new("UICorner")
HexInputCorner.CornerRadius = UDim.new(0, 4)
HexInputCorner.Parent = HexInput

-- Função: converte HEX string → Color3
local function hexToColor3(hex)
    hex = hex:gsub("#", "")
    if #hex ~= 6 then return nil end
    local r = tonumber(hex:sub(1,2), 16)
    local g = tonumber(hex:sub(3,4), 16)
    local b = tonumber(hex:sub(5,6), 16)
    if not (r and g and b) then return nil end
    return Color3.fromRGB(r, g, b)
end

-- Aplica a cor do HEX no preview quando o usuário termina de digitar
HexInput.FocusLost:Connect(function()
    local color = hexToColor3(HexInput.Text)
    if color then
        FovColorPreviewBG.BackgroundColor3 = color
        state.fovColor = HexInput.Text
    else
        -- HEX inválido: volta ao cinza e reseta o texto
        HexInput.Text = state.fovColor or "#FFFFFF"
    end
    HexInput.Visible = false
    FovColorPreviewBG.Visible = true
end)

-- Clique no preview → abre o input
local FovColorBtn = Instance.new("TextButton")
FovColorBtn.Size = UDim2.new(0, 52, 0, 26)
FovColorBtn.Position = UDim2.new(0, 115, 0.5, -13)
FovColorBtn.BackgroundTransparency = 1
FovColorBtn.Text = ""
FovColorBtn.ZIndex = 5
FovColorBtn.Parent = FovColorRow

FovColorBtn.MouseButton1Click:Connect(function()
    FovColorPreviewBG.Visible = false
    HexInput.Visible = true
    HexInput:CaptureFocus()
end)

state.fovColor = "#FFFFFF"

-- ── FIRELOCK (seletor de parte do corpo) ──
local FireLockRow = Instance.new("Frame")
FireLockRow.Name = "Row_FIRELOCK"
FireLockRow.Size = UDim2.new(0, 220, 0, 30)
FireLockRow.Position = UDim2.new(0, 260, 0, 60)
FireLockRow.BackgroundTransparency = 1
FireLockRow.Parent = AimbotTab

local FireLockLabel = Instance.new("TextLabel")
FireLockLabel.Size = UDim2.new(0, 110, 1, 0)
FireLockLabel.Position = UDim2.new(0, 0, 0, 0)
FireLockLabel.BackgroundTransparency = 1
FireLockLabel.Text = "FIRELOCK"
FireLockLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FireLockLabel.TextSize = 16
FireLockLabel.Font = Enum.Font.GothamBold
FireLockLabel.TextXAlignment = Enum.TextXAlignment.Left
FireLockLabel.Parent = FireLockRow

-- Partes do corpo disponíveis
local bodyParts = {"Head", "Torso", "Foot"}
local selectedPart = 1  -- Head por padrão

-- Container pill para os 3 botões de parte do corpo
local PartSelectorBG = Instance.new("Frame")
PartSelectorBG.Name = "PartSelectorBG"
PartSelectorBG.Size = UDim2.new(0, 120, 0, 26)
PartSelectorBG.Position = UDim2.new(0, 115, 0.5, -13)
PartSelectorBG.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
PartSelectorBG.BorderSizePixel = 0
PartSelectorBG.Parent = FireLockRow

local PartSelectorCorner = Instance.new("UICorner")
PartSelectorCorner.CornerRadius = UDim.new(1, 0)
PartSelectorCorner.Parent = PartSelectorBG

-- Layout horizontal dentro do pill
local PartLayout = Instance.new("UIListLayout")
PartLayout.FillDirection = Enum.FillDirection.Horizontal
PartLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
PartLayout.VerticalAlignment = Enum.VerticalAlignment.Center
PartLayout.Padding = UDim.new(0, 2)
PartLayout.Parent = PartSelectorBG

local partButtons = {}

local function refreshPartButtons()
    for i, btn in ipairs(partButtons) do
        if i == selectedPart then
            btn.TextColor3 = Color3.fromRGB(170, 80, 255)  -- roxo = selecionado
            btn.Font = Enum.Font.GothamBold
        else
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            btn.Font = Enum.Font.Gotham
        end
    end
end

for i, partName in ipairs(bodyParts) do
    local PartBtn = Instance.new("TextButton")
    PartBtn.Name = "Part_" .. partName
    PartBtn.Size = UDim2.new(0, 36, 0, 22)
    PartBtn.BackgroundTransparency = 1
    PartBtn.Text = partName
    PartBtn.TextSize = 10
    PartBtn.Font = Enum.Font.Gotham
    PartBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    PartBtn.Parent = PartSelectorBG

    local idx = i
    PartBtn.MouseButton1Click:Connect(function()
        selectedPart = idx
        state.firelockPart = partName
        refreshPartButtons()
    end)

    table.insert(partButtons, PartBtn)
end

state.firelockPart = "Head"
refreshPartButtons()


