//  SignInReducer.swift
//  SwiftBoard
//
//  Created by Amit Sen on 09/10/2025.
//  © 2025 Coding With Amit. All rights reserved.

import Foundation

/// Reducer for Sign In
public struct SignInReducer: Reducer {
  public init() {}

  public func reduce(
    _ state: inout SignInState,
    _ action: SignInAction,
    _ dependencies: Dependencies
  ) -> [Effect<SignInAction>] {
    switch action {
    case .onAppear:
      state.errorMessage = nil
      return []

    case .emailChanged(let value):
      state.email = value
      state.errorMessage = nil
      return []

    case .passwordChanged(let value):
      state.password = value
      state.errorMessage = nil
      return []

    case .signInTapped:
      guard state.canSubmit else { return [] }
      state.isSubmitting = true
      state.errorMessage = nil
      let email = state.email
      let password = state.password
      return [
        .task {
          do {
            let response: LoginResponse = try await dependencies.apiClient.request(.login(email: email, password: password))
            return .signInResponseSuccess(response)
          } catch let error as APIError {
            return .signInResponseFailure(error)
          } catch {
            return .signInResponseFailure(.networkError)
          }
        }
      ]

    case .appleSignInTapped:
      state.isSubmitting = true
      state.errorMessage = nil
      // Stubbed Apple sign-in success using same response shape
      return [
        .task {
          let response = LoginResponse(
            accessToken: "mock_access_token",
            refreshToken: "mock_refresh_token",
            user: User(id: "1", name: "Test User", avatarUrl: "https://example.com/avatar.jpg", lastLogin: dependencies.dateProvider.now)
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


