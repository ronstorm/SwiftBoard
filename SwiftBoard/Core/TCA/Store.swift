//
//  Store.swift
//  SwiftBoard
//
//  Created by Amit Sen on 9/9/25.
//  © 2025 Coding With Amit. All rights reserved.

import Foundation
import Combine
import _Concurrency

/// A store that manages state and handles actions through reducers
public final class Store<State, Action> {
  private let reducer: any Reducer<State, Action>
  private let dependencies: Dependencies
  
  @Published public private(set) var state: State
  
  private var cancellables: Set<AnyCancellable> = []
  
  public init(
    initialState: State,
    reducer: some Reducer<State, Action>,
    dependencies: Dependencies = .live
  ) {
    self.state = initialState
    self.reducer = reducer
    self.dependencies = dependencies
  }
  
  public func send(_ action: Action) {
    let effects = reducer.reduce(&state, action, dependencies)
    
    for effect in effects {
      effect.run { [weak self] action in
        self?.send(action)
      }
    }
  }
  
  public func send(_ action: Action, while predicate: @escaping (State) -> Bool) {
    send(action)
    
    var cancellable: AnyCancellable?
    cancellable = $state
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        if !predicate(state) {
          cancellable?.cancel()
        }
      }
  }
}

// MARK: - Store + ObservableObject

extension Store: ObservableObject {}
