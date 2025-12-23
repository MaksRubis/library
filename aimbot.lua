local runService = game:GetService("RunService")
local players = game:GetService("Players")
local uis = game:GetService("UserInputService")

local player  = players.LocalPlayer
local camera = workspace.CurrentCamera

local aimbotSettings = {
    aimbot = true,
    holding = false, 
    fov = 120,
    part = "Head",
    smoothness = 0.5,

    connections = {}
}

function _isAlive()
    local char = player.Character
    if not char or not char.Parent then return false end 

    return true
end

function _getClosestPlayerToMouse()
    local target  
    local maxDistance = aimbotSettings.fov
    local mousePos = uis:GetMouseLocation()

    for _, v in ipairs(players:GetPlayers()) do  
        if v ~= player and v.Character then 
            local enemyHRP = v.Character:FindFirstChild("HumanoidRootPart")

            if _isAlive() and enemyHRP then 
                local vector, onScreen = camera:WorldToViewportPoint(enemyHRP.Position)
                local distance = (Vector2.new(vector.X, vector.Y) - mousePos).Magnitude

                if onScreen and distance < maxDistance then 
                    maxDistance = distance
                    target = v.Character
                end 
            end 
        end 
    end


    return target
end

function _cleanUp()
   for i,v in aimbotSettings.connections do 
        v:Disconnect()
   end 
   aimbotSettings.connections = {}

   warn("Connections cleaned!")
end

aimbotSettings.connections.Stepped = runService.RenderStepped:Connect(function(dt)
    if not aimbotSettings.aimbot or not aimbotSettings.holding then return end 

    local enemy = _getClosestPlayerToMouse()

    if enemy and enemy[aimbotSettings.part] then 
        local target = CFrame.lookAt(camera.CFrame.Position,enemy[aimbotSettings.part].Position)

        camera.CFrame = camera.CFrame:Lerp(target,aimbotSettings.smoothness)
    end 
end)

aimbotSettings.connections.lol1 = uis.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then 
        aimbotSettings.holding = true
    end 
end)

aimbotSettings.connections.lol2 = uis.InputEnded:Connect(function(input, gameProcessedEvent)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then 
        aimbotSettings.holding = false
    end 
end)    


aimbotSettings.connections.lol3 = uis.InputEnded:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.L then 
        _cleanUp()
    end 
end)  


return aimbotSettings
