-- Shadow Menu [PVP] - Roblox LocalScript
-- ESP reescrito com Drawing API (GPU-rendered, sem deriva)

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")
local Camera      = workspace.CurrentCamera

-- ══════════════════════════════════════════
-- STATE
-- ══════════════════════════════════════════
local state = {
    currentTab = "AIMBOT",
    toggles = {
        AIMLOCK  = false,
        WALLCK   = false,
        SHOWFOV  = false,
        ESP_NAME  = false,
        ESP_BOX   = false,
        ESP_TRACE = false,
        ESP_RAGE  = false,
        ESP_LIFE  = false,
        ESP_HEAD  = false,
    },
    fov          = 70,
    fovColor     = "#FFFFFF",
    espColor     = "#00FF00",
    firelockPart = "Head",
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

local BtnESP = Instance.new("TextButton")
BtnESP.Name = "BtnESP"
BtnESP.Size = UDim2.new(0, 80, 1, 0)
BtnESP.Position = UDim2.new(0, 0, 0, 0)
BtnESP.BackgroundTransparency = 1
BtnESP.Text = "ESP"
BtnESP.TextSize = 18
BtnESP.Font = Enum.Font.GothamBold
BtnESP.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnESP.Parent = TabContainer

local BtnAIMBOT = Instance.new("TextButton")
BtnAIMBOT.Name = "BtnAIMBOT"
BtnAIMBOT.Size = UDim2.new(0, 100, 1, 0)
BtnAIMBOT.Position = UDim2.new(0, 85, 0, 0)
BtnAIMBOT.BackgroundTransparency = 1
BtnAIMBOT.Text = "AIMBOT"
BtnAIMBOT.TextSize = 18
BtnAIMBOT.Font = Enum.Font.GothamBold
BtnAIMBOT.TextColor3 = Color3.fromRGB(170, 80, 255)
BtnAIMBOT.Parent = TabContainer

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
    Row.Size = UDim2.new(1, -40, 0, 30)
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
-- AIMBOT TAB
-- ══════════════════════════════════════════
local AimbotTab = Instance.new("Frame")
AimbotTab.Name = "AimbotTab"
AimbotTab.Size = UDim2.new(1, 0, 1, 0)
AimbotTab.BackgroundTransparency = 1
AimbotTab.Visible = true
AimbotTab.Parent = ContentArea

createToggle(AimbotTab, "AIMLOCK",  15,  "AIMLOCK")
createToggle(AimbotTab, "WALLCK",   60,  "WALLCK")
createToggle(AimbotTab, "SHOWFOV",  105, "SHOWFOV")

local FovLabel = Instance.new("TextLabel")
FovLabel.Size = UDim2.new(0, 300, 0, 30)
FovLabel.Position = UDim2.new(0, 20, 0, 152)
FovLabel.BackgroundTransparency = 1
FovLabel.Text = "FOV CONFIG"
FovLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FovLabel.TextSize = 17
FovLabel.Font = Enum.Font.GothamBold
FovLabel.TextXAlignment = Enum.TextXAlignment.Left
FovLabel.Parent = AimbotTab

local SliderTrack = Instance.new("Frame")
SliderTrack.Size = UDim2.new(0, 300, 0, 6)
SliderTrack.Position = UDim2.new(0, 20, 0, 192)
SliderTrack.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
SliderTrack.BorderSizePixel = 0
SliderTrack.Parent = AimbotTab
Instance.new("UICorner", SliderTrack).CornerRadius = UDim.new(1, 0)

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(state.fov / 180, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderTrack
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

local sliderDragging = false
SliderTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = false
    end
end)

-- FOVCOLOR
local FovColorRow = Instance.new("Frame")
FovColorRow.Size = UDim2.new(0, 220, 0, 30)
FovColorRow.Position = UDim2.new(0, 260, 0, 15)
FovColorRow.BackgroundTransparency = 1
FovColorRow.Parent = AimbotTab

local FovColorLabel = Instance.new("TextLabel")
FovColorLabel.Size = UDim2.new(0, 110, 1, 0)
FovColorLabel.BackgroundTransparency = 1
FovColorLabel.Text = "FOVCOLOR"
FovColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FovColorLabel.TextSize = 16
FovColorLabel.Font = Enum.Font.GothamBold
FovColorLabel.TextXAlignment = Enum.TextXAlignment.Left
FovColorLabel.Parent = FovColorRow

local FovColorPreviewBG = Instance.new("Frame")
FovColorPreviewBG.Size = UDim2.new(0, 52, 0, 26)
FovColorPreviewBG.Position = UDim2.new(0, 115, 0.5, -13)
FovColorPreviewBG.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
FovColorPreviewBG.BorderSizePixel = 0
FovColorPreviewBG.Parent = FovColorRow
Instance.new("UICorner", FovColorPreviewBG).CornerRadius = UDim.new(1, 0)

local HexInput = Instance.new("TextBox")
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
Instance.new("UICorner", HexInput).CornerRadius = UDim.new(0, 4)

local function hexToColor3(hex)
    hex = hex:gsub("#", "")
    if #hex ~= 6 then return nil end
    local r = tonumber(hex:sub(1,2), 16)
    local g = tonumber(hex:sub(3,4), 16)
    local b = tonumber(hex:sub(5,6), 16)
    if not (r and g and b) then return nil end
    return Color3.fromRGB(r, g, b)
end

HexInput.FocusLost:Connect(function()
    local color = hexToColor3(HexInput.Text)
    if color then
        FovColorPreviewBG.BackgroundColor3 = color
        state.fovColor = HexInput.Text
    else
        HexInput.Text = state.fovColor or "#FFFFFF"
    end
    HexInput.Visible = false
    FovColorPreviewBG.Visible = true
end)

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

-- FIRELOCK
local FireLockRow = Instance.new("Frame")
FireLockRow.Size = UDim2.new(0, 220, 0, 30)
FireLockRow.Position = UDim2.new(0, 260, 0, 60)
FireLockRow.BackgroundTransparency = 1
FireLockRow.Parent = AimbotTab

local FireLockLabel = Instance.new("TextLabel")
FireLockLabel.Size = UDim2.new(0, 110, 1, 0)
FireLockLabel.BackgroundTransparency = 1
FireLockLabel.Text = "FIRELOCK"
FireLockLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FireLockLabel.TextSize = 16
FireLockLabel.Font = Enum.Font.GothamBold
FireLockLabel.TextXAlignment = Enum.TextXAlignment.Left
FireLockLabel.Parent = FireLockRow

local bodyParts = {"Head", "Torso", "Foot"}
local selectedPart = 1

local PartSelectorBG = Instance.new("Frame")
PartSelectorBG.Size = UDim2.new(0, 120, 0, 26)
PartSelectorBG.Position = UDim2.new(0, 115, 0.5, -13)
PartSelectorBG.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
PartSelectorBG.BorderSizePixel = 0
PartSelectorBG.Parent = FireLockRow
Instance.new("UICorner", PartSelectorBG).CornerRadius = UDim.new(1, 0)

local PartLayout = Instance.new("UIListLayout")
PartLayout.FillDirection = Enum.FillDirection.Horizontal
PartLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
PartLayout.VerticalAlignment = Enum.VerticalAlignment.Center
PartLayout.Padding = UDim.new(0, 2)
PartLayout.Parent = PartSelectorBG

local partButtons = {}
local function refreshPartButtons()
    for i, btn in ipairs(partButtons) do
        btn.TextColor3 = (i == selectedPart)
            and Color3.fromRGB(170, 80, 255)
            or  Color3.fromRGB(180, 180, 180)
        btn.Font = (i == selectedPart) and Enum.Font.GothamBold or Enum.Font.Gotham
    end
end

for i, partName in ipairs(bodyParts) do
    local PartBtn = Instance.new("TextButton")
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

-- ══════════════════════════════════════════
-- ESP TAB
-- ══════════════════════════════════════════
local EspTab = Instance.new("Frame")
EspTab.Name = "EspTab"
EspTab.Size = UDim2.new(1, 0, 1, 0)
EspTab.BackgroundTransparency = 1
EspTab.Visible = false
EspTab.Parent = ContentArea

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

-- Helper toggle direita
local function createToggleRight(parent, labelText, yPos, toggleKey)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(0, 220, 0, 30)
    Row.Position = UDim2.new(0, 260, 0, yPos)
    Row.BackgroundTransparency = 1
    Row.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 110, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 16
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local ToggleBG = Instance.new("Frame")
    ToggleBG.Size = UDim2.new(0, 52, 0, 26)
    ToggleBG.Position = UDim2.new(0, 115, 0.5, -13)
    ToggleBG.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    ToggleBG.BorderSizePixel = 0
    ToggleBG.Parent = Row
    Instance.new("UICorner", ToggleBG).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 20, 0, 20)
    Knob.Position = UDim2.new(0, 3, 0.5, -10)
    Knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Knob.BorderSizePixel = 0
    Knob.Parent = ToggleBG
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local ClickBtn = Instance.new("TextButton")
    ClickBtn.Size = UDim2.new(1, 0, 1, 0)
    ClickBtn.BackgroundTransparency = 1
    ClickBtn.Text = ""
    ClickBtn.Parent = Row

    local function refresh()
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
        refresh()
    end)
    refresh()
end

createToggleRight(EspTab, "ESP HEAD", 15, "ESP_HEAD")

-- ESP COLOR
local EspColorRow = Instance.new("Frame")
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
EspColorPreviewBG.Size = UDim2.new(0, 52, 0, 26)
EspColorPreviewBG.Position = UDim2.new(0, 115, 0.5, -13)
EspColorPreviewBG.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
EspColorPreviewBG.BorderSizePixel = 0
EspColorPreviewBG.Parent = EspColorRow
Instance.new("UICorner", EspColorPreviewBG).CornerRadius = UDim.new(1, 0)

local EspHexInput = Instance.new("TextBox")
EspHexInput.Size = UDim2.new(0, 90, 0, 22)
EspHexInput.Position = UDim2.new(0, 115, 0.5, -11)
EspHexInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
EspHexInput.BorderSizePixel = 0
EspHexInput.Text = "#00FF00"
EspHexInput.TextColor3 = Color3.fromRGB(255, 255, 255)
EspHexInput.PlaceholderText = "#RRGGBB"
EspHexInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
EspHexInput.TextSize = 12
EspHexInput.Font = Enum.Font.GothamBold
EspHexInput.ClearTextOnFocus = false
EspHexInput.Visible = false
EspHexInput.ZIndex = 10
EspHexInput.Parent = EspColorRow
Instance.new("UICorner", EspHexInput).CornerRadius = UDim.new(0, 4)

EspHexInput.FocusLost:Connect(function()
    local color = hexToColor3(EspHexInput.Text)
    if color then
        EspColorPreviewBG.BackgroundColor3 = color
        state.espColor = EspHexInput.Text
    else
        EspHexInput.Text = state.espColor or "#00FF00"
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

-- Slots "Em breve" coluna direita
for _, yPos in ipairs({105, 150, 195}) do
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(0, 220, 0, 30)
    Row.Position = UDim2.new(0, 260, 0, yPos)
    Row.BackgroundTransparency = 1
    Row.Parent = EspTab

    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(0, 110, 1, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = "Em breve"
    Lbl.TextColor3 = Color3.fromRGB(160, 160, 160)
    Lbl.TextSize = 14
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = Row

    local BG = Instance.new("Frame")
    BG.Size = UDim2.new(0, 52, 0, 26)
    BG.Position = UDim2.new(0, 115, 0.5, -13)
    BG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    BG.BorderSizePixel = 0
    BG.Parent = Row
    Instance.new("UICorner", BG).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 20, 0, 20)
    Knob.Position = UDim2.new(0, 3, 0.5, -10)
    Knob.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    Knob.BorderSizePixel = 0
    Knob.Parent = BG
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
end

-- ══════════════════════════════════════════
-- TAB SWITCHING
-- ══════════════════════════════════════════
local function switchTab(tab)
    state.currentTab = tab
    if tab == "ESP" then
        EspTab.Visible    = true
        AimbotTab.Visible = false
        BtnESP.TextColor3    = Color3.fromRGB(170, 80, 255)
        BtnAIMBOT.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        EspTab.Visible    = false
        AimbotTab.Visible = true
        BtnAIMBOT.TextColor3 = Color3.fromRGB(170, 80, 255)
        BtnESP.TextColor3    = Color3.fromRGB(255, 255, 255)
    end
end
BtnESP.MouseButton1Click:Connect(function() switchTab("ESP") end)
BtnAIMBOT.MouseButton1Click:Connect(function() switchTab("AIMBOT") end)

-- ══════════════════════════════════════════
-- TOGGLE MENU (INSERT)
-- ══════════════════════════════════════════
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("[ShadowMenu] Loaded. Press INSERT to toggle.")

-- ══════════════════════════════════════════════════════════════════
-- ESP LOGIC — Drawing API (GPU-rendered, coordenadas viewport diretas)
-- ══════════════════════════════════════════════════════════════════

-- ── Constantes de escala unificada ───────────────────────────────
local DIST_MIN  = 10
local DIST_MAX  = 500
local SCALE_MIN = 0.25
local SCALE_MAX = 1.0

local function getScale(dist)
    local t = 1 - math.clamp((dist - DIST_MIN) / (DIST_MAX - DIST_MIN), 0, 1)
    return SCALE_MIN + t * (SCALE_MAX - SCALE_MIN)
end

-- ── Cor ESP do state ──────────────────────────────────────────────
local function getEspColor()
    local hex = (state.espColor or "#00FF00"):gsub("#","")
    local r = tonumber(hex:sub(1,2),16) or 0
    local g = tonumber(hex:sub(3,4),16) or 255
    local b = tonumber(hex:sub(5,6),16) or 0
    return Color3.fromRGB(r, g, b)
end

-- ── Raycast LOS ───────────────────────────────────────────────────
local function hasLOS(fromPos, toPos)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    params.FilterType = Enum.RaycastFilterType.Exclude
    return workspace:Raycast(fromPos, toPos - fromPos, params) == nil
end

-- ── Helper: cria Drawing objeto ───────────────────────────────────
local function newDrawing(kind, props)
    local d = Drawing.new(kind)
    for k, v in pairs(props) do d[k] = v end
    return d
end

-- ── Tabela de objetos Drawing por jogador ─────────────────────────
local espObjects = {}

local function getCharParts(char)
    if not char then return nil, nil, nil end
    local hrp  = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    local hum  = char:FindFirstChildOfClass("Humanoid")
    if not (hrp and head and hum) then return nil, nil, nil end
    return hrp, head, hum
end

-- ── Criar todos os Drawing para um jogador ───────────────────────
local function createEspForPlayer(player)
    if player == LocalPlayer then return end
    if espObjects[player]    then return end

    local obj  = {}
    local col  = getEspColor()

    -- ESP NAME (Text)
    obj.name = newDrawing("Text", {
        Text      = player.Name,
        Size      = 14,
        Color     = Color3.fromRGB(255, 255, 255),
        Outline   = true,
        OutlineColor = Color3.fromRGB(0, 0, 0),
        Font      = Drawing.Fonts.GothamBold,
        Center    = true,
        Visible   = false,
    })

    -- ESP RAGE (Text — distância, acima do NAME)
    obj.rage = newDrawing("Text", {
        Text      = "0m",
        Size      = 12,
        Color     = Color3.fromRGB(255, 220, 50),
        Outline   = true,
        OutlineColor = Color3.fromRGB(0, 0, 0),
        Font      = Drawing.Fonts.Gotham,
        Center    = true,
        Visible   = false,
    })

    -- ESP BOX (Quad — 4 vértices em coordenadas viewport)
    obj.box = newDrawing("Quad", {
        Color     = col,
        Thickness = 2,
        Filled    = false,
        Visible   = false,
    })

    -- ESP TRACE (Line — topo da tela → cabeça)
    obj.trace = newDrawing("Line", {
        Color     = col,
        Thickness = 1,
        Visible   = false,
    })

    -- ESP LIFE background (Line cinza, lado direito do box)
    obj.lifeBG = newDrawing("Line", {
        Color     = Color3.fromRGB(40, 40, 40),
        Thickness = 4,
        Visible   = false,
    })

    -- ESP LIFE bar (Line verde, proporcional à vida)
    obj.lifeBar = newDrawing("Line", {
        Color     = Color3.fromRGB(50, 220, 50),
        Thickness = 4,
        Visible   = false,
    })

    -- ESP HEAD (Circle semitransparente na cabeça)
    obj.head = newDrawing("Circle", {
        Color       = Color3.fromRGB(50, 220, 50),
        Thickness   = 2,
        Filled      = true,
        Transparency = 0.55,
        Visible     = false,
    })

    espObjects[player] = obj
end

-- ── Remover Drawing de um jogador ────────────────────────────────
local function removeEspForPlayer(player)
    local obj = espObjects[player]
    if not obj then return end
    for _, d in pairs(obj) do
        if typeof(d) == "Instance" or (d and d.Remove) then
            pcall(function() d:Remove() end)
        end
    end
    espObjects[player] = nil
end

-- ── Inicializa ESP para jogadores existentes ─────────────────────
for _, p in ipairs(Players:GetPlayers()) do
    createEspForPlayer(p)
end
Players.PlayerAdded:Connect(createEspForPlayer)
Players.PlayerRemoving:Connect(removeEspForPlayer)

-- ══════════════════════════════════════════
-- LOOP PRINCIPAL ESP + SLIDER
-- ══════════════════════════════════════════
RunService.RenderStepped:Connect(function()

    -- Slider FOV drag
    if sliderDragging then
        local mouseX    = UIS:GetMouseLocation().X
        local trackPos  = SliderTrack.AbsolutePosition.X
        local trackW    = SliderTrack.AbsoluteSize.X
        local ratio     = math.clamp((mouseX - trackPos) / trackW, 0, 1)
        state.fov       = math.floor(ratio * 180)
        SliderFill.Size = UDim2.new(ratio, 0, 1, 0)
    end

    -- ── Setup personagem local ────────────────────────────────────
    local myChar = LocalPlayer.Character
    local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myPos  = myHRP and myHRP.Position or Vector3.new(0,0,0)

    local anyEspOn = state.toggles.ESP_NAME  or state.toggles.ESP_BOX   or
                     state.toggles.ESP_TRACE or state.toggles.ESP_RAGE  or
                     state.toggles.ESP_LIFE  or state.toggles.ESP_HEAD

    local espCol = getEspColor()
    local vp     = Camera.ViewportSize

    for player, obj in pairs(espObjects) do
        local char = player.Character
        local hrp, head, hum = getCharParts(char)

        -- Esconde tudo se ESP desligado ou personagem inválido
        if not anyEspOn or not hrp or not head or not hum then
            obj.name.Visible    = false
            obj.rage.Visible    = false
            obj.box.Visible     = false
            obj.trace.Visible   = false
            obj.lifeBG.Visible  = false
            obj.lifeBar.Visible = false
            obj.head.Visible    = false
        else
            local dist  = (hrp.Position - myPos).Magnitude
            local scale = getScale(dist)

            -- ── Calcular 8 pontos 3D do personagem (box preciso) ────
            local cf    = hrp.CFrame
            local right = cf.RightVector
            local up    = Vector3.new(0, 1, 0)

            -- Dimensões do personagem (HRP ~2 studs largura, 5 studs altura)
            local halfW = 1.0
            local halfD = 0.6
            local yFeet = hrp.Position.Y - 3.2   -- base dos pés
            local yTop  = head.Position.Y + 0.75  -- topo da cabeça

            -- 4 cantos topo + 4 cantos base
            local fwd   = cf.LookVector * halfD
            local rgt   = right * halfW

            local corners3D = {
                hrp.Position + rgt + fwd + Vector3.new(0, yTop - hrp.Position.Y, 0),
                hrp.Position - rgt + fwd + Vector3.new(0, yTop - hrp.Position.Y, 0),
                hrp.Position - rgt - fwd + Vector3.new(0, yTop - hrp.Position.Y, 0),
                hrp.Position + rgt - fwd + Vector3.new(0, yTop - hrp.Position.Y, 0),
                hrp.Position + rgt + fwd + Vector3.new(0, yFeet - hrp.Position.Y, 0),
                hrp.Position - rgt + fwd + Vector3.new(0, yFeet - hrp.Position.Y, 0),
                hrp.Position - rgt - fwd + Vector3.new(0, yFeet - hrp.Position.Y, 0),
                hrp.Position + rgt - fwd + Vector3.new(0, yFeet - hrp.Position.Y, 0),
            }

            -- Projeta todos para viewport
            local pts2D = {}
            local allOn = true
            for i, p3 in ipairs(corners3D) do
                local sp, onScreen, depth = Camera:WorldToViewportPoint(p3)
                pts2D[i] = Vector2.new(sp.X, sp.Y)
                if not onScreen or depth <= 0 then allOn = false end
            end

            -- Bounding box 2D (min/max X e Y dos 8 pontos)
            local minX, minY = math.huge,  math.huge
            local maxX, maxY = -math.huge, -math.huge
            for _, p2 in ipairs(pts2D) do
                if p2.X < minX then minX = p2.X end
                if p2.Y < minY then minY = p2.Y end
                if p2.X > maxX then maxX = p2.X end
                if p2.Y > maxY then maxY = p2.Y end
            end

            -- Pontos da cabeça e pés para referência
            local headSP3 = Camera:WorldToViewportPoint(head.Position)
            local headSP  = Vector2.new(headSP3.X, headSP3.Y)
            local headZ   = headSP3.Z
            local visible = headZ > 0

            -- ── ESP BOX (Quad) ────────────────────────────────────
            obj.box.Visible = visible and state.toggles.ESP_BOX
            if obj.box.Visible then
                obj.box.Color     = espCol
                obj.box.Thickness = math.max(1, math.floor(2 * scale))
                -- PointA..D = 4 cantos do bounding box 2D
                obj.box.PointA = Vector2.new(minX, minY)
                obj.box.PointB = Vector2.new(maxX, minY)
                obj.box.PointC = Vector2.new(maxX, maxY)
                obj.box.PointD = Vector2.new(minX, maxY)
            end

            -- ── ESP NAME (Text) ───────────────────────────────────
            obj.name.Visible = visible and state.toggles.ESP_NAME
            if obj.name.Visible then
                local fs = math.max(8, math.floor(14 * scale))
                obj.name.Size     = fs
                obj.name.Color    = espCol
                obj.name.Text     = player.Name
                -- Posiciona acima do topo do box
                obj.name.Position = Vector2.new(headSP.X, minY - fs - 2)
            end

            -- ── ESP RAGE (Text, acima do NAME) ───────────────────
            obj.rage.Visible = visible and state.toggles.ESP_RAGE
            if obj.rage.Visible then
                local fs      = math.max(7, math.floor(12 * scale))
                local nameH   = state.toggles.ESP_NAME and math.max(8, math.floor(14*scale)) + 4 or 0
                obj.rage.Size     = fs
                obj.rage.Text     = math.floor(dist) .. "m"
                obj.rage.Position = Vector2.new(headSP.X, minY - fs - 2 - nameH)
            end

            -- ── ESP TRACE (Line: centro-topo tela → cabeça) ──────
            obj.trace.Visible = visible and state.toggles.ESP_TRACE
            if obj.trace.Visible then
                obj.trace.Color     = espCol
                obj.trace.Thickness = math.max(1, math.floor(1.5 * scale))
                obj.trace.From      = Vector2.new(vp.X / 2, 0)
                obj.trace.To        = headSP
            end

            -- ── ESP LIFE (Lines ao lado direito do box) ───────────
            local lifeOn = visible and state.toggles.ESP_LIFE
            obj.lifeBG.Visible  = lifeOn
            obj.lifeBar.Visible = lifeOn
            if lifeOn then
                local barThick = math.max(3, math.floor(5 * scale))
                local barX     = maxX + math.max(3, math.floor(4 * scale))
                local boxH     = maxY - minY

                obj.lifeBG.Thickness = barThick
                obj.lifeBG.From      = Vector2.new(barX, minY)
                obj.lifeBG.To        = Vector2.new(barX, maxY)

                local maxHp = hum.MaxHealth
                local curHp = math.clamp(hum.Health, 0, maxHp)
                local ratio = maxHp > 0 and (curHp / maxHp) or 0
                local barTop = maxY - boxH * ratio  -- barra cresce de baixo pra cima

                obj.lifeBar.Thickness = barThick
                obj.lifeBar.From      = Vector2.new(barX, barTop)
                obj.lifeBar.To        = Vector2.new(barX, maxY)

                -- Cor: verde → amarelo → vermelho
                local r = math.floor((1 - ratio) * 255)
                local g = math.floor(ratio * 220)
                obj.lifeBar.Color = Color3.fromRGB(r, g, 30)
            end

            -- ── ESP HEAD (Circle semiopaco na cabeça) ────────────
            obj.head.Visible = visible and state.toggles.ESP_HEAD
            if obj.head.Visible then
                local sz = math.max(5, math.floor(18 * scale))
                obj.head.Radius   = sz
                obj.head.Position = headSP
                -- Verde com LOS, vermelho sem
                local los = myHRP and hasLOS(myHRP.Position, head.Position)
                obj.head.Color = los
                    and Color3.fromRGB(50, 220, 50)
                    or  Color3.fromRGB(220, 50, 50)
            end
        end
    end
end)

print("[ShadowMenu] ESP Drawing loaded.")
