# Music Generation for FilmStudioPilot

This document outlines music generation options compatible with the zero third-party dependency architecture, focusing on native Apple frameworks and open-source solutions.

## Recommended: AudioKit (Open Source)

**Best Choice for Native Integration**

### Overview
- **Open Source**: MIT License, completely free
- **Native**: Swift/Objective-C, designed for iOS/macOS
- **Professional**: Used in production apps
- **GitHub**: https://github.com/AudioKit/AudioKit

### Features
- **Synthesis**: Oscillators, filters, effects
- **Sequencing**: MIDI sequencing and playback
- **Effects**: Reverb, delay, distortion, compression
- **Analysis**: BPM detection, pitch tracking
- **Real-time**: Low-latency audio processing
- **SwiftUI Integration**: Native SwiftUI support

### Integration
```swift
import AudioKit

// Example: Generate music based on scene emotion
class MusicGenerator {
    let engine = AudioEngine()
    var oscillator: Oscillator?
    
    func generateMusic(for emotion: Emotion, duration: TimeInterval) {
        // Configure oscillator based on emotion
        let frequency: Float = emotionToFrequency(emotion)
        oscillator = Oscillator(waveform: .sine, frequency: frequency)
        
        // Add effects
        let reverb = Reverb(oscillator!)
        reverb.dryWetMix = 0.3
        
        // Start playback
        engine.output = reverb
        try? engine.start()
    }
}
```

### Use Cases for FilmStudioPilot
- **Emotional Scoring**: Generate music matching scene emotions
- **Background Music**: Ambient tracks for productions
- **Sound Design**: Create sound effects and atmospheres
- **Tempo Matching**: Sync music to scene pacing

### Documentation
- **Main Site**: https://audiokitpro.com/
- **GitHub**: https://github.com/AudioKit/AudioKit
- **Documentation**: https://audiokitpro.com/docs/
- **Examples**: https://github.com/AudioKit/AudioKit/tree/main/Examples

---

## Alternative: Core Audio (Native Apple)

**Pure Native Solution**

### Overview
- **Native**: Built into iOS/macOS
- **Low-Level**: Direct access to audio hardware
- **Powerful**: Professional audio processing
- **No Dependencies**: Part of Apple's frameworks

### Features
- **Audio Units**: Synthesis, effects, instruments
- **Audio Queue**: Playback and recording
- **Audio Graph**: Complex audio routing
- **MIDI**: MIDI processing and generation

### Integration
```swift
import AVFoundation
import AudioToolbox

// Example: Generate music using Audio Units
class CoreAudioMusicGenerator {
    var audioUnit: AudioComponentInstance?
    
    func generateMusic(for emotion: Emotion) {
        // Create audio component
        var componentDescription = AudioComponentDescription(
            componentType: kAudioUnitType_Generator,
            componentSubType: kAudioUnitSubType_SineWave,
            componentManufacturer: kAudioUnitManufacturer_Apple,
            componentFlags: 0,
            componentFlagsMask: 0
        )
        
        // Initialize audio unit
        // ... audio unit setup
    }
}
```

### Use Cases
- **Custom Synthesis**: Build custom instruments
- **Real-time Processing**: Low-latency audio
- **Professional Audio**: Advanced audio routing

### Documentation
- **Core Audio**: https://developer.apple.com/documentation/audiotoolbox
- **Audio Units**: https://developer.apple.com/documentation/audiotoolbox/audio_units
- **AVFoundation**: https://developer.apple.com/documentation/avfoundation

---

## AI Music Generation: Meta AudioCraft (Open Source)

**For AI-Generated Music from Text**

### Overview
- **Open Source**: MIT License
- **AI-Powered**: Text-to-music generation
- **MusicGen**: Generates music from text descriptions
- **GitHub**: https://github.com/facebookresearch/audiocraft

### Features
- **Text-to-Music**: "A dramatic orchestral piece for an emotional scene"
- **Style Transfer**: Generate in specific styles
- **Conditional Generation**: Control tempo, mood, instruments
- **High Quality**: Professional-sounding output

### Integration Options

**Option 1: Local Model (On-Device)**
- Requires Core ML model conversion
- Runs entirely on-device
- No API calls needed
- Larger app size

**Option 2: Server Integration**
- Run model on server
- API calls for generation
- Smaller app size
- Requires server infrastructure

### Use Cases
- **Scene-Specific Music**: Generate music matching scene descriptions
- **Emotional Scoring**: Create music for emotional moments
- **Style Matching**: Match music to production genre

### Documentation
- **GitHub**: https://github.com/facebookresearch/audiocraft
- **Paper**: https://arxiv.org/abs/2306.05284
- **Hugging Face**: https://huggingface.co/facebook/musicgen-large

---

## Recommended Architecture for FilmStudioPilot

### Phase 1: AudioKit Integration (Recommended Start)

**Why AudioKit:**
- ✅ Open-source and free
- ✅ Native Swift/iOS
- ✅ Professional quality
- ✅ Active community
- ✅ Well-documented
- ✅ SwiftUI compatible

**Implementation:**
1. Add AudioKit via Swift Package Manager
2. Create `MusicGenerationService` using AudioKit
3. Generate music based on scene emotions
4. Integrate with production pipeline

### Phase 2: Core Audio (Advanced)

**When to Use:**
- Need custom synthesis
- Require maximum performance
- Want zero external dependencies
- Building custom instruments

### Phase 3: AI Generation (Optional)

**When to Use:**
- Want text-to-music capabilities
- Need scene-specific generation
- Have server infrastructure
- Want more creative control

---

## Music Generation Service Design

### Service Architecture

```swift
@MainActor
class MusicGenerationService: ObservableObject {
    private let audioKitEngine: AudioEngine
    
    /// Generate music for a scene based on emotional context
    func generateMusic(
        for scene: Scene3D,
        emotionalContext: EmotionalContext,
        duration: TimeInterval
    ) async -> AudioAsset {
        // Analyze emotional context
        let emotion = emotionalContext.primaryEmotion
        let intensity = emotionalContext.emotionalIntensity
        
        // Generate music parameters
        let tempo = emotionToTempo(emotion)
        let key = emotionToKey(emotion)
        let instruments = emotionToInstruments(emotion)
        
        // Create audio using AudioKit
        let audioAsset = await createAudioAsset(
            tempo: tempo,
            key: key,
            instruments: instruments,
            duration: duration
        )
        
        return audioAsset
    }
    
    /// Generate music for emotional moment
    func generateEmotionalMusic(
        emotion: Emotion,
        intensity: Float,
        duration: TimeInterval
    ) async -> AudioAsset {
        // Generate music with emotional characteristics
        // Use AudioKit synthesis
    }
}
```

### Integration with Production Pipeline

```swift
// In ProductionEngineService
func addMusicToProduction(_ production: Production) async {
    let musicService = MusicGenerationService()
    
    // Generate music for each scene
    for scene in production.scenes {
        let music = await musicService.generateMusic(
            for: scene,
            emotionalContext: scene.emotionalContext,
            duration: scene.duration
        )
        
        // Add to production audio track
        production.audioTracks.append(music)
    }
}
```

---

## Emotion-to-Music Mapping

### Tempo Mapping
```swift
func emotionToTempo(_ emotion: Emotion) -> Float {
    switch emotion {
    case .joy: return 120.0 // Upbeat
    case .sadness: return 60.0 // Slow
    case .anger: return 140.0 // Fast, intense
    case .fear: return 100.0 // Uneasy
    case .neutral: return 90.0 // Moderate
    default: return 90.0
    }
}
```

### Key Mapping
```swift
func emotionToKey(_ emotion: Emotion) -> String {
    switch emotion {
    case .joy: return "C Major"
    case .sadness: return "A Minor"
    case .anger: return "D Minor"
    case .fear: return "E Minor"
    case .neutral: return "G Major"
    default: return "C Major"
    }
}
```

### Instrument Mapping
```swift
func emotionToInstruments(_ emotion: Emotion) -> [Instrument] {
    switch emotion {
    case .joy:
        return [.piano, .strings, .brass]
    case .sadness:
        return [.cello, .piano, .flute]
    case .anger:
        return [.drums, .electricGuitar, .brass]
    case .fear:
        return [.strings, .synthesizer, .percussion]
    default:
        return [.piano, .strings]
    }
}
```

---

## Implementation Steps

### Step 1: Add AudioKit Dependency

**Swift Package Manager:**
```swift
dependencies: [
    .package(url: "https://github.com/AudioKit/AudioKit.git", from: "5.0.0")
]
```

### Step 2: Create Music Generation Service

```swift
// Services/Music/MusicGenerationService.swift
import AudioKit

@MainActor
class MusicGenerationService: ObservableObject {
    // Implementation using AudioKit
}
```

### Step 3: Integrate with Production Pipeline

```swift
// In ProductionEngineService
let musicService = MusicGenerationService()
let music = await musicService.generateMusic(for: scene)
```

### Step 4: Export Audio Assets

```swift
// Export generated music to AudioAsset
let audioAsset = AudioAsset(
    url: exportedAudioURL,
    duration: musicDuration,
    format: "AAC"
)
```

---

## Resources

### AudioKit
- **GitHub**: https://github.com/AudioKit/AudioKit
- **Documentation**: https://audiokitpro.com/docs/
- **Examples**: https://github.com/AudioKit/AudioKit/tree/main/Examples
- **Community**: https://audiokitpro.com/community/

### Core Audio
- **Documentation**: https://developer.apple.com/documentation/audiotoolbox
- **Audio Units**: https://developer.apple.com/documentation/audiotoolbox/audio_units
- **AVFoundation**: https://developer.apple.com/documentation/avfoundation

### Meta AudioCraft
- **GitHub**: https://github.com/facebookresearch/audiocraft
- **Hugging Face**: https://huggingface.co/facebook/musicgen-large
- **Paper**: https://arxiv.org/abs/2306.05284

---

## Recommendation

**For FilmStudioPilot, use AudioKit** because:
1. ✅ Open-source and free
2. ✅ Native Swift/iOS integration
3. ✅ Professional quality
4. ✅ Active development
5. ✅ Great documentation
6. ✅ SwiftUI compatible
7. ✅ No API keys required
8. ✅ Can generate music on-device

This aligns perfectly with the zero third-party dependency architecture while providing professional music generation capabilities.

