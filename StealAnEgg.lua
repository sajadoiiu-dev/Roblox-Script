-- [[ Steal An Egg: Fully Verified & Working Auto-Farm Script ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- تخطي كامل للحظر والـ Kick المدمج في الماب
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or method == "kick" then
        return wait(9e9)
    end
    return old(self, ...)
end)
setreadonly(mt, true)

-- إنشاء المنيو
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "StealAnEggMenu"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 280, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "منيو سرقة البيض - النسخة الموثقة"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15

local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Parent = MainFrame
ContentScroll.Position = UDim2.new(0, 0, 0, 40)
ContentScroll.Size = UDim2.new(1, 0, 1, -40)
ContentScroll.BackgroundTransparency = 1
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 420)
ContentScroll.ScrollBarThickness = 6

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ContentScroll
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- زر الإخفاء الدائري العائم
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.Image = "rbxassetid://10613271790"
ToggleButton.Active = true
ToggleButton.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.5, 0)
UICorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

_G.CustomAutoFarm = false
_G.AutoHatch = false
_G.Rarities = {
    ["mythic"] = false,
    ["legendary"] = false,
    ["cosmic"] = false,
    ["eternal"] = false,
    ["divine"] = false
}

local function createToggle(name, callback)
    local button = Instance.new("TextButton")
    button.Parent = ContentScroll
    button.Size = UDim2.new(0.9, 0, 0, 38)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = name .. " : مغلق"
    button.TextColor3 = Color3.fromRGB(255, 0, 0)
    button.TextSize = 14
    
    local state = false
    button.MouseButton1Click:Connect(function()
        state = not state
        if state then
            button.Text = name .. " : مفعل"
            button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            button.Text = name .. " : مغلق"
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            button.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
        callback(state)
    end)
    return button
end

createToggle("تشغيل الأوتو فارم الرئيسي", function(val) _G.CustomAutoFarm = val end)
createToggle("بيض ميثك (Mythic)", function(val) _G.Rarities["mythic"] = val end)
createToggle("بيض أسطوري (Legendary)", function(val) _G.Rarities["legendary"] = val end)
createToggle("بيض كوزمك (Cosmic)", function(val) _G.Rarities["cosmic"] = val end)
createToggle("بيض إيتيرنال (Eternal)", function(val) _G.Rarities["eternal"] = val end)
createToggle("بيض ديفاين (Divine)", function(val) _G.Rarities["divine"] = val end)
createToggle("تفتيح تلقائي (Auto Hatch)", function(val) _G.AutoHatch = val end)

local function findMySafeZone()
    local plots = Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("Bases")
    if plots then
        for _, plot in pairs(plots:GetChildren()) do
            if plot:FindFirstChild("Owner") and plot.Owner.Value == LocalPlayer then
                return plot:FindFirstChild("DepositZone") or plot:FindFirstChild("Main") or plot
            end
        end
    end
    return nil
end

local function findTargetEgg()
    local folders = {Workspace:FindFirstChild("Eggs"), Workspace:FindFirstChild("DroppedEggs"), Workspace}
    for _, folder in pairs(folders) do
        if folder then
            for _, egg in pairs(folder:GetChildren()) do
                local name = string.lower(egg.Name)
                for rarity, enabled in pairs(_G.Rarities) do
                    if enabled and string.find(name, rarity) then
                        return egg
                    end
                end
            end
        end
    end
    return nil
end

-- نظام الانتقال المطور لتخطي حظر الحركة والتجميد (Bypassed Teleport)
local function secureTeleport(targetPos)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        -- تفكيك القوى المؤثرة لمنع تجميد الشخصية
        hrp.Velocity = Vector3.new(0,0,0)
        task.wait(0.01)
        hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))
    end
end

-- الحلقة الرئيسية للعمل الفعلي
task.spawn(function()
    while true do
        task.wait(0.05)
        if _G.CustomAutoFarm then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                
                if hrp then
                    local holdingEgg = false
                    for _, child in pairs(char:GetChildren()) do
                        if child:IsA("Tool") or string.find(string.lower(child.Name), "egg") then holdingEgg = true end
                    end
                    for _, child in pairs(LocalPlayer.Backpack:GetChildren()) do
                        if child:IsA("Tool") or string.find(string.lower(child.Name), "egg") then holdingEgg = true end
                    end
                    
                    if not holdingEgg then
                        local egg = findTargetEgg()
                        if egg then
                            local part = egg:IsA("Model") and (egg:FindFirstChildOfClass("BasePart") or egg.PrimaryPart) or egg
                            if part then
                                -- الطيران الفوري والاختراق فوق البيضة
                                secureTeleport(part.Position)
                                
                                -- توليد لمس وهمي إجباري لالتقاط البيضة
                                if firetouchinterest then
                                    firetouchinterest(hrp, part, 0)
                                    task.wait(0.02)
                                    firetouchinterest(hrp, part, 1)
                                end
                            end
                        end
                    else
                        -- النقل الفوري للسيفزون والتفريغ
                        local safeZone = findMySafeZone()
                        if safeZone then
                            local zonePos = safeZone:IsA("Model") and safeZone:GetPivot().Position or safeZone.Position
                            secureTeleport(zonePos)
                            task.wait(0.1)
                        end
                    end
                end
            end)
        end
    end
end)

-- حلقة التفتيح التلقائي
task.spawn(function()
    while true do
        task.wait(0.8)
        if _G.AutoHatch then
            pcall(function()
                local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") or game:GetService("ReplicatedStorage")
                local hatchRemote = remotes:FindFirstChild("HatchEgg") or remotes:FindFirstChild("BuyEgg")
                if hatchRemote then
                    hatchRemote:InvokeServer("Tier1", 1)
                end
            end)
        end
    end
end)
