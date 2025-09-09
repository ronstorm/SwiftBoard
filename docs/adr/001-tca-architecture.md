# ADR-001: Use TCA-lite for State Management

## Status
Accepted

## Context
We need a predictable and testable state management solution for SwiftBoard. The app has complex state interactions including authentication, offline data synchronization, and real-time UI updates. We need a solution that:

- Provides predictable state updates
- Makes business logic easily testable
- Handles side effects in a controlled manner
- Integrates well with SwiftUI
- Is lightweight and doesn't add unnecessary complexity

## Decision
We will implement a custom TCA-lite architecture inspired by The Composable Architecture, consisting of:

- **Store**: Manages state and coordinates actions and effects
- **Reducer**: Pure functions that describe how state changes in response to actions
- **Effect**: Represents side effects that can produce actions
- **Dependencies**: Container for external services and dependencies
- **WithViewStore**: SwiftUI integration for connecting views to the store

## Consequences

### Positive
- **Predictable State**: State changes are explicit and traceable
- **Testable**: Business logic is pure and easily testable
- **Composable**: Features can be built independently and composed together
- **Type Safety**: Compile-time guarantees about state and action types
- **Debugging**: Easy to trace state changes and side effects
- **SwiftUI Integration**: Seamless integration with SwiftUI's declarative nature

### Negative
- **Learning Curve**: Team needs to understand TCA patterns
- **Boilerplate**: More code required for simple state changes
- **Custom Implementation**: We're maintaining our own TCA-lite instead of using a library
- **Complexity**: Can be overkill for simple features

## Alternatives Considered

1. **Redux-like with Combine**: Similar to TCA but using Combine publishers
2. **MVVM with @ObservableObject**: Traditional MVVM pattern
3. **Full TCA Library**: Using the official TCA library from Point-Free
4. **StateObject/EnvironmentObject**: SwiftUI's built-in state management

## Implementation Details

The TCA-lite implementation includes:

```swift
// Store manages state and coordinates actions
@MainActor
public final class Store<State, Action> {
    @Published public private(set) var state: State
    private let reducer: any Reducer<State, Action>
    private let dependencies: Dependencies
    
    public func send(_ action: Action) {
        let effects = reducer.reduce(&state, action, dependencies)
        // Handle effects...
    }
}

// Reducer describes state changes
public protocol Reducer<State, Action> {
    func reduce(
        _ state: inout State,
        _ action: Action,
        _ dependencies: Dependencies
    ) -> [Effect<Action>]
}

// Effect represents side effects
public struct Effect<Action> {
    public func run(_ send: @escaping (Action) -> Void) {
        // Execute side effect and send actions back
    }
}
```

## References
- [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture)
- [SwiftUI State Management](https://developer.apple.com/documentation/swiftui/state-management)
- [Functional Programming in Swift](https://www.objc.io/books/functional-swift/)
