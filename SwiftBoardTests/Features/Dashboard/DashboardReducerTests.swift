//  DashboardReducerTests.swift
//  SwiftBoardTests
//
//  Created by Amit Sen on 09/11/2025.
//  © 2025 Coding With Amit. All rights reserved.

import XCTest
@testable import SwiftBoard

final class DashboardReducerTests: XCTestCase {
  func test_onAppear_loadsCache_andStartsRefresh() async {
    var deps = Dependencies.preview
    let store = Store(
      initialState: DashboardState(),
      reducer: DashboardReducer(),
      dependencies: deps
    )
    store.send(.onAppear)
    // No strict assertions yet; this is a skeleton to be expanded
    XCTAssertTrue(true)
  }
}
