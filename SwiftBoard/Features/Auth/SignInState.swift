//  SignInState.swift
//  SwiftBoard
//
//  Created by Amit Sen on 09/10/2025.
//  © 2025 Coding With Amit. All rights reserved.

import Foundation

/// State for the Sign In screen
public struct SignInState: Equatable {
  public var email: String = ""
  public var password: String = ""
  public var isSubmitting: Bool = false
  public var errorMessage: String?
  public var isAuthenticated: Bool = false

  public init() {}
}

// MARK: - Computed

public extension SignInState {
  var canSubmit: Bool {
    guard !isSubmitting else { return false }
    return isValidEmail(email) && !password.isEmpty
  }

  func isValidEmail(_ value: String) -> Bool {
    let pattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
    return value.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
  }
}


