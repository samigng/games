# Roblox Like Count Display Scripts

This directory contains Roblox scripts for displaying live like counts in a Roblox game. The scripts are designed to update a TextLabel located at `workspace.Misc.Leaderboards.LikesBoard.ShowPart.ShowGui.Main.Bar.Count` with the current like count of the game.

## Scripts Overview

### 1. LikeCountDisplay.lua (LocalScript)
A standalone LocalScript that fetches like count using MarketplaceService and updates the TextLabel directly.

**Features:**
- Uses MarketplaceService to get game information
- Updates every 45 seconds
- Formats numbers with K/M abbreviations (1.2K, 1M, etc.)
- Handles errors gracefully
- Self-contained solution

**Usage:** Place this LocalScript in StarterPlayerScripts or any location where LocalScripts run.

### 2. LikeCountServer.lua (ServerScript)
A ServerScript that fetches like count using HTTPService and distributes updates to clients via RemoteEvents.

**Features:**
- Uses HTTPService to call Roblox APIs
- Updates every 45 seconds
- Sends updates to all clients via RemoteEvents
- Handles new player connections
- More reliable for production use

**Usage:** Place this ServerScript in ServerScriptService.

### 3. LikeCountClient.lua (LocalScript)
A LocalScript that works with LikeCountServer.lua to receive updates and display them in the UI.

**Features:**
- Receives updates from server via RemoteEvents
- Retries finding the TextLabel if not initially available
- Provides visual feedback with subtle animations
- Handles connection failures gracefully

**Usage:** Place this LocalScript in StarterPlayerScripts to work with LikeCountServer.lua.

## Installation Options

### Option 1: Standalone (Recommended for testing)
Use only `LikeCountDisplay.lua`:
1. Place `LikeCountDisplay.lua` in `game.StarterPlayer.StarterPlayerScripts`
2. Ensure the TextLabel path exists in your game
3. The script will automatically start when players join

### Option 2: Client-Server Architecture (Recommended for production)
Use both `LikeCountServer.lua` and `LikeCountClient.lua`:
1. Place `LikeCountServer.lua` in `game.ServerScriptService`
2. Place `LikeCountClient.lua` in `game.StarterPlayer.StarterPlayerScripts`
3. Ensure HTTPService is enabled in your game settings
4. The scripts will automatically communicate via RemoteEvents

## Requirements

### Game Setup
1. **TextLabel Path**: Ensure the following path exists in your game:
   ```
   workspace.Misc.Leaderboards.LikesBoard.ShowPart.ShowGui.Main.Bar.Count
   ```

2. **HTTPService** (for server-client option): Enable HTTPService in your game:
   - Go to Game Settings → Security
   - Enable "Allow HTTP Requests"

### Game Structure Example
```
workspace/
├── Misc/
│   └── Leaderboards/
│       └── LikesBoard/
│           └── ShowPart/
│               └── ShowGui/
│                   └── Main/
│                       └── Bar/
│                           └── Count (TextLabel)
```

## Configuration

### Update Interval
To change how often the like count updates, modify the `UPDATE_INTERVAL` constant in the scripts:
```lua
local UPDATE_INTERVAL = 45 -- seconds (change this value)
```

### Number Formatting
The scripts automatically format large numbers:
- Numbers ≥ 1,000,000: "1.2M"
- Numbers ≥ 1,000: "1.2K"  
- Numbers < 1,000: "123"

### TextLabel Path
To change the TextLabel location, modify the `TEXTLABEL_PATH` constant:
```lua
local TEXTLABEL_PATH = "Your.Custom.Path.Here"
```

## Error Handling

The scripts include comprehensive error handling:
- **API failures**: Shows "Error" in the TextLabel
- **Missing TextLabel**: Continues retrying to find it
- **Network issues**: Gracefully handles connection problems
- **Invalid responses**: Validates API data before using it

## Best Practices

1. **Testing**: Test scripts in Roblox Studio before publishing
2. **Permissions**: Ensure HTTPService is enabled for production games
3. **Rate Limiting**: The 45-second update interval helps avoid API rate limits
4. **UI Feedback**: The client script includes subtle animations for user feedback
5. **Logging**: Scripts provide console output for debugging

## Troubleshooting

### Common Issues

1. **"TextLabel not found" warnings**:
   - Verify the path `workspace.Misc.Leaderboards.LikesBoard.ShowPart.ShowGui.Main.Bar.Count` exists
   - Check that all parent objects exist and are properly named

2. **"Failed to fetch like count" errors**:
   - Ensure HTTPService is enabled (for server-client option)
   - Check your internet connection
   - Verify the game ID is correct

3. **Like count shows "Error"**:
   - Check the developer console for detailed error messages
   - Verify API permissions and game settings

4. **RemoteEvent not found** (client-server option):
   - Ensure both server and client scripts are properly placed
   - Check that ServerScript runs before LocalScript

### Debug Mode
To enable more detailed logging, add this line at the top of any script:
```lua
local DEBUG_MODE = true
```

## API Information

The scripts use the following Roblox APIs:
- **MarketplaceService**: For getting game information (LocalScript version)
- **HTTPService**: For direct API calls (ServerScript version)
- **Roblox Games API**: `https://games.roblox.com/v1/games/{gameId}`

## License

These scripts are provided as-is for educational and development purposes. Use in accordance with Roblox Terms of Service and Community Guidelines.