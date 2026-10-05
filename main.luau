local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/D4rkRoblox/Meow-Madness-Script/refs/heads/main/Components/Interface.luau"
))()

local ESPLibrary = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/D4rkRoblox/Meow-Madness-Script/refs/heads/main/Components/ESP.luau"
))()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")

local OriginalLighting = {
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ColorShift_Top = Lighting.ColorShift_Top,
    ColorShift_Bottom = Lighting.ColorShift_Bottom,
    FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd,
    FogColor = Lighting.FogColor
}

local FullBrightEnabled = false
local FullBrightIntensity = 10
local FogEnabled = false
local FogStartValue = Lighting.FogStart
local FogEndValue = Lighting.FogEnd
local FogColorValue = Lighting.FogColor
local CustomSky = nil

local SkyPresets = {
    ["Purple Nebula"] = {
        SkyboxBk = "rbxassetid://159454299",
        SkyboxDn = "rbxassetid://159454296",
        SkyboxFt = "rbxassetid://159454293",
        SkyboxLf = "rbxassetid://159454286",
        SkyboxRt = "rbxassetid://159454300",
        SkyboxUp = "rbxassetid://159454288"
    },
    ["Dusty Clouds"] = {
        SkyboxBk = "rbxassetid://252760981",
        SkyboxDn = "rbxassetid://252763035",
        SkyboxFt = "rbxassetid://252761439",
        SkyboxLf = "rbxassetid://252760980",
        SkyboxRt = "rbxassetid://252760986",
        SkyboxUp = "rbxassetid://252762652"
    },
    ["Night Sky"] = {
        SkyboxBk = "rbxassetid://12064107",
        SkyboxDn = "rbxassetid://12064152",
        SkyboxFt = "rbxassetid://12064121",
        SkyboxLf = "rbxassetid://12063984",
        SkyboxRt = "rbxassetid://12064115",
        SkyboxUp = "rbxassetid://12064131"
    },
    ["Pink Daylight"] = {
        SkyboxBk = "rbxassetid://271042516",
        SkyboxDn = "rbxassetid://271077243",
        SkyboxFt = "rbxassetid://271042556",
        SkyboxLf = "rbxassetid://271042310",
        SkyboxRt = "rbxassetid://271042467",
        SkyboxUp = "rbxassetid://271077958"
    },
    ["Sunset"] = {
        SkyboxBk = "rbxassetid://323494035",
        SkyboxDn = "rbxassetid://323494368",
        SkyboxFt = "rbxassetid://323494130",
        SkyboxLf = "rbxassetid://323494252",
        SkyboxRt = "rbxassetid://323494067",
        SkyboxUp = "rbxassetid://323493360"
    }
}

local function ApplyFullBright()
    if FullBrightEnabled then
        Lighting.Brightness = FullBrightIntensity
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
        Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.Ambient = OriginalLighting.Ambient
        Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        Lighting.ColorShift_Top = OriginalLighting.ColorShift_Top
        Lighting.ColorShift_Bottom = OriginalLighting.ColorShift_Bottom
    end
end

local function SetSkyPreset(Name)
    if CustomSky and CustomSky.Parent then
        CustomSky:Destroy()
        CustomSky = nil
    end

    local Preset = SkyPresets[Name]
    if not Preset then
        return
    end

    local Sky = Instance.new("Sky")
    Sky.Name = "MeowMadness_CustomSky"
    Sky.SkyboxBk = Preset.SkyboxBk
    Sky.SkyboxDn = Preset.SkyboxDn
    Sky.SkyboxFt = Preset.SkyboxFt
    Sky.SkyboxLf = Preset.SkyboxLf
    Sky.SkyboxRt = Preset.SkyboxRt
    Sky.SkyboxUp = Preset.SkyboxUp
    Sky.Parent = Lighting
    CustomSky = Sky
end

local function ApplyFog()
    if FogEnabled then
        Lighting.FogStart = FogStartValue
        Lighting.FogEnd = FogEndValue
        Lighting.FogColor = FogColorValue
    else
        Lighting.FogStart = OriginalLighting.FogStart
        Lighting.FogEnd = OriginalLighting.FogEnd
        Lighting.FogColor = OriginalLighting.FogColor
    end
end


local Window = Library:CreateWindow({
    Title = "Meow Madness",
    Footer = "v1.0.0",
    ToggleKeybind = Enum.KeyCode.RightShift,
    Center = true,
    AutoShow = true
})

local MainTab = Window:AddTab({
    Name = "Main",
    Icon = "terminal",
    Description = "Main features",
    Order = 1
})

local AutoTab = Window:AddTab({
    Name = "Auto",
    Icon = "refresh-cw",
    Description = "Automatic features",
    Order = 2
})

local RageTab = Window:AddTab({
    Name = "Rage",
    Icon = "swords",
    Description = "Rage features",
    Order = 3
})

local VisualsTab = Window:AddTab({
    Name = "Visuals",
    Icon = "eye",
    Description = "Visual features",
    Order = 4
})

local PlayerESPEnabled = false
local PlayerESPColor = Color3.fromRGB(255, 80, 80)
local PlayerESPObjects = {}
local PlayerConnections = {}

local FishESPEnabled = false
local FishESPColor = Color3.fromRGB(80, 170, 255)
local FishESPObjects = {}

local function AddESP(Object, Text, Color)
    if not Object then
        return false
    end

    if not Object:IsA("BasePart") and not Object:IsA("Model") then
        return false
    end

    ESPLibrary:AddESP({
        Object = Object,
        Text = Text,
        Color = Color
    })

    return true
end

local function RemoveESP(Object)
    if Object then
        ESPLibrary:RemoveESP(Object)
    end
end

local function RemovePlayerESP(Player)
    local Character = PlayerESPObjects[Player]
    if Character then
        RemoveESP(Character)
        PlayerESPObjects[Player] = nil
    end
end

local function AddPlayerESP(Player)
    if not PlayerESPEnabled or Player == LocalPlayer then
        return
    end

    RemovePlayerESP(Player)

    local Character = Player.Character
    if not Character or not Character.Parent then
        return
    end

    local Root = Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChildWhichIsA("BasePart")

    if not Root then
        return
    end

    if AddESP(Character, Player.Name, PlayerESPColor) then
        PlayerESPObjects[Player] = Character
    end
end

local function SetPlayerESP(Value)
    PlayerESPEnabled = Value

    if Value then
        for _, Player in ipairs(Players:GetPlayers()) do
            AddPlayerESP(Player)
        end
    else
        for _, Player in ipairs(Players:GetPlayers()) do
            RemovePlayerESP(Player)
        end
    end
end

local function GetFishPickupsFolder()
    return Workspace:FindFirstChild("FishPickups")
end

local function IsFishESPObject(Object)
    if not Object then
        return false
    end

    if Object:IsA("Sound") then
        return false
    end

    return Object:IsA("Model") or Object:IsA("BasePart")
end

local function AddFishESP(Object)
    if not FishESPEnabled then
        return
    end

    local Folder = GetFishPickupsFolder()

    if not Folder or not Object:IsDescendantOf(Folder) then
        return
    end

    if not IsFishESPObject(Object) then
        return
    end

    if FishESPObjects[Object] then
        return
    end

    if AddESP(Object, "Fish", FishESPColor) then
        FishESPObjects[Object] = true
    end
end

local function ScanForFish()
    local Folder = GetFishPickupsFolder()

    if not Folder then
        return
    end

    for _, Object in ipairs(Folder:GetDescendants()) do
        if IsFishESPObject(Object) then
            AddFishESP(Object)
        end
    end
end

local function RemoveFishESP(Object)
    if FishESPObjects[Object] then
        RemoveESP(Object)
        FishESPObjects[Object] = nil
    end
end

local function SetFishESP(Value)
    FishESPEnabled = Value

    if Value then
        ScanForFish()
    else
        for Object in pairs(FishESPObjects) do
            RemoveFishESP(Object)
        end
    end
end

local function UpdateAllPlayerESPColors()
    for Player, Character in pairs(PlayerESPObjects) do
        if Character and Character.Parent then
            ESPLibrary:UpdateObjectColor(Character, PlayerESPColor)
        else
            PlayerESPObjects[Player] = nil
        end
    end
end

local function UpdateAllFishESPColors()
    for Object in pairs(FishESPObjects) do
        if Object and Object.Parent then
            ESPLibrary:UpdateObjectColor(Object, FishESPColor)
        else
            FishESPObjects[Object] = nil
        end
    end
end

local function SetupPlayer(Player)
    if Player == LocalPlayer then
        return
    end

    if PlayerConnections[Player] then
        PlayerConnections[Player]:Disconnect()
        PlayerConnections[Player] = nil
    end

    PlayerConnections[Player] = Player.CharacterAdded:Connect(function()
        task.wait(0.15)

        if PlayerESPEnabled then
            AddPlayerESP(Player)
        end
    end)

    if PlayerESPEnabled then
        task.defer(function()
            AddPlayerESP(Player)
        end)
    end
end

for _, Player in ipairs(Players:GetPlayers()) do
    SetupPlayer(Player)
end

local PlayerAddedConnection = Players.PlayerAdded:Connect(SetupPlayer)

local PlayerRemovingConnection = Players.PlayerRemoving:Connect(function(Player)
    RemovePlayerESP(Player)

    if PlayerConnections[Player] then
        PlayerConnections[Player]:Disconnect()
        PlayerConnections[Player] = nil
    end
end)

local FishAddedConnection = Workspace.DescendantAdded:Connect(function(Object)
    if not FishESPEnabled then
        return
    end

    local Folder = GetFishPickupsFolder()

    if not Folder or not Object:IsDescendantOf(Folder) then
        return
    end

    if IsFishESPObject(Object) then
        task.defer(function()
            AddFishESP(Object)
        end)
    end
end)

local FishRemovingConnection = Workspace.DescendantRemoving:Connect(function(Object)
    if FishESPObjects[Object] then
        RemoveFishESP(Object)
    end
end)

task.spawn(function()
    while not ESPLibrary.Unloaded do
        if FishESPEnabled then
            ScanForFish()
        end

        task.wait(1)
    end
end)

ESPLibrary:SetRainbow(false)
ESPLibrary:SetShowDistance(true)
ESPLibrary:SetFillTransparency(0.75)
ESPLibrary:SetOutlineTransparency(0)
ESPLibrary:SetTextTransparency(0)
ESPLibrary:SetTextOutlineTransparency(0)
ESPLibrary:SetRenderLimit(240)
ESPLibrary:SetFadeTime(0.25)
ESPLibrary:SetTextSize(20)
ESPLibrary:SetFont(Enum.Font.Highway)
ESPLibrary:SetTracers(false)
ESPLibrary:SetTracerSize(0.75)
ESPLibrary:SetTracerOrigin("Bottom")
ESPLibrary:SetArrows(false)
ESPLibrary:SetArrowRadius(250)
ESPLibrary:SetDistanceSizeRatio(0.8)

local MainLeft = MainTab:AddLeftGroupbox("Main")
MainLeft:AddLabel("Meow Madness")
MainLeft:AddLabel("Player: " .. LocalPlayer.Name)

local MainRight = MainTab:AddRightGroupbox("Options")
MainRight:AddToggle("MainEnabled", {
    Text = "Enabled",
    Default = true,
    Callback = function(Value)
        print("Main Enabled:", Value)
    end
})

local AutoCollectFishEnabled = false
local AutoCollectFishDelay = 0.15
local AutoCollectFishRunning = false

local function GetObjectCFrame(Object)
    if not Object then
        return nil
    end

    if Object:IsA("BasePart") then
        return Object.CFrame
    end

    if Object:IsA("Model") then
        local Success, CFrameValue = pcall(function()
            return Object:GetPivot()
        end)

        if Success then
            return CFrameValue
        end

        local PrimaryPart = Object.PrimaryPart or Object:FindFirstChildWhichIsA("BasePart", true)
        if PrimaryPart then
            return PrimaryPart.CFrame
        end
    end

    local Part = Object:FindFirstChildWhichIsA("BasePart", true)
    if Part then
        return Part.CFrame
    end

    return nil
end

local function GetCharacterRootPart()
    local Character = LocalPlayer.Character
    if not Character then
        return nil, nil
    end

    local Root = Character:FindFirstChild("HumanoidRootPart")
        or Character.PrimaryPart
        or Character:FindFirstChildWhichIsA("BasePart")

    return Character, Root
end

local function TryCollectObject(Object)
    if not Object or not Object.Parent or Object:IsA("Sound") then
        return
    end

    local Character, Root = GetCharacterRootPart()
    if not Character or not Root then
        return
    end

    local TargetCFrame = GetObjectCFrame(Object)
    if not TargetCFrame then
        return
    end

    pcall(function()
        Character:PivotTo(TargetCFrame)
    end)

    task.wait(0.03)

    local Prompt = Object:FindFirstChildWhichIsA("ProximityPrompt", true)
    if Prompt then
        local Fired = false

        if typeof(fireproximityprompt) == "function" then
            pcall(function()
                fireproximityprompt(Prompt)
                Fired = true
            end)
        end

        if not Fired then
            pcall(function()
                Prompt:InputHoldBegin()
                task.wait(math.max(Prompt.HoldDuration, 0.03))
                Prompt:InputHoldEnd()
            end)
        end
    end

    local ClickDetector = Object:FindFirstChildWhichIsA("ClickDetector", true)
    if ClickDetector and typeof(fireclickdetector) == "function" then
        pcall(function()
            fireclickdetector(ClickDetector)
        end)
    end
end

local function GetFishCollectables()
    local Folder = Workspace:FindFirstChild("FishPickups")
    if not Folder then
        return {}
    end

    local Results = {}

    for _, Object in ipairs(Folder:GetDescendants()) do
        if not Object:IsA("Sound")
            and (Object:IsA("Model") or Object:IsA("BasePart"))
            and Object.Parent
        then
            table.insert(Results, Object)
        end
    end

    return Results
end

local function AutoCollectFishLoop()
    if AutoCollectFishRunning then
        return
    end

    AutoCollectFishRunning = true

    while AutoCollectFishEnabled do
        for _, Object in ipairs(GetFishCollectables()) do
            if not AutoCollectFishEnabled then
                break
            end

            if Object and Object.Parent and not Object:IsA("Sound") then
                TryCollectObject(Object)
                task.wait(AutoCollectFishDelay)
            end
        end

        task.wait(0.05)
    end

    AutoCollectFishRunning = false
end

local AutoLeft = AutoTab:AddLeftGroupbox("Auto")

AutoLeft:AddToggle("AutoFarm", {
    Text = "Auto Farm",
    Default = false,
    Callback = function(Value)
        print("Auto Farm:", Value)
    end
})

AutoLeft:AddToggle("AutoCollectFish", {
    Text = "Auto Collect Fish",
    Default = false,
    Callback = function(Value)
        AutoCollectFishEnabled = Value

        if Value then
            task.spawn(AutoCollectFishLoop)
        end
    end
})

AutoLeft:AddButton({
    Text = "Collect Fish Once",
    Func = function()
        task.spawn(function()
            for _, Object in ipairs(GetFishCollectables()) do
                TryCollectObject(Object)
                task.wait(AutoCollectFishDelay)
            end
        end)
    end
})

local AutoRight = AutoTab:AddRightGroupbox("Settings")
AutoRight:AddDropdown("AutoMode", {
    Values = {"Nearest", "Best", "Random"},
    Default = 1,
    Text = "Mode",
    Callback = function(Value)
        print("Auto Mode:", Value)
    end
})

AutoRight:AddSlider("AutoDelay", {
    Text = "Delay",
    Default = 1,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Suffix = "s",
    Callback = function(Value)
        print("Auto Delay:", Value)
    end
})

AutoRight:AddSlider("FishCollectDelay", {
    Text = "Fish Collect Delay",
    Default = 0.15,
    Min = 0.05,
    Max = 1,
    Rounding = 2,
    Suffix = "s",
    Callback = function(Value)
        AutoCollectFishDelay = Value
    end
})

local RageEnabled = false
local RageRunning = false
local RageStayTime = 10
local RageUpdateInterval = 0.03

local function GetCharacterRoot(Character)
    if not Character then
        return nil
    end

    return Character:FindFirstChild("HumanoidRootPart")
        or Character.PrimaryPart
        or Character:FindFirstChildWhichIsA("BasePart")
end

local function FollowPlayerForTime(TargetPlayer, Duration)
    local StartTime = os.clock()

    while RageEnabled and os.clock() - StartTime < Duration do
        local Character = LocalPlayer.Character
        local TargetCharacter = TargetPlayer.Character

        local Root = GetCharacterRoot(Character)
        local TargetRoot = GetCharacterRoot(TargetCharacter)

        if Root and TargetRoot and Character and Character.Parent and TargetCharacter and TargetCharacter.Parent then
            local TargetCFrame = TargetRoot.CFrame

            pcall(function()
                Character:PivotTo(TargetCFrame)
            end)

            Root = GetCharacterRoot(LocalPlayer.Character)

            if Root then
                Root.CFrame = TargetCFrame
            end
        end

        task.wait(RageUpdateInterval)
    end
end

local function RageTeleportLoop()
    if RageRunning then
        return
    end

    RageRunning = true

    while RageEnabled do
        for _, Player in ipairs(Players:GetPlayers()) do
            if not RageEnabled then
                break
            end

            if Player ~= LocalPlayer and Player.Parent == Players then
                FollowPlayerForTime(Player, RageStayTime)
            end
        end

        if RageEnabled then
            task.wait(0.05)
        end
    end

    RageRunning = false
end

local RageLeft = RageTab:AddLeftGroupbox("Rage")

RageLeft:AddToggle("RageEnabled", {
    Text = "Rage Enabled",
    Default = false,
    Callback = function(Value)
        RageEnabled = Value

        if Value then
            task.spawn(RageTeleportLoop)
        end
    end
})

RageLeft:AddButton({
    Text = "Start Rage Once",
    Func = function()
        if RageRunning then
            return
        end

        task.spawn(function()
            RageRunning = true

            for _, Player in ipairs(Players:GetPlayers()) do
                if not RageEnabled and Player ~= LocalPlayer and Player.Parent == Players then
                    FollowPlayerForTime(Player, RageStayTime)
                elseif RageEnabled and Player ~= LocalPlayer and Player.Parent == Players then
                    FollowPlayerForTime(Player, RageStayTime)
                end
            end

            RageRunning = false
        end)
    end
})

local RageRight = RageTab:AddRightGroupbox("Teleport")

RageRight:AddSlider("RageStayTime", {
    Text = "Time On Player",
    Default = 10,
    Min = 1,
    Max = 30,
    Rounding = 0,
    Suffix = "s",
    Callback = function(Value)
        RageStayTime = Value
    end
})

RageRight:AddSlider("RageUpdateInterval", {
    Text = "Teleport Speed",
    Default = 0.03,
    Min = 0.01,
    Max = 0.2,
    Rounding = 2,
    Suffix = "s",
    Callback = function(Value)
        RageUpdateInterval = Value
    end
})

local LightingLeft = VisualsTab:AddLeftGroupbox("Lighting")

LightingLeft:AddToggle("FullBright", {
    Text = "FullBright",
    Default = false,
    Callback = function(Value)
        FullBrightEnabled = Value
        ApplyFullBright()
    end
})

LightingLeft:AddSlider("FullBrightIntensity", {
    Text = "FullBright Intensity",
    Default = 10,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        FullBrightIntensity = Value
        ApplyFullBright()
    end
})

LightingLeft:AddDropdown("SkyChanger", {
    Text = "Sky Changer",
    Values = {"Default", "Purple Nebula", "Dusty Clouds", "Night Sky", "Pink Daylight", "Sunset"},
    Default = 1,
    Callback = function(Value)
        SetSkyPreset(Value)
    end
})

local FogGroup = VisualsTab:AddRightGroupbox("Fog")

FogGroup:AddToggle("FogEnabled", {
    Text = "Fog Enabled",
    Default = false,
    Callback = function(Value)
        FogEnabled = Value
        ApplyFog()
    end
})

FogGroup:AddSlider("FogStart", {
    Text = "Fog Start",
    Default = math.clamp(FogStartValue, 0, 5000),
    Min = 0,
    Max = 5000,
    Rounding = 0,
    Callback = function(Value)
        FogStartValue = Value
        ApplyFog()
    end
})

FogGroup:AddSlider("FogEnd", {
    Text = "Fog End",
    Default = math.clamp(FogEndValue, 10, 10000),
    Min = 10,
    Max = 10000,
    Rounding = 0,
    Callback = function(Value)
        FogEndValue = Value
        ApplyFog()
    end
})

FogGroup:AddColorPicker("FogColor", {
    Default = FogColorValue,
    Title = "Fog Color",
    Callback = function(Value)
        FogColorValue = Value
        ApplyFog()
    end
})

local VisualsLeft = VisualsTab:AddLeftGroupbox("Player ESP")
VisualsLeft:AddToggle("PlayerESP", {
    Text = "Player ESP",
    Default = false,
    Callback = function(Value)
        SetPlayerESP(Value)
    end
}):AddColorPicker("PlayerESPColor", {
    Default = PlayerESPColor,
    Title = "Player ESP Color",
    Callback = function(Value)
        PlayerESPColor = Value
        UpdateAllPlayerESPColors()
    end
})

VisualsLeft:AddToggle("PlayerESPDistance", {
    Text = "Show Distance",
    Default = true,
    Callback = function(Value)
        ESPLibrary:SetShowDistance(Value)
    end
})

VisualsLeft:AddToggle("PlayerESPTracers", {
    Text = "Tracers",
    Default = false,
    Callback = function(Value)
        ESPLibrary:SetTracers(Value)
    end
})

VisualsLeft:AddToggle("PlayerESPArrows", {
    Text = "Arrows",
    Default = false,
    Callback = function(Value)
        ESPLibrary:SetArrows(Value)
    end
})

local FishLeft = VisualsTab:AddLeftGroupbox("Fish ESP")
FishLeft:AddToggle("FishESP", {
    Text = "Fish ESP",
    Default = false,
    Callback = function(Value)
        SetFishESP(Value)
    end
}):AddColorPicker("FishESPColor", {
    Default = FishESPColor,
    Title = "Fish ESP Color",
    Callback = function(Value)
        FishESPColor = Value
        UpdateAllFishESPColors()
    end
})

FishLeft:AddToggle("FishESPDistance", {
    Text = "Show Distance",
    Default = true,
    Callback = function(Value)
        ESPLibrary:SetShowDistance(Value)
    end
})

FishLeft:AddToggle("FishESPTracers", {
    Text = "Tracers",
    Default = false,
    Callback = function(Value)
        ESPLibrary:SetTracers(Value)
    end
})

FishLeft:AddToggle("FishESPArrows", {
    Text = "Arrows",
    Default = false,
    Callback = function(Value)
        ESPLibrary:SetArrows(Value)
    end
})

local ESPSettings = VisualsTab:AddRightGroupbox("ESP Settings")

ESPSettings:AddToggle("ESPRainbow", {
    Text = "Rainbow Effect",
    Default = false,
    Callback = function(Value)
        ESPLibrary:SetRainbow(Value)
    end
})

ESPSettings:AddSlider("ESPFillTransparency", {
    Text = "Fill Transparency",
    Min = 0,
    Max = 1,
    Default = 0.75,
    Rounding = 2,
    Callback = function(Value)
        ESPLibrary:SetFillTransparency(Value)
    end
})

ESPSettings:AddSlider("ESPOutlineTransparency", {
    Text = "Outline Transparency",
    Min = 0,
    Max = 1,
    Default = 0,
    Rounding = 2,
    Callback = function(Value)
        ESPLibrary:SetOutlineTransparency(Value)
    end
})

ESPSettings:AddSlider("ESPTextTransparency", {
    Text = "Text Transparency",
    Min = 0,
    Max = 1,
    Default = 0,
    Rounding = 2,
    Callback = function(Value)
        ESPLibrary:SetTextTransparency(Value)
    end
})

ESPSettings:AddSlider("ESPTextOutlineTransparency", {
    Text = "Text Outline Transparency",
    Min = 0,
    Max = 1,
    Default = 0,
    Rounding = 2,
    Callback = function(Value)
        ESPLibrary:SetTextOutlineTransparency(Value)
    end
})

ESPSettings:AddSlider("ESPFadeTime", {
    Text = "Fade Time",
    Min = 0,
    Max = 1,
    Default = 0.25,
    Rounding = 2,
    Callback = function(Value)
        ESPLibrary:SetFadeTime(Value)
    end
})

ESPSettings:AddSlider("ESPRenderLimit", {
    Text = "Render Limit",
    Min = 30,
    Max = 240,
    Default = 240,
    Rounding = 0,
    Callback = function(Value)
        ESPLibrary:SetRenderLimit(Value)
    end
})

ESPSettings:AddSlider("ESPTextSize", {
    Text = "Text Size",
    Min = 12,
    Max = 40,
    Default = 20,
    Rounding = 0,
    Callback = function(Value)
        ESPLibrary:SetTextSize(Value)
    end
})

ESPSettings:AddDropdown("ESPTextFont", {
    Text = "Text Font",
    Values = {
        "Roboto",
        "RobotoCondensed",
        "Highway",
        "Gotham",
        "GothamBold",
        "SourceSans",
        "SourceSansBold",
        "Code"
    },
    Default = 1,
    Callback = function(Value)
        local Success, Font = pcall(function()
            return Enum.Font[Value]
        end)

        if Success and Font then
            ESPLibrary:SetFont(Font)
        end
    end
})

ESPSettings:AddDropdown("ESPTracerOrigin", {
    Text = "Tracer Origin",
    Values = {"Bottom", "Center", "Top", "Mouse"},
    Default = 1,
    Callback = function(Value)
        ESPLibrary:SetTracerOrigin(Value)
    end
})

ESPSettings:AddSlider("ESPTracerThickness", {
    Text = "Tracer Thickness",
    Min = 0.5,
    Max = 2,
    Default = 0.75,
    Rounding = 2,
    Callback = function(Value)
        ESPLibrary:SetTracerSize(Value)
    end
})

ESPSettings:AddSlider("ESPArrowsRadius", {
    Text = "Arrow Radius",
    Min = 100,
    Max = 500,
    Default = 250,
    Rounding = 0,
    Callback = function(Value)
        ESPLibrary:SetArrowRadius(Value)
    end
})

ESPSettings:AddSlider("ESPDistanceSizeRatio", {
    Text = "Distance Size Ratio",
    Min = 0.1,
    Max = 2,
    Default = 0.8,
    Rounding = 2,
    Callback = function(Value)
        ESPLibrary:SetDistanceSizeRatio(Value)
    end
})

Library:OnUnload(function()
    Lighting.Brightness = OriginalLighting.Brightness
    Lighting.Ambient = OriginalLighting.Ambient
    Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
    Lighting.ColorShift_Top = OriginalLighting.ColorShift_Top
    Lighting.ColorShift_Bottom = OriginalLighting.ColorShift_Bottom
    Lighting.FogStart = OriginalLighting.FogStart
    Lighting.FogEnd = OriginalLighting.FogEnd
    Lighting.FogColor = OriginalLighting.FogColor

    if CustomSky and CustomSky.Parent then
        CustomSky:Destroy()
        CustomSky = nil
    end
    PlayerAddedConnection:Disconnect()
    PlayerRemovingConnection:Disconnect()
    FishAddedConnection:Disconnect()
    FishRemovingConnection:Disconnect()

    for Player, Connection in pairs(PlayerConnections) do
        if Connection then
            Connection:Disconnect()
        end

        RemovePlayerESP(Player)
    end

    for Object in pairs(FishESPObjects) do
        RemoveFishESP(Object)
    end

    ESPLibrary:Unload()
end)

return Library
