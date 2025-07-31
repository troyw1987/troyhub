-- make phantom forces without textures - https://www.roblox.com/games/292439477
-- aka pfplastic :)
local mainAncestors = {game:GetService("Workspace").Map}

if game:GetService("Workspace"):FindFirstChild("MenuLobby") then
    table.insert(mainAncestors,game:GetService("Workspace").MenuLobby)
end

function textureInstances(instance)

    if not instance then
        table.remove(mainAncestors,table.find(mainAncestors,instance))
        return
    end

    if instance:IsA("BasePart") then
        instance.Material = Enum.Material.SmoothPlastic
    end
    
    if instance:GetChildren() ~= {} then
        for _,v in pairs(instance:GetChildren()) do
            textureInstances(v)
        end
    end
end

for _,v in pairs(mainAncestors) do
    textureInstances(v)
end

while wait(10) do
    for _,v in pairs(mainAncestors) do
        textureInstances(v)
    end
end