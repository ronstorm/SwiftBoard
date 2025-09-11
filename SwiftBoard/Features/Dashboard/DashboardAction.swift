//  DashboardAction.swift
//  SwiftBoard
//
//  Created by Amit Sen on 09/11/2025.
//  © 2025 Coding With Amit. All rights reserved.

import Foundation

public enum DashboardAction {
  case onAppear
  case pullToRefresh
  case profileLoaded(ProfileVM?)
  case tasksLoaded([Task])
  case activityLoaded([ActivityEvent])
  case refreshCompleted(Result<Void, DashboardError>)
  case dismissBanner
}

public enum DashboardError: Error, LocalizedError, Equatable {
  case refreshFailed
  
  public var errorDescription: String? {
    switch self {
    case .refreshFailed: return "Failed to refresh data"
    }
  }
}


