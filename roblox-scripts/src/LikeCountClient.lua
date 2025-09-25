--[[
	LikeCountClient.lua
	
	A LocalScript that receives like count updates from the server
	and displays them in the TextLabel at the specified path.
	
	This script works in conjunction with LikeCountServer.lua
	
	Features:
	- Receives like count updates via RemoteEvents
	- Updates TextLabel at specified path
	- Handles connection retries if UI element not found initially
	- Provides visual feedback for errors
]]

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Constants
local TEXTLABEL_PATH = "Misc.Leaderboards.LikesBoard.ShowPart.ShowGui.Main.Bar.Count"
local RETRY_INTERVAL = 5 -- seconds to retry finding the TextLabel

-- Variables
local player = Players.LocalPlayer
local countLabel = nil
local remoteEvent = nil
local lastRetryTime = 0

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
		return nil
	end
end

-- Function to update the TextLabel with new like count
local function updateDisplay(formattedCount, rawCount)
	if not countLabel then
		countLabel = findCountLabel()
	end
	
	if countLabel then
		countLabel.Text = formattedCount
		
		-- Add visual feedback for successful update
		if formattedCount ~= "Error" then
			-- Optional: Add a subtle animation to show the count updated
			local originalSize = countLabel.Size
			countLabel:TweenSize(
				UDim2.new(originalSize.X.Scale * 1.05, originalSize.X.Offset, 
					originalSize.Y.Scale * 1.05, originalSize.Y.Offset),
				"Out", "Quad", 0.1, true,
				function()
					countLabel:TweenSize(originalSize, "Out", "Quad", 0.1)
				end
			)
		end
		
		print("Like count display updated: " .. formattedCount)
	else
		warn("TextLabel not found at path: " .. TEXTLABEL_PATH)
	end
end

-- Function to handle like count updates from server
local function onLikeCountUpdate(formattedCount, rawCount)
	updateDisplay(formattedCount, rawCount)
end

-- Function to periodically retry finding the TextLabel
local function onHeartbeat()
	if not countLabel then
		local currentTime = tick()
		if currentTime - lastRetryTime >= RETRY_INTERVAL then
			lastRetryTime = currentTime
			countLabel = findCountLabel()
			if countLabel then
				print("Found TextLabel at: " .. TEXTLABEL_PATH)
				-- Request current like count from server
				if remoteEvent then
					remoteEvent:FireServer()
				end
			end
		end
	end
end

-- Function to wait for RemoteEvent and connect to it
local function connectToRemoteEvent()
	local success, result = pcall(function()
		remoteEvent = ReplicatedStorage:WaitForChild("LikeCountUpdate", 30)
		return remoteEvent
	end)
	
	if success and result then
		remoteEvent.OnClientEvent:Connect(onLikeCountUpdate)
		print("Connected to LikeCountUpdate RemoteEvent")
		
		-- Request initial like count
		remoteEvent:FireServer()
		return true
	else
		warn("Failed to find LikeCountUpdate RemoteEvent")
		return false
	end
end

-- Initialize the client script
local function initialize()
	print("LikeCountClient script starting...")
	
	-- Try to find the TextLabel immediately
	countLabel = findCountLabel()
	
	if countLabel then
		print("Found TextLabel at: " .. TEXTLABEL_PATH)
	else
		print("TextLabel not found initially, will keep retrying...")
	end
	
	-- Connect to the RemoteEvent
	local connected = connectToRemoteEvent()
	
	if connected then
		-- Connect to heartbeat for retrying TextLabel discovery
		RunService.Heartbeat:Connect(onHeartbeat)
		print("LikeCountClient script initialized successfully")
	else
		warn("Failed to initialize LikeCountClient script - RemoteEvent not found")
	end
end

-- Wait for the player to fully load before starting
if player then
	initialize()
else
	Players.PlayerAdded:Connect(function(newPlayer)
		if newPlayer == player then
			initialize()
		end
	end)
end