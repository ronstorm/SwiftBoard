//  TaskRepository.swift
//  SwiftBoard
//
//  Created by Amit Sen on 09/11/2025.
//  © 2025 Coding With Amit. All rights reserved.

import Foundation
import CoreData

/// Repository for Task Core Data operations and refresh
public protocol TaskRepository {
  func fetchCached(limit: Int) async throws -> [Task]
  func refresh(limit: Int) async throws -> [Task]
}

public final class LiveTaskRepository: TaskRepository {
  private let context: NSManagedObjectContext
  private let apiClient: APIClient
  
  public init(context: NSManagedObjectContext, apiClient: APIClient) {
    self.context = context
    self.apiClient = apiClient
  }
  
  public func fetchCached(limit: Int) async throws -> [Task] {
    let request: NSFetchRequest<Task> = Task.fetchRequest()
    request.fetchLimit = limit
    request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
    return try await context.perform {
      try self.context.fetch(request)
    }
  }
  
  public func refresh(limit: Int) async throws -> [Task] {
    // Fetch from mock API, then upsert into Core Data
    let items: [TaskItem] = try await apiClient.request(.tasks)
    return try await context.perform {
      for item in items.prefix(limit) {
        let task = self.fetchOrCreateTask(id: item.id)
        task.title = item.title
        task.done = item.done
        task.updatedAt = item.updatedAt
      }
      try self.context.save()
      // Return the tasks directly instead of calling fetchCached
      let request: NSFetchRequest<Task> = Task.fetchRequest()
      request.fetchLimit = limit
      request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
      return try self.context.fetch(request)
    }
  }
  
  private func fetchOrCreateTask(id: String) -> Task {
    let request: NSFetchRequest<Task> = Task.fetchRequest()
    request.predicate = NSPredicate(format: "id == %@", id)
    request.fetchLimit = 1
    if let existing = try? context.fetch(request).first {
      return existing
    }
    let entity = Task(context: context)
    entity.id = id
    entity.updatedAt = Date()
    entity.done = false
    entity.title = ""
    return entity
  }
}


