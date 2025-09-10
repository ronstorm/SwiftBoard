//  OnboardingReducer.swift
//  SwiftBoard
//
//  Created by Amit Sen on 09/10/2025.
//  © 2025 Coding With Amit. All rights reserved.

import Foundation

/// Reducer for the onboarding flow
public struct OnboardingReducer: Reducer {
    public init() {}
    
    public     func reduce(
        _ state: inout OnboardingState,
        _ action: OnboardingAction,
        _ dependencies: inout Dependencies
    ) -> [Effect<OnboardingAction>] {
        switch action {
        case .continueTapped:
            if state.isLastPage {
                print("Last page reached")
                state.isCompleted = true
                return [.init(.onboardingCompleted)]
            } else {
                state.currentPage += 1
                return []
            }
            
        case .pageChanged(let newPage):
            // Update current page if valid
            if newPage >= 0 && newPage < state.totalPages {
                state.currentPage = newPage
            }
            return []
            
        case .onboardingCompleted:
            // Mark as completed
            state.isCompleted = true
            return []
            
        case .onAppear:
            // Reset state when onboarding appears
            state.currentPage = 0
            state.isCompleted = false
            state.isContinueEnabled = true
            return []
            
        case .onDisappear:
            // Clean up when onboarding disappears
            return []
        }
    }
}
