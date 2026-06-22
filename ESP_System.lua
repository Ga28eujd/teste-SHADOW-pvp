-- ══════════════════════════════════════════════════════════════════
-- UNIFIED ESP SYSTEM - Funciona com ShadowMenu.lua
-- ══════════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- ══════════════════════════════════════════════════════════════════
-- CONFIGURAÇÃO GLOBAL
-- ══════════════════════════════════════════════════════════════════

-- Variáveis de cache para os drawings
if not _G.espSystem then
    _G.espSystem = {
        drawings = {}, -- { playerName: { name, box, trace, rage, life, head } }
        playerConnections = {},
        renderConnection = nil,
        state = nil -- Será setado por referência do menu
    }
end

local espSystem = _G.espSystem

-- ══════════════════════════════════════════════════════════════════
-- FUNÇÕES AUXILIARES
-- ══════════════════════════════════════════════════════════════════

-- Converter HEX para Color3
local function hexToColor3(hex)
    hex = hex:gsub("#", "")
    if #hex ~= 6 then return Color3.new(1, 1, 1) end
    local r = tonumber(hex:sub(1,2), 16) or 255
    local g = tonumber(hex:sub(3,4), 16) or 255
    local b = tonumber(hex:sub(5,6), 16) or 255
    return Color3.fromRGB(r, g, b)
end

-- Calcular tamanho baseado em distância (quanto mais longe, menor)
-- Distância máxima = 500 studs (começa a ficar bem pequeno)
-- Distância mínima = 10 studs (tamanho normal)
local function getScaleFromDistance(distance)
    local maxDistance = 500
    local minDistance = 10
    
    if distance <= minDistance then
        return 1.0 -- Tamanho máximo
    elseif distance >= maxDistance then
        return 0.2 -- Tamanho mínimo (20%)
    else
        -- Interpolação linear entre minDistance e maxDistance
        local scale = 1.0 - ((distance - minDistance) / (maxDistance - minDistance)) * 0.8
        return math.max(0.2, math.min(1.0, scale))
    end
end

-- Verificar se há linha de visão entre dois pontos
local function isLineOfSight(from, to)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local direction = (to - from).Unit * 5000
    local result = workspace:Raycast(from, direction, raycastParams)
    
    if result then
        local distance = (result.Position - from).Magnitude
        local targetDistance = (to - from).Magnitude
        return distance >= targetDistance * 0.95 -- Pequena margem de erro
    end
    
    return true -- Sem obstrução
end

-- ══════════════════════════════════════════════════════════════════
-- FUNÇÕES DE CRIAÇÃO DE DRAWINGS
-- ══════════════════════════════════════════════════════════════════

local function createOrGetDrawings(playerName)
    if not espSystem.drawings[playerName] then
        espSystem.drawings[playerName] = {
            name = Drawing.new("Text"),
            box = Drawing.new("Quad"),
            trace = Drawing.new("Line"),
            rage = Drawing.new("Text"),
            life = Drawing.new("Quad"),
            head = Drawing.new("Circle"),
        }
        
        -- Configurar propriedades padrão dos drawings
        local d = espSystem.drawings[playerName]
        
        -- NAME
        d.name.Size = 16
        d.name.Center = true
        d.name.Outline = true
        
        -- BOX
        d.box.Thickness = 1.5
        d.box.Filled = false
        
        -- TRACE
        d.trace.Thickness = 1.2
        
        -- RAGE
        d.rage.Size = 14
        d.rage.Center = true
        d.rage.Outline = true
        
        -- LIFE
        d.life.Thickness = 1
        d.life.Filled = true
        
        -- HEAD
        d.head.Thickness = 1.5
        d.head.Filled = false
    end
    
    return espSystem.drawings[playerName]
end

local function removeDrawings(playerName)
    if espSystem.drawings[playerName] then
        for _, drawing in pairs(espSystem.drawings[playerName]) do
            if drawing then
                pcall(function() drawing:Remove() end)
            end
        end
        espSystem.drawings[playerName] = nil
    end
end

-- ══════════════════════════════════════════════════════════════════
-- FUNÇÕES DE RENDERIZAÇÃO POR ESP
-- ══════════════════════════════════════════════════════════════════

local function renderESPName(player, char, drawings, scale, espColor)
    if not state.toggles.ESP_NAME then
        drawings.name.Visible = false
        return
    end
    
    local head = char:FindFirstChild("Head")
    if not head then
        drawings.name.Visible = false
        return
    end
    
    local screenPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 3, 0))
    
    if screenPos.Z > 0 then
        drawings.name.Visible = true
        drawings.name.Position = Vector2.new(screenPos.X, screenPos.Y)
        drawings.name.Text = player.Name
        drawings.name.Color = espColor
        drawings.name.Size = math.floor(16 * scale)
    else
        drawings.name.Visible = false
    end
end

local function renderESPBox(player, char, drawings, scale, espColor)
    if not state.toggles.ESP_BOX then
        drawings.box.Visible = false
        return
    end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    
    if not hrp or not head then
        drawings.box.Visible = false
        return
    end
    
    -- Calcular pontos do box
    local top = head.Position + Vector3.new(0, head.Size.Y / 2, 0)
    local bottom = hrp.Position - Vector3.new(0, hrp.Size.Y / 2, 0)
    local r = hrp.Size.X / 2
    local z = hrp.Size.Z / 2
    
    local front = hrp.CFrame.LookVector * z
    local right = hrp.CFrame.RightVector * r
    
    -- Pontos do box em ordem: topo-direita, topo-esquerda, fundo-esquerda, fundo-direita
    local corners = {
        Camera:WorldToViewportPoint(top + right + front),     -- topo-direita
        Camera:WorldToViewportPoint(top - right + front),     -- topo-esquerda
        Camera:WorldToViewportPoint(bottom - right - front),  -- fundo-esquerda
        Camera:WorldToViewportPoint(bottom + right - front),  -- fundo-direita
    }
    
    if corners[1].Z > 0 and corners[2].Z > 0 and corners[3].Z > 0 and corners[4].Z > 0 then
        drawings.box.Visible = true
        drawings.box.PointA = Vector2.new(corners[1].X, corners[1].Y)
        drawings.box.PointB = Vector2.new(corners[2].X, corners[2].Y)
        drawings.box.PointC = Vector2.new(corners[3].X, corners[3].Y)
        drawings.box.PointD = Vector2.new(corners[4].X, corners[4].Y)
        drawings.box.Color = espColor
        drawings.box.Thickness = 1.5 * scale
    else
        drawings.box.Visible = false
    end
end

local function renderESPTrace(player, char, drawings, espColor)
    if not state.toggles.ESP_TRACE then
        drawings.trace.Visible = false
        return
    end
    
    local head = char:FindFirstChild("Head")
    if not head then
        drawings.trace.Visible = false
        return
    end
    
    local screenPos = Camera:WorldToViewportPoint(head.Position)
    
    if screenPos.Z > 0 then
        drawings.trace.Visible = true
        drawings.trace.From = Vector2.new(Camera.ViewportSize.X / 2, 0) -- Centro da tela, topo
        drawings.trace.To = Vector2.new(screenPos.X, screenPos.Y)
        drawings.trace.Color = espColor
        drawings.trace.Thickness = 1.2
    else
        drawings.trace.Visible = false
    end
end

local function renderESPRage(player, char, drawings, scale, espColor)
    if not state.toggles.ESP_RAGE then
        drawings.rage.Visible = false
        return
    end
    
    local head = char:FindFirstChild("Head")
    if not head then
        drawings.rage.Visible = false
        return
    end
    
    local distance = (head.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude
    local screenPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 5, 0))
    
    if screenPos.Z > 0 then
        drawings.rage.Visible = true
        drawings.rage.Position = Vector2.new(screenPos.X, screenPos.Y)
        drawings.rage.Text = math.floor(distance) .. "m"
        drawings.rage.Color = espColor
        drawings.rage.Size = math.floor(14 * scale)
    else
        drawings.rage.Visible = false
    end
end

local function renderESPLife(player, char, drawings, scale, espColor)
    if not state.toggles.ESP_LIFE then
        drawings.life.Visible = false
        return
    end
    
    local humanoid = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    
    if not humanoid or not hrp or not head then
        drawings.life.Visible = false
        return
    end
    
    -- Calcular posição da barra (ao lado direito do box)
    local top = head.Position + Vector3.new(0, head.Size.Y / 2, 0)
    local bottom = hrp.Position - Vector3.new(0, hrp.Size.Y / 2, 0)
    local r = hrp.Size.X / 2
    
    local rightTop = Camera:WorldToViewportPoint(top + hrp.CFrame.RightVector * r)
    local rightBottom = Camera:WorldToViewportPoint(bottom + hrp.CFrame.RightVector * r)
    
    if rightTop.Z > 0 and rightBottom.Z > 0 then
        local maxHealth = humanoid.MaxHealth
        local currentHealth = math.max(0, humanoid.Health)
        local healthPercent = math.min(1, currentHealth / maxHealth)
        
        local barWidth = 6 * scale
        local barHeight = math.abs(rightBottom.Y - rightTop.Y)
        local filledHeight = barHeight * healthPercent
        
        drawings.life.Visible = true
        drawings.life.PointA = Vector2.new(rightTop.X + 5, rightTop.Y)
        drawings.life.PointB = Vector2.new(rightTop.X + 5 + barWidth, rightTop.Y)
        drawings.life.PointC = Vector2.new(rightTop.X + 5 + barWidth, rightTop.Y + filledHeight)
        drawings.life.PointD = Vector2.new(rightTop.X + 5, rightTop.Y + filledHeight)
        drawings.life.Color = Color3.fromRGB(0, 255, 0) -- Verde
        drawings.life.Thickness = 1
    else
        drawings.life.Visible = false
    end
end

local function renderESPHead(player, char, drawings, scale, espColor)
    if not state.toggles.ESP_HEAD then
        drawings.head.Visible = false
        return
    end
    
    local head = char:FindFirstChild("Head")
    if not head then
        drawings.head.Visible = false
        return
    end
    
    -- Verificar linha de visão
    local hasLineOfSight = isLineOfSight(LocalPlayer.Character.PrimaryPart.Position, head.Position)
    
    if hasLineOfSight then
        local screenPos = Camera:WorldToViewportPoint(head.Position)
        
        if screenPos.Z > 0 then
            drawings.head.Visible = true
            drawings.head.Position = Vector2.new(screenPos.X, screenPos.Y)
            drawings.head.Radius = 8 * scale
            drawings.head.Color = Color3.fromRGB(0, 255, 0) -- Verde
            drawings.head.Transparency = 0.5
        else
            drawings.head.Visible = false
        end
    else
        drawings.head.Visible = false
    end
end

-- ══════════════════════════════════════════════════════════════════
-- RENDER LOOP
-- ══════════════════════════════════════════════════════════════════

local function startRenderLoop()
    if espSystem.renderConnection then
        espSystem.renderConnection:Disconnect()
    end
    
    espSystem.renderConnection = RunService.RenderStepped:Connect(function()
        if not espSystem.state then return end
        
        -- Pegar a cor do ESP do state
        local espColor = hexToColor3(espSystem.state.espColor or "#FFFFFF")
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local char = player.Character
                
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local distance = (hrp.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude
                        local scale = getScaleFromDistance(distance)
                        
                        local drawings = createOrGetDrawings(player.Name)
                        
                        -- Renderizar todos os ESPs
                        renderESPName(player, char, drawings, scale, espColor)
                        renderESPBox(player, char, drawings, scale, espColor)
                        renderESPTrace(player, char, drawings, espColor)
                        renderESPRage(player, char, drawings, scale, espColor)
                        renderESPLife(player, char, drawings, scale, espColor)
                        renderESPHead(player, char, drawings, scale, espColor)
                    end
                else
                    -- Jogador morreu ou sem character
                    removeDrawings(player.Name)
                end
            end
        end
    end)
end

-- ══════════════════════════════════════════════════════════════════
-- GERENCIAMENTO DE JOGADORES
-- ══════════════════════════════════════════════════════════════════

local function addPlayer(player)
    if player == LocalPlayer then return end
    
    if espSystem.playerConnections[player] then
        espSystem.playerConnections[player]:Disconnect()
    end
    
    espSystem.playerConnections[player] = player.CharacterAdded:Connect(function()
        removeDrawings(player.Name)
    end)
end

-- Adicionar jogadores já na game
for _, player in ipairs(Players:GetPlayers()) do
    addPlayer(player)
end

-- Monitorar novos jogadores
Players.PlayerAdded:Connect(function(player)
    addPlayer(player)
end)

-- Remover jogadores que saíram
Players.PlayerRemoving:Connect(function(player)
    if espSystem.playerConnections[player] then
        espSystem.playerConnections[player]:Disconnect()
        espSystem.playerConnections[player] = nil
    end
    removeDrawings(player.Name)
end)

-- ══════════════════════════════════════════════════════════════════
-- INICIALIZAR
-- ══════════════════════════════════════════════════════════════════

startRenderLoop()

print("[ESP System] Carregado e pronto. Aguardando conexão com ShadowMenu...")

-- Exportar função para conectar ao menu
function espSystem:connectToMenu(stateReference)
    self.state = stateReference
    print("[ESP System] Conectado ao ShadowMenu!")
end

