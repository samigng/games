# Installation Guide for Roblox Like Count Display Script

## Prerequisites

1. **Roblox Studio** with a game project
2. **HTTP Requests Enabled** in Game Settings
3. **Required UI Hierarchy** created in workspace

## Step-by-Step Installation

### 1. Enable HTTP Requests

1. Open your game in Roblox Studio
2. Go to **Game Settings** (Home tab > Game Settings)
3. Navigate to **Security** tab
4. Enable **Allow HTTP Requests**
5. Save and close Game Settings

### 2. Create UI Hierarchy

You need to create the following structure in your workspace:

```
workspace
└── Misc (Folder)
    └── Leaderboards (Folder)
        └── LikesBoard (Part)
            └── ShowPart (Part)
                └── ShowGui (SurfaceGui)
                    └── Main (Frame)
                        └── Bar (Frame)
                            └── Count (TextLabel)
```

**Option A: Use the provided setup script**
1. Copy the contents of `UI_Setup_Example.lua`
2. Paste and run it in Roblox Studio's Command Bar
3. The UI hierarchy will be created automatically

**Option B: Manual creation**
1. Create each element manually following the hierarchy above
2. Ensure the `Count` element is a `TextLabel`
3. Position and style the UI elements as desired

### 3. Install the Scripts

1. **Copy Configuration Module**:
   - Create a ModuleScript in ServerScriptService
   - Name it `LikeCountConfig`
   - Copy the contents of `ServerScriptService/LikeCountConfig.lua`

2. **Copy Main Script**:
   - Create a ServerScript in ServerScriptService
   - Name it `LikeCountScript`
   - Copy the contents of `ServerScriptService/LikeCountScript.lua`

3. **Verify Script Structure**:
   ```
   ServerScriptService
   ├── LikeCountConfig (ModuleScript)
   └── LikeCountScript (ServerScript)
   ```

### 4. Test the Installation

1. **Start the Game**: Run your game in Studio or publish and test
2. **Check the UI**: Navigate to the Count TextLabel location
3. **Verify Loading**: Should show "Loading..." initially
4. **Check Console**: Look for log messages starting with "LikeCountScript"
5. **Wait for Update**: Like count should appear within 2-5 seconds

## Troubleshooting

### "Could not find Count TextLabel" Error
- Verify the UI hierarchy exists exactly as specified
- Check that `Count` is a TextLabel (not Label or other type)
- Ensure all parent objects exist in the correct locations

### "HTTP request failed" Error
- Verify HTTP requests are enabled in Game Settings
- Check internet connectivity
- Ensure the game is published (not just in Studio edit mode)

### No Updates Appearing
- Check the Output console for error messages
- Verify the game ID is correct (script auto-detects from PlaceId)
- Test with a published game (some API features require published games)

### Rate Limiting Issues
- Default update interval is 45 seconds (safe for API limits)
- If you modify the interval, keep it above 30 seconds
- Multiple simultaneous requests may trigger rate limiting

## Customization

### Modify Update Frequency
Edit `UPDATE_INTERVAL` in `LikeCountConfig.lua`:
```lua
Config.UPDATE_INTERVAL = 60 -- Update every 60 seconds
```

### Change UI Path
Update `UI_PATH` in `LikeCountConfig.lua`:
```lua
Config.UI_PATH = "your.custom.ui.path.Count"
```

### Customize Number Formatting
Modify `NUMBER_SUFFIXES` in `LikeCountConfig.lua`:
```lua
Config.NUMBER_SUFFIXES = {
    {threshold = 1000000, suffix = "M"},
    {threshold = 1000, suffix = "K"}
}
```

### Enable/Disable Logging
Toggle logging in `LikeCountConfig.lua`:
```lua
Config.ENABLE_LOGGING = false  -- Disable console logging
```

## Support

If you encounter issues:

1. Check the Output console for error messages
2. Verify all prerequisites are met
3. Test with the provided UI setup example
4. Ensure HTTP requests are enabled
5. Try with a simple published game first

For additional help, refer to the main README.md file.