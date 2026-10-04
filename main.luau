local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/D4rkRoblox/Meow-Madness-Script/refs/heads/main/Components/Interface.luau"
))()

local PlayerESPLibrary = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/D4rkRoblox/Meow-Madness-Script/refs/heads/main/Components/ESP.luau"
))()

local FishESPLibrary = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/D4rkRoblox/Meow-Madness-Script/refs/heads/main/Components/ESP.luau"
))()

local Players = game:GetService("Players")
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

local EspEnabled = false
local EspConnections = {}
local EspObjects = {}
local EspColor = Color3.fromRGB(255, 80, 80)
local EspShowDistance = false
local EspTracers = false
local EspArrows = false

local FishEnabled = false
local FishShowDistance = false
local FishTracers = false
local FishArrows = false
local FishColor = Color3.fromRGB(80, 170, 255)
local FishObjects = {}

local function RemoveFishESP(object)
    if FishObjects[object] then
        FishESPLibrary:RemoveESP(object)
        FishObjects[object] = nil
    end
end

local function IsCrayfish(object)
    return object.Name:lower() == "crayfish" and (object:IsA("BasePart") or object:IsA("Model"))
end

local function AddFishESP(object)
    if not FishEnabled or not IsCrayfish(object) then
        return
    end

    if FishObjects[object] then
        return
    end

    FishESPLibrary:AddESP({
        Object = object,
        Text = "Crayfish",
        Color = FishColor
    })

    FishObjects[object] = true
end

local function SetFishESP(value)
    FishEnabled = value

    if value then
        for _, object in ipairs(workspace:GetDescendants()) do
            AddFishESP(object)
        end
    else
        for object in pairs(FishObjects) do
            RemoveFishESP(object)
        end
    end
end

local function ApplyFishESPSettings()
    FishESPLibrary:SetShowDistance(FishShowDistance)
    FishESPLibrary:SetTracers(FishTracers)
    FishESPLibrary:SetArrows(FishArrows)
end

local FishAddedConnection = workspace.DescendantAdded:Connect(function(object)
    if FishEnabled and IsCrayfish(object) then
        task.defer(function()
            AddFishESP(object)
        end)
    end
end)

local FishRemovingConnection = workspace.DescendantRemoving:Connect(function(object)
    if FishObjects[object] then
        FishObjects[object] = nil
    end
end)

local function RemovePlayerESP(player)
    local data = EspObjects[player]
    if not data then
        return
    end

    for _, object in ipairs(data) do
        if object and object.Parent then
            PlayerESPLibrary:RemoveESP(object)
        end
    end

    EspObjects[player] = nil
end

local function AddPlayerESP(player)
    if not EspEnabled or player == LocalPlayer then
        return
    end

    RemovePlayerESP(player)

    local character = player.Character
    if not character then
        return
    end

    local root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChildWhichIsA("BasePart")
    if not root then
        return
    end

    PlayerESPLibrary:AddESP({
        Object = character,
        Text = player.Name,
        Color = EspColor
    })

    EspObjects[player] = {character}
end

local function SetESP(value)
    EspEnabled = value

    if value then
        for _, player in ipairs(Players:GetPlayers()) do
            AddPlayerESP(player)
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do
            RemovePlayerESP(player)
        end
    end
end

local function ApplyESPSettings()
    PlayerESPLibrary:SetShowDistance(EspShowDistance)
    PlayerESPLibrary:SetTracers(EspTracers)
    PlayerESPLibrary:SetArrows(EspArrows)
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        EspConnections[player] = player.CharacterAdded:Connect(function()
            task.wait(0.2)
            AddPlayerESP(player)
        end)
    end
end

EspConnections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
    EspConnections[player] = player.CharacterAdded:Connect(function()
        task.wait(0.2)
        AddPlayerESP(player)
    end)
end)

EspConnections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
    RemovePlayerESP(player)
    if EspConnections[player] then
        EspConnections[player]:Disconnect()
        EspConnections[player] = nil
    end
end)

local MainLeft = MainTab:AddLeftGroupbox("Main")
MainLeft:AddLabel("Meow Madness")
MainLeft:AddLabel("Player: " .. LocalPlayer.Name)

MainLeft:AddButton({
    Text = "Test Notification",
    Func = function()
        Library:Notify({
            Title = "Meow Madness",
            Description = "Interface works.",
            Time = 3
        })
    end
})

local MainRight = MainTab:AddRightGroupbox("Options")
MainRight:AddToggle("MainEnabled", {
    Text = "Enabled",
    Default = true,
    Callback = function(value)
        print("Main Enabled:", value)
    end
})

local AutoLeft = AutoTab:AddLeftGroupbox("Auto")
AutoLeft:AddToggle("AutoFarm", {
    Text = "Auto Farm",
    Default = false,
    Callback = function(value)
        print("Auto Farm:", value)
    end
})

AutoLeft:AddToggle("AutoCollect", {
    Text = "Auto Collect",
    Default = false,
    Callback = function(value)
        print("Auto Collect:", value)
    end
})

local AutoRight = AutoTab:AddRightGroupbox("Settings")
AutoRight:AddDropdown("AutoMode", {
    Values = {"Nearest", "Best", "Random"},
    Default = 1,
    Text = "Mode",
    Callback = function(value)
        print("Auto Mode:", value)
    end
})

AutoRight:AddSlider("AutoDelay", {
    Text = "Delay",
    Default = 1,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Suffix = "s",
    Callback = function(value)
        print("Auto Delay:", value)
    end
})

local RageTeleportDelay = 0.35
local RageTeleporting = false

local function TeleportToAllPlayers()
    if RageTeleporting then
        return
    end

    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end

    RageTeleporting = true

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local targetCharacter = player.Character
            local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")

            if targetRoot and targetRoot.Parent then
                character = LocalPlayer.Character
                root = character and character:FindFirstChild("HumanoidRootPart")

                if root then
                    root.CFrame = targetRoot.CFrame
                end

                task.wait(RageTeleportDelay)
            end
        end
    end

    RageTeleporting = false
end

local RageLeft = RageTab:AddLeftGroupbox("Rage")
RageLeft:AddToggle("RageEnabled", {
    Text = "Rage Enabled",
    Default = false,
    Callback = function(value)
        print("Rage Enabled:", value)
        if value then
            task.spawn(TeleportToAllPlayers)
        end
    end
})

RageLeft:AddToggle("TeleportAllPlayers", {
    Text = "Teleport To All Players",
    Default = false,
    Callback = function(value)
        if value then
            task.spawn(TeleportToAllPlayers)
        end
    end
})

RageLeft:AddToggle("AutoAttack", {
    Text = "Auto Attack",
    Default = false,
    Callback = function(value)
        print("Auto Attack:", value)
    end
})

local RageRight = RageTab:AddRightGroupbox("Targeting")
RageRight:AddDropdown("TargetMode", {
    Values = {"Nearest", "Lowest Health", "Random"},
    Default = 1,
    Text = "Target Mode",
    Callback = function(value)
        print("Target Mode:", value)
    end
})

RageRight:AddSlider("Range", {
    Text = "Range",
    Default = 50,
    Min = 5,
    Max = 500,
    Rounding = 0,
    Callback = function(value)
        print("Range:", value)
    end
})

RageRight:AddSlider("TeleportDelay", {
    Text = "Teleport Delay",
    Default = 0.35,
    Min = 0,
    Max = 2,
    Rounding = 2,
    Suffix = "s",
    Callback = function(value)
        RageTeleportDelay = value
    end
})

local VisualsLeft = VisualsTab:AddLeftGroupbox("ESP")
VisualsLeft:AddToggle("ESP", {
    Text = "ESP",
    Default = false,
    Callback = function(value)
        SetESP(value)
    end
})

VisualsLeft:AddToggle("ESPDistance", {
    Text = "Show Distance",
    Default = false,
    Callback = function(value)
        EspShowDistance = value
        ApplyESPSettings()
    end
})

VisualsLeft:AddToggle("ESPTracers", {
    Text = "Tracers",
    Default = false,
    Callback = function(value)
        EspTracers = value
        ApplyESPSettings()
    end
})

VisualsLeft:AddToggle("ESPArrows", {
    Text = "Arrows",
    Default = false,
    Callback = function(value)
        EspArrows = value
        ApplyESPSettings()
    end
})

local VisualsRight = VisualsTab:AddRightGroupbox("Display")
VisualsRight:AddLabel("ESP Component")
VisualsRight:AddLabel("Loaded from Components/ESP.luau")

VisualsRight:AddSlider("ESPRenderLimit", {
    Text = "Render Limit",
    Default = 240,
    Min = 30,
    Max = 500,
    Rounding = 0,
    Callback = function(value)
        PlayerESPLibrary:SetRenderLimit(value)
    end
})

VisualsRight:AddSlider("ESPTextSize", {
    Text = "Text Size",
    Default = 20,
    Min = 10,
    Max = 40,
    Rounding = 0,
    Callback = function(value)
        PlayerESPLibrary:SetTextSize(value)
    end
})

VisualsRight:AddSlider("ESPFillTransparency", {
    Text = "Fill Transparency",
    Default = 75,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(value)
        PlayerESPLibrary:SetFillTransparency(value / 100)
    end
})

local FishLeft = VisualsTab:AddLeftGroupbox("Fish ESP")
FishLeft:AddToggle("FishESP", {
    Text = "Fish ESP",
    Default = false,
    Callback = function(value)
        SetFishESP(value)
    end
}):AddColorPicker("FishESPColor", {
    Default = FishColor,
    Title = "Fish ESP Color",
    Callback = function(value)
        FishColor = value
        for object in pairs(FishObjects) do
            FishESPLibrary:UpdateObjectColor(object, value)
        end
    end
})

FishLeft:AddToggle("FishESPDistance", {
    Text = "Show Distance",
    Default = false,
    Callback = function(value)
        FishShowDistance = value
        ApplyFishESPSettings()
    end
})

FishLeft:AddToggle("FishESPTracers", {
    Text = "Tracers",
    Default = false,
    Callback = function(value)
        FishTracers = value
        ApplyFishESPSettings()
    end
})

FishLeft:AddToggle("FishESPArrows", {
    Text = "Arrows",
    Default = false,
    Callback = function(value)
        FishArrows = value
        ApplyFishESPSettings()
    end
})

local FishRight = VisualsTab:AddRightGroupbox("Fish Settings")
FishRight:AddSlider("FishRenderLimit", {
    Text = "Render Limit",
    Default = 240,
    Min = 30,
    Max = 500,
    Rounding = 0,
    Callback = function(value)
        FishESPLibrary:SetRenderLimit(value)
    end
})

FishRight:AddSlider("FishTextSize", {
    Text = "Text Size",
    Default = 20,
    Min = 10,
    Max = 40,
    Rounding = 0,
    Callback = function(value)
        FishESPLibrary:SetTextSize(value)
    end
})

FishRight:AddSlider("FishFillTransparency", {
    Text = "Fill Transparency",
    Default = 75,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(value)
        FishESPLibrary:SetFillTransparency(value / 100)
    end
})

FishRight:AddLabel("Targets: Workspace > Crayfish")

local VisualsExtra = VisualsTab:AddRightGroupbox("Other")
VisualsExtra:AddToggle("FullBright", {
    Text = "Full Bright",
    Default = false,
    Callback = function(value)
        print("Full Bright:", value)
    end
})

VisualsExtra:AddDropdown("VisualMode", {
    Values = {"Default", "Bright", "Dark"},
    Default = 1,
    Text = "Mode",
    Callback = function(value)
        print("Visual Mode:", value)
    end
})

Library:OnUnload(function()
    for _, connection in pairs(EspConnections) do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        RemovePlayerESP(player)
    end

    FishAddedConnection:Disconnect()
    FishRemovingConnection:Disconnect()

    for object in pairs(FishObjects) do
        FishESPLibrary:RemoveESP(object)
    end

    PlayerESPLibrary:Unload()
    FishESPLibrary:Unload()
end)

return Library
