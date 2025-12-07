# Open Source Social Media APIs for Taste Analysis

This document outlines open-source social media APIs that can be integrated using native `URLSession` (no third-party SDKs) to analyze user preferences and generate personalized content.

## Core Principle

**Zero API Keys Required!** All APIs use OAuth 2.0 (user consent) - no developer API keys needed. This maintains the zero third-party dependency architecture and ensures user privacy.

---

## 1. Mastodon API (Federated Social Network)

**Best for:** Decentralized social media data, user interests, trending topics

### Documentation
- **Official API Docs**: https://docs.joinmastodon.org/api/
- **Getting Started**: https://docs.joinmastodon.org/api/guidelines/
- **Authentication**: https://docs.joinmastodon.org/api/authentication/
- **Streaming API**: https://docs.joinmastodon.org/api/streaming/

### Key Endpoints for Taste Analysis

**User Timeline**
```
GET /api/v1/accounts/:id/statuses
```
- Get user's posts to analyze interests
- Filter by media, tags, visibility
- Use for: Content preferences, topics of interest

**Public Timeline**
```
GET /api/v1/timelines/public
```
- Trending content across instance
- Use for: Popular topics, trending tastes

**Hashtag Timeline**
```
GET /api/v1/timelines/tag/:hashtag
```
- Content for specific hashtags
- Use for: Genre/topic clustering

**Favorites/Bookmarks**
```
GET /api/v1/favourites
GET /api/v1/bookmarks
```
- User's liked/saved content
- Use for: Strong preference signals

**Streaming (WebSocket)**
```
GET /api/v1/streaming
```
- Real-time updates
- Use for: Live taste pattern detection

### Authentication
- OAuth 2.0 (native implementation)
- App registration required
- Access tokens for user data

### Implementation Pattern
```swift
class MastodonClient: APIClient {
    private let baseURL: String // Instance URL
    private let accessToken: String
    
    func getUserTimeline(userId: String) async throws -> [MastodonStatus] {
        let url = URL(string: "\(baseURL)/api/v1/accounts/\(userId)/statuses")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        // ... URLSession implementation
    }
}
```

### Taste Analysis Use Cases
- Analyze user's posts for genre keywords
- Track hashtag usage patterns
- Identify favorite content types
- Monitor trending topics in user's network

---

## 2. Reddit API (Open Source Alternative)

**Best for:** Subreddit interests, content preferences, community engagement

### Documentation
- **Official API Docs**: https://www.reddit.com/dev/api/
- **OAuth Guide**: https://github.com/reddit-archive/reddit/wiki/OAuth2
- **API Rules**: https://www.reddit.com/wiki/api

### Key Endpoints for Taste Analysis

**User Subreddits**
```
GET /user/{username}/subreddits
```
- Subreddits user subscribes to
- Use for: Genre/topic preferences

**User Posts/Comments**
```
GET /user/{username}/submitted
GET /user/{username}/comments
```
- User's content history
- Use for: Content creation preferences

**Subreddit Posts**
```
GET /r/{subreddit}/hot
GET /r/{subreddit}/top
```
- Popular content in subreddit
- Use for: Genre-specific trending content

**Search**
```
GET /search
```
- Search posts by keywords
- Use for: Finding content matching user interests

### Authentication
- OAuth 2.0 (native implementation)
- App registration: https://www.reddit.com/prefs/apps
- User agent required in headers

### Implementation Pattern
```swift
class RedditClient: APIClient {
    private let baseURL = "https://oauth.reddit.com"
    private let accessToken: String
    private let userAgent: String
    
    func getUserSubreddits(username: String) async throws -> [RedditSubreddit] {
        let url = URL(string: "\(baseURL)/user/\(username)/subreddits")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        // ... URLSession implementation
    }
}
```

### Taste Analysis Use Cases
- Map subreddits to movie genres (r/scifi → Sci-Fi, r/horror → Horror)
- Analyze post titles for content preferences
- Track upvoted content for strong preferences
- Identify niche interests from subscribed subreddits

---

## 3. Lemmy API (Federated Reddit Alternative)

**Best for:** Open-source alternative to Reddit, community interests

### Documentation
- **API Documentation**: https://join-lemmy.org/api/classes/LemmyHttp.html
- **GitHub**: https://github.com/LemmyNet/lemmy
- **API Reference**: https://join-lemmy.org/api/

### Key Endpoints

**User Communities**
```
GET /api/v3/community/list
```
- Communities user follows
- Use for: Interest clustering

**User Posts**
```
GET /api/v3/post/list
```
- User's post history
- Use for: Content preferences

**Search**
```
GET /api/v3/search
```
- Search posts, comments, communities
- Use for: Finding relevant content

### Authentication
- JWT tokens
- Native URLSession implementation

---

## 4. Pixelfed API (Federated Instagram Alternative)

**Best for:** Visual content preferences, image-based taste analysis

### Documentation
- **API Docs**: https://docs.pixelfed.org/technical-documentation/api/
- **GitHub**: https://github.com/pixelfed/pixelfed

### Key Endpoints

**User Media**
```
GET /api/v1/accounts/:id/statuses
```
- User's posted images/videos
- Use for: Visual style preferences

**Timeline**
```
GET /api/v1/timelines/home
```
- User's feed
- Use for: Content consumption patterns

---

## 5. ActivityPub Protocol (Federated Social Web)

**Best for:** Universal protocol for federated social networks

### Documentation
- **ActivityPub Spec**: https://www.w3.org/TR/activitypub/
- **ActivityStreams**: https://www.w3.org/TR/activitystreams-core/
- **Implementation Guide**: https://activitypub.rocks/

### Key Concepts
- Followers/Following lists
- Activities (Create, Like, Share)
- Objects (Posts, Comments, Media)

### Implementation
- Native URLSession with ActivityPub JSON-LD
- Parse ActivityStreams 2.0 format
- Support multiple federated platforms

---

## Implementation Architecture

### Unified Social Media Client

```swift
protocol SocialMediaClient {
    func getUserInterests(userId: String) async throws -> [Interest]
    func getTrendingTopics() async throws -> [Topic]
    func getUserLikes(userId: String) async throws -> [ContentItem]
}

class UnifiedSocialMediaService {
    private let mastodonClient: MastodonClient?
    private let redditClient: RedditClient?
    private let lemmyClient: LemmyClient?
    
    func aggregateUserTastes(userId: String) async -> TasteProfile {
        // Aggregate data from multiple sources
        // Build unified taste profile
    }
}
```

### Taste Analysis from Social Data

**Data Sources:**
1. **Subreddits/Communities** → Genre mapping
2. **Hashtags** → Topic clustering
3. **Liked/Upvoted Content** → Strong preferences
4. **Post Content** → Keyword extraction
5. **Following Lists** → Interest networks

**Analysis Pipeline:**
1. Collect data from social APIs
2. Extract keywords, topics, genres
3. Map to movie/TV genres
4. Build taste vectors
5. Update `TasteProfile`

---

## Privacy & Best Practices

### User Consent
- **Explicit permission** required for social media access
- Clear explanation of data usage
- OAuth flow with user approval
- Option to revoke access

### Data Handling
- Store access tokens securely (Keychain)
- Cache taste data locally
- Don't store raw social media posts
- Aggregate and anonymize data

### Rate Limiting
- Respect API rate limits
- Implement exponential backoff
- Cache responses appropriately
- Batch requests when possible

### Compliance
- Follow platform ToS
- Respect user privacy settings
- Handle deleted/private content gracefully
- Provide data export/deletion

---

## Recommended Approach for FilmStudioPilot

### Phase 1: Reddit Integration (Easiest)
- **Why**: Well-documented, clear subreddit → genre mapping
- **Use**: Subreddit subscriptions for initial taste profile
- **Implementation**: OAuth + native URLSession

### Phase 2: Mastodon Integration (Federated)
- **Why**: Open-source, decentralized, growing
- **Use**: Hashtag analysis, timeline preferences
- **Implementation**: Instance selection + OAuth

### Phase 3: ActivityPub Support (Universal)
- **Why**: Works across multiple federated platforms
- **Use**: Unified taste analysis from multiple sources
- **Implementation**: ActivityPub JSON-LD parsing

---

## Quick Reference Links

**Mastodon**
- API Docs: https://docs.joinmastodon.org/api/
- Instance List: https://joinmastodon.org/servers
- OAuth Guide: https://docs.joinmastodon.org/api/authentication/

**Reddit**
- API Docs: https://www.reddit.com/dev/api/
- OAuth Guide: https://github.com/reddit-archive/reddit/wiki/OAuth2
- App Registration: https://www.reddit.com/prefs/apps

**Lemmy**
- API Docs: https://join-lemmy.org/api/
- GitHub: https://github.com/LemmyNet/lemmy

**ActivityPub**
- Spec: https://www.w3.org/TR/activitypub/
- ActivityStreams: https://www.w3.org/TR/activitystreams-core/

---

## Integration with FilmStudioPilot

### Taste Analysis Service Extension

```swift
class SocialMediaTasteService {
    func analyzeRedditProfile(username: String) async -> TasteProfile {
        // Get subreddits → map to genres
        // Analyze posts → extract keywords
        // Build taste profile
    }
    
    func analyzeMastodonProfile(accountId: String) async -> TasteProfile {
        // Get posts → extract hashtags
        // Analyze favorites → strong preferences
        // Build taste profile
    }
}
```

### State Observation Integration

- Observe social media updates
- Trigger taste profile updates
- Generate new stories based on social activity
- Match trending topics to content generation

---

This approach maintains zero third-party dependencies while enabling rich taste analysis from open-source social media platforms.

