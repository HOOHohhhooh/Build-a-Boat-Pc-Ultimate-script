local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Build a Boat Pc Ultimate Script",
    SubTitle = "By Phoomphat",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Aqua",
    MinimizeKey = Enum.KeyCode.LeftControl
})


local Tabs = {
	General = Window:AddTab({ Title = "General", Icon = "home" }),
	Teleport = Window:AddTab({ Title = "Teleport", Icon = "chevrons-left-right"}),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

local Options = Fluent.Options

do
	    Tabs.General:AddParagraph({
        Title = "Build a Boat Pc Ultimate Script",
    })


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local Toggle = Tabs.General:AddToggle("MyToggle", {Title = "Auto Farm", Default = false })

local isMoving = false

local function moveToPosition(position, speed)
    if isMoving then return end
    isMoving = true

    humanoid.WalkSpeed = speed
    humanoid:MoveTo(position)

    local moveToConnection
    moveToConnection = humanoid.MoveToFinished:Connect(function(reached)
        if reached then
            print("Reached", position)
        else
            print("Did not reach", position)
        end
        isMoving = false
        moveToConnection:Disconnect()
    end)
end

local autoWalkCoroutine

local function autoWalk()
    while Toggle.Value do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") then
            print("Character not found, waiting for respawn...")
            LocalPlayer.CharacterAdded:Wait()
            character = LocalPlayer.Character
            humanoid = character:WaitForChild("Humanoid")
            humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        end

        local speed = 400

        local positions = {
			Vector3.new(-100.3891983, 45.759857, 800.162481),
            Vector3.new(-100.3891983, 45.759857, 1367.16248),
            Vector3.new(-100.9626236, 45.073517, 2136.87646),
            Vector3.new(-100.7347946, 45.590759, 2908.04907),
            Vector3.new(-100.0725594, 45.263581, 3677.34595),
            Vector3.new(-100.7233849, 45.163925, 4447.53027),
            Vector3.new(-100.8003578, 45.784531, 5220.36328),
            Vector3.new(-100.0792274, 45.107323, 5985.90527),
            Vector3.new(-100.6662369, 45.504257, 6756.76367),
            Vector3.new(-100.2724304, 45.663834, 7531.16504),
			Vector3.new(-100.8484573, 45.640503, 8297.49023),
			Vector3.new(-55.8801956, -361.116333, 9488.1377),
			Vector3.new(-55.8801956, -361.116333, 9488.1377)
        }

        for _, position in ipairs(positions) do
            if not Toggle.Value then return end
            moveToPosition(position, speed)
            wait(2)
        end


        if not Toggle.Value then return end
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-55.8801956, -361.116333, 9488.1377)
        wait(18)
    end
end

local function createAndTrackPart()
    local existingPart = workspace:FindFirstChild("CustomPN")
    if existingPart then
        existingPart:Destroy()
    end

    local PN = Instance.new("Part")
    PN.Size = Vector3.new(50, 0.2, 50)
    PN.Anchored = true
    PN.CanCollide = true
    PN.Transparency = 0
    PN.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -3, 0)
    PN.Name = "CustomPN"
    PN.Parent = workspace

    local function updatePosition()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            PN.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -3, 0)
        end
    end

    RunService.RenderStepped:Connect(updatePosition)
end

local noclipConnection

local function enableNoclip()
    noclipConnection = RunService.Stepped:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end)
end

local function disableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
    end
end

Toggle:OnChanged(function()
    print("Toggle value changed to", Toggle.Value)
    if Toggle.Value then
        autoWalkCoroutine = coroutine.create(autoWalk)
        coroutine.resume(autoWalkCoroutine)
        createAndTrackPart()
        enableNoclip()
    else
        local existingPart = workspace:FindFirstChild("CustomPN")
        if existingPart then
            existingPart:Destroy()
        end
        if autoWalkCoroutine then
            coroutine.close(autoWalkCoroutine)
        end
        disableNoclip()
    end
end)

Toggle:SetValue(false)

LocalPlayer.CharacterAdded:Connect(function()
    wait(2)
    character = LocalPlayer.Character
    humanoid = character:WaitForChild("Humanoid")
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    if Toggle.Value then
        autoWalkCoroutine = coroutine.create(autoWalk)
        coroutine.resume(autoWalkCoroutine)
        enableNoclip()
    end
end)






Tabs.General:AddButton({
    Title = "Anti afk",
    Callback = function()
        local player = game.Players.LocalPlayer
        local virtualUser = game:GetService("VirtualUser")

        player.Idled:connect(function()
            virtualUser:CaptureController()
            virtualUser:ClickButton2(Vector2.new())
        end)
    end
})




Tabs.Teleport:AddButton({
    Title = "Go to the end",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-55.8801956, -361.116333, 9480.1377)
    end
})



Tabs.Teleport:AddButton({
    Title = "Go to White Team",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-49.7951889, -9.70198154, -499.178192, -0.999961972, 2.80194943e-08, -0.0087186629, 2.72136749e-08, 1, 9.25433952e-08, 0.0087186629, 9.23026136e-08, -0.999961972)
    end
})


Tabs.Teleport:AddButton({
    Title = "Go to Red Team",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(377.935089, -9.70198154, -64.7836533, -0.00871669129, -9.53981711e-08, 0.999962032, 5.20946095e-08, 1, 9.58559028e-08, -0.999962032, 5.29281792e-08, -0.00871669129)
    end
})


Tabs.Teleport:AddButton({
    Title = "Go to Black Team",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-486.363037, -9.7019825, -69.0905914, 0.00871715974, 1.86146139e-08, -0.999962032, -9.17608389e-08, 1, 1.78153972e-08, 0.999962032, 9.16020539e-08, 0.00871715974)
    end
})


Tabs.Teleport:AddButton({
    Title = "Go to Blue Team",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(379.938446, -9.70198154, 300.093842, 6.52950257e-06, -1.10306049e-08, 1, 7.77693521e-10, 1, 1.10305995e-08, -1, 7.77621467e-10, 6.52950257e-06)
    end
})


Tabs.Teleport:AddButton({
    Title = "Go to Green Team",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-485.759521, -9.7019825, 293.761902, 0.0261676107, -3.67409179e-08, -0.999657571, 3.57353869e-11, 1, -3.67525672e-08, 0.999657571, 9.26003718e-10, 0.0261676107)
    end
})


Tabs.Teleport:AddButton({
    Title = "Go to Purple Team",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(377.606628, -9.7019825, 647.264954, -0.00872450322, 2.95584748e-08, 0.999961913, 7.98235575e-08, 1, -2.88631519e-08, -0.999961913, 7.95687001e-08, -0.00872450322)
    end
})


Tabs.Teleport:AddButton({
    Title = "Go to Yellow Team",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-485.083893, -9.7019825, 640.529785, -7.91624259e-08, 8.82590356e-09, -1, -1.44160461e-09, 1, 8.82590356e-09, 1, 1.44160539e-09, -7.91624259e-08)
    end
})






local Plr = {}
for i, v in pairs(game:GetService("Players"):GetPlayers()) do
    table.insert(Plr, v.Name)
end

local selectedPlayer = Plr[1]
local Dropdown = Tabs.Visuals:AddDropdown("Dropdown", {
    Title = "Select Player",
    Values = Plr,
    Multi = false,
    Default = 1,
})

Dropdown:OnChanged(function(Value)
    selectedPlayer = Value
    print("", Value)
end)

Tabs.Visuals:AddButton({
    Title = "Tp to player",
    Callback = function()
        local targetPlayer = game.Players:FindFirstChild(selectedPlayer)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        else
            print("Player not found or not valid")
        end
    end
})

Tabs.Visuals:AddButton({
    Title = "Refresh Player",
    Callback = function()
        Plr = {}
        for i, v in pairs(game:GetService("Players"):GetPlayers()) do
            table.insert(Plr, v.Name)
        end

        Dropdown:SetValues(Plr)
        selectedPlayer = Plr[1]
        print("")
    end
})


local Slider = Tabs.Visuals:AddSlider("Slider", {
    Title = "Walk Speed",
    Default = 2,
    Min = 0,
    Max = 50,
    Rounding = 1,
    Callback = function(Value)
        print("Slider was changed:", Value)
    end
})

Slider:OnChanged(function(Value)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    humanoid.WalkSpeed = Value * 16
    print("", humanoid.WalkSpeed)
end)

Slider:SetValue(1.1)



Tabs.Visuals:AddButton({
    Title = "Reset Charactor",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5000000.346008, -600.844025, 120.757896, -0.158652276, 0.0307962075, -0.986854136, 0.0033622703, 0.999524474, 0.0306510683, 0.987328768, 0.00154479151, -0.158680379)
    end
})



    local Input = Tabs.Teleport:AddInput("Input", {
        Title = "Input",
        Default = "Default",
        Placeholder = "Placeholder",
        Numeric = false,
        Finished = false,
        Callback = function(Value)
            print("", Value)
        end
    })

    Input:OnChanged(function()
        print("", Input.Value)
    end)
end



InterfaceManager:SetLibrary(Fluent)


SaveManager:IgnoreThemeSettings()


SaveManager:SetIgnoreIndexes({})


InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "PHOOMPHAT",
    Content = "The script has been loaded.",
    Duration = 8
})
