//
//  DesignTokensTests.swift
//  SwiftBoardTests
//
//  Created by Amit Sen on 9/9/25.
//  © 2025 Coding With Amit. All rights reserved.

import XCTest
@testable import SwiftBoard

final class DesignTokensTests: XCTestCase {
  
  func testSpacingValues() {
    XCTAssertEqual(DesignTokens.Spacing.xs, 4)
    XCTAssertEqual(DesignTokens.Spacing.sm, 8)
    XCTAssertEqual(DesignTokens.Spacing.md, 16)
    XCTAssertEqual(DesignTokens.Spacing.lg, 24)
    XCTAssertEqual(DesignTokens.Spacing.xl, 32)
    XCTAssertEqual(DesignTokens.Spacing.xxl, 48)
    XCTAssertEqual(DesignTokens.Spacing.xxxl, 64)
  }
  
  func testRadiusValues() {
    XCTAssertEqual(DesignTokens.Radius.xs, 4)
    XCTAssertEqual(DesignTokens.Radius.sm, 8)
    XCTAssertEqual(DesignTokens.Radius.md, 12)
    XCTAssertEqual(DesignTokens.Radius.lg, 16)
    XCTAssertEqual(DesignTokens.Radius.xl, 24)
    XCTAssertEqual(DesignTokens.Radius.full, 999)
  }
  
  func testLayoutValues() {
    XCTAssertEqual(DesignTokens.Layout.maxContentWidth, 600)
    XCTAssertEqual(DesignTokens.Layout.cardMinHeight, 120)
    XCTAssertEqual(DesignTokens.Layout.buttonMinHeight, 44)
    XCTAssertEqual(DesignTokens.Layout.textFieldMinHeight, 44)
  }
  
  func testShadowStyles() {
    let smallShadow = DesignTokens.Shadow.small
    XCTAssertEqual(smallShadow.radius, 2)
    XCTAssertEqual(smallShadow.x, 0)
    XCTAssertEqual(smallShadow.y, 1)
    
    let mediumShadow = DesignTokens.Shadow.medium
    XCTAssertEqual(mediumShadow.radius, 4)
    XCTAssertEqual(mediumShadow.x, 0)
    XCTAssertEqual(mediumShadow.y, 2)
    
    let largeShadow = DesignTokens.Shadow.large
    XCTAssertEqual(largeShadow.radius, 8)
    XCTAssertEqual(largeShadow.x, 0)
    XCTAssertEqual(largeShadow.y, 4)
  }
}
