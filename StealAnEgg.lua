-- [[ Steal An Egg: Advanced Multi-Rarity Menu With Floating Toggle Button ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- نظام تخطي الحظر والطرد (Anti-Kick)
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

-- إنشاء المنيو والواجهة الرسومية الرئيسية
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
MainFrame.Visible = true -- تظهر المنيو بشكل افتراضي

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "منيو سرقة البيض المتطور"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

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

-- [[ زر الإخفاء والإظهار العائم بالصورة ]]
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0) -- موقع الزر على يسار الشاشة
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.Image = "rbxassetid://10613271790" -- معرف صورة أيقونة جيمينج (يمكنك تغيير هذا الرقم لأي صورة روبلوكس تريدها)
ToggleButton.Active = true
ToggleButton.Draggable = true -- يمكنك سحب الزر العائم ووضعه في أي مكان على الشاشة بيدك

-- إضافة حواف دائرية للزر لجعله فخماً
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.5, 0) -- تجعل الزر دائرياً بالكامل
UICorner.Parent = ToggleButton

-- دالة عمل زر الإخفاء والإظهار عند الضغط
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- قيم التفعيل الافتراضية للندرات والأوتو فارم
_G.CustomAutoFarm = false
_G.AutoHatch = false
_G.Rarities = {
    ["mythic"] = false,
    ["legendary"] = false,
    ["cosmic"] = false,
    ["eternal"] = false,
    ["divine"] = false
}

-- دالة مساعدة لإنشاء أزرار التفعيل داخل القائمة
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

-- إنشاء أزرار التحكم
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
                        if egg:IsA("BasePart") or egg:IsA("Model") or egg:IsA("Tool") then
                            return egg
                        end
                    end
                end
            end
        end
    end
    return nil
end

-- حلقة الأوتو فارم الذكية والسرعة الفائقة
task.spawn(function()
    while true do
        task.wait(0.01)
        if _G.CustomAutoFarm then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if not char:FindFirstChildOfClass("Tool") and not LocalPlayer.Backpack:FindFirstChildOfClass("Tool") then
                        local egg = findTargetEgg()
                        if egg then
                            local pos = egg:IsA("Model") and egg:GetPivot().Position or egg.Position
                            hrp.CFrame = CFrame.new(pos)
                        end
                    else
                        local safeZone = findMySafeZone()
                        if safeZone then
                            local zonePos = safeZone:IsA("Model") and safeZone:GetPivot().Position or safeZone.Position
                            hrp.CFrame = CFrame.new(zonePos + Vector3.new(0, 3, 0))
                            task.wait(0.05)
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
        task.wait(0.5)
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

print("⚡ تم تحديث السكربت بالكامل مع زر الإخفاء الدائري العائم!")
