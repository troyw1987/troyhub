-- mm2, a classic
if _G.mm2 then return end
_G.mm2 = true

local mm2folder = Instance.new("Folder",game:GetService("CoreGui"))

function createChamOnPart(part,color3) -- welcome to "using advanced logical expressions to ELIMINATE if statements"
    local cham = Instance.new("BoxHandleAdornment",mm2folder)
    cham.Name, cham.Adornee, cham.Size, cham.ZIndex,cham.Transparency, cham.AlwaysOnTop = part.Name, part, part.Size, 2, 0.5, true
    cham.Color3 = 0.5

    cham.Visible = true
end

function updateCham(cham,color3)
    cham.Color3 = color3
end

function chamChar(char,color3,transparency)
    for _,v in pairs(char:GetChildren()) do
        if not v:IsA("BasePart") then continue end

        if not v:FindFirstChild("cham") then
            createChamOnPart(v,color3)
            continue
        end
        updateCham(v:FindFirstChild("Cham"),color3)
    end
end

while task.wait(5) do
    for _,v in pairs(game:GetService("Players"):GetPlayers()) do
        local backpack = v.Backpack
        local char = v.Character or v.CharacterAdded:Wait(3)
        if not char or not backpack then continue end

        local hasknife, hasgun = backpack:FindFirstChild("Knife"), backpack:FindFirstChild("Gun")
        if not hasgun and not hasknife then continue end

        local tocolor = Color3.new(0,0,0)
        if hasknife then
            tocolor = Color3.new(1,0,0)
        else
            tocolor = Color3.new(0,0,1)
        end

        chamChar(char,tocolor)
    end
end
