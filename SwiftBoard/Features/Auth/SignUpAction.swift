//
//  SignUpAction.swift
//  SwiftBoard
//
//  Created by Amit Sen on 09/10/2025.
//  © 2025 Coding With Amit. All rights reserved.

import Foundation

/// Actions for the Sign Up screen
public enum SignUpAction {
  case onAppear
  case nameChanged(String)
  case nameFocusGained
  case nameFocusLost
  case emailChanged(String)
  case emailFocusGained
  case emailFocusLost
  case passwordChanged(String)
  case passwordFocusGained
  case passwordFocusLost
  case confirmPasswordChanged(String)
  case confirmPasswordFocusGained
  case confirmPasswordFocusLost
  case signUpTapped
  case signUpResponseSuccess(UserProtocol)
  case signUpResponseFailure(UserRepositoryError)
  case dismissError
}
