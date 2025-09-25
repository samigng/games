-- UI_Setup_Example.lua
-- Example script to create the required UI hierarchy for the Like Count Display
-- This is a reference implementation - adapt to your existing UI structure

local function createUIHierarchy()
    -- Create the main container in workspace
    local misc = workspace:FindFirstChild("Misc")
    if not misc then
        misc = Instance.new("Folder")
        misc.Name = "Misc"
        misc.Parent = workspace
    end
    
    -- Create Leaderboards folder
    local leaderboards = misc:FindFirstChild("Leaderboards")
    if not leaderboards then
        leaderboards = Instance.new("Folder")
        leaderboards.Name = "Leaderboards"
        leaderboards.Parent = misc
    end
    
    -- Create LikesBoard part
    local likesBoard = leaderboards:FindFirstChild("LikesBoard")
    if not likesBoard then
        likesBoard = Instance.new("Part")
        likesBoard.Name = "LikesBoard"
        likesBoard.Size = Vector3.new(10, 6, 1)
        likesBoard.Position = Vector3.new(0, 10, 0)
        likesBoard.Anchored = true
        likesBoard.CanCollide = false
        likesBoard.BrickColor = BrickColor.new("Dark stone grey")
        likesBoard.Parent = leaderboards
    end
    
    -- Create ShowPart
    local showPart = likesBoard:FindFirstChild("ShowPart")
    if not showPart then
        showPart = Instance.new("Part")
        showPart.Name = "ShowPart"
        showPart.Size = Vector3.new(8, 4, 0.2)
        showPart.Position = Vector3.new(0, 0, 0.6)
        showPart.Anchored = true
        showPart.CanCollide = false
        showPart.BrickColor = BrickColor.new("Institutional white")
        showPart.Parent = likesBoard
    end
    
    -- Create SurfaceGui
    local showGui = showPart:FindFirstChild("ShowGui")
    if not showGui then
        showGui = Instance.new("SurfaceGui")
        showGui.Name = "ShowGui"
        showGui.Face = Enum.NormalId.Front
        showGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        showGui.PixelsPerStud = 50
        showGui.Parent = showPart
    end
    
    -- Create Main frame
    local main = showGui:FindFirstChild("Main")
    if not main then
        main = Instance.new("Frame")
        main.Name = "Main"
        main.Size = UDim2.new(1, 0, 1, 0)
        main.Position = UDim2.new(0, 0, 0, 0)
        main.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        main.BorderSizePixel = 0
        main.Parent = showGui
    end
    
    -- Create Bar frame
    local bar = main:FindFirstChild("Bar")
    if not bar then
        bar = Instance.new("Frame")
        bar.Name = "Bar"
        bar.Size = UDim2.new(0.8, 0, 0.3, 0)
        bar.Position = UDim2.new(0.1, 0, 0.35, 0)
        bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        bar.BorderSizePixel = 0
        bar.Parent = main
        
        -- Add corner rounding
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = bar
    end
    
    -- Create Count TextLabel
    local count = bar:FindFirstChild("Count")
    if not count then
        count = Instance.new("TextLabel")
        count.Name = "Count"
        count.Size = UDim2.new(1, 0, 1, 0)
        count.Position = UDim2.new(0, 0, 0, 0)
        count.BackgroundTransparency = 1
        count.Text = "0"
        count.TextColor3 = Color3.fromRGB(255, 255, 255)
        count.TextScaled = true
        count.Font = Enum.Font.GothamBold
        count.Parent = bar
    end
    
    -- Add title label
    local title = main:FindFirstChild("Title")
    if not title then
        title = Instance.new("TextLabel")
        title.Name = "Title"
        title.Size = UDim2.new(1, 0, 0.25, 0)
        title.Position = UDim2.new(0, 0, 0.05, 0)
        title.BackgroundTransparency = 1
        title.Text = "LIKES"
        title.TextColor3 = Color3.fromRGB(200, 200, 200)
        title.TextScaled = true
        title.Font = Enum.Font.Gotham
        title.Parent = main
    end
    
    print("UI hierarchy created successfully!")
    print("Like count will be displayed at: workspace.Misc.Leaderboards.LikesBoard.ShowPart.ShowGui.Main.Bar.Count")
end

-- Call the function to create the UI
createUIHierarchy()