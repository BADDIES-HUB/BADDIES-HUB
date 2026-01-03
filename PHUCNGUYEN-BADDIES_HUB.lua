-- [[ REDZ HUB CLASSIC V7.6 - ULTIMATE EDITION (NEON + TOOLS) ]] --

-- === [ HỆ THỐNG KIỂM TRA PHIÊN BẢN ] ===
local CurrentVersion = 7.6
if CurrentVersion <= 7.0 then
    game.Players.LocalPlayer:Kick("\n\n⚠️ LỖI PHIÊN BẢN ⚠️\nScript Vision đã cũ (V"..CurrentVersion..").\nVui lòng cập nhật!")
    while true do task.wait() end return
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- CẤU HÌNH GLOBAL
getgenv().Config = {
    Hitbox = false, Size = 20, Trans = 5, Aura = false,
    Speed = false, WalkSpeed = 16, Jump = false,
    NoRagdoll = true, AntiVoid = true,
    HitSound = true, SkyWalk = false
}
getgenv().Whitelist = {}
getgenv().TargetKill = nil 
getgenv().TargetESP = {} 

function Notify(Text)
    StarterGui:SetCore("SendNotification", {Title = "REDZ HUB", Text = Text, Duration = 2})
end

-- === [ HÀM NEON EFFECT (RAINBOW STROKE) ] ===
local function AddNeon(obj)
    local stroke = Instance.new("UIStroke", obj)
    stroke.Thickness = 2
    spawn(function()
        local h = 0
        while obj.Parent do
            h = h + 0.005
            if h > 1 then h = 0 end
            stroke.Color = Color3.fromHSV(h, 1, 1)
            task.wait()
        end
    end)
end

-- === [ GIAO DIỆN CHÍNH ] ===
if CoreGui:FindFirstChild("RedzClassicV76") then CoreGui.RedzClassicV76:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "RedzClassicV76"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- NÚT ẨN GUI
local HideBtn = Instance.new("ImageButton", ScreenGui)
HideBtn.Size = UDim2.new(0, 40, 0, 40); HideBtn.Position = UDim2.new(0.95, -50, 0.05, 0)
HideBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0); HideBtn.BackgroundTransparency = 0.5
Instance.new("UICorner", HideBtn).CornerRadius = UDim.new(1, 0)
local HideIcon = Instance.new("TextLabel", HideBtn); HideIcon.Size = UDim2.new(1,0,1,0); HideIcon.Text = "👁️"; HideIcon.BackgroundTransparency=1; HideIcon.TextSize=20

-- NÚT BẬT TẮT
local Toggle = Instance.new("TextButton", ScreenGui)
Toggle.Size = UDim2.new(0, 50, 0, 50); Toggle.Position = UDim2.new(0.1, 0, 0.3, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Toggle.Text = "R7"; Toggle.TextColor3 = Color3.fromRGB(255, 0, 0)
Toggle.Font = Enum.Font.FredokaOne; Toggle.TextSize = 24; Instance.new("UICorner", Toggle)
AddNeon(Toggle) -- Thêm Neon

-- MENU CHÍNH
local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 280, 0, 260)
Main.Position = UDim2.new(0.5, -140, 0.5, -130); Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Main.Visible = false
Instance.new("UICorner", Main); AddNeon(Main) -- Thêm Neon

local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 30); Title.Text = "REDZ PRO V7.6"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.BackgroundTransparency = 1; Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 18
local Container = Instance.new("ScrollingFrame", Main); Container.Size = UDim2.new(1, -10, 1, -40); Container.Position = UDim2.new(0, 5, 0, 35)
Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 2; Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
local UIList = Instance.new("UIListLayout", Container); UIList.Padding = UDim.new(0, 5)

-- MENU PHỤ 1 (TRACKER)
local SubMenu = Instance.new("Frame", ScreenGui); SubMenu.Size = UDim2.new(0, 300, 0, 260); SubMenu.Position = UDim2.new(0.5, 150, 0.5, -130); SubMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 25); SubMenu.Visible = false
Instance.new("UICorner", SubMenu); AddNeon(SubMenu) -- Thêm Neon

local SubTitle = Instance.new("TextLabel", SubMenu); SubTitle.Size = UDim2.new(1, 0, 0, 30); SubTitle.Text = "PLAYER TRACKER"; SubTitle.TextColor3 = Color3.fromRGB(0, 255, 0); SubTitle.BackgroundTransparency = 1; SubTitle.Font = Enum.Font.SourceSansBold; SubTitle.TextSize = 14
local CloseSub = Instance.new("TextButton", SubMenu); CloseSub.Size = UDim2.new(0, 30, 0, 30); CloseSub.Position = UDim2.new(1, -30, 0, 0); CloseSub.Text = "X"; CloseSub.TextColor3 = Color3.fromRGB(255,0,0); CloseSub.BackgroundTransparency = 1; CloseSub.Font = Enum.Font.SourceSansBold
local PlayerList = Instance.new("ScrollingFrame", SubMenu); PlayerList.Size = UDim2.new(1, -10, 1, -40); PlayerList.Position = UDim2.new(0, 5, 0, 35); PlayerList.BackgroundTransparency = 1; PlayerList.ScrollBarThickness = 2; PlayerList.AutomaticCanvasSize = Enum.AutomaticSize.Y; local PListLayout = Instance.new("UIListLayout", PlayerList); PListLayout.Padding = UDim.new(0, 2)

-- MENU PHỤ 2 (TOOLS MENU - BÊN TRÁI) - NEW
local SubMenu2 = Instance.new("Frame", ScreenGui); SubMenu2.Size = UDim2.new(0, 250, 0, 200); SubMenu2.Position = UDim2.new(0.5, -420, 0.5, -100); SubMenu2.BackgroundColor3 = Color3.fromRGB(30, 30, 35); SubMenu2.Visible = false
Instance.new("UICorner", SubMenu2); AddNeon(SubMenu2) -- Thêm Neon

local SubTitle2 = Instance.new("TextLabel", SubMenu2); SubTitle2.Size = UDim2.new(1, 0, 0, 30); SubTitle2.Text = "TOOLS MENU"; SubTitle2.TextColor3 = Color3.fromRGB(0, 200, 255); SubTitle2.BackgroundTransparency = 1; SubTitle2.Font = Enum.Font.FredokaOne
local CloseSub2 = Instance.new("TextButton", SubMenu2); CloseSub2.Size = UDim2.new(0, 30, 0, 30); CloseSub2.Position = UDim2.new(1, -30, 0, 0); CloseSub2.Text = "X"; CloseSub2.TextColor3 = Color3.fromRGB(255,0,0); CloseSub2.BackgroundTransparency = 1; CloseSub2.Font = Enum.Font.FredokaOne

-- NÚT 1: ANIMATION
local AnimBtn = Instance.new("TextButton", SubMenu2); AnimBtn.Size = UDim2.new(0.8, 0, 0, 40); AnimBtn.Position = UDim2.new(0.1, 0, 0.25, 0); AnimBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60); AnimBtn.Text = "ANIMATION (Emotes)"; AnimBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", AnimBtn)
AnimBtn.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua"))() end)

-- NÚT 2: COMMAND
local CmdBtn = Instance.new("TextButton", SubMenu2); CmdBtn.Size = UDim2.new(0.8, 0, 0, 40); CmdBtn.Position = UDim2.new(0.1, 0, 0.5, 0); CmdBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60); CmdBtn.Text = "COMMAND (Infinite Yield)"; CmdBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", CmdBtn)
CmdBtn.MouseButton1Click:Connect(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)

-- TEXT GHI CHÚ
local NoteLabel = Instance.new("TextLabel", SubMenu2); NoteLabel.Size = UDim2.new(1, 0, 0, 30); NoteLabel.Position = UDim2.new(0, 0, 0.8, 0); NoteLabel.BackgroundTransparency = 1; NoteLabel.Text = "--- VUI LÒNG CHỜ 2 NGÀY ĐỂ UPDATE SCRIPT ---"; NoteLabel.TextColor3 = Color3.fromRGB(255, 100, 100); NoteLabel.Font = Enum.Font.SourceSansItalic; NoteLabel.TextSize = 11

-- NÚT MỞ TOOLS MENU (TRONG MENU CHÍNH)
local ToolsBtn = Instance.new("TextButton", Container); ToolsBtn.Size = UDim2.new(1, 0, 0, 35); ToolsBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 150); ToolsBtn.Text = ">>> MỞ TOOLS MENU <<<"; ToolsBtn.TextColor3 = Color3.new(1,1,1); ToolsBtn.Font = Enum.Font.FredokaOne
ToolsBtn.MouseButton1Click:Connect(function() if Main.Visible then SubMenu2.Visible = not SubMenu2.Visible; SubMenu.Visible = false end end)

-- TEXT KILL STATUS
local KillStatus = Instance.new("TextLabel", ScreenGui); KillStatus.Size = UDim2.new(1, 0, 0, 30); KillStatus.Position = UDim2.new(0, 0, 0, 50); KillStatus.BackgroundTransparency = 1; KillStatus.Text = ""; KillStatus.TextColor3 = Color3.fromRGB(255, 0, 0); KillStatus.Font = Enum.Font.FredokaOne; KillStatus.TextSize = 20; KillStatus.TextStrokeTransparency = 0

-- LOGIC HIỂN THỊ
local GUIVisible = true
HideBtn.MouseButton1Click:Connect(function() GUIVisible = not GUIVisible; Toggle.Visible = GUIVisible; Main.Visible = false; SubMenu.Visible = false; SubMenu2.Visible = false; HideIcon.Text = GUIVisible and "👁️" or "🚫" end)

-- LOGIC KÉO THẢ (ALL MENUS)
local function EnableDragging(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging=true; dragStart=i.Position; startPos=frame.Position end end)
    frame.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then dragInput=i end end)
    UserInputService.InputChanged:Connect(function(i) if i==dragInput and dragging then local d=i.Position-dragStart; frame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end end)
    frame.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging=false end end)
end
EnableDragging(Toggle); EnableDragging(SubMenu); EnableDragging(SubMenu2); EnableDragging(Main) -- Kéo cả menu chính

-- UI HELPERS
function AddToggle(Text, Flag)
    local Btn = Instance.new("TextButton", Container); Btn.Size = UDim2.new(1, 0, 0, 35); Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.Text = "  " .. Text .. " [OFF]"; Btn.TextColor3 = Color3.fromRGB(150, 150, 150); Btn.TextXAlignment = "Left"; Btn.Font = Enum.Font.SourceSansBold
    Btn.MouseButton1Click:Connect(function() if not Main.Visible then return end getgenv().Config[Flag] = not getgenv().Config[Flag]; Btn.Text = "  " .. Text .. " [" .. (getgenv().Config[Flag] and "ON" or "OFF") .. "]"; Btn.TextColor3 = getgenv().Config[Flag] and Color3.new(0,1,0) or Color3.fromRGB(150,150,150); Notify(getgenv().Config[Flag] and "✅ ĐÃ BẬT: "..Text or "❌ ĐÃ TẮT: "..Text) end)
end
function AddSlider(Text, Flag, Min, Max)
    local F = Instance.new("Frame", Container); F.Size = UDim2.new(1, 0, 0, 45); F.BackgroundTransparency = 1
    local L = Instance.new("TextLabel", F); L.Size = UDim2.new(1, 0, 0, 20); L.Text = Text .. ": " .. getgenv().Config[Flag]; L.TextColor3 = Color3.new(1,1,1); L.BackgroundTransparency = 1
    local B = Instance.new("TextButton", F); B.Size = UDim2.new(0.9, 0, 0, 8); B.Position = UDim2.new(0.05, 0, 0.6, 0); B.BackgroundColor3 = Color3.new(0,0,0); B.Text = ""; local Fill = Instance.new("Frame", B); Fill.Size = UDim2.new(0,0,1,0); Fill.BackgroundColor3 = Color3.new(1,0,0)
    B.MouseButton1Down:Connect(function() if not Main.Visible then return end local M = LocalPlayer:GetMouse(); local C; C = RunService.RenderStepped:Connect(function() if not UserInputService:IsMouseButtonPressed(0) or not Main.Visible then C:Disconnect() return end local P = math.clamp((M.X - B.AbsolutePosition.X) / B.AbsoluteSize.X, 0, 1); local V = math.floor(Min + (Max - Min) * P); getgenv().Config[Flag] = V; L.Text = Text .. ": " .. V; Fill.Size = UDim2.new(P, 0, 1, 0) end) end)
end

-- SETUP MAIN MENU
AddToggle("Hitbox (No Fling)", "Hitbox"); AddSlider("Kích Thước Hitbox", "Size", 2, 50); AddSlider("Độ Mờ Hitbox", "Trans", 0, 10); AddToggle("Hit Sound (Âm Thanh)", "HitSound"); AddToggle("Sky Walk (Đi Trên Không)", "SkyWalk")
local PlayerBtn = Instance.new("TextButton", Container); PlayerBtn.Size = UDim2.new(1,0,0,35); PlayerBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); PlayerBtn.Text = ">>> MỞ PLAYER TRACKER <<<"; PlayerBtn.TextColor3 = Color3.new(0,1,1); PlayerBtn.Font = Enum.Font.SourceSansBold
PlayerBtn.MouseButton1Click:Connect(function() if Main.Visible then SubMenu.Visible = not SubMenu.Visible; SubMenu2.Visible = false; if SubMenu.Visible then RefreshPlayers() end end end)
AddToggle("Attack Aura", "Aura"); AddToggle("Speed Fix", "Speed"); AddSlider("Tốc Độ", "WalkSpeed", 16, 100); AddToggle("Nhảy Vô Hạn", "Jump"); AddToggle("Anti-Void", "AntiVoid"); AddToggle("Anti-Ragdoll", "NoRagdoll")

-- REFRESH PLAYERS
function RefreshPlayers()
    for _,v in pairs(PlayerList:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    for _,v in pairs(Players:GetPlayers()) do
        if v~=LocalPlayer then
            local F=Instance.new("Frame",PlayerList); F.Size=UDim2.new(1,0,0,40); F.BackgroundColor3=Color3.fromRGB(35,35,35); local N=Instance.new("TextLabel",F); N.Size=UDim2.new(0.4,0,1,0); N.Text=v.Name; N.TextColor3=Color3.new(1,1,1); N.BackgroundTransparency=1
            local E=Instance.new("TextButton",F); E.Size=UDim2.new(0.2,0,0.8,0); E.Position=UDim2.new(0.45,0,0.1,0); E.Text="ESP"; local K=Instance.new("TextButton",F); K.Size=UDim2.new(0.2,0,0.8,0); K.Position=UDim2.new(0.7,0,0.1,0); K.Text="KILL"
            E.MouseButton1Click:Connect(function() getgenv().TargetESP[v.Name]=not getgenv().TargetESP[v.Name] end); K.MouseButton1Click:Connect(function() getgenv().TargetKill=(getgenv().TargetKill==v.Name) and nil or v.Name end)
        end
    end
end
CloseSub.MouseButton1Click:Connect(function() SubMenu.Visible = false end); CloseSub2.MouseButton1Click:Connect(function() SubMenu2.Visible = false end)

-- LOGIC CORE
local SkyPart = nil
spawn(function() while task.wait(0.1) do if getgenv().Config.SkyWalk and LocalPlayer.Character then if not SkyPart then SkyPart=Instance.new("Part",workspace); SkyPart.Name="RedzSkyWalk"; SkyPart.Size=Vector3.new(10,1,10); SkyPart.Anchored=true; SkyPart.Transparency=0.5; SkyPart.Material=Enum.Material.Neon; SkyPart.BrickColor=BrickColor.new("Cyan") end; SkyPart.CFrame=LocalPlayer.Character.HumanoidRootPart.CFrame*CFrame.new(0,-3.5,0) else if SkyPart then SkyPart:Destroy(); SkyPart=nil end end end end)
RunService.RenderStepped:Connect(function() if getgenv().Config.Hitbox then for _,v in pairs(Players:GetPlayers()) do if v~=LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then v.Character.HumanoidRootPart.Size=Vector3.new(getgenv().Config.Size,getgenv().Config.Size,getgenv().Config.Size); v.Character.HumanoidRootPart.Transparency=getgenv().Config.Trans/10; v.Character.HumanoidRootPart.CanCollide=false; v.Character.HumanoidRootPart.BrickColor=BrickColor.new("Really red") end end end end)
spawn(function() while task.wait(0.1) do pcall(function() if getgenv().Config.Aura then for _,v in pairs(Players:GetPlayers()) do if v~=LocalPlayer and v.Character then if (LocalPlayer.Character.HumanoidRootPart.Position-v.Character.HumanoidRootPart.Position).Magnitude < getgenv().Config.Size+5 then VirtualUser:CaptureController(); VirtualUser:ClickButton1(Vector2.new(9999,9999)) end end end end end) end end)
RunService.Heartbeat:Connect(function() if LocalPlayer.Character then if getgenv().Config.Speed then LocalPlayer.Character.Humanoid.WalkSpeed=getgenv().Config.WalkSpeed end; if getgenv().Config.NoRagdoll then LocalPlayer.Character.Humanoid:SetStateEnabled(0,false); LocalPlayer.Character.Humanoid:SetStateEnabled(1,false) end; if getgenv().Config.AntiVoid and LocalPlayer.Character.HumanoidRootPart.Position.Y<-50 then LocalPlayer.Character.HumanoidRootPart.Velocity=Vector3.new(0,50,0) end end end)
UserInputService.JumpRequest:Connect(function() if getgenv().Config.Jump then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end)
LocalPlayer.CharacterAdded:Connect(function() task.wait(1); if SubMenu.Visible then RefreshPlayers() end end)
Toggle.MouseButton1Click:Connect(function() if not Main.Visible then Main.Visible=true; SubMenu.Visible=false; SubMenu2.Visible=false else Main.Visible=false; SubMenu.Visible=false; SubMenu2.Visible=false end end)

-- LOGIC AUTO KILL (GIỮ NGUYÊN)
spawn(function() local Angle=0 while task.wait() do if getgenv().TargetKill then KillStatus.Text=">>> ĐANG SĂN: "..getgenv().TargetKill.." <<<"; local T=Players:FindFirstChild(getgenv().TargetKill); if T and T.Character and T.Character:FindFirstChild("HumanoidRootPart") then local Dist=(LocalPlayer.Character.HumanoidRootPart.Position-T.Character.HumanoidRootPart.Position).Magnitude; if T.Character.Humanoid.Health>0 and T.Character.Humanoid.Health<2 then KillStatus.Text=">>> STOMPING! <<<"; LocalPlayer.Character.HumanoidRootPart.CFrame=T.Character.HumanoidRootPart.CFrame; VirtualUser:CaptureController(); keypress(Enum.KeyCode.E); task.wait(0.1); keyrelease(Enum.KeyCode.E) else if Dist>8 then LocalPlayer.Character.Humanoid:MoveTo(T.Character.HumanoidRootPart.Position) else Angle=Angle+0.1; local O=Vector3.new(math.cos(Angle)*6,0,math.sin(Angle)*6); LocalPlayer.Character.Humanoid:MoveTo(T.Character.HumanoidRootPart.Position+O) end end else getgenv().TargetKill=nil; KillStatus.Text="" end else KillStatus.Text="" end end end)

-- LOGIC ESP (GIỮ NGUYÊN)
spawn(function() local ESPFolder=Instance.new("Folder",CoreGui); ESPFolder.Name="ESP_Container"; while task.wait(0.5) do ESPFolder:ClearAllChildren(); if LocalPlayer.Character then for N,A in pairs(getgenv().TargetESP) do if A then local T=Players:FindFirstChild(N); if T and T.Character then local B=Instance.new("BillboardGui",ESPFolder); B.Adornee=T.Character.HumanoidRootPart; B.Size=UDim2.new(0,200,0,100); B.AlwaysOnTop=true; local L=Instance.new("TextLabel",B); L.Size=UDim2.new(1,0,1,0); L.BackgroundTransparency=1; local D=math.floor((LocalPlayer.Character.HumanoidRootPart.Position-T.Character.HumanoidRootPart.Position).Magnitude); L.Text="TARGET ["..D.."m]"; L.TextColor3=Color3.new(1,0,0); local Box=Instance.new("Highlight",ESPFolder); Box.Adornee=T.Character; Box.FillColor=Color3.new(1,0,0); Box.OutlineColor=Color3.new(1,1,0) end end end end end end)

Notify("Script đã tải thành công!")
