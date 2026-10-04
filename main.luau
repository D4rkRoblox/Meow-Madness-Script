local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/D4rkRoblox/Meow-Madness-Script/refs/heads/main/Components/Interface.luau"
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
    Icon = "home",
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

local RageLeft = RageTab:AddLeftGroupbox("Rage")
RageLeft:AddToggle("RageEnabled", {
    Text = "Rage Enabled",
    Default = false,
    Callback = function(value)
        print("Rage Enabled:", value)
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

local VisualsLeft = VisualsTab:AddLeftGroupbox("Visuals")
VisualsLeft:AddToggle("ESP", {
    Text = "ESP",
    Default = false,
    Callback = function(value)
        print("ESP:", value)
    end
})

VisualsLeft:AddToggle("FullBright", {
    Text = "Full Bright",
    Default = false,
    Callback = function(value)
        print("Full Bright:", value)
    end
})

local VisualsRight = VisualsTab:AddRightGroupbox("Display")
VisualsRight:AddDropdown("VisualMode", {
    Values = {"Default", "Bright", "Dark"},
    Default = 1,
    Text = "Mode",
    Callback = function(value)
        print("Visual Mode:", value)
    end
})

VisualsRight:AddSlider("Intensity", {
    Text = "Intensity",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(value)
        print("Intensity:", value)
    end
})

return Library
