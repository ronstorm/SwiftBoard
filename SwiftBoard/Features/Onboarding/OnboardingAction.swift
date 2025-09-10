//  OnboardingAction.swift
//  SwiftBoard
//
//  Created by Amit Sen on 09/10/2025.
//  © 2025 Coding With Amit. All rights reserved.

import Foundation

/// Actions for the onboarding flow
public enum OnboardingAction: Equatable {
  /// User tapped the continue button
  case continueTapped
  
  /// User swiped to a different page
  case pageChanged(Int)
  
  /// User completed onboarding
  case onboardingCompleted
  
  /// Onboarding view appeared
  case onAppear
  
  /// Onboarding view disappeared
  case onDisappear
}
