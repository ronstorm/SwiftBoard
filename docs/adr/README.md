# Architecture Decision Records (ADRs)

This directory contains Architecture Decision Records for the SwiftBoard project.

## What are ADRs?

Architecture Decision Records are documents that capture important architectural decisions made in the project, along with their context and consequences. They help maintain a historical record of why certain decisions were made and provide context for future developers.

## ADR Format

Each ADR follows this format:

- **Title**: ADR-XXX: Brief description
- **Status**: Proposed, Accepted, Rejected, Deprecated, Superseded
- **Context**: The situation that led to this decision
- **Decision**: The architectural decision that was made
- **Consequences**: The positive and negative consequences of this decision

## ADR Index

| ADR | Title | Status | Date |
|-----|-------|--------|------|
| [ADR-001](001-tca-architecture.md) | Use TCA-lite for State Management | Accepted | 2025-09-09 |
| [ADR-002](002-offline-first-caching.md) | Offline-First Data Strategy with Core Data | Accepted | 2025-09-09 |
| [ADR-003](003-dependency-injection.md) | Dependency Injection with Dependencies Container | Accepted | 2025-09-09 |
| [ADR-004](004-design-tokens.md) | Design Token System for UI Consistency | Accepted | 2025-09-09 |
| [ADR-005](005-testing-strategy.md) | Comprehensive Testing Strategy | Accepted | 2025-09-09 |

## Creating New ADRs

When making significant architectural decisions:

1. Create a new ADR file: `ADR-XXX-descriptive-name.md`
2. Follow the ADR template format
3. Update this README with the new ADR
4. Submit as part of your PR

## ADR Template

```markdown
# ADR-XXX: [Title]

## Status
[Proposed/Accepted/Rejected/Deprecated/Superseded]

## Context
[Describe the situation that led to this decision]

## Decision
[Describe the architectural decision that was made]

## Consequences
[Describe the positive and negative consequences]

## Alternatives Considered
[Describe alternative approaches that were considered]

## References
[Link to relevant documentation, discussions, or resources]
```

## Review Process

ADRs should be:
- Reviewed by the team before acceptance
- Updated when decisions change
- Referenced in relevant code and documentation
- Used to guide future architectural decisions
