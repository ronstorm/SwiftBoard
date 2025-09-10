//
//  AppView.swift
//  SwiftBoard
//
//  Created by Amit Sen on 9/9/25.
//  © 2025 Coding With Amit. All rights reserved.

import SwiftUI

/// Main app view that handles routing and composition
struct AppView: View {
    @StateObject private var store = Store(
        initialState: AppState(),
        reducer: AppReducer(),
        dependencies: .live
    )
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                switch viewStore.state.route {
                case .onboarding:
                    OnboardingView {
                        // Animate the route change
                        withAnimation(.easeInOut(duration: 0.35)) {
                            viewStore.send(.onboardingCompleted)
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                case .auth:
                    SignInView(
                        onSuccess: {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                viewStore.send(.routeChanged(.dashboard))
                            }
                        },
                        onNavigateToSignUp: {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                viewStore.send(.navigateToSignUp)
                            }
                        }
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                case .signUp:
                    SignUpView(
                        onSuccess: {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                viewStore.send(.routeChanged(.dashboard))
                            }
                        },
                        onNavigateToSignIn: {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                viewStore.send(.navigateToSignIn)
                            }
                        }
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                case .dashboard:
                    DashboardView()
                        .transition(.opacity)
                }
            }
            // This actually performs the transition when route changes
            .animation(.easeInOut(duration: 0.35), value: viewStore.state.route)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

// MARK: - App State

struct AppState {
    var route: AppRoute = .onboarding
    var isLoading = false
    var errorMessage: String?
}

// MARK: - App Actions

enum AppAction {
    case onAppear
    case routeChanged(AppRoute)
    case errorOccurred(String)
    case errorDismissed
    case onboardingCompleted
    case navigateToSignUp
    case navigateToSignIn
    case checkAuthenticationStatus
}

// MARK: - App Routes

enum AppRoute {
    case onboarding
    case auth
    case signUp
    case dashboard
}

// MARK: - App Reducer

struct AppReducer: Reducer {
    func reduce(
        _ state: inout AppState,
        _ action: AppAction,
        _ dependencies: inout Dependencies
    ) -> [Effect<AppAction>] {
        switch action {
        case .onAppear:
            // Always check authentication status first
            return [.task {
                return .checkAuthenticationStatus
            }]
            
        case .checkAuthenticationStatus:
            let userRepository = dependencies.userRepository
            return [.task {
                do {
                    // Check if there's a current user in Core Data
                    let currentUser = try await userRepository.getCurrentUser()
                    if currentUser != nil {
                        return .routeChanged(.dashboard)
                    } else {
                        // User is not authenticated, show onboarding
                        return .routeChanged(.onboarding)
                    }
                } catch {
                    return .errorOccurred("Failed to check authentication status")
                }
            }]
            
        case .routeChanged(let route):
            state.route = route
            return []
            
        case .errorOccurred(let message):
            state.errorMessage = message
            return []
            
        case .errorDismissed:
            state.errorMessage = nil
            return []
            
        case .onboardingCompleted:
            // Check authentication status after onboarding completion
            return [.task {
                return .routeChanged(.auth)
            }]
            
        case .navigateToSignUp:
            state.route = .signUp
            return []
            
        case .navigateToSignIn:
            state.route = .auth
            return []
        }
    }
}


// MARK: - Placeholder Views


struct AuthView: View {
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            Text("Sign In")
                .font(DesignTokens.Typography.largeTitle)
                .foregroundColor(DesignTokens.Colors.onBackground)
            
            Text("Authentication view will be implemented in B-003")
                .font(DesignTokens.Typography.body)
                .foregroundColor(DesignTokens.Colors.onSurfaceVariant)
                .multilineTextAlignment(.center)
        }
        .padding(DesignTokens.Spacing.xl)
    }
}

struct DashboardView: View {
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            Text("Dashboard")
                .font(DesignTokens.Typography.largeTitle)
                .foregroundColor(DesignTokens.Colors.onBackground)
            
            Text("Dashboard view will be implemented in B-006")
                .font(DesignTokens.Typography.body)
                .foregroundColor(DesignTokens.Colors.onSurfaceVariant)
                .multilineTextAlignment(.center)
        }
        .padding(DesignTokens.Spacing.xl)
    }
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DesignTokens.Typography.headline)
            .foregroundColor(DesignTokens.Colors.onPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: DesignTokens.Layout.buttonMinHeight)
            .background(DesignTokens.Colors.primary)
            .cornerRadius(DesignTokens.Radius.md)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(DesignTokens.Animation.fast, value: configuration.isPressed)
    }
}

#Preview {
    AppView()
}
