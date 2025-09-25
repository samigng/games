# Roblox Like Count Display Script

This repository contains a Roblox ServerScript that displays the live like count for the game in a specific UI hierarchy.

## Overview

The script fetches the current like count from Roblox's public API and displays it in a TextLabel located at:
`workspace.Misc.Leaderboards.LikesBoard.ShowPart.ShowGui.Main.Bar.Count`

## Features

- **Real-time Updates**: Automatically refreshes the like count every 45 seconds
- **Number Formatting**: Displays large numbers with K/M suffixes (e.g., "1.2K", "2.5M")
- **Error Handling**: Gracefully handles API failures and network issues
- **Rate Limit Compliance**: Updates at safe intervals to avoid API rate limiting
- **Fallback Display**: Shows last known count or error message when API fails

## Installation

1. Place the `LikeCountScript.lua` file in your Roblox Studio's ServerScriptService
2. Ensure your game has the required UI hierarchy structure
3. Enable HTTP requests in your game settings (Game Settings > Security > Allow HTTP Requests)

## UI Structure Required

The script expects the following UI hierarchy to exist in your workspace:

```
workspace
└── Misc
    └── Leaderboards
        └── LikesBoard
            └── ShowPart
                └── ShowGui (ScreenGui or SurfaceGui)
                    └── Main (Frame)
                        └── Bar (Frame)
                            └── Count (TextLabel)
```

## Technical Details

- **API Endpoint**: `https://games.roblox.com/v1/games/{gameId}/votes`
- **Update Frequency**: Every 45 seconds (configurable)
- **Services Used**: HttpService for API calls
- **Error Recovery**: Maintains last known count during temporary failures

## Configuration

You can modify the following constants in the script:

- `UPDATE_INTERVAL`: Time between updates (default: 45 seconds)
- `API_ENDPOINT`: Roblox games API endpoint
- `UI_PATH`: Path to the Count TextLabel

## Behavior

1. **Startup**: Displays "Loading..." while fetching initial data
2. **Success**: Shows formatted like count (e.g., "1.2K likes")
3. **Network Error**: Shows "Error" or last known count with "(?)" indicator
4. **Auto-refresh**: Updates count automatically at configured intervals

## Error Handling

The script includes comprehensive error handling for:
- Network connectivity issues
- API response parsing errors
- Missing UI elements
- Rate limiting scenarios
- Game configuration problems

## Logging

The script provides console output for debugging:
- Successful API fetches
- Error conditions
- UI element access issues

## Requirements

- Roblox Studio
- HTTP requests enabled in game settings
- Required UI hierarchy in workspace
- ServerScriptService access

## License

This script is provided as-is for educational and development purposes.