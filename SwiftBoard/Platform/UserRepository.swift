//
//  UserRepository.swift
//  SwiftBoard
//
//  Created by Amit Sen on 09/10/2025.
//  © 2025 Coding With Amit. All rights reserved.

import Foundation
import CoreData

/// Protocol for User objects to support both Core Data and mock implementations
public protocol UserProtocol: AnyObject {
  var id: String? { get set }
  var name: String? { get set }
  var email: String? { get set }
  var passwordHash: String? { get set }
  var lastLogin: Date? { get set }
  var isCurrent: Bool { get set }
  var createdAt: Date? { get set }
}

/// Repository for User Core Data operations
public protocol UserRepository {
  func createUser(name: String, email: String, password: String) async throws -> UserProtocol
  func findUser(by email: String) async throws -> UserProtocol?
  func authenticateUser(email: String, password: String) async throws -> UserProtocol?
  func setCurrentUser(_ user: UserProtocol) async throws
  func getCurrentUser() async throws -> UserProtocol?
  func signOut() async throws
}

/// Live implementation of UserRepository
public class LiveUserRepository: UserRepository {
  private let context: NSManagedObjectContext
  
  public init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  public func createUser(name: String, email: String, password: String) async throws -> UserProtocol {
    // Check if user already exists
    if try await findUser(by: email) != nil {
      throw UserRepositoryError.userAlreadyExists
    }
    
    // Create new user
    let user = User(context: context)
    user.id = UUID().uuidString
    user.name = name
    user.email = email
    user.passwordHash = PasswordHasher.hash(password: password, email: email)
    user.createdAt = Date()
    user.isCurrent = false
    
    try await context.perform {
      try self.context.save()
    }
    return user
  }
  
  public func findUser(by email: String) async throws -> UserProtocol? {
    let request: NSFetchRequest<User> = User.fetchRequest()
    request.predicate = NSPredicate(format: "email == %@", email)
    request.fetchLimit = 1
    
    return try await context.perform {
      let users = try self.context.fetch(request)
      return users.first
    }
  }
  
  public func authenticateUser(email: String, password: String) async throws -> UserProtocol? {
    guard let user = try await findUser(by: email) else {
      return nil
    }
    
    let hashedPassword = PasswordHasher.hash(password: password, email: email)
    guard user.passwordHash == hashedPassword else {
      return nil
    }
    
    return user
  }
  
  public func setCurrentUser(_ user: UserProtocol) async throws {
    // Clear all current users first
    try await signOut()
    
    // Set this user as current
    try await context.perform {
      user.isCurrent = true
      user.lastLogin = Date()
      try self.context.save()
    }
  }
  
  public func getCurrentUser() async throws -> UserProtocol? {
    let request: NSFetchRequest<User> = User.fetchRequest()
    request.predicate = NSPredicate(format: "isCurrent == YES")
    request.fetchLimit = 1
    
    return try await context.perform {
      let users = try self.context.fetch(request)
      return users.first
    }
  }
  
  public func signOut() async throws {
    let request: NSFetchRequest<User> = User.fetchRequest()
    request.predicate = NSPredicate(format: "isCurrent == YES")
    
    try await context.perform {
      let currentUsers = try self.context.fetch(request)
      for user in currentUsers {
        user.isCurrent = false
      }
      try self.context.save()
    }
  }
}

/// Password hashing utility
public struct PasswordHasher {
  public static func hash(password: String, email: String) -> String {
    let salt = "SwiftBoard_Salt_2025"
    let combined = "\(email)\(password)\(salt)"
    return combined.sha256
  }
}

/// User repository errors
public enum UserRepositoryError: Error, LocalizedError {
  case userAlreadyExists
  case userNotFound
  case invalidCredentials
  case databaseError
  
  public var errorDescription: String? {
    switch self {
    case .userAlreadyExists:
      return "A user with this email already exists"
    case .userNotFound:
      return "User not found"
    case .invalidCredentials:
      return "Invalid email or password"
    case .databaseError:
      return "Database error occurred"
    }
  }
}

// MARK: - Core Data User Extension

extension User: UserProtocol {
  // Core Data User already has all the required properties
  // This extension just makes it conform to UserProtocol
}

// MARK: - String Extension for SHA256

private extension String {
  var sha256: String {
    guard let data = self.data(using: .utf8) else { return self }
    let hash = data.withUnsafeBytes { bytes in
      return bytes.bindMemory(to: UInt8.self)
    }
    
    // Simple hash implementation for demo purposes
    // In production, use CryptoKit or CommonCrypto
    var hashValue: UInt32 = 5381
    for byte in hash {
      hashValue = ((hashValue << 5) &+ hashValue) &+ UInt32(byte)
    }
    
    return String(format: "%08x", hashValue)
  }
}
