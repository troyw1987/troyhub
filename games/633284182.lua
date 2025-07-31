local Players = game:GetService("Players")
local lPlayer = Players.LocalPlayer

--game:GetService("ReplicatedFirst").Modules.Initiate
local PlayerList = nil
local myPlayer = nil

-- my stats
local myFireTeam = 0
local myTeam = 0

function update()
    local registry = debug.getregistry()
    for i,v in pairs(registry) do
        if type(v) == "function" then

            if getfenv(v).script == game:GetService("ReplicatedFirst").Modules.Initiate then

                local abc = debug.getupvalues(v)
                for l,y in pairs(abc) do
                    
                    if PlayerList then break end
                    
                    if type(y) == "table" then
                        if y.PlayerList then
                            PlayerList = y.PlayerList
                            myPlayer = PlayerList[lPlayer.Name]
                            --print("got playerlist")
                        end
                    end
                end
            end
        end
    end
end

function quickCham(instance,color,updatingCham)
    local chamFolder
    local rootLoop
    local classCheck = "BasePart"

    if updatingCham then
        chamFolder = updatingCham

        rootLoop = chamFolder:GetChildren()
        classCheck = "BoxHandleAdornment"
    else
        chamFolder = Instance.new("Folder",instance)
        chamFolder.Name = "cheese"

        rootLoop = instance:GetChildren()
    end



    for _,child in pairs(rootLoop) do
        if child:IsA(classCheck) then
            local cham

            if classCheck == "BoxHandleAdornment" then
                cham = child
            else
                cham = Instance.new("BoxHandleAdornment",chamFolder)
                cham.Adornee = child
            end
            cham.Name = child.Name

            cham.Color3 = color
            cham.AlwaysOnTop = true
            cham.Size = child.Size
            cham.ZIndex = 5
            cham.Transparency = 0.7
        end
    end

end

function chamCharacter(playerTable,character,updatingCham)
    local theirTeam = playerTable.team
    local theirFireTeam = playerTable.fireteam.FireteamID


    --print(character.Name,theirFireTeam,myFireTeam)

    if theirTeam ~= myTeam then
        quickCham(character,Color3.fromRGB(255, 30, 30),updatingCham)
    elseif theirFireTeam == myFireTeam then
        quickCham(character,Color3.fromRGB(33, 255, 33),updatingCham)
    else
        quickCham(character,Color3.fromRGB(43, 163, 255),updatingCham)
    end
end

function main()
    update()
    myFireTeam = myPlayer.fireteam.FireteamID
    myTeam = myPlayer.team
    for playerName,playerTable in pairs(PlayerList) do
        if playerName == lPlayer.Name then
            playerTable.stamina = 60    
            continue 
        end

        local character = playerTable.character

        if character then
			if character:FindFirstChild("cheese") then
				chamCharacter(playerTable,character,character:FindFirstChild("cheese"))
            else
                chamCharacter(playerTable,character,nil)
			end
        end


        if playerTable.isStaff then
            print(playerName.." Is a staffmember -be careful")
        end

    end

end


function initilizeBuildableChams()
    local buildable = game:GetService("Workspace").BuildableObjects
    for _,v in pairs(buildable:GetChildren()) do
        quickCham(v,Color3.new(1,1,1),nil)
    end

    buildable.ChildAdded:Connect(function(child)
        quickCham(child,Color3.new(1,1,1),nil)
    end)
end

function initMain()
    lPlayer.PlayerGui.CropOverlay.Enabled = false
    main()
    initilizeBuildableChams()

    while task.wait(5) do
        main()
        initilizeBuildableChams()
    end
end

initMain()