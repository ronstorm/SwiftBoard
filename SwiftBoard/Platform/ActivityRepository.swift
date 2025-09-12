//  ActivityRepository.swift
//  SwiftBoard
//
//  Created by Amit Sen on 09/11/2025.
//  © 2025 Coding With Amit. All rights reserved.

import Foundation
import CoreData

/// Repository for Activity Core Data operations and refresh
public protocol ActivityRepository {
  func fetchCached(limit: Int) async throws -> [ActivityEvent]
  func refresh(limit: Int) async throws -> [ActivityEvent]
}

public final class LiveActivityRepository: ActivityRepository {
  private let context: NSManagedObjectContext
  private let apiClient: APIClient
  
  public init(context: NSManagedObjectContext, apiClient: APIClient) {
    self.context = context
    self.apiClient = apiClient
  }
  
  public func fetchCached(limit: Int) async throws -> [ActivityEvent] {
    let request: NSFetchRequest<ActivityEvent> = ActivityEvent.fetchRequest()
    request.fetchLimit = limit
    request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
    return try await context.perform {
      try self.context.fetch(request)
    }
  }
  
  public func refresh(limit: Int) async throws -> [ActivityEvent] {
    let items: [Activity] = try await apiClient.request(.activity(limit: limit))
    return try await context.perform {
      for item in items.prefix(limit) {
        let event = self.fetchOrCreateEvent(id: item.id)
        event.type = item.type
        event.title = item.title
        event.createdAt = item.createdAt
      }
      try self.context.save()
      // Return the events directly instead of calling fetchCached
      let request: NSFetchRequest<ActivityEvent> = ActivityEvent.fetchRequest()
      request.fetchLimit = limit
      request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
      return try self.context.fetch(request)
    }
  }
  
  private func fetchOrCreateEvent(id: String) -> ActivityEvent {
    let request: NSFetchRequest<ActivityEvent> = ActivityEvent.fetchRequest()
    request.predicate = NSPredicate(format: "id == %@", id)
    request.fetchLimit = 1
    if let existing = try? context.fetch(request).first {
      return existing
    }
    let entity = ActivityEvent(context: context)
    entity.id = id
    entity.createdAt = Date()
    entity.title = ""
    entity.type = ""
    return entity
  }
}
