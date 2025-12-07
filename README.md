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
- **Music Generation**: AI-powered music generation using AudioKit for scene-appropriate scoring
- **Native Apple Stack**: Built entirely with SwiftUI, AVKit, AVFoundation, RealityKit, and Core Media

## Setup

### No API Keys Required! 🎉

This app uses **zero third-party APIs that require keys**. Everything is:
- **Native Apple frameworks** (SwiftUI, AVKit, AVFoundation, RealityKit)
- **Open-source social media APIs** (OAuth-based, user consent)
- **Local data** (pre-defined movie lists, user input)

### Optional: Social Media Integration

To enhance taste analysis, users can optionally connect:
- **Reddit** (OAuth - no API key needed)
- **Mastodon** (OAuth - no API key needed)
- **Lemmy** (OAuth - no API key needed)

All social media integration uses OAuth 2.0 with user consent - no developer API keys required.

## Architecture

### Models
- `Production`: Completed productions for viewing
- `StoryIdea`: Generated story ideas with acting method structure
- `TasteProfile`: User preferences and taste analysis
- `LocalMovie`: Local movie representation (no external API needed)
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
- `TasteAnalysisService`: Builds and updates taste profiles from local movie selections and social media data
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
│   ├── LocalMovie.swift
│   └── Observable/
│       ├── MediaWatchState.swift
│       ├── ProductionState.swift
│       ├── MediaInteractionState.swift
│       └── ProductionEngine.swift
├── Services/
│   ├── TasteAnalysisService.swift
│   └── ProductionEngineService.swift
├── Network/
│   ├── APIClient.swift
│   └── SocialMedia/ (OAuth-based, no API keys)
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

## Social Media Taste Analysis

The app can integrate with open-source social media platforms to enhance taste analysis:

- **Reddit API**: Analyze user's subreddit subscriptions for genre preferences
- **Mastodon API**: Analyze hashtags, favorites, and timeline for content interests
- **ActivityPub Protocol**: Universal support for federated social networks
- **Privacy-First**: User consent required, OAuth-based, read-only access

See `docs/social-media-apis.md` for complete integration guide.

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

