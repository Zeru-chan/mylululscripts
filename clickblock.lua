local DELAY = getgenv().DELAY or 0.05

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local VIM = game:GetService("VirtualInputManager")
local LP = Players.LocalPlayer

local function anim(o, p) TweenService:Create(o, TweenInfo.new(0.2), p):Play() end

local function blockLogic(plr)
    if plr and plr ~= LP then
        pcall(function() StarterGui:SetCore("PromptBlockPlayer", plr) end)
        task.wait(DELAY)
        local CX, CY = 998, 539 
        VIM:SendMouseButtonEvent(CX, CY, 0, true, game, 0)
        task.wait(0.02)
        VIM:SendMouseButtonEvent(CX, CY, 0, false, game, 0)
    end
end

local SG = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
SG.Name = "FullBlockerGui"
SG.ResetOnSpawn = false

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.fromOffset(320, 200)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Text = "Block Manager"
Title.Font = "GothamBold"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 16
Title.TextXAlignment = "Left"
Title.BackgroundTransparency = 1

local Close = Instance.new("TextButton", Header)
Close.Size = UDim2.fromOffset(28, 28)
Close.Position = UDim2.new(1, -15, 0.5, 0)
Close.AnchorPoint = Vector2.new(1, 0.5)
Close.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
Close.BackgroundTransparency = 0.8
Close.Text = "×"
Close.TextColor3 = Color3.new(1,1,1)
Close.Font = "GothamMedium"
Close.TextSize = 20
Instance.new("UICorner", Close).CornerRadius = UDim.new(1, 0)
Close.MouseButton1Click:Connect(function() SG:Destroy() end)

local Info = Instance.new("TextLabel", Main)
Info.Size = UDim2.new(1, -40, 0, 20)
Info.Position = UDim2.new(0, 20, 0, 50)
Info.Text = "0 PLAYERS"
Info.Font = "Gotham"
Info.TextColor3 = Color3.fromRGB(120, 120, 130)
Info.TextSize = 10
Info.TextXAlignment = "Left"
Info.BackgroundTransparency = 1

local List = Instance.new("ScrollingFrame", Main)
List.Size = UDim2.new(1, -20, 1, -135)
List.Position = UDim2.new(0, 10, 0, 75)
List.BackgroundTransparency = 1
List.ScrollBarThickness = 0
List.CanvasSize = UDim2.new(0, 0, 0, 0)

local Layout = Instance.new("UIListLayout", List)
Layout.Padding = UDim.new(0, 8)

local cards = {}

local function resize()
    local contentHeight = Layout.AbsoluteContentSize.Y
    local targetHeight = math.clamp(150 + contentHeight, 180, 520)
    anim(Main, {Size = UDim2.fromOffset(320, targetHeight)})
    List.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
end

local function add(plr)
    if plr == LP or cards[plr] then return end
    local Card = Instance.new("Frame", List)
    Card.Size = UDim2.new(1, 0, 0, 56)
    Card.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 12)
    
    local Img = Instance.new("ImageLabel", Card)
    Img.Size = UDim2.fromOffset(40, 40)
    Img.Position = UDim2.new(0, 8, 0.5, 0)
    Img.AnchorPoint = Vector2.new(0, 0.5)
    Img.Image = "rbxthumb://type=AvatarHeadShot&id="..plr.UserId.."&w=100&h=100"
    Img.BackgroundTransparency = 1
    Instance.new("UICorner", Img).CornerRadius = UDim.new(1, 0)

    local Name = Instance.new("TextLabel", Card)
    Name.Size = UDim2.new(1, -120, 0, 16)
    Name.Position = UDim2.fromOffset(55, 12)
    Name.Text = plr.DisplayName
    Name.Font = "GothamBold"
    Name.TextColor3 = Color3.new(1,1,1)
    Name.TextSize = 12
    Name.TextXAlignment = "Left"
    Name.BackgroundTransparency = 1

    local User = Instance.new("TextLabel", Card)
    User.Size = UDim2.new(1, -120, 0, 14)
    User.Position = UDim2.fromOffset(55, 28)
    User.Text = "@"..plr.Name
    User.Font = "Gotham"
    User.TextColor3 = Color3.fromRGB(140, 140, 140)
    User.TextSize = 10
    User.TextXAlignment = "Left"
    User.BackgroundTransparency = 1

    local B = Instance.new("TextButton", Card)
    B.Size = UDim2.fromOffset(65, 30)
    B.Position = UDim2.new(1, -10, 0.5, 0)
    B.AnchorPoint = Vector2.new(1, 0.5)
    B.BackgroundColor3 = Color3.fromRGB(200, 45, 45)
    B.Text = "Block"
    B.Font = "GothamBold"
    B.TextColor3 = Color3.new(1,1,1)
    B.TextSize = 11
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)

    B.MouseButton1Click:Connect(function()
        B.Text, B.BackgroundColor3 = "...", Color3.fromRGB(60, 60, 60)
        blockLogic(plr)
        B.Text = "Done"
        task.wait(1.5)
        B.Text, B.BackgroundColor3 = "Block", Color3.fromRGB(200, 45, 45)
    end)

    cards[plr] = Card
    resize()
end

local function up()
    local c = 0 for _ in pairs(cards) do c += 1 end
    Info.Text = c.." PLAYERS ONLINE"
end

Players.PlayerAdded:Connect(function(p) add(p) up() end)
Players.PlayerRemoving:Connect(function(p) if cards[p] then cards[p]:Destroy() cards[p] = nil end up() resize() end)
for _, p in pairs(Players:GetPlayers()) do add(p) end up()

local All = Instance.new("TextButton", Main)
All.Size = UDim2.new(1, -30, 0, 42)
All.Position = UDim2.new(0.5, 0, 1, -12)
All.AnchorPoint = Vector2.new(0.5, 1)
All.BackgroundColor3 = Color3.fromRGB(60, 85, 230)
All.Text = "BLOCK ALL PLAYERS"
All.Font = "GothamBold"
All.TextColor3 = Color3.new(1,1,1)
All.TextSize = 12
Instance.new("UICorner", All).CornerRadius = UDim.new(0, 12)

local active = false
All.MouseButton1Click:Connect(function()
    if active then return end
    active = true
    All.BackgroundColor3 = Color3.fromRGB(200, 160, 40)
    local pList = {}
    for _, p in pairs(Players:GetPlayers()) do if p ~= LP then table.insert(pList, p) end end
    for i, p in ipairs(pList) do
        All.Text = "BLOCKING... ["..i.."/"..#pList.."]"
        blockLogic(p)
        task.wait(DELAY) 
    end
    All.Text, All.BackgroundColor3 = "COMPLETED", Color3.fromRGB(60, 60, 60)
    task.wait(2)
    All.Text, All.BackgroundColor3 = "BLOCK ALL PLAYERS", Color3.fromRGB(60, 85, 230)
    active = false
end)

local dS, sP, dG
Header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dG = true dS = i.Position sP = Main.Position end end)
UIS.InputChanged:Connect(function(i) if dG and i.UserInputType == Enum.UserInputType.MouseMovement then
    local d = i.Position - dS
    Main.Position = UDim2.new(sP.X.Scale, sP.X.Offset + d.X, sP.Y.Scale, sP.Y.Offset + d.Y)
end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dG = false end end)
