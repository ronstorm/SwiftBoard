# SwiftBoard

<!-- [![CI/CD](https://github.com/amitsen/SwiftBoard/workflows/CI/CD/badge.svg)](https://github.com/amitsen/SwiftBoard/actions)
[![codecov](https://codecov.io/gh/amitsen/SwiftBoard/branch/main/graph/badge.svg)](https://codecov.io/gh/amitsen/SwiftBoard)
[![Swift Version](https://img.shields.io/badge/swift-5.9-orange.svg)](https://swift.org)
[![iOS Version](https://img.shields.io/badge/iOS-18.5+-blue.svg)](https://developer.apple.com/ios/)
[![Xcode Version](https://img.shields.io/badge/Xcode-16.0+-blue.svg)](https://developer.apple.com/xcode/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://developer.apple.com/ios/) -->

A modern SwiftUI demo app built with TCA (The Composable Architecture) that demonstrates authentication, offline-first data caching, and clean architecture patterns.

## 🚀 Features

- **Onboarding**: Multi-page onboarding flow with progress tracking and accessibility support
- **Authentication**: Email/Password and Apple Sign-In support
- **Offline-First**: Core Data caching with network synchronization
- **TCA Architecture**: Predictable state management with reducers and effects
- **Modern UI**: SwiftUI with design tokens and accessibility support
- **Testing**: Comprehensive unit and integration tests
- **CI/CD**: Automated builds, tests, and releases

## ✅ Completed Features

### B-002: Onboarding Flow (S-001)
- **State Management**: Complete TCA implementation with `OnboardingState`, `OnboardingAction`, and `OnboardingReducer`
- **UI Components**: Multi-page onboarding view with progress tracking and navigation
- **Accessibility**: Full VoiceOver support with semantic labels and hints
- **Design System**: Integrated with design tokens for consistent styling
- **Testing**: Comprehensive unit tests covering all reducer logic and state transitions
- **Integration**: Seamlessly integrated into app routing system

<!-- ## 📱 Screenshots

| Onboarding | Sign In | Dashboard |
|------------|---------|-----------|
| ![Onboarding](docs/screenshots/onboarding.png) | ![Sign In](docs/screenshots/signin.png) | ![Dashboard](docs/screenshots/dashboard.png) | -->

## 🏗️ Architecture

SwiftBoard follows a clean architecture pattern with TCA (The Composable Architecture) for state management:

```
App/
├── App/              # App entry, composition, routes
├── Features/         # Feature modules (Onboarding, Auth, Dashboard, etc.)
│   └── Onboarding/   # Onboarding flow with TCA state management
├── Core/             # Domain models, Interactors, ErrorMap, Observability
├── Core/TCA/         # TCA-lite implementation (Store, Reducer, Effect, Dependencies)
├── Platform/         # Keychain, Core Data stack, OS services
├── Networking/       # HTTP client, Mock API, Decoders
└── Resources/        # Assets, JSON fixtures, Design tokens
```

### Key Principles

- **Views are dumb**: Business logic lives in Reducers/Interactors
- **No singletons**: Dependencies are injected via the Dependencies container
- **Testable**: All business logic is easily testable
- **Offline-first**: Data is cached locally and synchronized when online

## 🛠️ Tech Stack

- **SwiftUI**: Modern declarative UI framework
- **TCA-lite**: Custom implementation of The Composable Architecture
- **Core Data**: Local data persistence and caching
- **Combine**: Reactive programming for async operations
- **Keychain**: Secure token storage
- **SwiftLint**: Code style and quality enforcement

## 📋 Requirements

- iOS 18.5+
- Xcode 16.0+
- Swift 5.9+

## 🚀 Getting Started

### Prerequisites

1. Install Xcode 16.0 or later
2. Clone the repository:
   ```bash
   git clone https://github.com/amitsen/SwiftBoard.git
   cd SwiftBoard
   ```

### Installation

1. Open `SwiftBoard.xcodeproj` in Xcode
2. Select your target device or simulator
3. Build and run the project (⌘+R)

### Running Tests

```bash
# Run all tests
xcodebuild test -scheme SwiftBoard -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.6'

# Run with coverage
xcodebuild test -scheme SwiftBoard -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.6' -enableCodeCoverage YES
```

### Code Quality

```bash
# Run SwiftLint
swiftlint

# Run SwiftLint with auto-fix
swiftlint --fix
```

## 🧪 Testing

The project includes comprehensive testing:

- **Unit Tests**: Reducer logic, business rules, and utilities
- **Integration Tests**: Token refresh, offline merge, and data synchronization
- **Snapshot Tests**: UI consistency and accessibility
- **Keychain Tests**: Secure storage functionality
- **Log Export Tests**: Debug and support features

### Test Structure

```
SwiftBoardTests/
├── Core/
│   └── TCA/
│       └── StoreTests.swift
├── Features/
│   ├── Onboarding/
│   │   └── OnboardingReducerTests.swift
│   ├── Auth/
│   ├── Dashboard/
│   └── Settings/
└── Resources/
    └── DesignTokensTests.swift
```

## 🔧 Development

### Project Structure

- **Features**: Each feature is self-contained with its own state, actions, and reducers
- **Core**: Shared business logic, models, and utilities
- **Platform**: Platform-specific implementations (iOS, Keychain, Core Data)
- **Resources**: Assets, design tokens, and configuration files

### Adding a New Feature

1. Create feature folder in `Features/`
2. Define state, actions, and reducer
3. Create SwiftUI views
4. Add tests
5. Update app routing

### Code Style

- Follow SwiftLint configuration
- Use TCA patterns consistently
- Write tests for all business logic
- Document public APIs
- Use meaningful commit messages (Conventional Commits)

## 📊 CI/CD

The project uses GitHub Actions for continuous integration:

- **Build**: Compiles the project on multiple configurations
- **Test**: Runs all tests with coverage reporting
- **Lint**: Enforces code style with SwiftLint
- **Security**: Scans for potential security issues
- **Release**: Automatically creates releases with artifacts

### Workflow Triggers

- **Push**: Runs on main and develop branches
- **Pull Request**: Validates all PRs before merge
- **Release**: Creates release artifacts when tags are pushed

## 🔐 Security

- **Keychain Storage**: Sensitive data (tokens) stored securely
- **PII Redaction**: Personal information is redacted from logs
- **HTTPS Only**: All network requests use secure connections
- **Code Scanning**: Automated security checks in CI/CD

## ♿ Accessibility

- **VoiceOver**: Full screen reader support
- **Dynamic Type**: Respects user's text size preferences
- **High Contrast**: Supports high contrast mode
- **Semantic Labels**: All UI elements have proper accessibility labels

## 📈 Analytics & Observability

- **Logging**: Structured logging with `os.Logger`
- **Error Tracking**: Centralized error handling and mapping
- **Performance**: Minimal analytics for app performance
- **Debug Support**: Log export for troubleshooting

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Run SwiftLint and fix any issues
7. Commit your changes (`git commit -m 'feat: add amazing feature'`)
8. Push to your branch (`git push origin feature/amazing-feature`)
9. Open a Pull Request

### Commit Convention

We use [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` New features
- `fix:` Bug fixes
- `docs:` Documentation changes
- `style:` Code style changes
- `refactor:` Code refactoring
- `test:` Test additions or changes
- `chore:` Build process or auxiliary tool changes

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Amit Sen** - *Initial work* - [@amitsen](https://github.com/ronstorm)

## 🙏 Acknowledgments

- [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture) for state management inspiration
- [SwiftUI](https://developer.apple.com/xcode/swiftui/) for the amazing UI framework
- [SwiftLint](https://github.com/realm/SwiftLint) for code quality enforcement

## 📚 Resources

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [TCA Documentation](https://github.com/pointfreeco/swift-composable-architecture)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios/)
- [Swift Style Guide](https://swift.org/documentation/api-design-guidelines/)

---

**Made with ❤️ by [Coding With Amit](https://codingwithamit.com)**
 
## 🔑 B-003: Sign In (S-002, F-001)

- Screen: `Features/Auth/SignInView.swift` using in-house TCA-lite (`SignInState`, `SignInAction`, `SignInReducer`).
- Mock credentials: use `test@example.com` with password `password`.
- On success: tokens saved with keys `access_token`, `refresh_token`, `token_expiry`; app routes to Dashboard placeholder.
- Reducer tests: skeleton at `SwiftBoardTests/Features/Auth/SignInReducerTests.swift`.

How to try:
1. Run the app and complete Onboarding.
2. Enter the mock credentials and tap Sign In.
3. You should reach the Dashboard placeholder.