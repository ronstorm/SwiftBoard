//  OnboardingView.swift
//  SwiftBoard
//
//  Created by Amit Sen on 09/10/2025.
//  © 2025 Coding With Amit. All rights reserved.

import SwiftUI

/// The main onboarding view that guides users through the app introduction
public struct OnboardingView: View {
    @State private var store = Store(
        initialState: OnboardingState(),
        reducer: OnboardingReducer(),
        dependencies: .live
    )
    @State private var currentPage: Int = 0
    
    let onCompleted: (() -> Void)?
    
    public init(onCompleted: (() -> Void)? = nil) {
        self.onCompleted = onCompleted
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Progress indicator
                    progressIndicator(viewStore: viewStore)
                    
                    // Main content
                    TabView(selection: $currentPage) {
                        ForEach(0..<viewStore.state.totalPages, id: \.self) { pageIndex in
                            onboardingPage(
                                pageIndex: pageIndex,
                                viewStore: viewStore,
                                geometry: geometry
                            )
                            .tag(pageIndex)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .accessibilityElement(children: .contain)
                    .accessibilityLabel("Onboarding pages")
                    .onChange(of: currentPage) { _, newPage in
                        viewStore.send(.pageChanged(newPage))
                    }
                    
                    // Action buttons
                    actionButtons(viewStore: viewStore)
                }
                .background(DesignTokens.Colors.background)
                .onAppear {
                    currentPage = viewStore.state.currentPage
                    viewStore.send(.onAppear)
                }
                .onDisappear {
                    viewStore.send(.onDisappear)
                }
                .onChange(of: viewStore.state.currentPage) { _, newValue in
                    // Only update if different to prevent flicker
                    if currentPage != newValue {
                        currentPage = newValue
                    }
                }
                .onChange(of: viewStore.state.isCompleted) { _, isCompleted in
                    if isCompleted {
                        onCompleted?()
                    }
                }
            }
        }
    }
    
    // MARK: - Progress Indicator
    
    private func progressIndicator(viewStore: ViewStore<OnboardingState, OnboardingAction>) -> some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            HStack {
                ForEach(0..<viewStore.state.totalPages, id: \.self) { index in
                    Circle()
                        .fill(index <= currentPage ?
                              DesignTokens.Colors.primary :
                                DesignTokens.Colors.outlineVariant)
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut(duration: 0.3), value: currentPage)
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Page \(currentPage + 1) of \(viewStore.state.totalPages)")
            .accessibilityValue("Progress: \(Int(progress(for: currentPage, totalPages: viewStore.state.totalPages) * 100))%")
            
            // Progress bar
            ProgressView(value: progress(for: currentPage, totalPages: viewStore.state.totalPages))
                .progressViewStyle(LinearProgressViewStyle(tint: DesignTokens.Colors.primary))
                .frame(height: 2)
                .accessibilityHidden(true)
        }
        .padding(.horizontal, DesignTokens.Spacing.lg)
        .padding(.top, DesignTokens.Spacing.lg)
    }
    
    // MARK: - Onboarding Page
    
    private func onboardingPage(
        pageIndex: Int,
        viewStore: ViewStore<OnboardingState, OnboardingAction>,
        geometry: GeometryProxy
    ) -> some View {
        VStack(spacing: DesignTokens.Spacing.xl) {
            Spacer()
            
            // Icon
            Image(systemName: pageIcon(for: pageIndex))
                .font(.system(size: 80, weight: .light))
                .foregroundColor(DesignTokens.Colors.primary)
                .accessibilityHidden(true)
            
            // Title
            Text(pageTitle(for: pageIndex))
                .font(DesignTokens.Typography.largeTitle)
                .foregroundColor(DesignTokens.Colors.onBackground)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)
            
            // Description
            Text(pageDescription(for: pageIndex))
                .font(DesignTokens.Typography.body)
                .foregroundColor(DesignTokens.Colors.onSurfaceVariant)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .padding(.horizontal, DesignTokens.Spacing.lg)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(pageTitle(for: pageIndex)). \(pageDescription(for: pageIndex))")
    }
    
    // MARK: - Action Buttons
    
    private func actionButtons(viewStore: ViewStore<OnboardingState, OnboardingAction>) -> some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            // Continue/Get Started button
            Button(action: {
                if currentPage == viewStore.state.totalPages - 1 {
                    viewStore.send(.continueTapped)
                } else {
                    withAnimation(.easeInOut) {
                        currentPage += 1
                    }
                    viewStore.send(.pageChanged(currentPage))
                }
            }) {
              HStack {
                Text(currentPage == viewStore.state.totalPages - 1 ? "Get Started" : "Continue")
                  .font(DesignTokens.Typography.headline)

                if currentPage != viewStore.state.totalPages - 1 {
                  Image(systemName: "arrow.right")
                    .font(.system(size: 16, weight: .semibold))
                }
              }
              .foregroundColor(DesignTokens.Colors.onPrimary)
              .frame(maxWidth: .infinity)
              .frame(height: 56)
              .background(DesignTokens.Colors.primary)
              .cornerRadius(DesignTokens.Radius.lg)
            }
            .disabled(!viewStore.state.isContinueEnabled)
            .accessibilityLabel(currentPage == viewStore.state.totalPages - 1 ? "Get started with SwiftBoard" : "Continue to next page")
            .accessibilityHint(currentPage == viewStore.state.totalPages - 1 ? "Completes onboarding and proceeds to sign in" : "Shows the next onboarding page")
        }
        .padding(.horizontal, DesignTokens.Spacing.lg)
        .padding(.bottom, DesignTokens.Spacing.xl)
    }
    
    // MARK: - Helper Methods
    
    private func progress(for currentPage: Int, totalPages: Int) -> Double {
        guard totalPages > 0 else { return 0.0 }
        return Double(currentPage + 1) / Double(totalPages)
    }
    
    private func pageTitle(for index: Int) -> String {
        switch index {
        case 0:
            return "Welcome to SwiftBoard"
        case 1:
            return "Your Personal Dashboard"
        case 2:
            return "Stay Organized"
        default:
            return "Welcome"
        }
    }
    
    private func pageDescription(for index: Int) -> String {
        switch index {
        case 0:
            return "SwiftBoard helps you manage your tasks and stay organized with a beautiful, intuitive interface."
        case 1:
            return "View your tasks, track your progress, and see your activity all in one place."
        case 2:
            return "Get started by signing in to your account and begin organizing your work."
        default:
            return "Welcome to SwiftBoard"
        }
    }
    
    private func pageIcon(for index: Int) -> String {
        switch index {
        case 0:
            return "hand.wave.fill"
        case 1:
            return "gauge.with.dots.needle.bottom.fill"
        case 2:
            return "checkmark.circle.fill"
        default:
            return "star.fill"
        }
    }
}

// MARK: - Preview

#Preview {
    OnboardingView()
}
