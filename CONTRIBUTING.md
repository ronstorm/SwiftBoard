# Contributing to SwiftBoard

Thank you for your interest in contributing to SwiftBoard! This document provides guidelines and information for contributors.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Style](#code-style)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [Issue Guidelines](#issue-guidelines)
- [Architecture Guidelines](#architecture-guidelines)

## 🤝 Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to [me@amitsen.de](mailto:me@amitsen.de).

## 🚀 Getting Started

### Prerequisites

- Xcode 16.0 or later
- iOS 18.5+ deployment target
- Swift 5.9+
- Git

### Setup

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/your-username/SwiftBoard.git
   cd SwiftBoard
   ```
3. Open `SwiftBoard.xcodeproj` in Xcode
4. Build and run the project to ensure everything works

## 🔄 Development Workflow

### Branch Naming

Use descriptive branch names with prefixes:

- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation updates
- `refactor/` - Code refactoring
- `test/` - Test improvements
- `chore/` - Build/tooling changes

Examples:
- `feature/user-profile-screen`
- `fix/authentication-token-refresh`
- `docs/api-documentation`

### Commit Messages

We use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

#### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Test additions or changes
- `chore`: Build process or auxiliary tool changes
- `perf`: Performance improvements
- `ci`: CI/CD changes

#### Examples

```
feat(auth): add Apple Sign-In support

fix(dashboard): resolve task toggle optimistic update issue

docs(readme): update installation instructions

test(store): add unit tests for effect composition
```

## 🎨 Code Style

### SwiftLint

We use SwiftLint to enforce code style. The configuration is in `.swiftlint.yml`.

```bash
# Check for style violations
swiftlint

# Auto-fix violations where possible
swiftlint --fix
```

### Naming Conventions

- **Types**: PascalCase (`UserProfile`, `TaskItem`)
- **Functions/Methods**: camelCase (`fetchUserData`, `toggleTask`)
- **Variables/Properties**: camelCase (`userName`, `isLoading`)
- **Constants**: camelCase (`maxRetryCount`, `defaultTimeout`)
- **Enums**: PascalCase with descriptive cases (`AuthenticationState.signedIn`)

### File Organization

- One main type per file
- Extensions in separate files when they become large
- Group related functionality together
- Use `// MARK:` comments for organization

### Documentation

- Document all public APIs
- Use Swift documentation comments (`///`)
- Include parameter descriptions and return values
- Provide usage examples for complex APIs

## 🧪 Testing

### Test Structure

```
SwiftBoardTests/
├── Core/
│   └── TCA/
│       └── StoreTests.swift
├── Features/
│   ├── Auth/
│   ├── Dashboard/
│   └── Settings/
└── Resources/
    └── DesignTokensTests.swift
```

### Writing Tests

- **Unit Tests**: Test individual functions and methods
- **Integration Tests**: Test component interactions
- **Snapshot Tests**: Test UI consistency
- **Accessibility Tests**: Test VoiceOver and accessibility features

### Test Naming

Use descriptive test names that explain the scenario:

```swift
func testUserSignInWithValidCredentialsShouldReturnSuccess() {
    // Test implementation
}

func testTaskToggleWithNetworkErrorShouldRollbackOptimisticUpdate() {
    // Test implementation
}
```

### Running Tests

```bash
# Run all tests
xcodebuild test -scheme SwiftBoard -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.6'

# Run specific test
xcodebuild test -scheme SwiftBoard -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.6' -only-testing:SwiftBoardTests/StoreTests/testIncrement
```

## 🔀 Pull Request Process

### Before Submitting

1. **Update your branch** with the latest changes from main
2. **Run tests** to ensure everything passes
3. **Run SwiftLint** to check code style
4. **Update documentation** if needed
5. **Add tests** for new functionality

### PR Description

Use the provided PR template and include:

- Clear description of changes
- Related issues
- Testing performed
- Screenshots/videos (if applicable)
- Breaking changes (if any)

### Review Process

1. **Automated checks** must pass (CI/CD, SwiftLint, tests)
2. **Code review** by maintainers
3. **Approval** from at least one maintainer
4. **Merge** by maintainers

## 🐛 Issue Guidelines

### Bug Reports

Use the bug report template and include:

- Clear description of the bug
- Steps to reproduce
- Expected vs actual behavior
- Environment details
- Screenshots/videos
- Debug information

### Feature Requests

Use the feature request template and include:

- Clear description of the feature
- Motivation and use case
- Acceptance criteria
- Design considerations
- Technical considerations

## 🏗️ Architecture Guidelines

### TCA Patterns

Follow TCA patterns consistently:

```swift
// State
struct FeatureState: Equatable {
    var isLoading: Bool = false
    var data: [Item] = []
}

// Actions
enum FeatureAction: Equatable {
    case onAppear
    case dataLoaded([Item])
    case loadFailed(Error)
}

// Reducer
struct FeatureReducer: Reducer {
    func reduce(
        _ state: inout FeatureState,
        _ action: FeatureAction,
        _ dependencies: Dependencies
    ) -> [Effect<FeatureAction>] {
        // Implementation
    }
}
```

### Dependency Injection

- Use the `Dependencies` container
- No singletons
- Mock implementations for testing
- Protocol-based design

### Error Handling

- Use the centralized error mapping
- Provide user-friendly error messages
- Log errors appropriately
- Handle network errors gracefully

### Performance

- Use `@MainActor` for UI updates
- Avoid unnecessary re-renders
- Implement proper caching
- Use async/await for network operations

## 📚 Resources

- [Swift Style Guide](https://swift.org/documentation/api-design-guidelines/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [TCA Documentation](https://github.com/pointfreeco/swift-composable-architecture)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios/)

## ❓ Questions?

If you have questions about contributing:

1. Check existing issues and discussions
2. Create a new issue with the "question" label
3. Contact maintainers at [contact@codingwithamit.com](mailto:contact@codingwithamit.com)

## 🙏 Thank You

Thank you for contributing to SwiftBoard! Your contributions help make this project better for everyone.
