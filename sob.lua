
if _G.Celerity == true then return end
_G.Celerity = true

repeat task.wait() until game:IsLoaded()
wait(.1)

local Players = game:GetService("Players")
local Replicated_Storage = game:GetService("ReplicatedStorage")
local Teleport_Service = game:GetService("TeleportService")
local Http_Service = game:GetService("HttpService")

local Local_Player = Players.LocalPlayer

local function ServerHop()
    local x = {}
    local success, result = pcall(function()
        return Http_Service:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
    end)
    
    if success then
        for _, v in ipairs(result) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                x[#x + 1] = v.id
            end
        end
    end

    if #x > 0 then
        queueonteleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/Zeru-chan/mylululscripts/refs/heads/main/sob.lua"))()]])
        
        Teleport_Service:TeleportToPlaceInstance(game.PlaceId, x[math.random(1, #x)])
    end
end

local Keywords = {"hack", "cheat", "exploit", "exploiter", "hacker", "чит", "хакер"}
local function MonitorChat(Player)
    Player.Chatted:Connect(function(Message)
        local LowerMsg = string.lower(Message)
        for _, word in ipairs(Keywords) do
            if string.find(LowerMsg, word) then
                ServerHop()
            end
        end
    end)
end
for _, p in ipairs(Players:GetPlayers()) do if p ~= Local_Player then MonitorChat(p) end end
Players.PlayerAdded:Connect(MonitorChat)

local function Slappable(Character)
    if Character:FindFirstChild("isInArena") and Character.isInArena.Value == true then return true end
    if Character:FindFirstChild("IsInDefaultArena") and Character.IsInDefaultArena.Value == true then return true end
    return false
end

local function Get_Closest_Player()
    local Closest_Player = Local_Player
    local Minimum_Distance = 1e9
    for _, v in ipairs(Players:GetPlayers()) do
        local Character = v.Character
        if v ~= Local_Player and Character and Character:FindFirstChild("HumanoidRootPart") and Slappable(Character) then
            local Distance = (Character.Head.Position - Local_Player.Character.Head.Position).Magnitude
            if Distance < Minimum_Distance then
                Minimum_Distance = Distance
                Closest_Player = v
            end
        end
    end
    return Closest_Player
end

local CelerityFarm = Instance.new("ScreenGui", Local_Player.PlayerGui)
CelerityFarm.Name = "Celerity Farm"
CelerityFarm.IgnoreGuiInset = true

local Background = Instance.new("ImageLabel", CelerityFarm)
Background.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
Background.Size = UDim2.new(1, 0, 1, 0)
Background.Image = "rbxassetid://296812735"

local SlapCounter = Instance.new("TextLabel", Background)
SlapCounter.BackgroundTransparency = 1
SlapCounter.Position = UDim2.new(0.5, -250, 0.1, -50)
SlapCounter.Size = UDim2.new(0, 500, 0, 100)
SlapCounter.Font = Enum.Font.Garamond
SlapCounter.TextColor3 = Color3.fromRGB(255, 255, 255)
SlapCounter.TextSize = 100
SlapCounter.Text = "Slaps: 0"

local Finisher = Instance.new("TextButton", Background)
Finisher.BackgroundTransparency = 1
Finisher.Position = UDim2.new(0.5, -100, 0.5, -100)
Finisher.Size = UDim2.new(0, 200, 0, 200)
Finisher.Font = Enum.Font.Garamond
Finisher.Text = "Finish"
Finisher.TextColor3 = Color3.fromRGB(255, 255, 255)
Finisher.TextSize = 50

task.spawn(function()
    while task.wait(0.15) do
        pcall(function()
            local Target = Get_Closest_Player()
            if Target ~= Local_Player then
                local Root = Target.Character.HumanoidRootPart
                Local_Player.Character:SetPrimaryPartCFrame(Root.CFrame * CFrame.new(0, -5.9, 0))
                Replicated_Storage.GeneralHit:FireServer(Root)
            end
            SlapCounter.Text = "Slaps: "..Local_Player.leaderstats.Slaps.Value
        end)
    end
end)

task.delay(2, function()
    ServerHop()
end)

Finisher.MouseButton1Click:Connect(ServerHop)

workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
workspace.CurrentCamera.CFrame = CFrame.new(0, 20000, 0)

for _, v in ipairs(workspace:GetDescendants()) do
    if table.find({"AntiDefaultArena", "ArenaBarrier", "DEATHBARRIER"}, v.Name) then
        pcall(function() v.CanTouch = false end)
    end
end

