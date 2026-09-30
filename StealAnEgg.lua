-- [[ Steal An Egg: Fast Auto-Farm (Eternal & Divine Only) ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

_G.CustomAutoFarm = true 

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
                if string.find(name, "eternal") or string.find(name, "divine") then
                    if egg:IsA("BasePart") or egg:IsA("Model") or egg:IsA("Tool") then
                        return egg
                    end
                end
            end
        end
    end
    return nil
end

task.spawn(function()
    while _G.CustomAutoFarm and task.wait(0.01) do 
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
end)
