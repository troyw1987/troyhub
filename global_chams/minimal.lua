local settings = _G.Settings or {
    chams = {
        Enabled = true,
        UseTeamColor = true,
        Color = Color3.fromRGB(255,255,255),
        Transparency = 0.8,
        SameTeam = true,
        AlwaysOnTop = true,
        Self = false
    }
}

--Globals:
local CoreGui = game:GetService("CoreGui")
local players = game:GetService("Players")
local local_Player = players.LocalPlayer
local main_folder = CoreGui:FindFirstChild("Henlo")
_G.Signals = _G.Signals or {}

--Functions:
function chamPlayerPart(part,player,folder) -- welcome to "using advanced logical expressions to ELIMINATE if statements"
    local cham = Instance.new("BoxHandleAdornment",folder)
    cham.Adornee, cham.ZIndex, cham.Size, cham.CFrame = part,5,part.Size, CFrame.new(0,0,0) -- required stuff
    cham.Transparency, cham.AlwaysOnTop = _G.Settings.chams.Transparency, _G.Settings.chams.AlwaysOnTop -- directly set from settings
    cham.Color3 = (_G.Settings.chams.UseTeamColor and player.TeamColor.Color) or _G.Settings.chams.Color -- actual magic
    cham.Visible = (_G.Settings.chams.Enabled and ((player.TeamColor ~= local_Player.TeamColor or (_G.Settings.chams.SameTeam and player ~= local_Player)) or (_G.Settings.chams.Self and player == local_Player))) -- lmao
end

function chamCharacter(player,char)
    if not char or not char:WaitForChild("HumanoidRootPart",3) then return end
    local cham_Folder = Instance.new("Folder",main_folder)
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
        local folder = main_folder:FindFirstChild(player.Name)
        main_folder:FindFirstChild(player.Name):Destroy()
    end)
    local changed_event = player:GetPropertyChangedSignal("TeamColor"):Connect(function()
        main_folder:FindFirstChild(player.Name):Destroy()
        chamCharacter(player,player.Character)
    end)
    _G.Signals[player.Name] = {[1]=char_added_event,[2]=char_removing_event,[3]=changed_event}
end

function cleanup_crew()
    if not main_folder then game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Global Chams (Minimal)",Text = "👍 Change settings and re-execute as needed -T 👍"}) return end
    main_folder:Destroy()
    for _,v in pairs(_G.Signals) do
        if typeof(v) == "table" then
            v[1]:Disconnect(); v[2]:Disconnect(); v[3]:Disconnect(); -- players have their own table
        elseif typeof(v) == "RBXScriptSignal" then
            v:Disconnect() -- player added/removed and workspace added/removed events
        end
    end
    game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Global Chams",Text = "👍 Reloaded 👍"})
end

function main()
    cleanup_crew()

    main_folder = Instance.new("Folder",CoreGui)
    main_folder.Name = "Henlo"

    for _,player in pairs(players:GetPlayers()) do
        initialize_player(player)
    end

    _G.Signals["PlayerAdded"] = game.Players.PlayerAdded:Connect(function(player)
        initialize_player(player)
    end)

    _G.Signals["PlayerRemoved"] = game.Players.PlayerRemoving:Connect(function(player)
        for _,signal in pairs(_G.Signals[player.Name]) do
            signal:Disconnect()
        end
    end)
end

main()-- made by 426226778403504129 / troyw1987