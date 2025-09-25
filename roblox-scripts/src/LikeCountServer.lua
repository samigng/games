--[[
	LikeCountServer.lua
	
	A ServerScript that displays the live like count for a Roblox game.
	This script fetches the current like count using HTTPService and
	updates the TextLabel via RemoteEvents to client scripts.
	
	Features:
	- Fetches like count using HTTPService and Roblox APIs
	- Updates every 45 seconds
	- Formats numbers with K/M abbreviations
	- Handles errors gracefully
	- Uses RemoteEvents to communicate with client
]]

-- Services
local HTTPService = game:GetService("HTTPService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Constants
local UPDATE_INTERVAL = 45 -- seconds
local ROBLOX_API_BASE = "https://games.roblox.com/v1/games/"

-- Variables
local lastUpdateTime = 0
local currentGameId = game.GameId
local currentLikeCount = 0

-- Create RemoteEvent for communicating with client
local remoteEvent = Instance.new("RemoteEvent")
remoteEvent.Name = "LikeCountUpdate"
remoteEvent.Parent = ReplicatedStorage

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

-- Function to get game like count using HTTPService
local function getLikeCount()
	local success, result = pcall(function()
		local url = ROBLOX_API_BASE .. tostring(currentGameId)
		local response = HTTPService:GetAsync(url)
		local data = HTTPService:JSONDecode(response)
		
		-- The API returns voting information
		if data and data.data and #data.data > 0 then
			local gameData = data.data[1]
			return gameData.upVotes or 0
		end
		
		return 0
	end)
	
	if success then
		return result
	else
		warn("Failed to fetch like count: " .. tostring(result))
		return nil
	end
end

-- Function to update the like count
local function updateLikeCount()
	local likeCount = getLikeCount()
	
	if likeCount then
		currentLikeCount = likeCount
		local formattedCount = formatNumber(likeCount)
		
		-- Send update to all clients
		remoteEvent:FireAllClients(formattedCount, likeCount)
		print("Updated like count to: " .. formattedCount .. " (raw: " .. likeCount .. ")")
		return true
	else
		-- Send error state to clients
		remoteEvent:FireAllClients("Error", 0)
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

-- Handle new player requests for current like count
local function onPlayerRequest(player)
	if currentLikeCount > 0 then
		local formattedCount = formatNumber(currentLikeCount)
		remoteEvent:FireClient(player, formattedCount, currentLikeCount)
	end
end

-- Initialize the script
local function initialize()
	print("LikeCountServer script starting...")
	print("Game ID: " .. tostring(currentGameId))
	
	-- Enable HTTPService
	pcall(function()
		HTTPService.HttpEnabled = true
	end)
	
	-- Perform initial update
	updateLikeCount()
	
	-- Connect to heartbeat for periodic updates
	RunService.Heartbeat:Connect(onHeartbeat)
	
	-- Handle player requests
	remoteEvent.OnServerEvent:Connect(onPlayerRequest)
	
	print("LikeCountServer script initialized successfully")
end

-- Start the script
initialize()