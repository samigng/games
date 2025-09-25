-- LikeCountScript.lua
-- ServerScript to display live like count in the UI hierarchy
-- Location: workspace.Misc.Leaderboards.LikesBoard.ShowPart.ShowGui.Main.Bar.Count

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Load configuration
local Config = require(script.Parent.LikeCountConfig)

-- State variables
local lastKnownCount = 0
local isUpdating = false
local retryCount = 0

-- Logging function
local function log(level, message)
    if Config.ENABLE_LOGGING then
        local timestamp = os.date("%H:%M:%S")
        print(string.format("[%s] LikeCountScript [%s]: %s", timestamp, level, message))
    end
end

-- Function to format numbers with K/M/B suffixes
local function formatNumber(num)
    if not Config.USE_FORMATTING or num < Config.FORMAT_THRESHOLD then
        return tostring(num)
    end
    
    for _, suffix_data in ipairs(Config.NUMBER_SUFFIXES) do
        if num >= suffix_data.threshold then
            local formatted = num / suffix_data.threshold
            return string.format("%.1f%s", formatted, suffix_data.suffix)
        end
    end
    
    return tostring(num)
end

-- Function to safely get the UI TextLabel
local function getCountLabel()
    local success, result = pcall(function()
        return workspace.Misc.Leaderboards.LikesBoard.ShowPart.ShowGui.Main.Bar.Count
    end)
    
    if success and result and result:IsA("TextLabel") then
        return result
    else
        log("WARN", "Could not find Count TextLabel at path: " .. Config.UI_PATH)
        return nil
    end
end

-- Function to update the UI with current count
local function updateCountDisplay(count, isError)
    local countLabel = getCountLabel()
    if not countLabel then
        return
    end
    
    if isError then
        if Config.SHOW_LAST_KNOWN_ON_ERROR and lastKnownCount > 0 then
            countLabel.Text = formatNumber(lastKnownCount) .. " (?)"
        else
            countLabel.Text = Config.ERROR_TEXT
        end
    else
        countLabel.Text = formatNumber(count)
        lastKnownCount = count
        retryCount = 0  -- Reset retry count on success
    end
end

-- Function to fetch like count from Roblox API
local function fetchLikeCount()
    if isUpdating then
        log("DEBUG", "Update already in progress, skipping")
        return
    end
    
    isUpdating = true
    
    local gameId = game.PlaceId
    local url = string.format(Config.API_ENDPOINT, gameId)
    
    log("DEBUG", "Fetching like count for game ID: " .. gameId)
    
    local success, response = pcall(function()
        return HttpService:GetAsync(url)
    end)
    
    if success then
        local parseSuccess, data = pcall(function()
            return HttpService:JSONDecode(response)
        end)
        
        if parseSuccess and data and data.data and data.data[1] then
            local gameData = data.data[1]
            local upVotes = gameData.upVotes or 0
            
            log("INFO", "Successfully fetched like count: " .. upVotes)
            updateCountDisplay(upVotes, false)
        else
            log("ERROR", "Failed to parse API response")
            updateCountDisplay(0, true)
            
            -- Schedule retry if under limit
            if retryCount < Config.MAX_RETRIES then
                retryCount = retryCount + 1
                log("INFO", "Scheduling retry " .. retryCount .. "/" .. Config.MAX_RETRIES)
                spawn(function()
                    wait(Config.RETRY_DELAY)
                    isUpdating = false
                    fetchLikeCount()
                end)
                return
            end
        end
    else
        log("ERROR", "HTTP request failed: " .. tostring(response))
        updateCountDisplay(0, true)
        
        -- Schedule retry if under limit
        if retryCount < Config.MAX_RETRIES then
            retryCount = retryCount + 1
            log("INFO", "Scheduling retry " .. retryCount .. "/" .. Config.MAX_RETRIES)
            spawn(function()
                wait(Config.RETRY_DELAY)
                isUpdating = false
                fetchLikeCount()
            end)
            return
        end
    end
    
    isUpdating = false
end

-- Function to initialize the script
local function initialize()
    log("INFO", "Initializing like count display system")
    log("INFO", "Update interval: " .. Config.UPDATE_INTERVAL .. " seconds")
    log("INFO", "Target UI path: " .. Config.UI_PATH)
    
    -- Set initial loading state
    updateCountDisplay(0, false)
    local countLabel = getCountLabel()
    if countLabel then
        countLabel.Text = Config.LOADING_TEXT
        log("INFO", "Set initial loading text")
    end
    
    -- Wait for the game to fully load
    wait(Config.INITIAL_DELAY)
    
    -- Perform initial fetch
    log("INFO", "Starting initial like count fetch")
    fetchLikeCount()
    
    -- Set up periodic updates
    spawn(function()
        while true do
            wait(Config.UPDATE_INTERVAL)
            log("DEBUG", "Starting periodic update")
            fetchLikeCount()
        end
    end)
    
    log("INFO", "Like count display system initialized successfully")
end

-- Start the script when the server starts
initialize()