# ADR-002: Offline-First Data Strategy with Core Data

## Status
Accepted

## Context
SwiftBoard needs to work reliably in offline scenarios and provide a fast, responsive user experience. Users expect:

- Fast app startup and navigation
- Ability to view and interact with data when offline
- Automatic synchronization when connectivity is restored
- Optimistic updates for better perceived performance
- Data persistence across app launches

## Decision
We will implement an offline-first data strategy using Core Data for local persistence with the following approach:

- **Cache-First Loading**: Always load from local cache first, then fetch from network
- **Background Synchronization**: Sync data in the background when online
- **Optimistic Updates**: Update UI immediately, rollback on failure
- **Conflict Resolution**: Last-write-wins with timestamp-based resolution
- **ETag/Last-Modified**: Use HTTP headers for efficient cache validation

## Consequences

### Positive
- **Fast Performance**: Instant data loading from local cache
- **Offline Capability**: Full app functionality without network
- **Better UX**: Optimistic updates provide immediate feedback
- **Data Persistence**: Data survives app restarts and device reboots
- **Bandwidth Efficiency**: Only fetch changed data using ETags
- **Reliability**: App works even with poor network conditions

### Negative
- **Storage Requirements**: Local database increases app size
- **Complexity**: More complex data synchronization logic
- **Conflict Resolution**: Need to handle data conflicts
- **Cache Invalidation**: Need to manage cache freshness
- **Development Time**: More time required for implementation

## Implementation Details

### Core Data Stack
```swift
// Core Data stack with automatic background sync
class CoreDataStack {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SwiftBoard")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error)")
            }
        }
        return container
    }()
}
```

### Data Flow
1. **Load**: Check local cache first, display immediately
2. **Fetch**: Fetch from network in background
3. **Merge**: Merge network data with local cache
4. **Update**: Update UI with merged data
5. **Sync**: Periodically sync in background

### Cache Strategy
- **Profile Data**: Cache for 1 hour
- **Tasks**: Cache for 5 minutes, optimistic updates
- **Activity Feed**: Cache for 10 minutes
- **Settings**: Cache indefinitely, sync on change

## Alternatives Considered

1. **Network-First**: Always fetch from network, fallback to cache
2. **SQLite**: Direct SQLite instead of Core Data
3. **UserDefaults**: Simple key-value storage for small data
4. **CloudKit**: Apple's cloud database solution
5. **Realm**: Alternative to Core Data

## Cache Invalidation Strategy

- **Time-based**: Expire cache after specific time intervals
- **ETag-based**: Use HTTP ETags to detect changes
- **Manual**: Force refresh on user action (pull-to-refresh)
- **Event-based**: Invalidate related data when user makes changes

## Conflict Resolution

- **Last-Write-Wins**: Use `updatedAt` timestamps
- **User Priority**: Local changes take precedence over server
- **Merge Strategy**: Combine non-conflicting fields
- **User Notification**: Alert user to conflicts when necessary

## References
- [Core Data Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/)
- [Offline-First Architecture](https://offlinefirst.org/)
- [HTTP Caching](https://developer.mozilla.org/en-US/docs/Web/HTTP/Caching)
- [ETag Header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/ETag)
