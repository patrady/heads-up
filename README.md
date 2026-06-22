# Brady Heads

A motion-controlled word-guessing iOS game for the whole family. Players hold their phone to their forehead and tilt it to guess words — down for correct, up to pass.

## Features

- **10 word decks** — Animals, Parks & Rec, Family Members, Movies, Sports, Pop Culture, Food, Geography, Music, and Favorite Memories
- **Motion controls** — game starts automatically when the phone is held flat; tilt to guess or skip
- **60-second rounds** with a live countdown and color-coded timer
- **Leaderboard** — save scores by name and track top results locally
- **Simulator support** — on-screen buttons replace motion controls when running in the simulator

## Requirements

- Xcode 16.0+
- iOS 17.0+
- Swift 5.9

No third-party dependencies — uses only Apple frameworks (SwiftUI, CoreMotion, Combine).

## Running the App

```bash
# Generate the Xcode project (requires xcodegen)
brew install xcodegen
xcodegen generate

# Open in Xcode and run
open BradyHeads.xcodeproj
```

Press `Cmd+R` in Xcode to build and run on a simulator or device.

> Motion sensors require a physical device. The simulator shows Pass/Correct buttons instead.

## How to Play

1. Pick a deck from the home screen
2. Hand the phone to a player — they hold it to their forehead, screen facing up
3. The round starts automatically once the phone is held flat for one second
4. Teammates shout clues; the player tilts:
   - **Down** → Correct
   - **Up** → Pass
5. After 60 seconds, scores are shown and can be saved to the leaderboard

## License

MIT
