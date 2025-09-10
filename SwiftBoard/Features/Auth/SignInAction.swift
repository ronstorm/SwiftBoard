//  SignInAction.swift
//  SwiftBoard
//
//  Created by Amit Sen on 09/10/2025.
//  © 2025 Coding With Amit. All rights reserved.

import Foundation

/// Actions for the Sign In screen
public enum SignInAction {
  case onAppear
  case emailChanged(String)
  case passwordChanged(String)
  case signInTapped
  case appleSignInTapped
  case signInResponseSuccess(LoginResponse)
  case signInResponseFailure(APIError)
  case appleSignInResponseSuccess(LoginResponse)
  case appleSignInResponseFailure(APIError)
  case dismissError
}


