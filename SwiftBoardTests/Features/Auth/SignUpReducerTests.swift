//
//  SignUpReducerTests.swift
//  SwiftBoardTests
//
//  Created by Amit Sen on 09/10/2025.
//  © 2025 Coding With Amit. All rights reserved.

import XCTest
@testable import SwiftBoard

final class SignUpReducerTests: XCTestCase {
  func testSignUp_Success_CreatesUserAndSetsAuthenticated() async {
    let deps = Dependencies(
      apiClient: .mock, 
      keychainService: .mock, 
      coreDataService: .preview, 
      userRepository: .mock,
      logger: .mock, 
      analytics: .mock, 
      dateProvider: MockDateProvider(now: Date(timeIntervalSince1970: 0))
    )
    let store = Store(initialState: SignUpState(), reducer: SignUpReducer(), dependencies: deps)

    store.send(.nameChanged("John Doe"))
    store.send(.emailChanged("john@example.com"))
    store.send(.passwordChanged("password123"))
    store.send(.confirmPasswordChanged("password123"))
    store.send(.signUpTapped)
    
    // Wait for async effect to complete by checking state changes
    var attempts = 0
    while store.state.isSubmitting && attempts < 100 {
      try? await Task.sleep(nanoseconds: 10_000_000) // 0.01 seconds
      attempts += 1
    }
    
    // Verify user was created and authenticated
    XCTAssertTrue(store.state.isAuthenticated, "Expected user to be authenticated, but isAuthenticated is \(store.state.isAuthenticated)")
    XCTAssertFalse(store.state.isSubmitting, "Expected isSubmitting to be false, but it's \(store.state.isSubmitting)")
    XCTAssertNil(store.state.errorMessage, "Expected no error message, but got: \(store.state.errorMessage ?? "nil")")
  }

  func testSignUp_UserAlreadyExists_ShowsError() async {
    // Create a shared MockUserRepository to persist state between calls
    let mockUserRepository = MockUserRepository()
    
    let deps = Dependencies(
      apiClient: .mock, 
      keychainService: .mock, 
      coreDataService: .preview, 
      userRepository: mockUserRepository,
      logger: .mock, 
      analytics: .mock, 
      dateProvider: MockDateProvider(now: Date(timeIntervalSince1970: 0))
    )
    let store = Store(initialState: SignUpState(), reducer: SignUpReducer(), dependencies: deps)

    // Create first user
    store.send(.nameChanged("John Doe"))
    store.send(.emailChanged("john@example.com"))
    store.send(.passwordChanged("password123"))
    store.send(.confirmPasswordChanged("password123"))
    store.send(.signUpTapped)
    
    // Wait for first signup to complete
    var attempts = 0
    while store.state.isSubmitting && attempts < 100 {
      try? await Task.sleep(nanoseconds: 10_000_000) // 0.01 seconds
      attempts += 1
    }

    // Clear any previous state to simulate starting a new signup flow
    let newState = SignUpState()
    
    // Create a new store with the same MockUserRepository to test duplicate user scenario
    let newStore = Store(initialState: newState, reducer: SignUpReducer(), dependencies: deps)
    
    // Try to create second user with same email
    newStore.send(.nameChanged("Jane Doe"))
    newStore.send(.emailChanged("john@example.com")) // Same email
    newStore.send(.passwordChanged("password456"))
    newStore.send(.confirmPasswordChanged("password456"))
    newStore.send(.signUpTapped)
    
    // Wait for second signup to complete
    attempts = 0
    while newStore.state.isSubmitting && attempts < 100 {
      try? await Task.sleep(nanoseconds: 10_000_000) // 0.01 seconds
      attempts += 1
    }

    // Verify error is shown for duplicate user
    XCTAssertNotNil(newStore.state.errorMessage, "Expected error message for duplicate user, but got nil")
    XCTAssertFalse(newStore.state.isSubmitting, "Expected isSubmitting to be false, but it's \(newStore.state.isSubmitting)")
    XCTAssertFalse(newStore.state.isAuthenticated, "Expected user to not be authenticated for duplicate email, but isAuthenticated is \(newStore.state.isAuthenticated)")
  }

  func testSignUp_PasswordMismatch_ShowsValidationError() {
    let dependencies = Dependencies.preview
    let store = Store(initialState: SignUpState(), reducer: SignUpReducer(), dependencies: dependencies)

    store.send(.passwordChanged("password123"))
    store.send(.confirmPasswordChanged("differentpassword"))
    store.send(.confirmPasswordFocusGained)
    store.send(.confirmPasswordFocusLost)

    XCTAssertNotNil(store.state.confirmPasswordValidationError)
    XCTAssertEqual(store.state.confirmPasswordValidationError, "Passwords do not match")
  }

  func testSignUp_InvalidEmail_ShowsValidationError() {
    let dependencies = Dependencies.preview
    let store = Store(initialState: SignUpState(), reducer: SignUpReducer(), dependencies: dependencies)

    store.send(.emailChanged("invalid-email"))
    store.send(.emailFocusGained)
    store.send(.emailFocusLost)

    XCTAssertNotNil(store.state.emailValidationError)
    XCTAssertEqual(store.state.emailValidationError, "Please enter a valid email address")
  }

  func testSignUp_EmptyName_ShowsValidationError() {
    let dependencies = Dependencies.preview
    let store = Store(initialState: SignUpState(), reducer: SignUpReducer(), dependencies: dependencies)

    store.send(.nameFocusGained)
    store.send(.nameFocusLost)

    XCTAssertNotNil(store.state.nameValidationError)
    XCTAssertEqual(store.state.nameValidationError, "Name is required")
  }

  func testSignUp_ShortPassword_ShowsValidationError() {
    let dependencies = Dependencies.preview
    let store = Store(initialState: SignUpState(), reducer: SignUpReducer(), dependencies: dependencies)

    store.send(.passwordChanged("123"))
    store.send(.passwordFocusGained)
    store.send(.passwordFocusLost)

    XCTAssertNotNil(store.state.passwordValidationError)
    XCTAssertEqual(store.state.passwordValidationError, "Password must be at least 6 characters")
  }

  func testSignUp_CanSubmit_WithValidData() {
    let dependencies = Dependencies.preview
    let store = Store(initialState: SignUpState(), reducer: SignUpReducer(), dependencies: dependencies)

    store.send(.nameChanged("John Doe"))
    store.send(.emailChanged("john@example.com"))
    store.send(.passwordChanged("password123"))
    store.send(.confirmPasswordChanged("password123"))

    XCTAssertTrue(store.state.canSubmit)
  }

  func testSignUp_CannotSubmit_WithInvalidData() {
    let dependencies = Dependencies.preview
    let store = Store(initialState: SignUpState(), reducer: SignUpReducer(), dependencies: dependencies)

    store.send(.nameChanged("John Doe"))
    store.send(.emailChanged("invalid-email"))
    store.send(.passwordChanged("123"))
    store.send(.confirmPasswordChanged("different"))

    XCTAssertFalse(store.state.canSubmit)
  }
}
