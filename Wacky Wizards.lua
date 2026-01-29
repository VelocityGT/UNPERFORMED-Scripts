local FlyEnabled = false
local FlySpeed = 60

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local root
local att
local lv
local ao

local move = Vector3.zero

local function StartFly()
    if not Humanoid then return end
    root = Humanoid.RootPart

    att = Instance.new("Attachment", root)

    lv = Instance.new("LinearVelocity")
    lv.Attachment0 = att
    lv.MaxForce = math.huge
    lv.VectorVelocity = Vector3.zero
    lv.Parent = root

    ao = Instance.new("AlignOrientation")
    ao.Attachment0 = att
    ao.MaxTorque = math.huge
    ao.Responsiveness = 20
    ao.Parent = root
end

local function StopFly()
    if lv then lv:Destroy() lv = nil end
    if ao then ao:Destroy() ao = nil end
    if att then att:Destroy() att = nil end
end

-- WASD input (no up/down keys)
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then move += Vector3.new(0,0,-1) end
    if input.KeyCode == Enum.KeyCode.S then move += Vector3.new(0,0,1) end
    if input.KeyCode == Enum.KeyCode.A then move += Vector3.new(-1,0,0) end
    if input.KeyCode == Enum.KeyCode.D then move += Vector3.new(1,0,0) end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then move -= Vector3.new(0,0,-1) end
    if input.KeyCode == Enum.KeyCode.S then move -= Vector3.new(0,0,1) end
    if input.KeyCode == Enum.KeyCode.A then move -= Vector3.new(-1,0,0) end
    if input.KeyCode == Enum.KeyCode.D then move -= Vector3.new(1,0,0) end
end)

RunService.RenderStepped:Connect(function()
    if FlyEnabled and lv and ao then
        local cam = workspace.CurrentCamera
        local dir = cam.CFrame:VectorToWorldSpace(move)

        lv.VectorVelocity = dir * FlySpeed
        ao.CFrame = cam.CFrame
    end
end)

-- FLY TOGGLE
PlayerTab:Toggle({
    Title = "Fly",
    Default = false,
    Callback = function(state)
        FlyEnabled = state
        if state then
            StartFly()
        else
            StopFly()
        end
    end
})

-- FLY SPEED SLIDER
PlayerTab:Slider({
    Title = "Fly Speed",
    Default = 60,
    Min = 1,
    Max = 300,
    Step = 1,
    Callback = function(value)
        FlySpeed = value
    end
})
