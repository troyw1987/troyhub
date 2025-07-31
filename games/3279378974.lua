-- no recoil: https://www.roblox.com/games/3279378974/HALLOWEEN-Weapon-Warfare
-- UPVAUES!!

local plr = game:GetService("Players").LocalPlayer

function noRecoil(script)
    for i,v in pairs(getsenv(script)) do
        if type(v) == "function" then
            if i == "RecoilCamera" then
                for l,y in pairs(debug.getupvalues(v)) do
                    
                    debug.setupvalue(v,1,0)
                    
                end
            end
        end
    end
end


function isGun(tool)
    if tool:FindFirstChild("GunScript_Local") then
        return true
    end
    return false
end

function getTools()
    local char = plr.Character or plr.CharacterAdded:Wait()
    local tools = {}

    for _,v in pairs(plr.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            if isGun(v) then
                noRecoil(v:FindFirstChild("GunScript_Local"))
            end
        end
    end

    for _,v in pairs(char:GetChildren()) do
        if v:IsA("Tool") then
            if isGun(v) then
                noRecoil(v:FindFirstChild("GunScript_Local"))
            end
        end
    end
end

while wait(1) do
    getTools()
end