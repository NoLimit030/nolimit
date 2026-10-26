-- Diagnostic loader: shows download, compilation or startup errors on screen.
local player=game:GetService("Players").LocalPlayer
local parent=player:WaitForChild("PlayerGui")
local previous=parent:FindFirstChild("NoLimitStartup")
if previous then previous:Destroy() end
local gui=Instance.new("ScreenGui")
gui.Name="NoLimitStartup"
gui.ResetOnSpawn=false
gui.DisplayOrder=10000
gui.Parent=parent
local box=Instance.new("TextLabel")
box.AnchorPoint=Vector2.new(0.5,0.5)
box.Position=UDim2.fromScale(0.5,0.5)
box.Size=UDim2.new(0.8,0,0,220)
box.BackgroundColor3=Color3.fromRGB(12,18,29)
box.TextColor3=Color3.fromRGB(237,242,250)
box.Font=Enum.Font.Code
box.TextSize=15
box.TextWrapped=true
box.Text="NoLimit: downloading..."
box.Parent=gui
local corner=Instance.new("UICorner")
corner.CornerRadius=UDim.new(0,12)
corner.Parent=box
local stage="Download"
local ok,err=xpcall(function()
    local source=game:HttpGet("https://raw.githubusercontent.com/NoLimit030/nolimit/refs/heads/main/nolimitFertig")
    source=source:gsub("^\239\187\191","")
    stage="Compilation"
    box.Text="NoLimit: compiling..."
    local fn,reason=loadstring(source)
    assert(fn,reason)
    stage="Startup"
    box.Text="NoLimit: starting..."
    fn()
    assert(parent:FindFirstChild("NoLimitPanel"),"The downloaded script did not create the NoLimit menu")
end,function(message)
    return debug.traceback(tostring(message),2)
end)
if ok then
    gui:Destroy()
else
    box.Text="NoLimit — "..stage.." failed\n\n"..tostring(err).."\n\nSend a screenshot of this message."
    warn(box.Text)
end
