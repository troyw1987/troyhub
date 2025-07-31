local gameId, GameVersion = game.PlaceId, game.PlaceVersion
local settings = _G.Settings or {
    Run_Global_Chams = true,
    chams = {
        Enabled = true,
        UseTeamColor = true,
        Color = Color3.fromRGB(255,255,255),
        Transparency = 0.8,
        SameTeam = true,
        AlwaysOnTop = true,
        Self = false
    }
} -- defaults

_G.Utilities = _G.Utilities or {
    ["SendNotification"] = function(title,text)
        game:GetService("StarterGui"):SetCore("SendNotification",{Title = title,Text = text})
    end;
}

function main()
    local githubgame = "https://raw.githubusercontent.com/troyw1987/troyhub/refs/heads/main/games/%s.lua"
    local formatted = string.format(githubgame,tostring(gameId))

    loadstring(game:HttpGet(formatted))()

    if not settings.Run_Global_Chams then
        return
    end
    loadstring(game:HttpGet('https://raw.githubusercontent.com/troyw1987/troyhub/main/global_chams/minimal.lua'))()
end


