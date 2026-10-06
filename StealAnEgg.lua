_G.AutoFarm = true

task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.01) -- منع اللاق تماماً
        
        local WorkspaceEggs = workspace:FindFirstChild("Eggs") or workspace:FindFirstChild("WorldEggs") or workspace
        local Player = game.Players.LocalPlayer
        
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local Root = Player.Character.HumanoidRootPart
            
            for _, egg in pairs(WorkspaceEggs:GetChildren()) do
                -- البحث الذكي: السكربت يقرأ أي نص مكتوب فوق البيضة تلقائياً
                local hasName = egg:FindFirstChildOfClass("BillboardGui") or egg:FindFirstChildOfClass("SurfaceGui")
                local eggName = egg.Name:lower()
                
                -- إذا كان اسم البيضة أو اللوحة المكتوبة فوقها تحتوي على أحد التطويرات
                if string.find(eggName, "mythic") or string.find(eggName, "secret") or string.find(eggName, "eternal") or string.find(eggName, "divine") or (hasName and (string.find(hasName:GetFullScreenText():lower(), "mythic") or string.find(hasName:GetFullScreenText():lower(), "secret"))) then
                    
                    pcall(function()
                        -- الانتقال والجمع الفوري
                        Root.CFrame = egg:GetModelCFrame() or egg.CFrame
                        firetouchinterest(Root, egg, 0)
                        task.wait()
                        firetouchinterest(Root, egg, 1)
                    end)
                    
                    task.wait(0.05)
                    break
                end
            end
        end
    end
end)
