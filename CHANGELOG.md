# Changelog

All notable changes to SwiftBoard will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial project setup with TCA-lite architecture
- Design token system for consistent UI
- Core Data integration for offline-first data
- Dependency injection system
- Comprehensive testing framework
- CI/CD pipeline with GitHub Actions
- SwiftLint configuration
- Documentation and ADRs

### Changed

### Deprecated

### Removed

### Fixed

### Security

## [1.0.0] - 2025-09-09

### Added
- **B-001**: TCA shell setup with Store, Reducer, Effect, and Dependencies
- **B-001**: Design tokens for spacing, radius, typography, and colors
- **B-001**: Organized folder structure (App/, Features/, Core/, Platform/, etc.)
- **B-001**: Dependency injection system with @Dependency
- **B-013**: GitHub Actions CI/CD workflow
- **B-013**: README with badges and comprehensive documentation
- **B-013**: PR and issue templates
- **B-013**: Contributing guidelines
- **B-013**: Architecture Decision Records (ADRs)
- **B-013**: Security policy and changelog

### Technical Details
- Custom TCA-lite implementation for state management
- Protocol-based dependency injection for testability
- Core Data stack for local data persistence
- SwiftLint configuration for code quality
- Comprehensive test coverage setup
- Automated CI/CD with build, test, lint, and security scanning

## [0.1.0] - 2025-09-09

### Added
- Initial Xcode project setup
- Basic SwiftUI app structure
- Core Data model with Item entity
- Basic test target setup

---

## Release Notes Format

### Version Numbering
We use [Semantic Versioning](https://semver.org/):
- **MAJOR**: Incompatible API changes
- **MINOR**: New functionality in a backwards compatible manner
- **PATCH**: Backwards compatible bug fixes

### Change Categories
- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Security improvements

### Build References
Changes are referenced by build step (e.g., B-001, B-002) for traceability to the original requirements document.

## Contributing

When adding entries to the changelog:

1. Add entries under the appropriate version section
2. Use the correct category (Added, Changed, etc.)
3. Include build step references where applicable
4. Use clear, concise descriptions
5. Link to related issues or PRs when relevant

## Links

- [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
- [Semantic Versioning](https://semver.org/spec/v2.0.0.html)
- [Conventional Commits](https://www.conventionalcommits.org/)
