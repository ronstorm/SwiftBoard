//
//  SignUpViewComponents.swift
//  SwiftBoard
//
//  Created by Amit Sen on 09/10/2025.
//  © 2025 Coding With Amit. All rights reserved.

import SwiftUI

// MARK: - Form Fields Component

struct SignUpFormFields: View {
  let viewStore: ViewStore<SignUpState, SignUpAction>
  @FocusState.Binding var isNameFieldFocused: Bool
  @FocusState.Binding var isEmailFieldFocused: Bool
  @FocusState.Binding var isPasswordFieldFocused: Bool
  @FocusState.Binding var isConfirmPasswordFieldFocused: Bool

  var body: some View {
    VStack(spacing: DesignTokens.Spacing.md) {
      // Name field
      SignUpTextField(
        title: "Full Name",
        text: Binding(
          get: { viewStore.state.name },
          set: { viewStore.send(.nameChanged($0)) }
        ),
        error: viewStore.state.nameValidationError,
        isFocused: $isNameFieldFocused,
        contentType: .name,
        onSubmit: { viewStore.send(.nameFocusLost) }
      )

      // Email field
      SignUpTextField(
        title: "Email",
        text: Binding(
          get: { viewStore.state.email },
          set: { viewStore.send(.emailChanged($0)) }
        ),
        error: viewStore.state.emailValidationError,
        isFocused: $isEmailFieldFocused,
        contentType: .emailAddress,
        keyboardType: .emailAddress,
        onSubmit: { viewStore.send(.emailFocusLost) }
      )

      // Password field
      SignUpSecureField(
        title: "Password",
        text: Binding(
          get: { viewStore.state.password },
          set: { viewStore.send(.passwordChanged($0)) }
        ),
        error: viewStore.state.passwordValidationError,
        isFocused: $isPasswordFieldFocused,
        onSubmit: { viewStore.send(.passwordFocusLost) }
      )

      // Confirm Password field
      SignUpSecureField(
        title: "Confirm Password",
        text: Binding(
          get: { viewStore.state.confirmPassword },
          set: { viewStore.send(.confirmPasswordChanged($0)) }
        ),
        error: viewStore.state.confirmPasswordValidationError,
        isFocused: $isConfirmPasswordFieldFocused,
        onSubmit: { viewStore.send(.confirmPasswordFocusLost) }
      )
    }
  }
}

// MARK: - Text Field Component

struct SignUpTextField: View {
  let title: String
  @Binding var text: String
  let error: String?
  @FocusState.Binding var isFocused: Bool
  let contentType: UITextContentType
  let keyboardType: UIKeyboardType
  let onSubmit: () -> Void

  init(
    title: String,
    text: Binding<String>,
    error: String?,
    isFocused: FocusState<Bool>.Binding,
    contentType: UITextContentType,
    keyboardType: UIKeyboardType = .default,
    onSubmit: @escaping () -> Void
  ) {
    self.title = title
    self._text = text
    self.error = error
    self._isFocused = isFocused
    self.contentType = contentType
    self.keyboardType = keyboardType
    self.onSubmit = onSubmit
  }

  var body: some View {
    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
      TextField(title, text: $text)
        .textContentType(contentType)
        .keyboardType(keyboardType)
        .textInputAutocapitalization(.never)
        .disableAutocorrection(true)
        .padding()
        .background(DesignTokens.Colors.surface)
        .cornerRadius(DesignTokens.Radius.md)
        .accessibilityLabel(title)
        .focused($isFocused)
        .onSubmit(onSubmit)
        .overlay(
          RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
            .stroke(
              error != nil ? DesignTokens.Colors.error : DesignTokens.Colors.primary,
              lineWidth: 1
            )
        )

      if let error = error {
        Text(error)
          .font(DesignTokens.Typography.caption)
          .foregroundColor(DesignTokens.Colors.error)
          .accessibilityLabel("\(title) validation error: \(error)")
      }
    }
  }
}

// MARK: - Secure Field Component

struct SignUpSecureField: View {
  let title: String
  @Binding var text: String
  let error: String?
  @FocusState.Binding var isFocused: Bool
  let onSubmit: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
      SecureField(title, text: $text)
        .textContentType(.newPassword)
        .padding()
        .background(DesignTokens.Colors.surface)
        .cornerRadius(DesignTokens.Radius.md)
        .accessibilityLabel(title)
        .focused($isFocused)
        .onSubmit(onSubmit)
        .overlay(
          RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
            .stroke(
              error != nil ? DesignTokens.Colors.error : DesignTokens.Colors.primary,
              lineWidth: 1
            )
        )

      if let error = error {
        Text(error)
          .font(DesignTokens.Typography.caption)
          .foregroundColor(DesignTokens.Colors.error)
          .accessibilityLabel("\(title) validation error: \(error)")
      }
    }
  }
}

// MARK: - Sign Up Button Component

struct SignUpButton: View {
  let viewStore: ViewStore<SignUpState, SignUpAction>

  var body: some View {
    Button(action: {
      viewStore.send(.signUpTapped)
    }) {
      HStack {
        if viewStore.state.isSubmitting {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: DesignTokens.Colors.onPrimary))
            .scaleEffect(0.8)
        }
        Text(viewStore.state.isSubmitting ? "Creating Account..." : "Create Account")
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
    .accessibilityLabel("Create account button")
    .accessibilityHint(viewStore.state.canSubmit ? "Tap to create your account" : "Fill in all required fields to enable this button")
  }
}

// MARK: - Sign In Link Component

struct SignInLink: View {
  let onNavigateToSignIn: (() -> Void)?

  var body: some View {
    HStack {
      Text("Already have an account?")
        .font(DesignTokens.Typography.body)
        .foregroundColor(DesignTokens.Colors.onBackground)
      
      Button("Sign In") {
        onNavigateToSignIn?()
      }
      .font(DesignTokens.Typography.body)
      .foregroundColor(DesignTokens.Colors.primary)
      .accessibilityLabel("Sign in button")
      .accessibilityHint("Tap to sign in to your existing account")
    }
  }
}
