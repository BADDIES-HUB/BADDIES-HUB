-- [[ REDZ HUB CLASSIC V7.6 - FINAL STABLE & NOTIFICATIONS ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui") -- Thêm StarterGui để thông báo
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CẤU HÌNH GLOBAL
getgenv().Config = {
    Hitbox = false, Size = 20, Trans = 5, Aura = false,
    Speed = false, WalkSpeed = 16, Jump = false,
    NoRagdoll = true, AntiVoid = true,
    HitSound = true,
    SkyWalk = false
}
getgenv().Whitelist = {}
getgenv().TargetKill = nil 
getgenv().TargetESP = {} 

-- HÀM THÔNG BÁO (NEW)
function Notify(Text)
    StarterGui:SetCore("SendNotification", {
        Title = "REDZ HUB",
        Text = Text,
        Duration = 2,
    })
end

-- 1. GIAO DIỆN CHÍNH
if CoreGui:FindFirstChild("RedzClassicV76") then CoreGui.RedzClassicV76:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "RedzClassicV76"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- NÚT ẨN GUI
local HideBtn = Instance.new("ImageButton", ScreenGui)
HideBtn.Size = UDim2.new(0, 40, 0, 40); HideBtn.Position = UDim2.new(0.95, -50, 0.05, 0)
HideBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0); HideBtn.BackgroundTransparency = 0.5
Instance.new("UICorner", HideBtn).CornerRadius = UDim.new(1, 0)
local HideIcon = Instance.new("TextLabel", HideBtn)
HideIcon.Size = UDim2.new(1,0,1,0); HideIcon.Text = "👁️"; HideIcon.BackgroundTransparency=1; HideIcon.TextSize=20

-- NÚT BẬT TẮT
local Toggle = Instance.new("TextButton", ScreenGui)
Toggle.Size = UDim2.new(0, 50, 0, 50); Toggle.Position = UDim2.new(0.1, 0, 0.3, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Toggle.Text = "R7"; Toggle.TextColor3 = Color3.fromRGB(255, 0, 0)
Toggle.Font = Enum.Font.FredokaOne; Toggle.TextSize = 24; Instance.new("UICorner", Toggle)
Instance.new("UIStroke", Toggle).Color = Color3.fromRGB(255, 0, 0)

-- MENU CHÍNH
local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 280, 0, 260)
Main.Position = UDim2.new(0.5, -140, 0.5, -130); Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Main.Visible = false
Instance.new("UICorner", Main); local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Color3.fromRGB(255,0,0); Stroke.Thickness = 2
local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 30); Title.Text = "REDZ PRO V7.6"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.BackgroundTransparency = 1; Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 18

local Container = Instance.new("ScrollingFrame", Main); Container.Size = UDim2.new(1, -10, 1, -40); Container.Position = UDim2.new(0, 5, 0, 35)
Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 2; Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
local UIList = Instance.new("UIListLayout", Container); UIList.Padding = UDim.new(0, 5)

-- MENU PHỤ
local SubMenu = Instance.new("Frame", ScreenGui)
SubMenu.Size = UDim2.new(0, 300, 0, 260); SubMenu.Position = UDim2.new(0.5, 150, 0.5, -130)
SubMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 25); SubMenu.Visible = false
Instance.new("UICorner", SubMenu); local SubStroke = Instance.new("UIStroke", SubMenu); SubStroke.Color = Color3.fromRGB(0, 255, 0)

local SubTitle = Instance.new("TextLabel", SubMenu); SubTitle.Size = UDim2.new(1, 0, 0, 30); SubTitle.Text = "PLAYER TRACKER"; SubTitle.TextColor3 = Color3.fromRGB(0, 255, 0); SubTitle.BackgroundTransparency = 1; SubTitle.Font = Enum.Font.SourceSansBold; SubTitle.TextSize = 14
local CloseSub = Instance.new("TextButton", SubMenu); CloseSub.Size = UDim2.new(0, 30, 0, 30); CloseSub.Position = UDim2.new(1, -30, 0, 0); CloseSub.Text = "X"; CloseSub.TextColor3 = Color3.fromRGB(255,0,0); CloseSub.BackgroundTransparency = 1; CloseSub.Font = Enum.Font.SourceSansBold

local PlayerList = Instance.new("ScrollingFrame", SubMenu); PlayerList.Size = UDim2.new(1, -10, 1, -40); PlayerList.Position = UDim2.new(0, 5, 0, 35)
PlayerList.BackgroundTransparency = 1; PlayerList.ScrollBarThickness = 2; PlayerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
local PListLayout = Instance.new("UIListLayout", PlayerList); PListLayout.Padding = UDim.new(0, 2)

-- TEXT KILL STATUS
local KillStatus = Instance.new("TextLabel", ScreenGui)
KillStatus.Size = UDim2.new(1, 0, 0, 30); KillStatus.Position = UDim2.new(0, 0, 0, 50); KillStatus.BackgroundTransparency = 1
KillStatus.Text = ""; KillStatus.TextColor3 = Color3.fromRGB(255, 0, 0); KillStatus.Font = Enum.Font.FredokaOne; KillStatus.TextSize = 20; KillStatus.TextStrokeTransparency = 0

-- LOGIC ẨN/HIỆN GUI
local GUIVisible = true
HideBtn.MouseButton1Click:Connect(function()
    GUIVisible = not GUIVisible
    Toggle.Visible = GUIVisible
    Main.Visible = false
    SubMenu.Visible = false
    HideIcon.Text = GUIVisible and "👁️" or "🚫"
end)

-- LOGIC KÉO THẢ
local function EnableDragging(frame)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)
end
EnableDragging(Toggle); EnableDragging(SubMenu)

-- AUTO KILL & STOMP
spawn(function()
    local Angle = 0
    while task.wait() do
        if getgenv().TargetKill then
            KillStatus.Text = ">>> ĐANG SĂN: " .. getgenv().TargetKill .. " <<<"
            local Target = Players:FindFirstChild(getgenv().TargetKill)
            if Target and Target.Character and Target.Character:FindFirstChild("Humanoid") and Target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local MyRoot = LocalPlayer.Character.HumanoidRootPart
                local TarRoot = Target.Character.HumanoidRootPart
                local TarHum = Target.Character.Humanoid
                local Dist = (MyRoot.Position - TarRoot.Position).Magnitude
                if TarHum.Health > 0 and TarHum.Health < 5 then 
                    KillStatus.Text = ">>> ĐANG DẬM (STOMPING)! <<<"
                    LocalPlayer.Character.HumanoidRootPart.CFrame = TarRoot.CFrame 
                    VirtualUser:CaptureController(); keypress(Enum.KeyCode.E); task.wait(0.1); keyrelease(Enum.KeyCode.E)
                else
                    if Dist > 10 then LocalPlayer.Character.Humanoid:MoveTo(TarRoot.Position) else Angle = Angle + 0.15; local Offset = Vector3.new(math.cos(Angle) * 5, 0, math.sin(Angle) * 5); LocalPlayer.Character.Humanoid:MoveTo(TarRoot.Position + Offset) end
                end
            else getgenv().TargetKill = nil; KillStatus.Text = "" end
        else KillStatus.Text = "" end
    end
end)

-- REFRESH PLAYERS
function RefreshPlayers()
    for _, v in pairs(PlayerList:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            local PFrame = Instance.new("Frame", PlayerList); PFrame.Size = UDim2.new(1, 0, 0, 40); PFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35); Instance.new("UICorner", PFrame)
            local PName = Instance.new("TextLabel", PFrame); PName.Size = UDim2.new(0.35, 0, 1, 0); PName.BackgroundTransparency = 1; PName.Text = v.Name; PName.TextColor3 = Color3.new(1,1,1); PName.Font = Enum.Font.SourceSansBold; PName.TextSize = 13; PName.TextXAlignment = Enum.TextXAlignment.Left; PName.Position = UDim2.new(0.02,0,0,0)
            local HPBtn = Instance.new("TextButton", PFrame); HPBtn.Size = UDim2.new(0.18, 0, 0.8, 0); HPBtn.Position = UDim2.new(0.38, 0, 0.1, 0); HPBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); HPBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", HPBtn); HPBtn.Font = Enum.Font.SourceSansBold; HPBtn.TextSize = 11
            local SafeBtn = Instance.new("TextButton", PFrame); SafeBtn.Size = UDim2.new(0.18, 0, 0.8, 0); SafeBtn.Position = UDim2.new(0.58, 0, 0.1, 0); SafeBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); SafeBtn.Text = "SAFE"; SafeBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", SafeBtn); SafeBtn.Font = Enum.Font.SourceSansBold; SafeBtn.TextSize = 10
            local KillBtn = Instance.new("TextButton", PFrame); KillBtn.Size = UDim2.new(0.2, 0, 0.8, 0); KillBtn.Position = UDim2.new(0.78, 0, 0.1, 0); KillBtn.BackgroundColor3 = Color3.fromRGB(150,0,0); KillBtn.Text = "KILL"; KillBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", KillBtn); KillBtn.Font = Enum.Font.SourceSansBold; KillBtn.TextSize = 12

            spawn(function()
                while PFrame.Parent do
                    if v.Character and v.Character:FindFirstChild("Humanoid") then
                        local HP = math.floor(v.Character.Humanoid.Health)
                        HPBtn.Text = HP .. "%"
                        if getgenv().TargetESP[v.Name] then HPBtn.BackgroundColor3 = Color3.new(1,0,0) else HPBtn.BackgroundColor3 = Color3.fromRGB(50,50,50) end
                    else HPBtn.Text = "X" end
                    if getgenv().Whitelist[v.Name] then SafeBtn.TextColor3 = Color3.new(0,1,0) else SafeBtn.TextColor3 = Color3.new(1,1,1) end
                    if getgenv().TargetKill == v.Name then KillBtn.Text = "STOP"; KillBtn.BackgroundColor3 = Color3.new(0,1,0) else KillBtn.Text = "KILL"; KillBtn.BackgroundColor3 = Color3.fromRGB(150,0,0) end
                    task.wait(0.5)
                end
            end)
            HPBtn.MouseButton1Click:Connect(function() getgenv().TargetESP[v.Name] = not getgenv().TargetESP[v.Name] end)
            SafeBtn.MouseButton1Click:Connect(function() getgenv().Whitelist[v.Name] = not getgenv().Whitelist[v.Name] end)
            KillBtn.MouseButton1Click:Connect(function() if getgenv().TargetKill == v.Name then getgenv().TargetKill = nil else getgenv().TargetKill = v.Name end end)
        end
    end
end
CloseSub.MouseButton1Click:Connect(function() SubMenu.Visible = false end)

-- UI HELPERS (THÊM THÔNG BÁO)
function AddToggle(Text, Flag)
    local Btn = Instance.new("TextButton", Container); Btn.Size = UDim2.new(1, 0, 0, 35); Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.Text = "  " .. Text .. " [OFF]"; Btn.TextColor3 = Color3.fromRGB(150, 150, 150); Btn.TextXAlignment = "Left"; Btn.Font = Enum.Font.SourceSansBold
    Btn.MouseButton1Click:Connect(function()
        if not Main.Visible then return end
        getgenv().Config[Flag] = not getgenv().Config[Flag]
        Btn.Text = "  " .. Text .. " [" .. (getgenv().Config[Flag] and "ON" or "OFF") .. "]"
        Btn.TextColor3 = getgenv().Config[Flag] and Color3.new(0,1,0) or Color3.fromRGB(150,150,150)
        
        -- THÔNG BÁO KHI BẬT/TẮT
        if getgenv().Config[Flag] then
            Notify("✅ ĐÃ BẬT: " .. Text)
        else
            Notify("❌ ĐÃ TẮT: " .. Text)
        end
    end)
end

function AddSlider(Text, Flag, Min, Max)
    local F = Instance.new("Frame", Container); F.Size = UDim2.new(1, 0, 0, 45); F.BackgroundTransparency = 1
    local L = Instance.new("TextLabel", F); L.Size = UDim2.new(1, 0, 0, 20); L.Text = Text .. ": " .. getgenv().Config[Flag]; L.TextColor3 = Color3.new(1,1,1); L.BackgroundTransparency = 1
    local B = Instance.new("TextButton", F); B.Size = UDim2.new(0.9, 0, 0, 8); B.Position = UDim2.new(0.05, 0, 0.6, 0); B.BackgroundColor3 = Color3.new(0,0,0); B.Text = ""
    local Fill = Instance.new("Frame", B); Fill.Size = UDim2.new(0,0,1,0); Fill.BackgroundColor3 = Color3.new(1,0,0)
    B.MouseButton1Down:Connect(function()
        if not Main.Visible then return end
        local M = LocalPlayer:GetMouse(); local C; C = RunService.RenderStepped:Connect(function()
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or not Main.Visible then C:Disconnect() return end
            local P = math.clamp((M.X - B.AbsolutePosition.X) / B.AbsoluteSize.X, 0, 1); local V = math.floor(Min + (Max - Min) * P); getgenv().Config[Flag] = V; L.Text = Text .. ": " .. V; Fill.Size = UDim2.new(P, 0, 1, 0)
        end)
    end)
end

-- SYSTEM ESP
spawn(function()
    local ESPFolder = Instance.new("Folder", CoreGui); ESPFolder.Name = "ESP_Container"
    while task.wait(0.5) do
        ESPFolder:ClearAllChildren()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for PlayerName, IsActive in pairs(getgenv().TargetESP) do
                if IsActive then
                    local Target = Players:FindFirstChild(PlayerName)
                    if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
                        local Billboard = Instance.new("BillboardGui", ESPFolder); Billboard.Adornee = Target.Character.HumanoidRootPart; Billboard.Size = UDim2.new(0, 200, 0, 100); Billboard.StudsOffset = Vector3.new(0, 3.5, 0); Billboard.AlwaysOnTop = true
                        local Label = Instance.new("TextLabel", Billboard); Label.Size = UDim2.new(1,0,1,0); Label.BackgroundTransparency = 1; local Dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - Target.Character.HumanoidRootPart.Position).Magnitude)
                        Label.Text = "👹 NÓ ĐÂY NÈ TRỜI 👹\n[" .. Dist .. "m]"; Label.TextColor3 = Color3.fromRGB(255, 0, 0); Label.TextStrokeTransparency = 0; Label.Font = Enum.Font.FredokaOne; Label.TextSize = 18
                        local Box = Instance.new("Highlight", ESPFolder); Box.Adornee = Target.Character; Box.FillColor = Color3.fromRGB(255, 0, 0); Box.FillTransparency = 0.5; Box.OutlineColor = Color3.fromRGB(255, 255, 0)
                    end
                end
            end
        end
    end
end)

-- SETUP MENU
AddToggle("Hitbox (No Fling)", "Hitbox")
AddSlider("Kích Thước Hitbox", "Size", 2, 50) 
AddSlider("Độ Mờ Hitbox", "Trans", 0, 10) 
AddToggle("Hit Sound (Âm Thanh)", "HitSound")
AddToggle("Sky Walk (Đi Trên Không)", "SkyWalk") 

local PlayerBtn = Instance.new("TextButton", Container); PlayerBtn.Size = UDim2.new(1,0,0,35); PlayerBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); PlayerBtn.Text = ">>> MỞ PLAYER TRACKER (KILL/ESP) <<<"; PlayerBtn.TextColor3 = Color3.new(0,1,1); PlayerBtn.Font = Enum.Font.SourceSansBold
PlayerBtn.MouseButton1Click:Connect(function() if Main.Visible then SubMenu.Visible = not SubMenu.Visible; if SubMenu.Visible then RefreshPlayers() end end end)

AddToggle("Attack Aura", "Aura")
AddToggle("Speed Fix", "Speed")
AddSlider("Tốc Độ", "WalkSpeed", 16, 100)
AddToggle("Nhảy Vô Hạn", "Jump")
AddToggle("Anti-Void", "AntiVoid")
AddToggle("Anti-Ragdoll", "NoRagdoll")

-- LOGIC SKY WALK (TẠO PART ĐI TRÊN KHÔNG)
local SkyPart = nil
spawn(function()
    while task.wait(0.1) do
        if getgenv().Config.SkyWalk and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if not SkyPart then
                SkyPart = Instance.new("Part", workspace)
                SkyPart.Name = "RedzSkyWalk"
                SkyPart.Size = Vector3.new(10, 1, 10)
                SkyPart.Anchored = true
                SkyPart.Transparency = 0.5
                SkyPart.Material = Enum.Material.Neon
                SkyPart.BrickColor = BrickColor.new("Cyan")
            end
            SkyPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -3.5, 0)
        else
            if SkyPart then SkyPart:Destroy(); SkyPart = nil end
        end
    end
end)

-- LOGIC LOOPS
local HitSound = Instance.new("Sound", Workspace); HitSound.SoundId = "rbxassetid://169444938"; HitSound.Volume = 1
RunService.RenderStepped:Connect(function()
    if getgenv().Config.Hitbox then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and not getgenv().Whitelist[v.Name] and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local HRP = v.Character.HumanoidRootPart
                HRP.Size = Vector3.new(getgenv().Config.Size, getgenv().Config.Size, getgenv().Config.Size)
                HRP.Transparency = getgenv().Config.Trans/10; HRP.CanCollide = false; HRP.BrickColor = BrickColor.new("Really red")
            end
        end
    end
end)

spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if getgenv().Config.Aura then
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LocalPlayer and not getgenv().Whitelist[v.Name] and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        if (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude < (getgenv().Config.Size + 5) then
                            VirtualUser:CaptureController(); VirtualUser:ClickButton1(Vector2.new(9999, 9999)); if getgenv().Config.HitSound then HitSound:Play() end
                        end
                    end
                end
            end
        end)
    end
end)

RunService.Heartbeat:Connect(function()
    local C = LocalPlayer.Character
    if C and C:FindFirstChild("Humanoid") then
        if getgenv().Config.Speed then C.Humanoid.WalkSpeed = getgenv().Config.WalkSpeed end
        if getgenv().Config.NoRagdoll then C.Humanoid:SetStateEnabled(0, false); C.Humanoid:SetStateEnabled(1, false) end
        if getgenv().Config.AntiVoid and C.HumanoidRootPart.Position.Y < -50 then C.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0) end
    end
end)

UserInputService.JumpRequest:Connect(function() if getgenv().Config.Jump then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end)

Toggle.MouseButton1Click:Connect(function() if not Main.Visible then Main.Visible = true; SubMenu.Visible = false else Main.Visible = false; SubMenu.Visible = false end end)

-- FIX CHẾT MẤT ESP
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if SubMenu.Visible then RefreshPlayers() end
end)

Notify("Script đã tải thành công!")
