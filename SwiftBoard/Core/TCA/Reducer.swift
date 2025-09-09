//
//  Reducer.swift
//  SwiftBoard
//
//  Created by Amit Sen on 9/9/25.
//  © 2025 Coding With Amit. All rights reserved.

import Foundation

/// A protocol that defines how to reduce state and actions into effects
public protocol Reducer<State, Action> {
  associatedtype State
  associatedtype Action
  
  /// Reduces the current state and action into a new state and effects
  func reduce(
    _ state: inout State,
    _ action: Action,
    _ dependencies: Dependencies
  ) -> [Effect<Action>]
}

/// A concrete reducer implementation
public struct AnyReducer<State, Action>: Reducer {
  private let _reduce: (inout State, Action, Dependencies) -> [Effect<Action>]
  
  public init<R: Reducer>(_ reducer: R) where R.State == State, R.Action == Action {
    self._reduce = reducer.reduce
  }
  
  public func reduce(
    _ state: inout State,
    _ action: Action,
    _ dependencies: Dependencies
  ) -> [Effect<Action>] {
    _reduce(&state, action, dependencies)
  }
}

// MARK: - Reducer Composition

extension Reducer {
  /// Combines multiple reducers into a single reducer
  public static func combine<R1: Reducer, R2: Reducer>(
    _ r1: R1,
    _ r2: R2
  ) -> AnyReducer<State, Action>
  where R1.State == State, R1.Action == Action,
        R2.State == State, R2.Action == Action {
    AnyReducer(CombinedReducer(r1: r1, r2: r2))
  }
  
  /// Combines multiple reducers into a single reducer
  public static func combine<R1: Reducer, R2: Reducer, R3: Reducer>(
    _ r1: R1,
    _ r2: R2,
    _ r3: R3
  ) -> AnyReducer<State, Action>
  where R1.State == State, R1.Action == Action,
        R2.State == State, R2.Action == Action,
        R3.State == State, R3.Action == Action {
    AnyReducer(CombinedReducer3(r1: r1, r2: r2, r3: r3))
  }
}

// MARK: - Helper Reducers

private struct CombinedReducer<State, Action, R1: Reducer, R2: Reducer>: Reducer
where R1.State == State, R1.Action == Action, R2.State == State, R2.Action == Action {
  let r1: R1
  let r2: R2
  
  func reduce(
    _ state: inout State,
    _ action: Action,
    _ dependencies: Dependencies
  ) -> [Effect<Action>] {
    let effects1 = r1.reduce(&state, action, dependencies)
    let effects2 = r2.reduce(&state, action, dependencies)
    return effects1 + effects2
  }
}

private struct CombinedReducer3<State, Action, R1: Reducer, R2: Reducer, R3: Reducer>: Reducer
where R1.State == State, R1.Action == Action, R2.State == State, R2.Action == Action, R3.State == State, R3.Action == Action {
  let r1: R1
  let r2: R2
  let r3: R3
  
  func reduce(
    _ state: inout State,
    _ action: Action,
    _ dependencies: Dependencies
  ) -> [Effect<Action>] {
    let effects1 = r1.reduce(&state, action, dependencies)
    let effects2 = r2.reduce(&state, action, dependencies)
    let effects3 = r3.reduce(&state, action, dependencies)
    return effects1 + effects2 + effects3
  }
}
