//  SignInReducer.swift
//  SwiftBoard
//
//  Created by Amit Sen on 09/10/2025.
//  © 2025 Coding With Amit. All rights reserved.

import Foundation

// swiftlint:disable cyclomatic_complexity
/// Reducer for Sign In
public struct SignInReducer: Reducer {
  public init() {}

  public func reduce(
    _ state: inout SignInState,
    _ action: SignInAction,
    _ dependencies: inout Dependencies
  ) -> [Effect<SignInAction>] {
    switch action {
    case .onAppear:
      state.errorMessage = nil
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

    case .signInTapped:
      guard state.canSubmit else { return [] }
      state.isSubmitting = true
      state.errorMessage = nil
      let email = state.email
      let password = state.password
      let userRepository = dependencies.userRepository
      let dateProvider = dependencies.dateProvider
      return [
        .task {
          do {
            if let user = try await userRepository.authenticateUser(email: email, password: password) {
              try await userRepository.setCurrentUser(user)
              // Still emit a success to keep view flow; tokens are not used for Core Data auth
              let response = LoginResponse(
                accessToken: "local_coredata_session",
                refreshToken: "local_coredata_session",
                user: UserResponse(id: user.id ?? "", name: user.name ?? "", avatarUrl: "", lastLogin: dateProvider.now)
              )
              return .signInResponseSuccess(response)
            } else {
              return .signInResponseFailure(.invalidCredentials)
            }
          } catch {
            return .signInResponseFailure(.invalidCredentials)
          }
        }
      ]

    case .appleSignInTapped:
      state.isSubmitting = true
      state.errorMessage = nil
      // Stubbed Apple sign-in success using same response shape
      let dateProvider = dependencies.dateProvider
      return [
        .task {
          let response = LoginResponse(
            accessToken: "mock_access_token",
            refreshToken: "mock_refresh_token",
            user: UserResponse(id: "1", name: "Test User", avatarUrl: "https://example.com/avatar.jpg", lastLogin: dateProvider.now)
          )
          return .appleSignInResponseSuccess(response)
        }
      ]

    case .signInResponseSuccess(let resp):
      state.isSubmitting = false
        // Save tokens
        do {
          var keychain = dependencies.keychainService
          let expiry = dependencies.dateProvider.now.addingTimeInterval(3600)
          try keychain.save(Data(resp.accessToken.utf8), forKey: "access_token")
          try keychain.save(Data(resp.refreshToken.utf8), forKey: "refresh_token")
          let expiryData = try JSONEncoder().encode(expiry)
          try keychain.save(expiryData, forKey: "token_expiry")
          state.isAuthenticated = true
        } catch {
          state.errorMessage = "Failed to save credentials"
        }
        return []
    
    case .signInResponseFailure(let apiError):
      state.isSubmitting = false
      state.errorMessage = apiError.errorDescription ?? "Sign in failed"
      return []

    case .appleSignInResponseSuccess(let resp):
      state.isSubmitting = false
        do {
          var keychain = dependencies.keychainService
          let expiry = dependencies.dateProvider.now.addingTimeInterval(3600)
          try keychain.save(Data(resp.accessToken.utf8), forKey: "access_token")
          try keychain.save(Data(resp.refreshToken.utf8), forKey: "refresh_token")
          let expiryData = try JSONEncoder().encode(expiry)
          try keychain.save(expiryData, forKey: "token_expiry")
          state.isAuthenticated = true
        } catch {
          state.errorMessage = "Failed to save credentials"
        }
        return []
    
    case .appleSignInResponseFailure(let apiError):
      state.isSubmitting = false
      state.errorMessage = apiError.errorDescription ?? "Apple sign in failed"
      return []

    case .dismissError:
      state.errorMessage = nil
      return []
    }
  }
}
// swiftlint:enable cyclomatic_complexity
