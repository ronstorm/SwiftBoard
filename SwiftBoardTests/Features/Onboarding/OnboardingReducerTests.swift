//  OnboardingReducerTests.swift
//  SwiftBoardTests
//
//  Created by Amit Sen on 09/10/2025.
//  © 2025 Coding With Amit. All rights reserved.

import XCTest
@testable import SwiftBoard

final class OnboardingReducerTests: XCTestCase {
  
  func testInitialState() {
    let state = OnboardingState()
    
    XCTAssertEqual(state.currentPage, 0)
    XCTAssertEqual(state.totalPages, 3)
    XCTAssertFalse(state.isCompleted)
    XCTAssertTrue(state.isContinueEnabled)
    XCTAssertFalse(state.isLastPage)
    XCTAssertEqual(state.progress, 1.0/3.0, accuracy: 0.01)
  }
  
  func testContinueTappedOnFirstPage() {
    var state = OnboardingState()
    var dependencies = Dependencies.preview
    let reducer = OnboardingReducer()
    
    let effects = reducer.reduce(&state, .continueTapped, &dependencies)
    
    XCTAssertEqual(state.currentPage, 1)
    XCTAssertFalse(state.isCompleted)
    XCTAssertEqual(effects.count, 0)
  }
  
  func testContinueTappedOnLastPage() {
    var state = OnboardingState()
    state.currentPage = 2 // Last page
    var dependencies = Dependencies.preview
    let reducer = OnboardingReducer()
    
    let effects = reducer.reduce(&state, .continueTapped, &dependencies)
    
    XCTAssertTrue(state.isCompleted)
    XCTAssertEqual(effects.count, 1)
  }
  
  
  func testPageChanged() {
    var state = OnboardingState()
    var dependencies = Dependencies.preview
    let reducer = OnboardingReducer()
    
    let effects = reducer.reduce(&state, .pageChanged(2), &dependencies)
    
    XCTAssertEqual(state.currentPage, 2)
    XCTAssertEqual(effects.count, 0)
  }
  
  func testPageChangedInvalidPage() {
    var state = OnboardingState()
    state.currentPage = 1
    var dependencies = Dependencies.preview
    let reducer = OnboardingReducer()
    
    // Try to set invalid page
    let effects = reducer.reduce(&state, .pageChanged(-1), &dependencies)
    
    // Should not change
    XCTAssertEqual(state.currentPage, 1)
    XCTAssertEqual(effects.count, 0)
  }
  
  func testOnAppear() {
    var state = OnboardingState()
    state.currentPage = 2
    state.isCompleted = true
    var dependencies = Dependencies.preview
    let reducer = OnboardingReducer()
    
    let effects = reducer.reduce(&state, .onAppear, &dependencies)
    
    XCTAssertEqual(state.currentPage, 0)
    XCTAssertFalse(state.isCompleted)
    XCTAssertTrue(state.isContinueEnabled)
    XCTAssertEqual(effects.count, 0)
  }
  
  func testOnboardingCompleted() {
    var state = OnboardingState()
    var dependencies = Dependencies.preview
    let reducer = OnboardingReducer()
    
    let effects = reducer.reduce(&state, .onboardingCompleted, &dependencies)
    
    XCTAssertTrue(state.isCompleted)
    XCTAssertEqual(effects.count, 0)
  }
  
  func testComputedProperties() {
    var state = OnboardingState()
    
    // Test first page
    XCTAssertEqual(state.currentPageTitle, "Welcome to SwiftBoard")
    XCTAssertEqual(state.currentPageDescription, "SwiftBoard helps you manage your tasks and stay organized with a beautiful, intuitive interface.")
    XCTAssertEqual(state.currentPageIcon, "hand.wave.fill")
    XCTAssertFalse(state.isLastPage)
    
    // Test second page
    state.currentPage = 1
    XCTAssertEqual(state.currentPageTitle, "Your Personal Dashboard")
    XCTAssertEqual(state.currentPageDescription, "View your tasks, track your progress, and see your activity all in one place.")
    XCTAssertEqual(state.currentPageIcon, "gauge.with.dots.needle.bottom.fill")
    XCTAssertFalse(state.isLastPage)
    
    // Test last page
    state.currentPage = 2
    XCTAssertEqual(state.currentPageTitle, "Stay Organized")
    XCTAssertEqual(state.currentPageDescription, "Get started by signing in to your account and begin organizing your work.")
    XCTAssertEqual(state.currentPageIcon, "checkmark.circle.fill")
    XCTAssertTrue(state.isLastPage)
  }
  
  func testProgressCalculation() {
    var state = OnboardingState()
    
    // First page
    XCTAssertEqual(state.progress, 1.0/3.0, accuracy: 0.01)
    
    // Second page
    state.currentPage = 1
    XCTAssertEqual(state.progress, 2.0/3.0, accuracy: 0.01)
    
    // Last page
    state.currentPage = 2
    XCTAssertEqual(state.progress, 1.0, accuracy: 0.01)
  }
}
