-- [[ Steal An Egg: Full Script Part 1 ]]
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
        return wait(9e9) -- إيقاف عملية الطرد نهائياً
    end
    return old(self, ...)
end)
setreadonly(mt, true)

-- إنشاء المنيو (واجهة رسومية خفيفة لدلتا)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FarmToggle = Instance.new("TextButton")
local HatchToggle = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
MainFrame.Name = "StealAnEggMenu"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "منيو سرقة البيض النادر"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

_G.CustomAutoFarm = false
_G.AutoHatch = false

FarmToggle.Parent = MainFrame
FarmToggle.Position = UDim2.new(0.05, 0, 0.25, 0)
FarmToggle.Size = UDim2.new(0.9, 0, 0, 40)
FarmToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FarmToggle.Text = "تشغيل الأوتو فارم: مغلق"
FarmToggle.TextColor3 = Color3.fromRGB(255, 0, 0)
FarmToggle.TextSize = 16

FarmToggle.MouseButton1Click:Connect(function()
    _G.CustomAutoFarm = not _G.CustomAutoFarm
    if _G.CustomAutoFarm then
        FarmToggle.Text = "تشغيل الأوتو فارم: مفعل"
        FarmToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        FarmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        FarmToggle.Text = "تشغيل الأوتو فارم: مغلق"
        FarmToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        FarmToggle.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)
