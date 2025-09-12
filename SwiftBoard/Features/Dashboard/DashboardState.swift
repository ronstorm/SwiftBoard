//  DashboardState.swift
//  SwiftBoard
//
//  Created by Amit Sen on 09/11/2025.
//  © 2025 Coding With Amit. All rights reserved.

import Foundation

public struct ProfileVM: Equatable {
  public let id: String
  public let name: String
  public let email: String
  public let lastLogin: Date?
}

public struct DashboardState: Equatable {
  public var profile: ProfileVM?
  public var tasks: [Task] = []
  public var activity: [ActivityEvent] = []
  public var isLoading: Bool = false
  public var isRefreshing: Bool = false
  public var errorBanner: String?
  
  public init() {  }
}
