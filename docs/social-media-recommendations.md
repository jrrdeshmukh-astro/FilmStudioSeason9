# Recommended Social Media APIs for Taste Analysis

## Top Recommendations

### 1. **Reddit API** ⭐ Best Starting Point

**Why Start Here:**
- ✅ Well-documented and stable
- ✅ Clear subreddit → genre mapping
- ✅ Large user base
- ✅ Easy OAuth implementation
- ✅ No third-party SDK needed (native URLSession)

**Key Documentation:**
- **API Reference**: https://www.reddit.com/dev/api/
- **OAuth 2.0 Guide**: https://github.com/reddit-archive/reddit/wiki/OAuth2
- **App Registration**: https://www.reddit.com/prefs/apps

**Taste Analysis Strategy:**
```
User's Subreddits → Genre Mapping:
- r/scifi → Science Fiction
- r/horror → Horror
- r/TrueFilm → Drama/Art House
- r/movies → General Cinema
- r/television → TV Preferences
```

**Implementation Priority:** Phase 1 (Easiest)

---

### 2. **Mastodon API** ⭐ Best for Federated Data

**Why Use:**
- ✅ Open-source and decentralized
- ✅ Growing user base
- ✅ Streaming API for real-time updates
- ✅ Hashtag-based topic analysis
- ✅ No corporate control

**Key Documentation:**
- **API Docs**: https://docs.joinmastodon.org/api/
- **Streaming API**: https://docs.joinmastodon.org/api/streaming/
- **Authentication**: https://docs.joinmastodon.org/api/authentication/

**Taste Analysis Strategy:**
```
User's Hashtags → Topic Clustering:
- #scifi → Science Fiction
- #horror → Horror
- #indiefilm → Independent Cinema
- #documentary → Documentary

User's Favorites → Strong Preferences
Timeline Analysis → Content Consumption Patterns
```

**Implementation Priority:** Phase 2 (After Reddit)

---

### 3. **ActivityPub Protocol** ⭐ Best for Universal Integration

**Why Use:**
- ✅ Works across multiple platforms (Mastodon, Lemmy, Pixelfed, etc.)
- ✅ W3C standard
- ✅ Single implementation for multiple sources
- ✅ Future-proof

**Key Documentation:**
- **ActivityPub Spec**: https://www.w3.org/TR/activitypub/
- **ActivityStreams**: https://www.w3.org/TR/activitystreams-core/
- **Implementation Guide**: https://activitypub.rocks/

**Taste Analysis Strategy:**
```
Unified Protocol → Multiple Sources:
- Mastodon posts
- Lemmy communities
- Pixelfed images
- Any ActivityPub-compatible platform
```

**Implementation Priority:** Phase 3 (Advanced)

---

## Implementation Roadmap

### Phase 1: Reddit Integration (Week 1-2)
1. Register Reddit app
2. Implement OAuth 2.0 flow
3. Create `RedditClient` with native URLSession
4. Map subreddits to genres
5. Integrate with `TasteAnalysisService`

### Phase 2: Mastodon Integration (Week 3-4)
1. Select Mastodon instance
2. Implement OAuth flow
3. Create `MastodonClient`
4. Analyze hashtags and favorites
5. Add to taste profile

### Phase 3: ActivityPub Support (Week 5+)
1. Implement ActivityPub JSON-LD parser
2. Support multiple federated platforms
3. Unified taste aggregation
4. Real-time streaming updates

---

## Code Structure

```swift
// Network/SocialMedia/
├── RedditClient.swift
├── MastodonClient.swift
├── LemmyClient.swift
├── ActivityPubClient.swift
└── Models/
    ├── RedditModels.swift
    ├── MastodonModels.swift
    └── ActivityPubModels.swift

// Services/
└── SocialMediaTasteService.swift
    - Aggregates data from all sources
    - Maps to TasteProfile
    - Updates user preferences
```

---

## Privacy Considerations

### Required Permissions
- **Read-only access** to user's posts/likes
- **No posting** capabilities needed
- **Clear consent** flow explaining data usage

### Data Storage
- Store OAuth tokens in Keychain
- Cache taste data locally (SwiftData)
- Don't store raw social media posts
- Aggregate and anonymize immediately

### User Control
- Settings to connect/disconnect accounts
- View what data is being analyzed
- Export taste profile
- Delete all social media data

---

## Quick Start: Reddit Integration

### 1. Register App
Visit: https://www.reddit.com/prefs/apps
- Create "web app" type
- Get client ID and secret

### 2. OAuth Flow
```swift
// Use ASWebAuthenticationSession for OAuth
let authURL = URL(string: "https://www.reddit.com/api/v1/authorize?...")!
let session = ASWebAuthenticationSession(
    url: authURL,
    callbackURLScheme: "filmstudiopilot"
) { callbackURL, error in
    // Handle OAuth callback
}
```

### 3. API Calls
```swift
class RedditClient: APIClient {
    func getUserSubreddits() async throws -> [String] {
        // GET /user/{username}/subreddits
        // Map to genres
    }
}
```

---

## Taste Analysis Example

```swift
// User subscribes to: r/scifi, r/cyberpunk, r/bladerunner
// Analysis:
- Primary Genre: Science Fiction (0.9)
- Sub-genres: Cyberpunk (0.8), Dystopian (0.7)
- Themes: Technology, Future, Identity

// Generate story aligned with these preferences
```

---

## Resources

**Reddit**
- API Docs: https://www.reddit.com/dev/api/
- OAuth: https://github.com/reddit-archive/reddit/wiki/OAuth2

**Mastodon**
- API Docs: https://docs.joinmastodon.org/api/
- Instance List: https://joinmastodon.org/servers

**ActivityPub**
- Spec: https://www.w3.org/TR/activitypub/
- Guide: https://activitypub.rocks/

---

All implementations use native `URLSession` - zero third-party dependencies! 🎯

