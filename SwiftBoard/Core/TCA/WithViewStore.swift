//
//  WithViewStore.swift
//  SwiftBoard
//
//  Created by Amit Sen on 9/9/25.
//  © 2025 Coding With Amit. All rights reserved.
//

import SwiftUI
import Combine

/// A view that provides access to a store's state and actions
@MainActor
public struct WithViewStore<State, Action, Content: View>: View {
    @ObservedObject private var viewStore: ViewStore<State, Action>
    private let content: (ViewStore<State, Action>) -> Content
    
    public init(
        _ store: Store<State, Action>,
        @ViewBuilder content: @escaping (ViewStore<State, Action>) -> Content
    ) {
        self.viewStore = ViewStore(store: store)
        self.content = content
    }
    
    public var body: some View {
        content(viewStore)
    }
}

/// A view store that provides access to state and actions
@MainActor
public final class ViewStore<State, Action>: ObservableObject {
    @Published public private(set) var state: State
    private let store: Store<State, Action>
    private var cancellables: Set<AnyCancellable> = []
    
    public init(store: Store<State, Action>) {
        self.store = store
        self.state = store.state
        
        // Subscribe to state changes using the @Published property
        store.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newState in
                self?.state = newState
            }
            .store(in: &cancellables)
    }
    
    public func send(_ action: Action) {
        store.send(action)
    }
    
    public func send(_ action: Action, while predicate: @escaping (State) -> Bool) {
        store.send(action, while: predicate)
    }
}
