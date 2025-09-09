# ADR-003: Dependency Injection with Dependencies Container

## Status
Accepted

## Context
SwiftBoard needs a clean way to manage dependencies and external services. The app uses various services including:

- API clients for network requests
- Keychain for secure storage
- Core Data for local persistence
- Logging services
- Analytics services

We need a solution that:
- Makes testing easier by allowing mock implementations
- Avoids singletons and global state
- Provides clear separation of concerns
- Is easy to use and maintain

## Decision
We will implement a dependency injection system using a `Dependencies` container that:

- Contains all external services and dependencies
- Provides both live and mock implementations
- Is passed through the TCA store to reducers
- Uses protocol-based design for testability
- Supports environment-specific configurations

## Consequences

### Positive
- **Testability**: Easy to inject mock dependencies for testing
- **Flexibility**: Can swap implementations for different environments
- **No Singletons**: Eliminates global state and hidden dependencies
- **Clear Dependencies**: Explicit about what each component needs
- **Type Safety**: Compile-time guarantees about available services
- **Maintainability**: Easy to add new services or modify existing ones

### Negative
- **Boilerplate**: More code required for dependency setup
- **Complexity**: Need to manage dependency lifecycle
- **Learning Curve**: Team needs to understand DI patterns
- **Initialization**: More complex app startup process

## Implementation Details

### Dependencies Container
```swift
public struct Dependencies {
    // MARK: - Networking
    public let apiClient: APIClient
    
    // MARK: - Storage
    public var keychainService: KeychainService
    public let coreDataService: CoreDataService
    
    // MARK: - Observability
    public let logger: Logger
    
    public init(
        apiClient: APIClient,
        keychainService: KeychainService,
        coreDataService: CoreDataService,
        logger: Logger
    ) {
        self.apiClient = apiClient
        self.keychainService = keychainService
        self.coreDataService = coreDataService
        self.logger = logger
    }
}
```

### Environment Configurations
```swift
extension Dependencies {
    static let live = Dependencies(
        apiClient: LiveAPIClient(),
        keychainService: LiveKeychainService(),
        coreDataService: LiveCoreDataService(),
        logger: LiveLogger()
    )
    
    static let mock = Dependencies(
        apiClient: MockAPIClient(),
        keychainService: MockKeychainService(),
        coreDataService: MockCoreDataService(),
        logger: MockLogger()
    )
}
```

### Usage in Reducers
```swift
struct FeatureReducer: Reducer {
    func reduce(
        _ state: inout FeatureState,
        _ action: FeatureAction,
        _ dependencies: Dependencies
    ) -> [Effect<FeatureAction>] {
        switch action {
        case .loadData:
            return [.task {
                let data = try await dependencies.apiClient.fetchData()
                return .dataLoaded(data)
            }]
        }
    }
}
```

## Alternatives Considered

1. **Singleton Pattern**: Global instances of services
2. **Environment Objects**: SwiftUI's environment system
3. **Service Locator**: Registry pattern for finding services
4. **Constructor Injection**: Pass dependencies through initializers
5. **Property Injection**: Set dependencies after object creation

## Service Protocols

All services are defined as protocols to enable easy mocking:

```swift
public protocol APIClient {
    func request<T: Codable>(_ endpoint: APIEndpoint) async throws -> T
}

public protocol KeychainService {
    mutating func save(_ data: Data, forKey key: String) throws
    func load(forKey key: String) throws -> Data?
    mutating func delete(forKey key: String) throws
}

public protocol Logger {
    func log(_ message: String, level: LogLevel)
}
```

## Testing Benefits

With dependency injection, testing becomes straightforward:

```swift
func testFeatureReducer() {
    let mockDependencies = Dependencies.mock
    let reducer = FeatureReducer()
    var state = FeatureState()
    
    let effects = reducer.reduce(&state, .loadData, mockDependencies)
    
    // Verify effects and state changes
    XCTAssertEqual(effects.count, 1)
}
```

## Environment Management

Different environments can have different dependency configurations:

- **Development**: Mock services for faster development
- **Testing**: Mock services for reliable tests
- **Production**: Live services for real functionality
- **Preview**: Mock services for SwiftUI previews

## References
- [Dependency Injection in Swift](https://www.swiftbysundell.com/articles/dependency-injection-using-factories-in-swift/)
- [Protocol-Oriented Programming](https://developer.apple.com/videos/play/wwdc2015/408/)
- [Testing with Dependency Injection](https://www.swiftbysundell.com/articles/testing-swift-code-that-uses-system-apis/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
