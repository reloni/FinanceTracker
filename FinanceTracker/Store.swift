//
//  Store.swift
//  FinanceTracker
//
//  Created by Anton Efimenko on 16/09/2019.
//  Copyright © 2019 Anton Efimenko. All rights reserved.
//

import SwiftUI

final class Store<State, Action>: ObservableObject {
    typealias Reducer = (inout State, Action) -> Void
    private let reducer: Reducer
    @Published var state: State
    
    init(initialState: State, _ reducer: @escaping Reducer) {
        self.state = initialState
        self.reducer = reducer
    }
    
    func send(_ action: Action) {
        reducer(&state, action)
    }
}
