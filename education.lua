if game.PlaceId == 9999999999 then
    if game.CoreGui:FindFirstChild("FluxLib") then
        game.CoreGui:FindFirstChild("FluxLib"):Destroy()
    end
    local Flux = loadstring(game:HttpGet "")()
    local mcwin = Flux:Window("HUB", "THAILAND", Color3.fromRGB(0, 255, 104), Enum.KeyCode.Insert)
    local autofarmmer = mcwin:Tab("Auto Farm", "http://www.roblox.com/asset/?id=6023426915")
    local automaticstats = mcwin:Tab("Auto Stats", "http://www.roblox.com/asset/?id=6023426915")
    local pvplobbyteletubies = mcwin:Tab("Lobby", "http://www.roblox.com/asset/?id=6023426915")
    local misctobenumberone = mcwin:Tab("Misc", "http://www.roblox.com/asset/?id=6023426915")
    local configpath = mcwin:Tab("Config", "http://www.roblox.com/asset/?id=6023426915")

    for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.SaveGui.AntiAutoClick:GetChildren()) do
        if v.Name == "AntiAutoClickScript" then
            v.Disabled = true
        end
    end

    local tween
    function toTarget(pos, targetPos, targetCFrame)
        local tween_s = game:service "TweenService"
        local info = TweenInfo.new((targetPos - pos).Magnitude / 256, Enum.EasingStyle.Linear)
        local tic_k = tick()
        local tween, err =
            pcall(
            function()
                tween =
                    tween_s:Create(
                    game.Players.LocalPlayer.Character["HumanoidRootPart"],
                    info,
                    {CFrame = targetCFrame}
                )
                tween:Play()
            end
        )
        if not tween then
            return err
        end
    end

    function fgnmp()
        local Config = {
            ProtectedName = "NameProtect", --What the protected name should be called.
            OtherPlayers = false, --If other players should also have protected names.
            OtherPlayersTemplate = "NameProtect", --Template for other players protected name (ex: "NamedProtect" will turn into "NameProtect1" for first player and so on)
            RenameTextBoxes = false, --If TextBoxes should be renamed. (could cause issues with admin guis/etc)
            UseFilterPadding = false, --If filtered name should be the same size as a regular name.
            FilterPad = " ", --Character used to filter pad.
            UseMetatableHook = false, --Use metatable hook to increase chance of filtering. (is not supported on wrappers like bleu)
            UseAggressiveFiltering = false --Use aggressive property renaming filter. (renames a lot more but at the cost of lag)
        }

        local ProtectedNames = {}
        local Counter = 1
        if Config.OtherPlayers then
            for I, V in pairs(game:GetService("Players"):GetPlayers()) do
                local Filter = Config.OtherPlayersTemplate .. tostring(Counter)
                if Config.UseFilterPadding then
                    if string.len(Filter) > string.len(V.Name) then
                        Filter = string.sub(Filter, 1, string.len(V.Name))
                    elseif string.len(Filter) < string.len(V.Name) then
                        local Add = string.len(V.Name) - string.len(Filter)
                        for I = 1, Add do
                            Filter = Filter .. Config.FilterPad
                        end
                    end
                end
                ProtectedNames[V.Name] = Filter
                Counter = Counter + 1
            end

            game:GetService("Players").PlayerAdded:connect(
                function(Player)
                    local Filter = Config.OtherPlayersTemplate .. tostring(Counter)
                    if Config.UseFilterPadding then
                        if string.len(Filter) > string.len(V.Name) then
                            Filter = string.sub(Filter, 1, string.len(V.Name))
                        elseif string.len(Filter) < string.len(V.Name) then
                            local Add = string.len(V.Name) - string.len(Filter)
                            for I = 1, Add do
                                Filter = Filter .. Config.FilterPad
                            end
                        end
                    end
                    ProtectedNames[Player.Name] = Filter
                    Counter = Counter + 1
                end
            )
        end

        local LPName = game:GetService("Players").LocalPlayer.Name
        local IsA = game.IsA

        if Config.UseFilterPadding then
            if string.len(Config.ProtectedName) > string.len(LPName) then
                Config.ProtectedName = string.sub(Config.ProtectedName, 1, string.len(LPName))
            elseif string.len(Config.ProtectedName) < string.len(LPName) then
                local Add = string.len(LPName) - string.len(Config.ProtectedName)
                for I = 1, Add do
                    Config.ProtectedName = Config.ProtectedName .. Config.FilterPad
                end
            end
        end

        local function FilterString(S)
            local RS = S
            if Config.OtherPlayers then
                for I, V in pairs(ProtectedNames) do
                    RS = string.gsub(RS, I, V)
                end
            end
            RS = string.gsub(RS, LPName, Config.ProtectedName)
            return RS
        end

        for I, V in pairs(game:GetDescendants()) do
            if Config.RenameTextBoxes then
                if IsA(V, "TextLabel") or IsA(V, "TextButton") or IsA(V, "TextBox") then
                    V.Text = FilterString(V.Text)

                    if Config.UseAggressiveFiltering then
                        V:GetPropertyChangedSignal("Text"):connect(
                            function()
                                V.Text = FilterString(V.Text)
                            end
                        )
                    end
                end
            else
                if IsA(V, "TextLabel") or IsA(V, "TextButton") then
                    V.Text = FilterString(V.Text)

                    if Config.UseAggressiveFiltering then
                        V:GetPropertyChangedSignal("Text"):connect(
                            function()
                                V.Text = FilterString(V.Text)
                            end
                        )
                    end
                end
            end
        end

        if Config.UseAggressiveFiltering then
            game.DescendantAdded:connect(
                function(V)
                    if Config.RenameTextBoxes then
                        if IsA(V, "TextLabel") or IsA(V, "TextButton") or IsA(V, "TextBox") then
                            V:GetPropertyChangedSignal("Text"):connect(
                                function()
                                    V.Text = FilterString(V.Text)
                                end
                            )
                        end
                    else
                        if IsA(V, "TextLabel") or IsA(V, "TextButton") then
                            V:GetPropertyChangedSignal("Text"):connect(
                                function()
                                    V.Text = FilterString(V.Text)
                                end
                            )
                        end
                    end
                end
            )
        end

        if Config.UseMetatableHook then
            if not getrawmetatable then
                error("GetRawMetaTable not found")
            end

            local NewCC = function(F)
                if newcclosure then
                    return newcclosure(F)
                end
                return F
            end

            local SetRO = function(MT, V)
                if setreadonly then
                    return setreadonly(MT, V)
                end
                if not V and make_writeable then
                    return make_writeable(MT)
                end
                if V and make_readonly then
                    return make_readonly(MT)
                end
                error("No setreadonly found")
            end

            local MT = getrawmetatable(game)
            local OldNewIndex = MT.__newindex
            SetRO(MT, false)

            MT.__newindex =
                NewCC(
                function(T, K, V)
                    if Config.RenameTextBoxes then
                        if
                            (IsA(T, "TextLabel") or IsA(T, "TextButton") or IsA(T, "TextBox")) and K == "Text" and
                                type(V) == "string"
                         then
                            return OldNewIndex(T, K, FilterString(V))
                        end
                    else
                        if (IsA(T, "TextLabel") or IsA(T, "TextButton")) and K == "Text" and type(V) == "string" then
                            return OldNewIndex(T, K, FilterString(V))
                        end
                    end

                    return OldNewIndex(T, K, V)
                end
            )

            SetRO(MT, true)
        end
    end

    local kv = {
        [1] = "Kill Villain"
    }
    local kph = {
        [1] = "Kill Pro Hero"
    }
    local kcr = {
        [1] = "Kill Criminal"
    }
    local kho = {
        [1] = "Kill Hero"
    }
    local khd = {
        [1] = "Kill High End"
    }
    local kpe = {
        [1] = "Kill Police"
    }
    local kua = {
        [1] = "Defeat UA Student"
    }
    local kwu = {
        [1] = "Kill Weak Nomu"
    }
    local moveonstr = {
        [1] = 1
    }
    local moveonagi = {
        [1] = 1
    }
    local moveond = {
        [1] = 1
    }
    local kwvn = {
        [1] = "Kill Weak Villain"
    }

    function qkv()
        game:GetService("ReplicatedStorage").Remotes.Quest.AcceptQuest:FireServer(unpack(kv))
        game:GetService("ReplicatedStorage").Remotes.Quest.CompleteQuest:FireServer(unpack(kv))
    end

    function qph()
        game:GetService("ReplicatedStorage").Remotes.Quest.AcceptQuest:FireServer(unpack(kph))
        game:GetService("ReplicatedStorage").Remotes.Quest.CompleteQuest:FireServer(unpack(kph))
    end

    function qcr()
        game:GetService("ReplicatedStorage").Remotes.Quest.AcceptQuest:FireServer(unpack(kcr))
        game:GetService("ReplicatedStorage").Remotes.Quest.CompleteQuest:FireServer(unpack(kcr))
    end

    function qho()
        game:GetService("ReplicatedStorage").Remotes.Quest.AcceptQuest:FireServer(unpack(kho))
        game:GetService("ReplicatedStorage").Remotes.Quest.CompleteQuest:FireServer(unpack(kho))
    end

    function qhd()
        game:GetService("ReplicatedStorage").Remotes.Quest.AcceptQuest:FireServer(unpack(khd))
        game:GetService("ReplicatedStorage").Remotes.Quest.CompleteQuest:FireServer(unpack(khd))
    end

    function qpe()
        game:GetService("ReplicatedStorage").Remotes.Quest.AcceptQuest:FireServer(unpack(kpe))
        game:GetService("ReplicatedStorage").Remotes.Quest.CompleteQuest:FireServer(unpack(kpe))
    end

    function qua()
        game:GetService("ReplicatedStorage").Remotes.Quest.AcceptQuest:FireServer(unpack(kua))
        game:GetService("ReplicatedStorage").Remotes.Quest.CompleteQuest:FireServer(unpack(kua))
    end

    function qwu()
        game:GetService("ReplicatedStorage").Remotes.Quest.AcceptQuest:FireServer(unpack(kwu))
        game:GetService("ReplicatedStorage").Remotes.Quest.CompleteQuest:FireServer(unpack(kwu))
    end

    function qwvn()
        game:GetService("ReplicatedStorage").Remotes.Quest.AcceptQuest:FireServer(unpack(kwvn))
        game:GetService("ReplicatedStorage").Remotes.Quest.CompleteQuest:FireServer(unpack(kwvn))
    end

    function autocheckbotters()
        if SelectExpert == "Villain" then
            qkv()
        elseif SelectExpert == "Weak Villain" then
            qwvn()
        elseif SelectExpert == "Pro Hero" then
            qph()
        elseif SelectExpert == "Criminal" then
            qcr()
        elseif SelectExpert == "Hero" then
            qho()
        elseif SelectExpert == "High End" then
            qhd()
        elseif SelectExpert == "Police" then
            qpe()
        elseif SelectExpert == "UA Student" then
            qua()
        elseif SelectExpert == "Weak Nomu" then
            qwu()
        end
    end

    function nowhere()
        game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
    end

    function comteebats()
        keypress(0x45)
        keyrelease(0x45)
    end

    function autokicker()
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton1(Vector2.new(851, 158), game:GetService("Workspace").Camera.CFrame)
    end

    function strauto()
        game:GetService("ReplicatedStorage").Remotes.Strength:FireServer(unpack(moveonstr))
    end

    function agiauto()
        game:GetService("ReplicatedStorage").Remotes.Agility:FireServer(unpack(moveonagi))
    end
    function dauto()
        game:GetService("ReplicatedStorage").Remotes.Durability:FireServer(unpack(moveond))
    end

    function doubleqf()
        keypress(0x51)
        keyrelease(0x51)
    end

    function doublezf()
        keypress(0x5A)
        keyrelease(0x5A)
    end

    function doublexf()
        keypress(0x58)
        keyrelease(0x58)
    end

    function doublecf()
        keypress(0x43)
        keyrelease(0x43)
    end

    function doublevf()
        keypress(0x56)
        keyrelease(0x56)
    end

    function doubleff()
        keypress(0x46)
        keyrelease(0x46)
    end

    function doublebf()
        keypress(0x42)
        keyrelease(0x42)
    end

    SelectExpert = ""
    autofarmmer:Line()
    autofarmmer:Dropdown(
        "Select NPCs",
        {
            "Police",
            "Criminal",
            "Pro Hero",
            "Hero",
            "Mount Lady",
            "Endeavor",
            "Villain",
            "UA Student",
            "Midnight",
            "Tomura",
            "Gang Orca",
            "All Might 1",
            "Forest Beast",
            "Dabi",
            "Gigantomachia",
            "Noumu",
            "Overhaul",
            "High End",
            "Hawks",
            "Weak Nomu",
            "Awakened Tomura",
            "Present Mic",
            "AllForOne",
            "Weak Villain",
            "Deku"
        },
        function(pjy)
            SelectExpert = pjy
        end
    )

    autofarmmer:Toggle(
        "AUTO FARM",
        "AUTO FARM",
        false,
        function(vac)
            _G.autobot = vac
            spawn(
                function()
                    while _G.autobot do
                        wait()
                        pcall(
                            function()
                                autoslaybotter()
                            end
                        )
                    end
                end
            )
        end
    )
    autofarmmer:Line()
    autofarmmer:Label("If You Don't Have Weapons Please Select Combat")
    autofarmmer:Line()
    autofarmmer:Toggle(
        "Combat",
        "If You Don't Have Weapons Please Select Combat",
        false,
        function(mintans)
            _G.teebats = mintans
            spawn(
                function()
                    while _G.teebats do
                        wait()
                        pcall(
                            function()
                                if _G.autobot == true then
                                    comteebats()
                                end
                            end
                        )
                    end
                end
            )
        end
    )
    autofarmmer:Line()

    automaticstats:Line()
    automaticstats:Label("Select Option You Want.")
    automaticstats:Line()
    automaticstats:Toggle(
        "STRENGTH",
        "STRENGTH",
        false,
        function(astr)
            _G.autostr = astr
            spawn(
                function()
                    while _G.autostr do
                        wait()
                        pcall(
                            function()
                                strauto()
                            end
                        )
                    end
                end
            )
        end
    )

    automaticstats:Toggle(
        "AGILITY",
        "AGILITY",
        false,
        function(aagi)
            _G.autoagi = aagi
            spawn(
                function()
                    while _G.autoagi do
                        wait()
                        pcall(
                            function()
                                agiauto()
                            end
                        )
                    end
                end
            )
        end
    )

    automaticstats:Toggle(
        "DURABILITY",
        "DURABILITY",
        false,
        function(ad)
            _G.autod = ad
            spawn(
                function()
                    while _G.autod do
                        wait()
                        pcall(
                            function()
                                dauto()
                            end
                        )
                    end
                end
            )
        end
    )

    automaticstats:Line()

    pvplobbyteletubies:Line()
    pvplobbyteletubies:Label("Click To Teleport To Lobby")
    pvplobbyteletubies:Line()
    pvplobbyteletubies:Button(
        "TELEPORT",
        "Click To Teleport To Lobby.",
        function()
            game:GetService("ReplicatedStorage").LobbyRemotes.Teleport:FireServer()
        end
    )
    pvplobbyteletubies:Line()

    misctobenumberone:Line()
    misctobenumberone:Label("Please Select Option.")
    misctobenumberone:Line()
    misctobenumberone:Button(
        "Name Protect",
        "Name Protect",
        function()
            fgnmp()
        end
    )
    misctobenumberone:Line()

    configpath:Line()
    configpath:Label("Setting")
    configpath:Line()
    configpath:Toggle(
        "Auto Click",
        "Auto Click",
        false,
        function(crink)
            _G.crying = crink
            spawn(
                function()
                    while _G.crying do
                        wait()
                        pcall(
                            function()
                                if _G.autobot == true then
                                    autokicker()
                                end
                            end
                        )
                    end
                end
            )
        end
    )
    configpath:Line()
    configpath:Label("Auto Skill")
    configpath:Toggle(
        "Q",
        "Q",
        false,
        function(qq)
            _G.doubleq = qq
            spawn(
                function()
                    while _G.doubleq do
                        wait(1)
                        pcall(
                            function()
                                if _G.autobot == true then
                                    doubleqf()
                                end
                            end
                        )
                    end
                end
            )
        end
    )

    configpath:Toggle(
        "Z",
        "Z",
        false,
        function(zz)
            _G.doublez = zz
            spawn(
                function()
                    while _G.doublez do
                        wait(1.14)
                        pcall(
                            function()
                                if _G.autobot == true then
                                    doublezf()
                                end
                            end
                        )
                    end
                end
            )
        end
    )

    configpath:Toggle(
        "X",
        "X",
        false,
        function(xx)
            _G.doublex = xx
            spawn(
                function()
                    while _G.doublex do
                        wait(1.24)
                        pcall(
                            function()
                                if _G.autobot == true then
                                    doublexf()
                                end
                            end
                        )
                    end
                end
            )
        end
    )

    configpath:Toggle(
        "C",
        "C",
        false,
        function(cc)
            _G.doublec = cc
            spawn(
                function()
                    while _G.doublec do
                        wait(1.34)
                        pcall(
                            function()
                                doublecf()
                            end
                        )
                    end
                end
            )
        end
    )

    configpath:Toggle(
        "V",
        "V",
        false,
        function(vv)
            _G.doublev = vv
            spawn(
                function()
                    while _G.doublev do
                        wait(1.44)
                        pcall(
                            function()
                                if _G.autobot == true then
                                    doublevf()
                                end
                            end
                        )
                    end
                end
            )
        end
    )

    configpath:Toggle(
        "F",
        "F",
        false,
        function(ff)
            _G.doublef = ff
            spawn(
                function()
                    while _G.doublef do
                        wait(1.54)
                        pcall(
                            function()
                                if _G.autobot == true then
                                    doubleff()
                                end
                            end
                        )
                    end
                end
            )
        end
    )

    configpath:Toggle(
        "B",
        "B",
        false,
        function(bb)
            _G.doubleb = bb
            spawn(
                function()
                    while _G.doubleb do
                        wait(1)
                        pcall(
                            function()
                                if _G.autobot == true then
                                    doublebf()
                                end
                            end
                        )
                    end
                end
            )
        end
    )
    configpath:Line()

    function autoslaybotter()
        for i, v in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
            if v.Name == SelectExpert then
                repeat
                    wait()
                    autocheckbotters()
                    nowhere()
                    toTarget(
                        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position,
                        v.HumanoidRootPart.Position,
                        v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 0) - v.HumanoidRootPart.CFrame.lookVector * 2.1
                    )
                until v.Humanoid.Health == 0 or _G.autobot == false
            end
        end
    end
elseif game.PlaceId ~= 1499872953 then
    game.Players.localPlayer:Kick("Games Not Supports.")
end
