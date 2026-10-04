local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/D4rkRoblox/Meow-Madness-Script/refs/heads/main/Components/Interface.luau"
))()

local ESPLibrary = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/D4rkRoblox/Meow-Madness-Script/refs/heads/main/Components/ESP.luau"
))()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local Window = Library:CreateWindow({
    Title = "Meow Madness",
    Footer = "v1.0.0",
    ToggleKeybind = Enum.KeyCode.RightControl,
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

local AutoLeft = AutoTab:AddLeftGroupbox("Auto")
AutoLeft:AddToggle("AutoFarm", {
    Text = "Auto Farm",
    Default = false,
    Callback = function(Value)
        print("Auto Farm:", Value)
    end
})

AutoLeft:AddToggle("AutoCollect", {
    Text = "Auto Collect",
    Default = false,
    Callback = function(Value)
        print("Auto Collect:", Value)
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

local RageTeleportDelay = 0.35
local RageEnabled = false
local RageRunning = false

local function GetCharacterRoot(Character)
    if not Character then
        return nil
    end

    return Character:FindFirstChild("HumanoidRootPart")
        or Character.PrimaryPart
        or Character:FindFirstChildWhichIsA("BasePart")
end

local function TeleportToPlayer(TargetPlayer)
    local Character = LocalPlayer.Character
    local TargetCharacter = TargetPlayer.Character
    local Root = GetCharacterRoot(Character)
    local TargetRoot = GetCharacterRoot(TargetCharacter)

    if not Root or not TargetRoot then
        return false
    end

    local TargetCFrame = TargetRoot.CFrame * CFrame.new(0, 0, 2)

    pcall(function()
        Character:PivotTo(TargetCFrame)
    end)

    Root = GetCharacterRoot(LocalPlayer.Character)

    if Root then
        Root.CFrame = TargetCFrame
    end

    return true
end

local function RageTeleportLoop()
    if RageRunning then
        return
    end

    RageRunning = true

    while RageEnabled do
        local PlayersList = Players:GetPlayers()

        for _, Player in ipairs(PlayersList) do
            if not RageEnabled then
                break
            end

            if Player ~= LocalPlayer then
                TeleportToPlayer(Player)
                task.wait(RageTeleportDelay)
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
    Text = "Teleport To All Players",
    Func = function()
        if RageRunning then
            return
        end

        task.spawn(function()
            for _, Player in ipairs(Players:GetPlayers()) do
                if Player ~= LocalPlayer then
                    TeleportToPlayer(Player)
                    task.wait(RageTeleportDelay)
                end
            end
        end)
    end
})

local RageRight = RageTab:AddRightGroupbox("Teleport")
RageRight:AddSlider("TeleportDelay", {
    Text = "Teleport Delay",
    Default = 0.35,
    Min = 0,
    Max = 2,
    Rounding = 2,
    Suffix = "s",
    Callback = function(Value)
        RageTeleportDelay = Value
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
