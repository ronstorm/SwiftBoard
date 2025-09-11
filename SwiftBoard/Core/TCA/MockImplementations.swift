//
//  MockImplementations.swift
//  SwiftBoard
//
//  Created by Amit Sen on 9/9/25.
//  © 2025 Coding With Amit. All rights reserved.

import Foundation
import CoreData
import Combine

// MARK: - Mock API Client

public struct MockAPIClient: APIClient {
  public init() {}
  
  public func request<T: Codable>(_ endpoint: APIEndpoint) async throws -> T {
    // Simulate network delay
    try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
    
    switch endpoint {
    case .login(let email, let password):
      if email == "test@example.com" && password == "password" {
        let response = LoginResponse(
          accessToken: "mock_access_token",
          refreshToken: "mock_refresh_token",
          user: UserResponse(
            id: "1",
            name: "Test User",
            avatarUrl: "https://example.com/avatar.jpg",
            lastLogin: Date()
          )
        )
        return response as! T
      } else {
        throw APIError.invalidCredentials
      }
      
    case .refreshToken(let token):
      if token == "mock_refresh_token" {
        let response = RefreshResponse(accessToken: "new_mock_access_token")
        return response as! T
      } else {
        throw APIError.invalidToken
      }
      
    case .me:
      let response = UserResponse(
        id: "1",
        name: "Test User",
        avatarUrl: "https://example.com/avatar.jpg",
        lastLogin: Date()
      )
      return response as! T
      
    case .tasks:
      let response = [
        TaskItem(id: "1", title: "Complete project setup", done: false, updatedAt: Date()),
        TaskItem(id: "2", title: "Write unit tests", done: true, updatedAt: Date()),
        TaskItem(id: "3", title: "Review code", done: false, updatedAt: Date()),
        TaskItem(id: "4", title: "Deploy to staging", done: false, updatedAt: Date()),
        TaskItem(id: "5", title: "Update documentation", done: true, updatedAt: Date())
      ]
      return response as! T
      
    case .toggleTask(let id):
      let response = TaskItem(
        id: id,
        title: "Updated task",
        done: true,
        updatedAt: Date()
      )
      return response as! T
      
    case .activity(let limit):
      let response = Array(1...limit).map { index in
        Activity(
          id: "\(index)",
          type: index % 2 == 0 ? "task_completed" : "task_created",
          title: index % 2 == 0 ? "Task completed" : "New task created",
          createdAt: Date().addingTimeInterval(-Double(index * 3600))
        )
      }
      return response as! T
    }
  }
}

// MARK: - Mock Keychain Service

public struct MockKeychainService: KeychainService {
  private var storage: [String: Data] = [:]
  
  public init() {}
  
  public mutating func save(_ data: Data, forKey key: String) throws {
    storage[key] = data
  }
  
  public func load(forKey key: String) throws -> Data? {
    return storage[key]
  }
  
  public mutating func delete(forKey key: String) throws {
    storage.removeValue(forKey: key)
  }
}

// MARK: - Mock Logger

public struct MockLogger: Logger {
  public init() {}
  
  public func log(_ message: String, level: LogLevel, category: String) {
    print("[\(level.rawValue)] [\(category)] \(message)")
  }
}

// MARK: - Mock Analytics Service

public struct MockAnalyticsService: AnalyticsService {
  public init() {}
  
  public func track(_ event: String, properties: [String: Any]?) {
    print("Analytics: \(event) - \(properties ?? [:])")
  }
}

// MARK: - Mock Date Provider

public struct MockDateProvider: DateProvider {
  public let now: Date
  
  public init(now: Date = Date()) {
    self.now = now
  }
}

// MARK: - Live Implementations

public struct LiveAPIClient: APIClient {
  public init() {}
  
  public func request<T: Codable>(_ endpoint: APIEndpoint) async throws -> T {
    // This would make actual network requests
    // For now, we'll use the mock implementation
    let mockClient = MockAPIClient()
    return try await mockClient.request(endpoint)
  }
}

public struct LiveKeychainService: KeychainService {
  public init() {}
  
  public mutating func save(_ data: Data, forKey key: String) throws {
    // This would use actual Keychain APIs
    // For now, we'll use UserDefaults as a fallback
    UserDefaults.standard.set(data, forKey: key)
  }
  
  public func load(forKey key: String) throws -> Data? {
    return UserDefaults.standard.data(forKey: key)
  }
  
  public mutating func delete(forKey key: String) throws {
    UserDefaults.standard.removeObject(forKey: key)
  }
}

public struct LiveCoreDataService: CoreDataService {
  public let viewContext: NSManagedObjectContext
  
  public init() {
    // Use the existing PersistenceController
    self.viewContext = PersistenceController.shared.container.viewContext
  }
  
  public func save() throws {
    try viewContext.save()
  }
}

public struct LiveLogger: Logger {
  public init() {}
  
  public func log(_ message: String, level: LogLevel, category: String) {
    // This would use os.Logger in a real implementation
    print("[\(level.rawValue)] [\(category)] \(message)")
  }
}

public struct LiveAnalyticsService: AnalyticsService {
  public init() {}
  
  public func track(_ event: String, properties: [String: Any]?) {
    // This would integrate with actual analytics services
    print("Analytics: \(event) - \(properties ?? [:])")
  }
}

public struct LiveDateProvider: DateProvider {
  public var now: Date { Date() }
  
  public init() {}
}

// MARK: - Mock User Repository

public class MockUserRepository: UserRepository {
  private var users: [String: MockUser] = [:]
  private var currentUser: MockUser?
  
  public init() {}
  
  public func createUser(name: String, email: String, password: String) async throws -> UserProtocol {
    if users[email] != nil {
      throw UserRepositoryError.userAlreadyExists
    }
    
    let mockUser = MockUser(
      id: UUID().uuidString,
      name: name,
      email: email,
      passwordHash: PasswordHasher.hash(password: password, email: email),
      createdAt: Date(),
      isCurrent: false
    )
    
    users[email] = mockUser
    return mockUser.toCoreDataUser()
  }
  
  public func findUser(by email: String) async throws -> UserProtocol? {
    return users[email]?.toCoreDataUser()
  }
  
  public func authenticateUser(email: String, password: String) async throws -> UserProtocol? {
    guard let mockUser = users[email] else { return nil }
    
    let hashedPassword = PasswordHasher.hash(password: password, email: email)
    guard mockUser.passwordHash == hashedPassword else { return nil }
    
    return mockUser.toCoreDataUser()
  }
  
  public func setCurrentUser(_ user: UserProtocol) async throws {
    currentUser = nil
    // Find the mock user and set as current
    for (_, mockUser) in users {
      if mockUser.id == user.id {
        currentUser = mockUser
        break
      }
    }
  }
  
  public func getCurrentUser() async throws -> UserProtocol? {
    return currentUser?.toCoreDataUser()
  }
  
  public func signOut() async throws {
    currentUser = nil
  }
}

// MARK: - Mock User Model

private struct MockUser {
  let id: String
  let name: String
  let email: String
  let passwordHash: String
  let createdAt: Date
  let isCurrent: Bool
  
  func toCoreDataUser() -> UserProtocol {
    // For testing purposes, we'll create a mock User object
    // In a real test, you would use an in-memory Core Data stack
    let user = MockCoreDataUser()
    user.id = id
    user.name = name
    user.email = email
    user.passwordHash = passwordHash
    user.createdAt = createdAt
    user.isCurrent = isCurrent
    return user
  }
}

// MARK: - Mock Core Data User for Testing

/// Mock implementation of Core Data User for testing purposes
public class MockCoreDataUser: NSObject, UserProtocol {
  public var id: String?
  public var name: String?
  public var email: String?
  public var passwordHash: String?
  public var lastLogin: Date?
  public var isCurrent: Bool = false
  public var createdAt: Date?
  
  public override init() {
    super.init()
  }
}

// MARK: - Supporting Types

public struct LoginResponse: Codable {
  public let accessToken: String
  public let refreshToken: String
  public let user: UserResponse
}

public struct RefreshResponse: Codable {
  public let accessToken: String
}

public struct UserResponse: Codable {
  public let id: String
  public let name: String
  public let avatarUrl: String
  public let lastLogin: Date
}

public struct TaskItem: Codable {
  public let id: String
  public let title: String
  public let done: Bool
  public let updatedAt: Date
}

public struct Activity: Codable {
  public let id: String
  public let type: String
  public let title: String
  public let createdAt: Date
}

public enum APIError: Error, LocalizedError {
  case invalidCredentials
  case invalidToken
  case networkError
  case decodingError
  
  public var errorDescription: String? {
    switch self {
    case .invalidCredentials:
      return "Invalid email or password"
    case .invalidToken:
      return "Invalid or expired token"
    case .networkError:
      return "Network connection error"
    case .decodingError:
      return "Failed to decode response"
    }
  }
}
