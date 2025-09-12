//  DashboardReducer.swift
//  SwiftBoard
//
//  Created by Amit Sen on 09/11/2025.
//  © 2025 Coding With Amit. All rights reserved.

import Foundation

public struct DashboardReducer: Reducer {
  public init() {}
  
  public func reduce(
    _ state: inout DashboardState,
    _ action: DashboardAction,
    _ dependencies: inout Dependencies
  ) -> [Effect<DashboardAction>] {
    switch action {
    case .onAppear:
      state.isLoading = true
      state.errorBanner = nil
      return loadCacheEffects(dependencies: dependencies)
        + refreshEffects(dependencies: dependencies)
      
    case .pullToRefresh:
      state.isRefreshing = true
      state.errorBanner = nil
      return refreshEffects(dependencies: dependencies)
      
    case .profileLoaded(let profile):
      state.profile = profile
      state.isLoading = false
      return []
      
    case .tasksLoaded(let tasks):
      state.tasks = Array(tasks.prefix(5))
      state.isLoading = false
      return []
      
    case .activityLoaded(let events):
      state.activity = Array(events.prefix(5))
      state.isLoading = false
      return []
      
    case .refreshCompleted(let result):
      state.isRefreshing = false
      switch result {
      case .success:
        return []
      case .failure:
        state.errorBanner = DashboardError.refreshFailed.errorDescription
        return []
      }
      
    case .dismissBanner:
      state.errorBanner = nil
      return []
    }
  }
  
  private func loadCacheEffects(dependencies: Dependencies) -> [Effect<DashboardAction>] {
    [
      .task {
        let u = try await dependencies.userRepository.getCurrentUser()
        let profileVM = u.map { user in
          ProfileVM(
            id: user.id ?? "",
            name: user.name ?? "",
            email: user.email ?? "",
            lastLogin: user.lastLogin
          )
        }
        return .profileLoaded(profileVM)
      },
      .task {
        let tasks = try await dependencies.taskRepository.fetchCached(limit: 5)
        return .tasksLoaded(tasks)
      },
      .task {
        let events = try await dependencies.activityRepository.fetchCached(limit: 5)
        return .activityLoaded(events)
      }
    ]
  }
  
  private func refreshEffects(dependencies: Dependencies) -> [Effect<DashboardAction>] {
    [
      .task {
        do {
          let tasks = try await dependencies.taskRepository.refresh(limit: 5)
          return .tasksLoaded(tasks)
        } catch {
          return .refreshCompleted(.failure(.refreshFailed))
        }
      },
      .task {
        do {
          let events = try await dependencies.activityRepository.refresh(limit: 5)
          return .activityLoaded(events)
        } catch {
          return .refreshCompleted(.failure(.refreshFailed))
        }
      },
      .task { .refreshCompleted(.success(())) }
    ]
  }
}
