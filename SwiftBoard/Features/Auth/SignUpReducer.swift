//
//  SignUpReducer.swift
//  SwiftBoard
//
//  Created by Amit Sen on 09/10/2025.
//  © 2025 Coding With Amit. All rights reserved.

import Foundation

/// Reducer for Sign Up
// swiftlint:disable cyclomatic_complexity
public struct SignUpReducer: Reducer {
  public init() {}

  public func reduce(
    _ state: inout SignUpState,
    _ action: SignUpAction,
    _ dependencies: inout Dependencies
  ) -> [Effect<SignUpAction>] {
    switch action {
    case .onAppear:
      state.errorMessage = nil
      return []

    case .nameChanged(let value):
      state.name = value
      state.errorMessage = nil
      state.nameValidationError = nil
      return []

    case .nameFocusGained:
      state.hasNameFieldBeenFocused = true
      return []

    case .nameFocusLost:
      if state.hasNameFieldBeenFocused {
        if state.name.isEmpty {
          state.nameValidationError = "Name is required"
        } else {
          state.nameValidationError = nil
        }
      }
      return []

    case .emailChanged(let value):
      state.email = value
      state.errorMessage = nil
      state.emailValidationError = nil
      return []

    case .emailFocusGained:
      state.hasEmailFieldBeenFocused = true
      return []

    case .emailFocusLost:
      if state.hasEmailFieldBeenFocused {
        if state.email.isEmpty {
          state.emailValidationError = "Email is required"
        } else if !state.isValidEmail(state.email) {
          state.emailValidationError = "Please enter a valid email address"
        } else {
          state.emailValidationError = nil
        }
      }
      return []

    case .passwordChanged(let value):
      state.password = value
      state.errorMessage = nil
      state.passwordValidationError = nil
      // Clear confirm password error when password changes
      state.confirmPasswordValidationError = nil
      return []

    case .passwordFocusGained:
      state.hasPasswordFieldBeenFocused = true
      return []

    case .passwordFocusLost:
      if state.hasPasswordFieldBeenFocused {
        if state.password.isEmpty {
          state.passwordValidationError = "Password is required"
        } else if state.password.count < 6 {
          state.passwordValidationError = "Password must be at least 6 characters"
        } else {
          state.passwordValidationError = nil
        }
      }
      return []

    case .confirmPasswordChanged(let value):
      state.confirmPassword = value
      state.errorMessage = nil
      state.confirmPasswordValidationError = nil
      return []

    case .confirmPasswordFocusGained:
      state.hasConfirmPasswordFieldBeenFocused = true
      return []

    case .confirmPasswordFocusLost:
      if state.hasConfirmPasswordFieldBeenFocused {
        if state.confirmPassword.isEmpty {
          state.confirmPasswordValidationError = "Please confirm your password"
        } else if state.password != state.confirmPassword {
          state.confirmPasswordValidationError = "Passwords do not match"
        } else {
          state.confirmPasswordValidationError = nil
        }
      }
      return []

    case .signUpTapped:
      state.isSubmitting = true
      state.errorMessage = nil
      
      // Capture values before the task to avoid inout capture
      let name = state.name
      let email = state.email
      let password = state.password
      let userRepository = dependencies.userRepository
      
      return [
        .task {
          do {
            let user = try await userRepository.createUser(
              name: name,
              email: email,
              password: password
            )
            try await userRepository.setCurrentUser(user)
            return .signUpResponseSuccess(user)
          } catch let error as UserRepositoryError {
            return .signUpResponseFailure(error)
          } catch {
            return .signUpResponseFailure(.databaseError)
          }
        }
      ]

    case .signUpResponseSuccess(_):
      state.isSubmitting = false
      state.isAuthenticated = true
      return []

    case .signUpResponseFailure(let error):
      state.isSubmitting = false
      state.errorMessage = error.localizedDescription
      return []

    case .dismissError:
      state.errorMessage = nil
      return []
    }
  }
}
// swiftlint:enable cyclomatic_complexity
