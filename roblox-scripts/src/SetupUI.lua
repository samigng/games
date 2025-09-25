--[[
	SetupUI.lua
	
	A utility script to create the UI structure expected by the LikeCount scripts.
	This script creates the path: workspace.Misc.Leaderboards.LikesBoard.ShowPart.ShowGui.Main.Bar.Count
	
	Run this script once in your game to set up the required UI elements.
	This can be run as a ServerScript in ServerScriptService.
]]

-- Function to create the UI structure
local function createUIStructure()
	print("Setting up UI structure for LikeCount display...")
	
	-- Create the folder structure in workspace
	local misc = workspace:FindFirstChild("Misc") or Instance.new("Folder")
	misc.Name = "Misc"
	misc.Parent = workspace
	
	local leaderboards = misc:FindFirstChild("Leaderboards") or Instance.new("Folder")
	leaderboards.Name = "Leaderboards"
	leaderboards.Parent = misc
	
	local likesBoard = leaderboards:FindFirstChild("LikesBoard") or Instance.new("Part")
	likesBoard.Name = "LikesBoard"
	likesBoard.Parent = leaderboards
	likesBoard.Anchored = true
	likesBoard.CanCollide = false
	likesBoard.Size = Vector3.new(8, 6, 1)
	likesBoard.Position = Vector3.new(0, 10, 0)
	likesBoard.BrickColor = BrickColor.new("Dark stone grey")
	
	local showPart = likesBoard:FindFirstChild("ShowPart") or Instance.new("Part")
	showPart.Name = "ShowPart"
	showPart.Parent = likesBoard
	showPart.Anchored = true
	showPart.CanCollide = false
	showPart.Size = Vector3.new(6, 4, 0.1)
	showPart.Position = Vector3.new(0, 10, 0.5)
	showPart.BrickColor = BrickColor.new("Really black")
	
	-- Create SurfaceGui
	local showGui = showPart:FindFirstChild("ShowGui") or Instance.new("SurfaceGui")
	showGui.Name = "ShowGui"
	showGui.Parent = showPart
	showGui.Face = Enum.NormalId.Front
	
	-- Create main frame
	local main = showGui:FindFirstChild("Main") or Instance.new("Frame")
	main.Name = "Main"
	main.Parent = showGui
	main.Size = UDim2.new(1, 0, 1, 0)
	main.Position = UDim2.new(0, 0, 0, 0)
	main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	main.BorderSizePixel = 0
	
	-- Create bar frame
	local bar = main:FindFirstChild("Bar") or Instance.new("Frame")
	bar.Name = "Bar"
	bar.Parent = main
	bar.Size = UDim2.new(0.8, 0, 0.3, 0)
	bar.Position = UDim2.new(0.1, 0, 0.35, 0)
	bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	bar.BorderSizePixel = 2
	bar.BorderColor3 = Color3.fromRGB(255, 255, 255)
	
	-- Create the count TextLabel
	local count = bar:FindFirstChild("Count") or Instance.new("TextLabel")
	count.Name = "Count"
	count.Parent = bar
	count.Size = UDim2.new(1, 0, 1, 0)
	count.Position = UDim2.new(0, 0, 0, 0)
	count.BackgroundTransparency = 1
	count.Text = "Loading..."
	count.TextColor3 = Color3.fromRGB(255, 255, 255)
	count.TextScaled = true
	count.Font = Enum.Font.SourceSansBold
	
	-- Add a title label
	local title = main:FindFirstChild("Title") or Instance.new("TextLabel")
	title.Name = "Title"
	title.Parent = main
	title.Size = UDim2.new(0.8, 0, 0.2, 0)
	title.Position = UDim2.new(0.1, 0, 0.1, 0)
	title.BackgroundTransparency = 1
	title.Text = "👍 LIKES"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextScaled = true
	title.Font = Enum.Font.SourceSansBold
	
	print("UI structure created successfully!")
	print("TextLabel path: workspace.Misc.Leaderboards.LikesBoard.ShowPart.ShowGui.Main.Bar.Count")
	
	return count
end

-- Create the UI structure
local countLabel = createUIStructure()

-- Verify the path works
local function verifyPath()
	local pathParts = {"Misc", "Leaderboards", "LikesBoard", "ShowPart", "ShowGui", "Main", "Bar", "Count"}
	local current = workspace
	
	for i, part in ipairs(pathParts) do
		current = current:FindFirstChild(part)
		if not current then
			warn("Path verification failed at: " .. part)
			return false
		end
		print("✓ Found: " .. table.concat(pathParts, ".", 1, i))
	end
	
	print("✓ Path verification successful!")
	return true
end

-- Verify the setup
wait(1) -- Give time for everything to be created
verifyPath()