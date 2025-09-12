//
//  Effect.swift
//  SwiftBoard
//
//  Created by Amit Sen on 9/9/25.
//  © 2025 Coding With Amit. All rights reserved.

import Foundation
import Combine

/// An effect represents a side effect that can send actions back to the store
public struct Effect<Action> {
  private let publisher: AnyPublisher<Action, Never>
  
  public init(_ publisher: AnyPublisher<Action, Never>) {
    self.publisher = publisher
  }
  
  public init(_ action: Action) {
    self.publisher = Just(action).eraseToAnyPublisher()
  }
  
  public init(_ actions: [Action]) {
    self.publisher = Publishers.Sequence(sequence: actions)
      .eraseToAnyPublisher()
  }
  
  public func run(_ send: @escaping (Action) -> Void) -> AnyCancellable {
    publisher
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: send)
  }
}

// MARK: - Effect Composition

extension Effect {
  /// Combines multiple effects into a single effect
  public static func merge(_ effects: [Effect<Action>]) -> Effect<Action> {
    Effect(
      Publishers.MergeMany(effects.map(\.publisher))
        .eraseToAnyPublisher()
    )
  }
  
  /// Combines multiple effects into a single effect
  public static func merge(_ effects: Effect<Action>...) -> Effect<Action> {
    merge(effects)
  }
  
  /// Concatenates multiple effects, running them sequentially
  public static func concatenate(_ effects: [Effect<Action>]) -> Effect<Action> {
    guard let first = effects.first else {
      return Effect([])
    }
    
    return effects.dropFirst().reduce(first) { result, effect in
      Effect(
        result.publisher
          .append(effect.publisher)
          .eraseToAnyPublisher()
      )
    }
  }
  
  /// Concatenates multiple effects, running them sequentially
  public static func concatenate(_ effects: Effect<Action>...) -> Effect<Action> {
    concatenate(effects)
  }
}

// MARK: - Effect + Async

extension Effect {
  /// Creates an effect from an async operation
  public static func task(
    priority: TaskPriority = .userInitiated,
    operation: @escaping () async -> Action
  ) -> Effect<Action> {
    Effect(
      Future { promise in
        _Concurrency.Task {
          let action = await operation()
          promise(.success(action))
        }
      }
      .eraseToAnyPublisher()
    )
  }
  
  /// Creates an effect from an async operation that can fail
  public static func task(
    priority: TaskPriority = .userInitiated,
    operation: @escaping () async throws -> Action
  ) -> Effect<Action> {
    Effect(
      Future { promise in
        _Concurrency.Task {
          do {
            let action = try await operation()
            promise(.success(action))
          } catch {
            // For now, we'll just ignore errors
            // In a real implementation, this would need proper error handling
            print("Effect task failed: \(error)")
          }
        }
      }
      .eraseToAnyPublisher()
    )
  }
}
