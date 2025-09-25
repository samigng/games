# Implementation Guide

This guide provides step-by-step instructions for implementing the like count display system in your Roblox game.

## Quick Start

### Step 1: Set Up the UI Structure
1. Place `SetupUI.lua` in `ServerScriptService`
2. Run your game in Roblox Studio
3. The script will create the required UI structure automatically
4. You should see a leaderboard appear in your workspace

### Step 2: Choose Your Implementation

#### Option A: Simple LocalScript (Recommended for beginners)
1. Place `LikeCountDisplay.lua` in `StarterPlayer → StarterPlayerScripts`
2. Run the game - the like count should start updating automatically

#### Option B: Client-Server Architecture (Recommended for production)
1. Place `LikeCountServer.lua` in `ServerScriptService`
2. Place `LikeCountClient.lua` in `StarterPlayer → StarterPlayerScripts`
3. Enable HTTPService in Game Settings → Security → "Allow HTTP Requests"
4. Run the game - the system should start working automatically

## Detailed Setup Instructions

### 1. Game Settings Configuration

#### Enable HTTPService (Required for Option B)
1. In Roblox Studio, go to Home → Game Settings
2. Navigate to Security tab
3. Check "Allow HTTP Requests"
4. Save settings

### 2. Script Placement

```
ServerScriptService/
├── SetupUI.lua (run once to create UI)
└── LikeCountServer.lua (for client-server option)

StarterPlayer/
└── StarterPlayerScripts/
    ├── LikeCountDisplay.lua (for standalone option)
    └── LikeCountClient.lua (for client-server option)
```

### 3. Testing the Implementation

#### In Roblox Studio:
1. Press F5 to run a local server
2. Check the output window for status messages
3. Look for the leaderboard in workspace
4. Verify the like count updates

#### Expected Console Output:
```
SetupUI: UI structure created successfully!
LikeCountServer: script starting...
LikeCountClient: script starting...
LikeCountClient: Found TextLabel at: workspace.Misc.Leaderboards.LikesBoard.ShowPart.ShowGui.Main.Bar.Count
LikeCountServer: Updated like count to: 1.2K (raw: 1234)
```

### 4. Customization

#### Changing Update Frequency
Edit the `UPDATE_INTERVAL` in your chosen scripts:
```lua
local UPDATE_INTERVAL = 30 -- Update every 30 seconds instead of 45
```

#### Custom TextLabel Location
If you want to use a different TextLabel location, update the path:
```lua
local TEXTLABEL_PATH = "Your.Custom.Path.Here"
```

#### Styling the UI
Modify `SetupUI.lua` to customize colors, sizes, and positions:
```lua
-- Example: Change text color to green
count.TextColor3 = Color3.fromRGB(0, 255, 0)

-- Example: Change background color
main.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
```

## Troubleshooting

### Common Issues and Solutions

#### 1. "TextLabel not found" Error
**Cause**: The UI structure doesn't exist or path is incorrect.

**Solution**:
- Run `SetupUI.lua` first to create the UI structure
- Verify the path in workspace Explorer
- Check spelling and capitalization

#### 2. "Failed to fetch like count" Error
**Cause**: HTTPService disabled or network issues.

**Solution**:
- Enable HTTPService in Game Settings
- Check internet connection
- Try the LocalScript version instead

#### 3. Like Count Shows "Error"
**Cause**: API call failed or returned invalid data.

**Solution**:
- Check the Developer Console (F9) for detailed errors
- Ensure your game is published (has a valid Game ID)
- Wait a moment and try again

#### 4. Scripts Not Running
**Cause**: Scripts placed in wrong location or disabled.

**Solution**:
- Verify script placement according to the guide
- Check if scripts are enabled (not grayed out)
- Ensure LocalScripts are in proper containers

### Debug Mode

To enable detailed logging, add this to the top of any script:
```lua
local DEBUG = true

-- Then use throughout the script:
if DEBUG then
    print("Debug info here")
end
```

## Performance Considerations

### Update Frequency
- Default: 45 seconds (recommended)
- Minimum: 30 seconds (to avoid rate limiting)
- Maximum: 300 seconds (5 minutes)

### Memory Usage
- LocalScript version: ~1KB memory per player
- Client-Server version: ~2KB total memory
- UI elements: ~5KB memory

### Network Usage
- Each update: ~500 bytes
- Per hour: ~40KB (at 45-second intervals)
- Negligible impact on game performance

## Advanced Features

### Adding Visual Effects
Enhance the display with particle effects or animations:
```lua
-- Add to LikeCountClient.lua after updating display
local function addSparkleEffect()
    local attachment = Instance.new("Attachment")
    attachment.Parent = countLabel
    
    local particles = Instance.new("ParticleEmitter")
    particles.Parent = attachment
    particles.Enabled = true
    -- Configure particle properties...
end
```

### Multiple Leaderboards
Create separate leaderboards for likes, favorites, visits:
```lua
-- Modify TEXTLABEL_PATH for different stats
local LIKES_PATH = "Misc.Leaderboards.LikesBoard.ShowPart.ShowGui.Main.Bar.Count"
local FAVS_PATH = "Misc.Leaderboards.FavsBoard.ShowPart.ShowGui.Main.Bar.Count"
local VISITS_PATH = "Misc.Leaderboards.VisitsBoard.ShowPart.ShowGui.Main.Bar.Count"
```

### Data Persistence
Store historical data using DataStoreService:
```lua
local DataStoreService = game:GetService("DataStoreService")
local likeHistoryStore = DataStoreService:GetDataStore("LikeHistory")

-- Save like count with timestamp
local function saveLikeCount(count)
    local timestamp = os.time()
    likeHistoryStore:SetAsync(tostring(timestamp), count)
end
```

## Support

If you encounter issues:
1. Check the troubleshooting section above
2. Review console output for error messages
3. Verify all setup steps were completed
4. Test with the simple LocalScript version first

## Best Practices Summary

1. ✅ Always test in Studio before publishing
2. ✅ Enable HTTPService for production games
3. ✅ Use reasonable update intervals (30-60 seconds)
4. ✅ Handle errors gracefully
5. ✅ Provide user feedback (loading states, animations)
6. ✅ Follow Roblox community guidelines
7. ✅ Keep UI elements organized and named clearly