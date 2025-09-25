-- LikeCountConfig.lua
-- Configuration module for the Like Count Display Script

local Config = {}

-- Update settings
Config.UPDATE_INTERVAL = 45 -- seconds (recommended: 30-60 to avoid rate limiting)
Config.INITIAL_DELAY = 2    -- seconds to wait before first fetch

-- API settings
Config.API_ENDPOINT = "https://games.roblox.com/v1/games/%d/votes"
Config.TIMEOUT = 10         -- HTTP request timeout in seconds

-- UI settings
Config.UI_PATH = "workspace.Misc.Leaderboards.LikesBoard.ShowPart.ShowGui.Main.Bar.Count"
Config.LOADING_TEXT = "Loading..."
Config.ERROR_TEXT = "Error"

-- Number formatting settings
Config.USE_FORMATTING = true  -- Enable K/M formatting for large numbers
Config.FORMAT_THRESHOLD = 1000 -- Minimum number to apply formatting

-- Error handling settings
Config.SHOW_LAST_KNOWN_ON_ERROR = true  -- Show last known count with (?) on error
Config.MAX_RETRIES = 3  -- Maximum number of retry attempts on failure
Config.RETRY_DELAY = 5  -- Seconds to wait between retries

-- Logging settings
Config.ENABLE_LOGGING = true  -- Enable console logging
Config.LOG_LEVEL = "INFO"     -- "DEBUG", "INFO", "WARN", "ERROR"

-- Display customization
Config.NUMBER_SUFFIXES = {
    {threshold = 1000000000, suffix = "B"},  -- Billions
    {threshold = 1000000, suffix = "M"},     -- Millions  
    {threshold = 1000, suffix = "K"}         -- Thousands
}

return Config