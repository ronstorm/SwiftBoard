//
//  SignUpState.swift
//  SwiftBoard
//
//  Created by Amit Sen on 09/10/2025.
//  © 2025 Coding With Amit. All rights reserved.

import Foundation

/// State for the Sign Up screen
public struct SignUpState: Equatable {
  public var name: String = ""
  public var email: String = ""
  public var password: String = ""
  public var confirmPassword: String = ""
  public var isSubmitting: Bool = false
  public var errorMessage: String?
  public var nameValidationError: String?
  public var emailValidationError: String?
  public var passwordValidationError: String?
  public var confirmPasswordValidationError: String?
  public var hasNameFieldBeenFocused: Bool = false
  public var hasEmailFieldBeenFocused: Bool = false
  public var hasPasswordFieldBeenFocused: Bool = false
  public var hasConfirmPasswordFieldBeenFocused: Bool = false
  public var isAuthenticated: Bool = false

  public init() {}
}

// MARK: - Computed

public extension SignUpState {
  var canSubmit: Bool {
    guard !isSubmitting else { return false }
    return !name.isEmpty && 
           isValidEmail(email) && 
           !password.isEmpty && 
           password.count >= 6 && 
           password == confirmPassword
  }

  func isValidEmail(_ value: String) -> Bool {
    let pattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
    let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    let range = NSRange(location: 0, length: value.utf16.count)
    return regex?.firstMatch(in: value, options: [], range: range) != nil
  }
}
