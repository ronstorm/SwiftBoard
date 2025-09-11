//  SignInView.swift
//  SwiftBoard
//
//  Created by Amit Sen on 09/10/2025.
//  © 2025 Coding With Amit. All rights reserved.

import SwiftUI

/// Sign In screen
public struct SignInView: View {
  @State private var store = Store(
    initialState: SignInState(),
    reducer: SignInReducer(),
    dependencies: .live
  )
  @FocusState private var isEmailFieldFocused: Bool
  @FocusState private var isPasswordFieldFocused: Bool

  let onSuccess: (() -> Void)?
  let onNavigateToSignUp: (() -> Void)?

  public init(onSuccess: (() -> Void)? = nil, onNavigateToSignUp: (() -> Void)? = nil) {
    self.onSuccess = onSuccess
    self.onNavigateToSignUp = onNavigateToSignUp
  }

  public var body: some View {
    // swiftlint:disable closure_body_length
    WithViewStore(store) { viewStore in
      VStack(spacing: DesignTokens.Spacing.lg) {
        // Title
        Text("Sign In")
          .font(DesignTokens.Typography.largeTitle)
          .foregroundColor(DesignTokens.Colors.onBackground)
          .accessibilityAddTraits(.isHeader)

        // Error message
        if let error = viewStore.state.errorMessage {
          Text(error)
            .font(DesignTokens.Typography.footnote)
            .foregroundColor(DesignTokens.Colors.error)
            .multilineTextAlignment(.center)
            .accessibilityLabel("Error: \(error)")
        }

        // Form fields
        VStack(spacing: DesignTokens.Spacing.md) {
          VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            TextField("Email", text: Binding(
              get: { viewStore.state.email },
              set: { viewStore.send(.emailChanged($0)) }
            ))
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .padding()
            .background(DesignTokens.Colors.surface)
            .cornerRadius(DesignTokens.Radius.md)
            .overlay(
              RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                .stroke(
                  viewStore.state.emailValidationError != nil 
                    ? DesignTokens.Colors.error 
                    : DesignTokens.Colors.primary,
                  lineWidth: 1
                )
            )
            .accessibilityLabel("Email address")
            .focused($isEmailFieldFocused)
            .onSubmit {
              viewStore.send(.emailFocusLost)
            }
            .onTapGesture {
              // Clear validation error when user starts typing again
              if viewStore.state.emailValidationError != nil {
                viewStore.send(.emailChanged(viewStore.state.email))
              }
            }
            
            if let emailError = viewStore.state.emailValidationError {
              Text(emailError)
                .font(DesignTokens.Typography.footnote)
                .foregroundColor(DesignTokens.Colors.error)
                .accessibilityLabel("Email validation error: \(emailError)")
            }
          }

          VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            SecureField("Password", text: Binding(
              get: { viewStore.state.password },
              set: { viewStore.send(.passwordChanged($0)) }
            ))
            .textContentType(.password)
            .padding()
            .background(DesignTokens.Colors.surface)
            .cornerRadius(DesignTokens.Radius.md)
            .overlay(
              RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                .stroke(
                  viewStore.state.passwordValidationError != nil 
                    ? DesignTokens.Colors.error 
                    : DesignTokens.Colors.primary,
                  lineWidth: 1
                )
            )
            .accessibilityLabel("Password")
            .focused($isPasswordFieldFocused)
            .onSubmit {
              viewStore.send(.passwordFocusLost)
            }
            .onTapGesture {
              // Clear validation error when user starts typing again
              if viewStore.state.passwordValidationError != nil {
                viewStore.send(.passwordChanged(viewStore.state.password))
              }
            }
            
            if let passwordError = viewStore.state.passwordValidationError {
              Text(passwordError)
                .font(DesignTokens.Typography.footnote)
                .foregroundColor(DesignTokens.Colors.error)
                .accessibilityLabel("Password validation error: \(passwordError)")
            }
            
            // Forgot password button
            Button("Forgot password?") { 
              // TODO: Implement forgot password functionality
            }
            .font(DesignTokens.Typography.footnote)
            .foregroundColor(DesignTokens.Colors.primary)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .accessibilityLabel("Forgot password button")
            .accessibilityHint("Tap to reset your password")
          }
        }

        // Sign In button
        Button(action: { viewStore.send(.signInTapped) }) {
          HStack {
            if viewStore.state.isSubmitting {
              ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: DesignTokens.Colors.onPrimary))
                .scaleEffect(0.8)
            }
            Text(viewStore.state.isSubmitting ? "Signing In..." : "Sign In")
              .font(DesignTokens.Typography.headline)
              .foregroundColor(DesignTokens.Colors.onPrimary)
          }
          .frame(maxWidth: .infinity)
          .padding()
          .background(
            viewStore.state.canSubmit ? 
              DesignTokens.Colors.primary : 
              DesignTokens.Colors.primary.opacity(0.5)
          )
          .cornerRadius(DesignTokens.Radius.md)
        }
        .disabled(!viewStore.state.canSubmit)
        .accessibilityLabel("Sign in")
        .accessibilityHint(viewStore.state.canSubmit ? "Tap to sign in to your account" : "Fill in all required fields to enable this button")

        // Sign Up link
        HStack {
          Text("Don't have an account?")
            .font(DesignTokens.Typography.body)
            .foregroundColor(DesignTokens.Colors.onBackground)
          
          Button("Sign Up") {
            onNavigateToSignUp?()
          }
          .font(DesignTokens.Typography.body)
          .foregroundColor(DesignTokens.Colors.primary)
          .accessibilityLabel("Sign up button")
          .accessibilityHint("Tap to create a new account")
        }

        Spacer()
      }
      .padding(DesignTokens.Spacing.xl)
      .background(DesignTokens.Colors.background)
      .onChange(of: viewStore.state.isAuthenticated) { _, isAuthed in
        if isAuthed { onSuccess?() }
      }
      .onChange(of: isEmailFieldFocused) { _, isFocused in
        if isFocused {
          viewStore.send(.emailFocusGained)
        } else {
          viewStore.send(.emailFocusLost)
        }
      }
      .onChange(of: isPasswordFieldFocused) { _, isFocused in
        if isFocused {
          viewStore.send(.passwordFocusGained)
        } else {
          viewStore.send(.passwordFocusLost)
        }
      }
      .onAppear { viewStore.send(.onAppear) }
    }
    // swiftlint:enable closure_body_length
  }
}

#Preview {
  SignInView()
}


