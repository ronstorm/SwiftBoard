//  OnboardingState.swift
//  SwiftBoard
//
//  Created by Amit Sen on 09/10/2025.
//  © 2025 Coding With Amit. All rights reserved.

import Foundation

/// State for the onboarding flow
public struct OnboardingState: Equatable {
  /// Current page index in the onboarding flow
  public var currentPage: Int = 0
  
  /// Total number of pages in the onboarding
  public var totalPages: Int = 3
  
  /// Whether the user has completed onboarding
  public var isCompleted: Bool = false
  
  /// Whether the continue button is enabled
  public var isContinueEnabled: Bool = true
  
  public init() {}
}

// MARK: - Computed Properties

extension OnboardingState {
  /// Whether this is the last page of onboarding
  public var isLastPage: Bool {
    currentPage >= totalPages - 1
  }
  
  /// Progress percentage (0.0 to 1.0)
  public var progress: Double {
    guard totalPages > 0 else { return 0.0 }
    return Double(currentPage + 1) / Double(totalPages)
  }
  
  /// Current page title
  public var currentPageTitle: String {
    switch currentPage {
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
  
  /// Current page description
  public var currentPageDescription: String {
    switch currentPage {
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
  
  /// Current page icon name
  public var currentPageIcon: String {
    switch currentPage {
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
