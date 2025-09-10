//
//  Dependencies.swift
//  SwiftBoard
//
//  Created by Amit Sen on 9/9/25.
//  © 2025 Coding With Amit. All rights reserved.

import Foundation
import Combine
import CoreData

/// A container for all dependencies used throughout the app
public struct Dependencies {
  // MARK: - Networking
  public let apiClient: APIClient
  public let keychainService: KeychainService
  
  // MARK: - Storage
  public let coreDataService: CoreDataService
  public var userRepository: UserRepository
  
  // MARK: - System Services
  public let logger: Logger
  public let analytics: AnalyticsService
  public let dateProvider: DateProvider
  
  public init(
    apiClient: APIClient = .live,
    keychainService: KeychainService = .live,
    coreDataService: CoreDataService = .live,
    userRepository: UserRepository = .live,
    logger: Logger = .live,
    analytics: AnalyticsService = .live,
    dateProvider: DateProvider = .live
  ) {
    self.apiClient = apiClient
    self.keychainService = keychainService
    self.coreDataService = coreDataService
    self.userRepository = userRepository
    self.logger = logger
    self.analytics = analytics
    self.dateProvider = dateProvider
  }
  
  public static let live = Dependencies()
  public static let preview = Dependencies(
    apiClient: .mock,
    keychainService: .mock,
    coreDataService: .preview,
    userRepository: .mock,
    logger: .mock,
    analytics: .mock,
    dateProvider: .mock
  )
}

// MARK: - Dependency Protocols

public protocol APIClient {
  func request<T: Codable>(_ endpoint: APIEndpoint) async throws -> T
}

public protocol KeychainService {
  mutating func save(_ data: Data, forKey key: String) throws
  func load(forKey key: String) throws -> Data?
  mutating func delete(forKey key: String) throws
}

public protocol CoreDataService {
  var viewContext: NSManagedObjectContext { get }
  func save() throws
}

public protocol Logger {
  func log(_ message: String, level: LogLevel, category: String)
}

public protocol AnalyticsService {
  func track(_ event: String, properties: [String: Any]?)
}

public protocol DateProvider {
  var now: Date { get }
}

// MARK: - Supporting Types

public enum APIEndpoint {
  case login(email: String, password: String)
  case refreshToken(String)
  case me
  case tasks
  case toggleTask(id: String)
  case activity(limit: Int)
}

public enum LogLevel: String, CaseIterable {
  case debug = "DEBUG"
  case info = "INFO"
  case warning = "WARNING"
  case error = "ERROR"
}

// MARK: - Live Implementations

public extension APIClient where Self == LiveAPIClient {
  static var live: LiveAPIClient { LiveAPIClient() }
  static var mock: MockAPIClient { MockAPIClient() }
}

public extension KeychainService where Self == LiveKeychainService {
  static var live: LiveKeychainService { LiveKeychainService() }
  static var mock: MockKeychainService { MockKeychainService() }
}

public extension CoreDataService where Self == LiveCoreDataService {
  static var live: LiveCoreDataService { LiveCoreDataService() }
  static var preview: LiveCoreDataService { LiveCoreDataService() }
}

public extension Logger where Self == LiveLogger {
  static var live: LiveLogger { LiveLogger() }
  static var mock: MockLogger { MockLogger() }
}

public extension AnalyticsService where Self == LiveAnalyticsService {
  static var live: LiveAnalyticsService { LiveAnalyticsService() }
  static var mock: MockAnalyticsService { MockAnalyticsService() }
}

public extension DateProvider where Self == LiveDateProvider {
  static var live: LiveDateProvider { LiveDateProvider() }
  static var mock: MockDateProvider { MockDateProvider() }
}

public extension UserRepository where Self == LiveUserRepository {
  static var live: LiveUserRepository { 
    LiveUserRepository(context: PersistenceController.shared.container.viewContext) 
  }
  static var mock: MockUserRepository { MockUserRepository() }
}
