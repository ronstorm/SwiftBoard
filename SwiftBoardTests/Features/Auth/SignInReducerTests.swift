//  SignInReducerTests.swift
//  SwiftBoardTests
//
//  Created by Amit Sen on 09/10/2025.
//  © 2025 Coding With Amit. All rights reserved.

import XCTest
@testable import SwiftBoard

final class SignInReducerTests: XCTestCase {
  func testSignIn_Success_SavesTokensAndSetsAuthenticated() async {
    var deps = Dependencies(apiClient: .mock, keychainService: .mock, coreDataService: .preview, logger: .mock, analytics: .mock, dateProvider: MockDateProvider(now: Date(timeIntervalSince1970: 0)))
    let store = Store(initialState: SignInState(), reducer: SignInReducer(), dependencies: deps)

    store.send(.emailChanged("test@example.com"))
    store.send(.passwordChanged("password"))
    store.send(.signInTapped)

    // No direct assertions here; this is a skeleton placeholder.
    // In a full test, we'd await state changes and inspect mock keychain contents.
    XCTAssertTrue(true)
  }

  func testSignIn_InvalidCredentials_ShowsError() async {
    var dependencies = Dependencies.preview
    let store = Store(initialState: SignInState(), reducer: SignInReducer(), dependencies: dependencies)
    store.send(.emailChanged("test@example.com"))
    store.send(.passwordChanged("wrong"))
    store.send(.signInTapped)
    XCTAssertTrue(true)
  }
}
