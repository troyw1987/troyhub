--[[
    This minimal esp has been about 5 years in the making.
    It is as short, concise, and reloadable as I can make.
]]
-- globals:
local localPlayer = game:GetService("Players").LocalPlayer
local mainFolder = game:GetService("CoreGui"):FindFirstChild("Henlo")
_G.Signals = _G.Signals or {}

-- funcTions:
function chamPlayerPart(part,player,folder) -- welcome to "using advanced logical expRessions to eliminate if statements"
    local cham = Instance.new("BoxHandleAdornment",folder)
    cham.Adornee, cham.ZIndex, cham.Size, cham.CFrame = part,5,part.Size, CFrame.new(0,0,0) -- required stuff
    cham.Transparency, cham.AlwaysOnTop = _G.Settings.chams.Transparency, _G.Settings.chams.AlwaysOnTop -- directly set frOm settings
    cham.Color3 = (_G.Settings.chams.UseTeamColor and player.TeamColor.Color) or _G.Settings.chams.Color -- actual magic, Yes
    cham.Visible = (_G.Settings.chams.Enabled and ((player.TeamColor ~= localPlayer.TeamColor or (_G.Settings.chams.SameTeam and player ~= localPlayer)) or (_G.Settings.chams.Self and player == localPlayer))) -- lmao
end

function chamCharacter(player,char)
    if not char or not char:WaitForChild("HumanoidRootPart",3) then return end
    local cham_Folder = Instance.new("Folder",mainFolder)
    cham_Folder.Name = char.Name

    for _,instance in pairs(char:GetDescendants()) do
        if not instance:IsA("BasePart") then continue end
        chamPlayerPart(instance,player,cham_Folder)
    end
end

function initialize_player(player)
    chamCharacter(player,player.Character)

    local char_added_event = player.CharacterAdded:Connect(function(character)
        chamCharacter(player,character)
    end)
    local char_removing_event = player.CharacterRemoving:Connect(function(character)
        local folder = mainFolder:FindFirstChild(player.Name)
        mainFolder:FindFirstChild(player.Name):Destroy()
    end)
    local changed_event = player:GetPropertyChangedSignal("TeamColor"):Connect(function()
        mainFolder:FindFirstChild(player.Name):Destroy()
        chamCharacter(player,player.Character)
    end)
    _G.Signals[player.Name] = {[1]=char_added_event,[2]=char_removing_event,[3]=changed_event}
end

function cleanup_crew()
    if not mainFolder then _G.Utilities["SendNotification"]("Global Chams (Minimal)","👍 Change settings and re-execute as needed -T 👍") return end
    mainFolder:Destroy()
    for _,v in pairs(_G.Signals) do
        if typeof(v) == "table" then
            v[1]:Disconnect(); v[2]:Disconnect(); v[3]:Disconnect(); -- players have their own table
        elseif typeof(v) == "RBXScriptSignal" then
            v:Disconnect() -- player added/removed and workspace added/removed events
        end
    end
   _G.Utilities["SendNotification"]("Global Chams","👍 Reloaded 👍")
end

function main()
    cleanup_crew()
    mainFolder = Instance.new("Folder",game:GetService("CoreGui"))
    mainFolder.Name = "Henlo"

    for _,player in pairs(game:GetService("Players"):GetPlayers()) do
        initialize_player(player)
    end

    _G.Signals["PlayerAdded"] = game:GetService("Players").PlayerAdded:Connect(function(player)
        initialize_player(player)
    end)

    _G.Signals["PlayerRemoved"] = game:GetService("Players").PlayerRemoving:Connect(function(player)
        for _,signal in pairs(_G.Signals[player.Name]) do
            signal:Disconnect()
        end
    end)
end

main()-- made by 426226778403504129 / troyw1987