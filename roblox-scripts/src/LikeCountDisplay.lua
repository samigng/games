--[[
	LikeCountDisplay.lua
	
	A LocalScript that displays the live like count for a Roblox game.
	This script fetches the current like count and updates the TextLabel
	at workspace.Misc.Leaderboards.LikesBoard.ShowPart.ShowGui.Main.Bar.Count
	
	Features:
	- Fetches like count using MarketplaceService
	- Updates every 45 seconds
	- Formats numbers with K/M abbreviations
	- Handles errors gracefully
	- Follows Roblox scripting best practices
]]

-- Services
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Constants
local UPDATE_INTERVAL = 45 -- seconds
local TEXTLABEL_PATH = "Misc.Leaderboards.LikesBoard.ShowPart.ShowGui.Main.Bar.Count"

-- Variables
local player = Players.LocalPlayer
local lastUpdateTime = 0
local currentGameId = game.GameId

-- UI Reference
local countLabel = nil

-- Function to format numbers with K/M abbreviations
local function formatNumber(number)
	if number >= 1000000 then
		return string.format("%.1fM", number / 1000000)
	elseif number >= 1000 then
		return string.format("%.1fK", number / 1000)
	else
		return tostring(number)
	end
end

-- Function to find the TextLabel at the specified path
local function findCountLabel()
	local success, result = pcall(function()
		local pathParts = string.split(TEXTLABEL_PATH, ".")
		local current = workspace
		
		for _, part in ipairs(pathParts) do
			current = current:FindFirstChild(part)
			if not current then
				return nil
			end
		end
		
		return current
	end)
	
	if success and result and result:IsA("TextLabel") then
		return result
	else
		warn("Could not find TextLabel at path: " .. TEXTLABEL_PATH)
		return nil
	end
end

-- Function to get game like count
local function getLikeCount()
	local success, result = pcall(function()
		-- Get game info which includes like count
		local gameInfo = MarketplaceService:GetProductInfo(currentGameId, Enum.InfoType.Game)
		return gameInfo.VotingEnabled and gameInfo.UpVotes or 0
	end)
	
	if success then
		return result
	else
		warn("Failed to fetch like count: " .. tostring(result))
		return nil
	end
end

-- Function to update the like count display
local function updateLikeCount()
	if not countLabel then
		countLabel = findCountLabel()
		if not countLabel then
			return false
		end
	end
	
	local likeCount = getLikeCount()
	if likeCount then
		local formattedCount = formatNumber(likeCount)
		countLabel.Text = formattedCount
		print("Updated like count to: " .. formattedCount)
		return true
	else
		-- Show error state
		countLabel.Text = "Error"
		return false
	end
end

-- Function to handle periodic updates
local function onHeartbeat()
	local currentTime = tick()
	if currentTime - lastUpdateTime >= UPDATE_INTERVAL then
		lastUpdateTime = currentTime
		updateLikeCount()
	end
end

-- Initialize the script
local function initialize()
	print("LikeCountDisplay script starting...")
	
	-- Try to find the TextLabel immediately
	countLabel = findCountLabel()
	
	if countLabel then
		print("Found TextLabel at: " .. TEXTLABEL_PATH)
		-- Perform initial update
		updateLikeCount()
	else
		print("TextLabel not found, will keep trying...")
	end
	
	-- Connect to heartbeat for periodic updates
	RunService.Heartbeat:Connect(onHeartbeat)
	
	print("LikeCountDisplay script initialized successfully")
end

-- Start the script
initialize()