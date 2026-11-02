-- Blockspin Master Hub V8.0 (ABSOLUTELY FINAL & FIXED)
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local GUI_Parent = gethui and gethui() or CoreGui
if GUI_Parent:FindFirstChild("BlockspinMasterHub") then GUI_Parent.BlockspinMasterHub:Destroy() end

-- ==========================================
-- 1. الإعدادات (أول شي)
-- ==========================================
local Settings = {
    AimbotEnabled = false,
    SilentAimEnabled = false,
    ESPEnabled = false,
    AutoFarmATM = false,
    SilentFOVSize = 120,
    AimbotFOVSize = 150,
    Smoothness = 5
}

local AtmPositions = {
    Vector3.new(-132.2, 258.5, 106.9),
    Vector3.new(-156.8, 258.5, 442.9),
    Vector3.new(68.4, 265.1, 44.0),
    Vector3.new(90.7, 258.7, 166.4),
    Vector3.new(109.7, 258.5, 463.5)
}
local ToolVendorPos = Vector3.new(-211.6, 255.2, 387.3)

-- ==========================================
-- 2. الدوائر (Drawing) - قبل الواجهة عشان تشتغل
-- ==========================================
local SilentFOVCircle = Drawing.new("Circle")
SilentFOVCircle.Visible = false
SilentFOVCircle.Transparency = 0.6
SilentFOVCircle.Thickness = 1.5
SilentFOVCircle.Color = Color3.fromRGB(0, 255, 0) -- أخضر
SilentFOVCircle.Filled = false
SilentFOVCircle.Radius = Settings.SilentFOVSize

local AimbotFOVCircle = Drawing.new("Circle")
AimbotFOVCircle.Visible = false
AimbotFOVCircle.Transparency = 0.6
AimbotFOVCircle.Thickness = 1.5
AimbotFOVCircle.Color = Color3.fromRGB(255, 0, 0) -- أحمر
AimbotFOVCircle.Filled = false
AimbotFOVCircle.Radius = Settings.AimbotFOVSize

-- ==========================================
-- 3. بناء الواجهة (UI)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlockspinMasterHub"
ScreenGui.Parent = GUI_Parent
ScreenGui.ResetOnSpawn = false

local FloatingIcon = Instance.new("TextButton")
FloatingIcon.Parent = ScreenGui
FloatingIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
FloatingIcon.Position = UDim2.new(0, 35, 0, 150)
FloatingIcon.Size = UDim2.new(0, 55, 0, 55)
FloatingIcon.Font = Enum.Font.SourceSansBold
FloatingIcon.Text = "🔥"
FloatingIcon.TextColor3 = Color3.fromRGB(255, 165, 0)
FloatingIcon.TextSize = 28
local IconCorner = Instance.new("UICorner"); IconCorner.CornerRadius = UDim.new(1, 0); IconCorner.Parent = FloatingIcon
local IconStroke = Instance.new("UIStroke"); IconStroke.Color = Color3.fromRGB(255, 165, 0); IconStroke.Thickness = 2.5; IconStroke.Parent = FloatingIcon

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -230)
MainFrame.Size = UDim2.new(0, 420, 0, 460)
MainFrame.Visible = false
local MainCorner = Instance.new("UICorner"); MainCorner.CornerRadius = UDim.new(0, 16); MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke"); MainStroke.Color = Color3.fromRGB(255, 165, 0); MainStroke.Thickness = 2; MainStroke.Parent = MainFrame

local TopBar = Instance.new("Frame"); TopBar.Parent = MainFrame; TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30); TopBar.Size = UDim2.new(1, 0, 0, 50)
local TopCorner = Instance.new("UICorner"); TopCorner.CornerRadius = UDim.new(0, 16); TopCorner.Parent = TopBar
local Title = Instance.new("TextLabel"); Title.Parent = TopBar; Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 20, 0, 0); Title.Size = UDim2.new(0.7, 0, 1, 0); Title.Font = Enum.Font.SourceSansBold; Title.Text = "BLOCKSPIN | Master Hub V8"; Title.TextColor3 = Color3.fromRGB(255, 165, 0); Title.TextSize = 16; Title.TextXAlignment = Enum.TextXAlignment.Left
local CloseXBtn = Instance.new("TextButton"); CloseXBtn.Parent = TopBar; CloseXBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50); CloseXBtn.Position = UDim2.new(1, -40, 0.5, -14); CloseXBtn.Size = UDim2.new(0, 28, 0, 28); CloseXBtn.Font = Enum.Font.SourceSansBold; CloseXBtn.Text = "X"; CloseXBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CloseXBtn.TextSize = 14; CloseXBtn.AutoButtonColor = false
local XCorner = Instance.new("UICorner"); XCorner.CornerRadius = UDim.new(1, 0); XCorner.Parent = CloseXBtn

local TabsBar = Instance.new("Frame"); TabsBar.Parent = MainFrame; TabsBar.BackgroundTransparency = 1; TabsBar.Position = UDim2.new(0, 10, 0, 60); TabsBar.Size = UDim2.new(1, -20, 0, 35)
local TabsLayout = Instance.new("UIListLayout"); TabsLayout.Parent = TabsBar; TabsLayout.FillDirection = Enum.FillDirection.Horizontal; TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder; TabsLayout.Padding = UDim.new(0, 8)
local ContentContainer = Instance.new("Frame"); ContentContainer.Parent = MainFrame; ContentContainer.BackgroundTransparency = 1; ContentContainer.Position = UDim2.new(0, 10, 0, 100); ContentContainer.Size = UDim2.new(1, -20, 1, -110)

local tabs = {}
local function createTabContent(name)
    local scrolling = Instance.new("ScrollingFrame"); scrolling.Name = name .. "Content"; scrolling.Parent = ContentContainer; scrolling.BackgroundTransparency = 1; scrolling.Size = UDim2.new(1, 0, 1, 0); scrolling.CanvasSize = UDim2.new(0, 0, 0, 0); scrolling.ScrollBarThickness = 4; scrolling.Visible = false
    local list = Instance.new("UIListLayout"); list.Parent = scrolling; list.HorizontalAlignment = Enum.HorizontalAlignment.Center; list.SortOrder = Enum.SortOrder.LayoutOrder; list.Padding = UDim.new(0, 10)
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() scrolling.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 15) end)
    return scrolling
end

local function createTabButton(name, iconText)
    local btn = Instance.new("TextButton"); btn.Parent = TabsBar; btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35); btn.Size = UDim2.new(0, 90, 1, 0); btn.Font = Enum.Font.SourceSansBold; btn.Text = iconText .. " " .. name; btn.TextColor3 = Color3.fromRGB(150, 150, 150); btn.TextSize = 13; btn.AutoButtonColor = false
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 8); corner.Parent = btn
    local stroke = Instance.new("UIStroke"); stroke.Color = Color3.fromRGB(45, 45, 60); stroke.Thickness = 1; stroke.Parent = btn
    local content = createTabContent(name)
    btn.Activated:Connect(function()
        for _, t in pairs(tabs) do t.content.Visible = false; t.btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35); t.btn.TextColor3 = Color3.fromRGB(150, 150, 150); t.stroke.Color = Color3.fromRGB(45, 45, 60) end
        content.Visible = true; btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50); btn.TextColor3 = Color3.fromRGB(255, 165, 0); stroke.Color = Color3.fromRGB(255, 165, 0)
    end)
    tabs[name] = {btn = btn, content = content, stroke = stroke}
    return content
end

local combatTab = createTabButton("Combat", "🎯")
local visualsTab = createTabButton("Visuals", "👁️")
local utilityTab = createTabButton("Utility", "📦")
tabs["Combat"].content.Visible = true; tabs["Combat"].btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50); tabs["Combat"].btn.TextColor3 = Color3.fromRGB(255, 165, 0); tabs["Combat"].stroke.Color = Color3.fromRGB(255, 165, 0)

local function createFeatureToggle(parentTab, name, desc, callback)
    local btn = Instance.new("TextButton"); btn.Parent = parentTab; btn.BackgroundColor3 = Color3.fromRGB(22, 22, 30); btn.Size = UDim2.new(0.95, 0, 0, 50); btn.Text = ""; btn.AutoButtonColor = false
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 10); corner.Parent = btn
    local stroke = Instance.new("UIStroke"); stroke.Color = Color3.fromRGB(45, 45, 60); stroke.Thickness = 1.2; stroke.Parent = btn
    local nameLabel = Instance.new("TextLabel"); nameLabel.Parent = btn; nameLabel.BackgroundTransparency = 1; nameLabel.Position = UDim2.new(0, 15, 0, 8); nameLabel.Size = UDim2.new(0.7, 0, 0, 16); nameLabel.Font = Enum.Font.SourceSansBold; nameLabel.Text = name; nameLabel.TextColor3 = Color3.fromRGB(240, 240, 240); nameLabel.TextSize = 14; nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    local descLabel = Instance.new("TextLabel"); descLabel.Parent = btn; descLabel.BackgroundTransparency = 1; descLabel.Position = UDim2.new(0, 15, 0, 26); descLabel.Size = UDim2.new(0.7, 0, 0, 16); descLabel.Font = Enum.Font.SourceSans; descLabel.Text = desc; descLabel.TextColor3 = Color3.fromRGB(120, 120, 120); descLabel.TextSize = 11; descLabel.TextXAlignment = Enum.TextXAlignment.Left
    local statusBox = Instance.new("Frame"); statusBox.Parent = btn; statusBox.BackgroundColor3 = Color3.fromRGB(50, 50, 65); statusBox.Position = UDim2.new(1, -40, 0.5, -12); statusBox.Size = UDim2.new(0, 24, 0, 24)
    local boxCorner = Instance.new("UICorner"); boxCorner.CornerRadius = UDim.new(0, 6); boxCorner.Parent = statusBox
    local state = false
    btn.Activated:Connect(function()
        state = not state
        if state then statusBox.BackgroundColor3 = Color3.fromRGB(255, 165, 0); stroke.Color = Color3.fromRGB(255, 165, 0) else statusBox.BackgroundColor3 = Color3.fromRGB(50, 50, 65); stroke.Color = Color3.fromRGB(45, 45, 60) end
        callback(state)
    end)
    return btn
end

-- ربط الأزرار
createFeatureToggle(combatTab, "Silent Aim", "تصويب صامت (الأخضر)", function(enabled) 
    Settings.SilentAimEnabled = enabled
    SilentFOVCircle.Visible = enabled
    if enabled then setupSilentAim() end
end)

createFeatureToggle(combatTab, "Aimbot", "قفل الكاميرا (الأحمر)", function(enabled) 
    Settings.AimbotEnabled = enabled
    AimbotFOVCircle.Visible = enabled
end)

createFeatureToggle(visualsTab, "ESP", "مربعات وأسماء اللاعبين", function(enabled) Settings.ESPEnabled = enabled end)
createFeatureToggle(utilityTab, "Auto Farm ATM", "طيران Tween واختفاء", function(enabled) Settings.AutoFarmATM = enabled; if not enabled then SetGhostMode(false) end end)

-- أزرار الـ FOV
local function createFovControl(parentTab, labelText, initialVal, onMinus, onPlus)
    local frame = Instance.new("Frame"); frame.Parent = parentTab; frame.BackgroundColor3 = Color3.fromRGB(22, 22, 30); frame.Size = UDim2.new(0.95, 0, 0, 45)
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 10); corner.Parent = frame
    local stroke = Instance.new("UIStroke"); stroke.Color = Color3.fromRGB(45, 45, 60); stroke.Thickness = 1.2; stroke.Parent = frame
    local label = Instance.new("TextLabel"); label.Parent = frame; label.BackgroundTransparency = 1; label.Position = UDim2.new(0, 15, 0, 0); label.Size = UDim2.new(0.5, 0, 1, 0); label.Font = Enum.Font.SourceSansBold; label.Text = labelText .. ": " .. initialVal; label.TextColor3 = Color3.fromRGB(200, 200, 200); label.TextSize = 14; label.TextXAlignment = Enum.TextXAlignment.Left
    
    local minusBtn = Instance.new("TextButton"); minusBtn.Parent = frame; minusBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48); minusBtn.Position = UDim2.new(1, -80, 0.5, -12); minusBtn.Size = UDim2.new(0, 28, 0, 24); minusBtn.Font = Enum.Font.SourceSansBold; minusBtn.Text = "-"; minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255); minusBtn.TextSize = 18
    local mCorner = Instance.new("UICorner"); mCorner.CornerRadius = UDim.new(0, 6); mCorner.Parent = minusBtn
    local plusBtn = Instance.new("TextButton"); plusBtn.Parent = frame; plusBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48); plusBtn.Position = UDim2.new(1, -45, 0.5, -12); plusBtn.Size = UDim2.new(0, 28, 0, 24); plusBtn.Font = Enum.Font.SourceSansBold; plusBtn.Text = "+"; plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255); plusBtn.TextSize = 18
    local pCorner = Instance.new("UICorner"); pCorner.CornerRadius = UDim.new(0, 6); pCorner.Parent = plusBtn

    minusBtn.Activated:Connect(function() local newVal = onMinus(); label.Text = labelText .. ": " .. tostring(math.floor(newVal)) end)
    plusBtn.Activated:Connect(function() local newVal = onPlus(); label.Text = labelText .. ": " .. tostring(math.floor(newVal)) end)
    return frame
end

createFovControl(combatTab, "Silent FOV", Settings.SilentFOVSize,
    function() Settings.SilentFOVSize = math.max(20, Settings.SilentFOVSize - 10); SilentFOVCircle.Radius = Settings.SilentFOVSize; return Settings.SilentFOVSize end,
    function() Settings.SilentFOVSize = math.min(600, Settings.SilentFOVSize + 10); SilentFOVCircle.Radius = Settings.SilentFOVSize; return Settings.SilentFOVSize end
)

createFovControl(combatTab, "Aimbot FOV", Settings.AimbotFOVSize,
    function() Settings.AimbotFOVSize = math.max(20, Settings.AimbotFOVSize - 10); AimbotFOVCircle.Radius = Settings.AimbotFOVSize; return Settings.AimbotFOVSize end,
    function() Settings.AimbotFOVSize = math.min(600, Settings.AimbotFOVSize + 10); AimbotFOVCircle.Radius = Settings.AimbotFOVSize; return Settings.AimbotFOVSize end
)

-- ==========================================
-- 4. السايلنت أيم والأيم بوت
-- ==========================================
local cachedSilentTarget = nil
local oldNamecall = nil

local function setupSilentAim()
    if oldNamecall then return end
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if Settings.SilentAimEnabled and not checkcaller() and (method == "Raycast" or method == "FindPartOnRay") and self == Workspace then
            if cachedSilentTarget and cachedSilentTarget.Parent then
                local args = {...}
                pcall(function()
                    if method == "Raycast" and typeof(args[1]) == "Vector3" and typeof(args[2]) == "Vector3" then
                        args[2] = (cachedSilentTarget.Position - args[1]).Unit * args[2].Magnitude
                    elseif method == "FindPartOnRay" and typeof(args[1]) == "Ray" then
                        args[1] = Ray.new(args[1].Origin, (cachedSilentTarget.Position - args[1].Origin).Unit * args[1].Direction.Magnitude)
                    end
                end)
                return oldNamecall(self, unpack(args))
            end
        end
        return oldNamecall(self, ...)
    end)
end

local function getClosestSilentTarget()
    local closest = nil; local shortest = Settings.SilentFOVSize
    local mousePos = UserInputService:GetMouseLocation()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local part = p.Character:FindFirstChild("Head")
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if dist < shortest then shortest = dist; closest = part end
                end
            end
        end
    end
    return closest
end

local function getClosestAimbotTarget()
    local closest = nil; local shortest = Settings.AimbotFOVSize
    local camCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local part = p.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - camCenter).Magnitude
                    if dist < shortest then shortest = dist; closest = part end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    local camCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    -- تثبيت الدوائر بنص الشاشة
    SilentFOVCircle.Position = camCenter
    AimbotFOVCircle.Position = camCenter

    -- تحديث السايلنت أيم
    if Settings.SilentAimEnabled then cachedSilentTarget = getClosestSilentTarget() else cachedSilentTarget = nil end
    
    -- تحديث الأيم بوت
    if Settings.AimbotEnabled then
        local targetHead = getClosestAimbotTarget()
        if targetHead then
            local targetCFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 / Settings.Smoothness)
        end
    end
end)

-- ==========================================
-- 5. نظام ESP
-- ==========================================
local espCache = {}
local function CreateESP(player)
    if player == LocalPlayer then return end
    local box = Drawing.new("Square"); box.Visible = false; box.Color = Color3.fromRGB(255, 50, 50); box.Thickness = 1; box.Filled = false
    local nameTag = Drawing.new("Text"); nameTag.Visible = false; nameTag.Color = Color3.fromRGB(255, 255, 255); nameTag.Size = 12; nameTag.Center = true; nameTag.Outline = true
    espCache[player] = {Box = box, Name = nameTag}
    player.CharacterRemoving:Connect(function() box.Visible = false; nameTag.Visible = false end)
end

for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(function(p) if espCache[p] then espCache[p].Box:Remove(); espCache[p].Name:Remove(); espCache[p] = nil end end)

RunService.RenderStepped:Connect(function()
    if not Settings.ESPEnabled then for _, data in pairs(espCache) do data.Box.Visible = false; data.Name.Visible = false end; return end
    for player, data in pairs(espCache) do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local hrp = char.HumanoidRootPart
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local headPos = Camera:WorldToViewportPoint(char.Head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                local height = math.abs(headPos.Y - legPos.Y); local width = height / 2
                data.Box.Size = Vector2.new(width, height); data.Box.Position = Vector2.new(vector.X - width / 2, headPos.Y); data.Box.Visible = true
                data.Name.Text = player.Name; data.Name.Position = Vector2.new(vector.X, headPos.Y - 16); data.Name.Visible = true
            else data.Box.Visible = false; data.Name.Visible = false end
        else data.Box.Visible = false; data.Name.Visible = false end
    end
end)

-- ==========================================
-- 6. دوال الفارم
-- ==========================================
local function SetGhostMode(isGhost)
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            if isGhost then part.LocalTransparencyModifier = 1 else part.LocalTransparencyModifier = 0 end
        end
    end
end

local function tweenTo(targetPos, duration)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    local hrp = char.HumanoidRootPart
    hrp.CanCollide = false
    local tweenInfo = TweenInfo.new(duration or 0.3, Enum.EasingStyle.Linear)
    local targetCFrame = CFrame.new(targetPos)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
    hrp.CanCollide = true
    return true
end

local function GetMoney()
    local stats = LocalPlayer:FindFirstChild("leaderstats") or LocalPlayer:FindFirstChild("Stats")
    if stats then
        local money = stats:FindFirstChild("Money") or stats:FindFirstChild("Cash") or stats:FindFirstChild("Coins")
        if money then return money.Value end
    end
    return 0
end

local function HasHackTool()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local char = LocalPlayer.Character
    if backpack and (backpack:FindFirstChild("Hack Tool") or backpack:FindFirstChild("Pro Hack Tool") or backpack:FindFirstChild("Laptop")) then return true end
    if char and (char:FindFirstChild("Hack Tool") or char:FindFirstChild("Pro Hack Tool") or char:FindFirstChild("Laptop")) then return true end
    return false
end

local function TryBuyTool()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    tweenTo(ToolVendorPos + Vector3.new(0, -4, 0), 0.3)
    task.wait(0.5)
    local params = OverlapParams.new(); params.FilterDescendantsInstances = {char}; params.FilterType = Enum.RaycastFilterType.Exclude
    local partsNear = Workspace:GetPartBoundsInRadius(ToolVendorPos, 15, params)
    local bestPrompt = nil; local cheapestPrompt = nil
    for _, part in pairs(partsNear) do
        local prompt = part:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            local text = prompt.ActionText:lower()
            if text:find("buy") or text:find("hack") or part.Name:lower():find("tool") then
                if text:find("pro") or text:find("advanced") then bestPrompt = prompt else cheapestPrompt = prompt end
            end
        end
    end
    if bestPrompt then pcall(function() fireproximityprompt(bestPrompt) end); task.wait(1) end
    if not HasHackTool() and cheapestPrompt then pcall(function() fireproximityprompt(cheapestPrompt) end); task.wait(1) end
    return HasHackTool()
end

-- ==========================================
-- 7. حلقة الأوتو فارم
-- ==========================================
task.spawn(function()
    while task.wait(1) do
        if Settings.AutoFarmATM then
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
            local currentMoney = GetMoney()
            if currentMoney < 10 and not HasHackTool() then
                game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Auto Farm"; Text = "You don't have enough money to buy a Hack Tool!"; Duration = 3 })
                Settings.AutoFarmATM = false
                continue
            end
            if not HasHackTool() then SetGhostMode(true); TryBuyTool() end
            if HasHackTool() then
                SetGhostMode(true)
                for _, atmPos in ipairs(AtmPositions) do
                    if not Settings.AutoFarmATM then break end
                    tweenTo(atmPos + Vector3.new(0, -4, 0), 0.3)
                    task.wait(0.5)
                    local params = OverlapParams.new(); params.FilterDescendantsInstances = {char}; params.FilterType = Enum.RaycastFilterType.Exclude
                    local partsNear = Workspace:GetPartBoundsInRadius(atmPos, 15, params)
                    for _, part in pairs(partsNear) do
                        local prompt = part:FindFirstChildOfClass("ProximityPrompt")
                        if prompt and (prompt.ActionText:lower():find("atm") or prompt.ActionText:lower():find("hack") or part.Name:lower():find("atm")) then
                            pcall(function() fireproximityprompt(prompt) end)
                            break
                        end
                    end
                    task.wait(2)
                end
            end
        else
            SetGhostMode(false)
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if Settings.AutoFarmATM then SetGhostMode(true) else SetGhostMode(false) end
end)

-- ==========================================
-- 8. تحريك الأيقونة
-- ==========================================
local dragging, dragStart, startPos
FloatingIcon.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = FloatingIcon.Position end end)
UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; FloatingIcon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
local function toggleMenu() MainFrame.Visible = not MainFrame.Visible end
FloatingIcon.Activated:Connect(toggleMenu)
CloseXBtn.Activated:Connect(toggleMenu)

print("Blockspin Master Hub V8.0 (Truly Fixed) Loaded Successfully!")
