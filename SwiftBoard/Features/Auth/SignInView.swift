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

  let onSuccess: (() -> Void)?

  public init(onSuccess: (() -> Void)? = nil) {
    self.onSuccess = onSuccess
  }

  public var body: some View {
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
          .accessibilityLabel("Email address")

          SecureField("Password", text: Binding(
            get: { viewStore.state.password },
            set: { viewStore.send(.passwordChanged($0)) }
          ))
          .textContentType(.password)
          .padding()
          .background(DesignTokens.Colors.surface)
          .cornerRadius(DesignTokens.Radius.md)
          .accessibilityLabel("Password")
        }

        // Sign In button
        Button(action: { viewStore.send(.signInTapped) }) {
          HStack {
            if viewStore.state.isSubmitting { ProgressView().tint(DesignTokens.Colors.onPrimary) }
            Text("Sign In")
          }
          .frame(maxWidth: .infinity)
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(!viewStore.state.canSubmit)
        .accessibilityLabel("Sign in")

        // Apple stub
        Button(action: { viewStore.send(.appleSignInTapped) }) {
          Text("Sign in with Apple (Stub)")
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)

        // Links row
        HStack {
          Button("Forgot password") { }
            .buttonStyle(.plain)
          Spacer()
          Button("Sign Up") { }
            .buttonStyle(.plain)
        }

        Spacer()
      }
      .padding(DesignTokens.Spacing.xl)
      .background(DesignTokens.Colors.background)
      .onChange(of: viewStore.state.isAuthenticated) { _, isAuthed in
        if isAuthed { onSuccess?() }
      }
      .onAppear { viewStore.send(.onAppear) }
    }
  }
}

#Preview {
  SignInView()
}


