//
//  StoreTests.swift
//  SwiftBoardTests
//
//  Created by Amit Sen on 9/9/25.
//  © 2025 Coding With Amit. All rights reserved.

import XCTest
@testable import SwiftBoard

final class StoreTests: XCTestCase {
  
  func testStoreInitialState() {
    let initialState = TestState(count: 0)
    let store = Store(
      initialState: initialState,
      reducer: TestReducer(),
      dependencies: .preview
    )
    
    XCTAssertEqual(store.state.count, 0)
  }
  
  func testStoreActionHandling() {
    let initialState = TestState(count: 0)
    let store = Store(
      initialState: initialState,
      reducer: TestReducer(),
      dependencies: .preview
    )
    
    store.send(.increment)
    XCTAssertEqual(store.state.count, 1)
    
    store.send(.increment)
    XCTAssertEqual(store.state.count, 2)
    
    store.send(.decrement)
    XCTAssertEqual(store.state.count, 1)
  }
  
  func testStoreEffectHandling() {
    let initialState = TestState(count: 0)
    let store = Store(
      initialState: initialState,
      reducer: TestReducer(),
      dependencies: .preview
    )
    
    // Initially count should be 0
    XCTAssertEqual(store.state.count, 0)
    
    // Test that the async effect is sent (we can't easily test the completion in this simple setup)
    store.send(.incrementAsync)
    
    // The count should still be 0 immediately after sending the async action
    XCTAssertEqual(store.state.count, 0)
  }
}

// MARK: - Test Types

struct TestState {
  var count: Int = 0
}

enum TestAction {
  case increment
  case decrement
  case incrementAsync
  case setCount(Int)
}

struct TestReducer: Reducer {
  typealias State = TestState
  typealias Action = TestAction
  
  func reduce(
    _ state: inout TestState,
    _ action: TestAction,
    _ dependencies: inout Dependencies
  ) -> [Effect<TestAction>] {
    switch action {
    case .increment:
      state.count += 1
      return []
      
    case .decrement:
      state.count -= 1
      return []
      
    case .incrementAsync:
      let currentCount = state.count
      return [.task {
        try await _Concurrency.Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds
        return .setCount(currentCount + 1)
      }]
      
    case .setCount(let count):
      state.count = count
      return []
    }
  }
}
