//
//  SignUpView.swift
//  SwiftBoard
//
//  Created by Amit Sen on 09/10/2025.
//  © 2025 Coding With Amit. All rights reserved.

import SwiftUI

/// Sign Up screen
public struct SignUpView: View {
  @State private var store = Store(
    initialState: SignUpState(),
    reducer: SignUpReducer(),
    dependencies: .live
  )
  @FocusState private var isNameFieldFocused: Bool
  @FocusState private var isEmailFieldFocused: Bool
  @FocusState private var isPasswordFieldFocused: Bool
  @FocusState private var isConfirmPasswordFieldFocused: Bool

  let onSuccess: (() -> Void)?
  let onNavigateToSignIn: (() -> Void)?

  public init(onSuccess: (() -> Void)? = nil, onNavigateToSignIn: (() -> Void)? = nil) {
    self.onSuccess = onSuccess
    self.onNavigateToSignIn = onNavigateToSignIn
  }

  public var body: some View {
    // swiftlint:disable closure_body_length
    WithViewStore(store) { viewStore in
      VStack(spacing: DesignTokens.Spacing.lg) {
        // Title
        Text("Create Account")
          .font(DesignTokens.Typography.largeTitle)
          .foregroundColor(DesignTokens.Colors.onBackground)
          .accessibilityAddTraits(.isHeader)

        // Form fields
        SignUpFormFields(
          viewStore: viewStore,
          isNameFieldFocused: $isNameFieldFocused,
          isEmailFieldFocused: $isEmailFieldFocused,
          isPasswordFieldFocused: $isPasswordFieldFocused,
          isConfirmPasswordFieldFocused: $isConfirmPasswordFieldFocused
        )

        // Error message
        if let errorMessage = viewStore.state.errorMessage {
          Text(errorMessage)
            .font(DesignTokens.Typography.body)
            .foregroundColor(DesignTokens.Colors.error)
            .padding()
            .background(DesignTokens.Colors.error.opacity(0.1))
            .cornerRadius(DesignTokens.Radius.sm)
            .accessibilityLabel("Error: \(errorMessage)")
        }

        // Sign Up button
        SignUpButton(viewStore: viewStore)

        // Sign In link
        SignInLink(onNavigateToSignIn: onNavigateToSignIn)

        Spacer()
      }
      .padding(DesignTokens.Spacing.lg)
      .background(DesignTokens.Colors.background)
      .onChange(of: viewStore.state.isAuthenticated) { _, isAuthed in
        if isAuthed { onSuccess?() }
      }
      .onChange(of: isNameFieldFocused) { _, isFocused in
        if isFocused {
          viewStore.send(.nameFocusGained)
        } else {
          viewStore.send(.nameFocusLost)
        }
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
      .onChange(of: isConfirmPasswordFieldFocused) { _, isFocused in
        if isFocused {
          viewStore.send(.confirmPasswordFocusGained)
        } else {
          viewStore.send(.confirmPasswordFocusLost)
        }
      }
      .onAppear { viewStore.send(.onAppear) }
    }
    // swiftlint:enable closure_body_length
  }
}

#Preview {
  SignUpView()
}
