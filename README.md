# FilmStudioPilot

An Apple TV-like experience for discovering and watching AI-generated film productions. Productions are automatically generated based on your viewing preferences and media consumption patterns.

## Features

- **Apple TV-like Interface**: Browse productions with hero carousels and content rows
- **Automatic Production Generation**: Stories are generated automatically based on your viewing behavior
- **Taste Profile**: Personalized content based on your movie preferences
- **State-Driven**: Observable media state triggers automatic story generation
- **3D Storyboards**: Visualize scenes in 3D using RealityKit
- **AR Preview**: Preview storyboard scenes in augmented reality
- **DirectorKit**: AI-assisted film direction - converts screenplays to directed shots with camera setups and blocking
- **OSF Support**: Open Screenplay Format (OSF) XML parsing and generation
- **Timeline Composition**: AVFoundation-based video timeline creation
- **Voice Over & Dialogue Rigging**: Character voice profiles, dialogue timing, emotional delivery, and acting technique integration
- **Character Backstory**: Comprehensive character development with Stanislavski objectives, relationships, and emotional range
- **Native Apple Stack**: Built entirely with SwiftUI, AVKit, AVFoundation, RealityKit, and Core Media

## Setup

### 1. API Keys

You'll need API keys for movie metadata:

1. **TMDb API Key** (Required):
   - Sign up at https://www.themoviedb.org/signup
   - Get your API key from https://www.themoviedb.org/settings/api
   - Add to `Info.plist` as `TMDbAPIKey`

2. **OMDb API Key** (Optional):
   - Sign up at https://www.omdbapi.com/apikey.aspx
   - Add to `Info.plist` as `OMDbAPIKey`

### 2. Info.plist Configuration

Add your API keys to `Info.plist`:

```xml
<key>TMDbAPIKey</key>
<string>YOUR_TMDB_API_KEY</string>
<key>OMDbAPIKey</key>
<string>YOUR_OMDB_API_KEY</string>
```

### 3. Update OnboardingView

In `Views/Onboarding/OnboardingView.swift`, replace the placeholder API key:

```swift
let tmdbKey = Bundle.main.object(forInfoDictionaryKey: "TMDbAPIKey") as? String ?? ""
```

## Architecture

### Models
- `Production`: Completed productions for viewing
- `StoryIdea`: Generated story ideas with acting method structure
- `TasteProfile`: User preferences and taste analysis
- `MovieMetadata`: Movie data from TMDb/OMDb
- `Scene3D`: 3D scene representation with entities, lighting, and camera positions
- `DirectorProject`: Complete film project with screenplay and directed scenes
- `Screenplay`: Screenplay data with OSF XML support
- `DirectedScene`: Scene broken down into shots with camera setups
- `Shot`: Individual shot with camera, framing, dialogue, and timing
- `AssetCatalog`: Video, audio, image, and 3D model assets
- `CharacterBackstory`: Character development with biography, objectives, relationships, and emotional range
- `VoiceProfile`: Voice characteristics including pitch, pace, timbre, and accent
- `DialogueRigging`: Dialogue timing, pauses, emphasis points, and delivery instructions

### Observable State
- `MediaWatchState`: Tracks watching, completion, likes, skips
- `ProductionState`: Manages active productions and queue
- `MediaInteractionState`: Records user interactions
- `ProductionEngine`: Orchestrates background production

### Services
- `MovieMetadataService`: Fetches movie data from APIs
- `TasteAnalysisService`: Builds and updates taste profiles
- `ProductionEngineService`: Generates stories and productions
- `Scene3DService`: Generates 3D scenes from story beats and builds RealityKit entities
- `DirectorKitService`: Orchestrates screenplay-to-shots conversion with camera setups and blocking
- `OSFParser`: Parses and generates Open Screenplay Format (OSF) XML
- `VoiceOverService`: Generates dialogue rigging with timing, pauses, emphasis, and delivery instructions based on character backstory

### Views
- `OnboardingView`: Initial taste selection
- `HomeView`: Apple TV-like browse interface
- `ProductionDetailView`: Production details and metadata with 3D storyboard access
- `VideoPlayerView`: Full-screen playback with state tracking
- `Storyboard3DView`: 3D visualization of storyboard scenes
- `Storyboard3DListView`: List of all 3D storyboard scenes
- `ARPreviewView`: AR preview of storyboard scenes

## State-Driven Story Generation

Stories are automatically generated when:

1. **Production Completion**: User finishes watching a production
2. **Skip Streak**: User skips 3+ productions in a row
3. **Repeat Viewing**: User watches same production multiple times
4. **Pause Patterns**: User pauses at emotional moments
5. **Like Patterns**: User likes certain types of productions

## Project Structure

```
FilmStudioPilot/
├── Models/
│   ├── Production.swift
│   ├── StoryIdea.swift
│   ├── TasteProfile.swift
│   ├── MovieMetadata.swift
│   └── Observable/
│       ├── MediaWatchState.swift
│       ├── ProductionState.swift
│       ├── MediaInteractionState.swift
│       └── ProductionEngine.swift
├── Services/
│   ├── MovieMetadataService.swift
│   ├── TasteAnalysisService.swift
│   └── ProductionEngineService.swift
├── Network/
│   ├── APIClient.swift
│   ├── TMDbClient.swift
│   └── OMDbClient.swift
├── Observers/
│   └── MediaStateObserver.swift
└── Views/
    ├── Onboarding/
    ├── Browse/
    ├── ProductionDetail/
    └── Playback/
```

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+
- Device with ARKit support (for AR preview features)

## RealityKit Integration

The app uses RealityKit for 3D storyboard visualization:

- **3D Scene Generation**: Automatically generates 3D scenes from story beats
- **Entity System**: Creates characters, props, and set pieces as 3D entities
- **Camera Positioning**: Intelligent camera placement based on scene objectives
- **Lighting**: Dynamic lighting based on emotional moments
- **AR Preview**: View storyboard scenes in augmented reality

### Using 3D Storyboards

1. Open a production detail view
2. Tap "View 3D Storyboard" button (if story has scene beats)
3. Browse scenes in 3D
4. Tap "View in AR" to preview in augmented reality

## License

Copyright © 2025 FilmStudioPilot. All rights reserved.

